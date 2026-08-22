using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NeuroGest.API.Data;
using NeuroGest.API.DTOs;
using NeuroGest.API.Models;

namespace NeuroGest.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
[Authorize]
public class AgendamentosController : ControllerBase
{
    private readonly AppDbContext _db;

    public AgendamentosController(AppDbContext db)
    {
        _db = db;
    }

    // GET /api/agendamentos/mes?idUsuario=1&ano=2026&mes=8
    [HttpGet("mes")]
    public async Task<IActionResult> ListarDoMes(
        [FromQuery] int idUsuario, [FromQuery] int ano, [FromQuery] int mes)
    {
        var idsComAtendimento = await _db.Atendimentos
            .Where(at => at.IdAgendamento != null)
            .Select(at => at.IdAgendamento!.Value)
            .ToListAsync();

        var lista = await _db.Agendamentos
            .Include(a => a.Aluno)
            .Include(a => a.Usuario)
            .Where(a => a.IdUsuario == idUsuario
                     && a.Horario.Year == ano
                     && a.Horario.Month == mes)
            .OrderBy(a => a.Horario)
            .ToListAsync();

        return Ok(lista.Select(a => ToDto(a, idsComAtendimento.Contains(a.Id))).ToList());
    }

    // GET /api/agendamentos/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> BuscarPorId(int id)
    {
        var a = await _db.Agendamentos
            .Include(a => a.Aluno)
            .Include(a => a.Usuario)
            .FirstOrDefaultAsync(a => a.Id == id);
        if (a is null)
            return NotFound(new { mensagem = "Agendamento não encontrado." });

        var temAtendimento = await _db.Atendimentos.AnyAsync(at => at.IdAgendamento == id);
        return Ok(ToDto(a, temAtendimento));
    }

    // POST /api/agendamentos
    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] CriarAgendamentoDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var alunoExiste   = await _db.Alunos.AnyAsync(a => a.Id == dto.IdAluno);
        var usuarioExiste = await _db.Usuarios.AnyAsync(u => u.Id == dto.IdUsuario);

        if (!alunoExiste)   return Conflict(new { mensagem = "Aluno não encontrado." });
        if (!usuarioExiste) return Conflict(new { mensagem = "Usuário não encontrado." });

        var agendamento = new Agendamento
        {
            IdAluno       = dto.IdAluno,
            IdUsuario     = dto.IdUsuario,
            Horario       = dto.Horario,
            ValorConsulta = dto.ValorConsulta,
            EstaPago      = dto.EstaPago,
        };

        _db.Agendamentos.Add(agendamento);
        await _db.SaveChangesAsync();

        // O lançamento financeiro já nasce junto com o agendamento — fica
        // "em aberto" (pronto para dar baixa no Financeiro) mesmo que o
        // agendamento ainda não tenha sido marcado como pago.
        SincronizarLancamento(agendamento, null);
        await _db.SaveChangesAsync();

        await _db.Entry(agendamento).Reference(a => a.Aluno).LoadAsync();
        await _db.Entry(agendamento).Reference(a => a.Usuario).LoadAsync();

        return CreatedAtAction(nameof(BuscarPorId), new { id = agendamento.Id }, ToDto(agendamento, false));
    }

    // PUT /api/agendamentos/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> Editar(int id, [FromBody] EditarAgendamentoDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var agendamento = await _db.Agendamentos
            .Include(a => a.Aluno)
            .Include(a => a.Usuario)
            .FirstOrDefaultAsync(a => a.Id == id);

        if (agendamento is null)
            return NotFound(new { mensagem = "Agendamento não encontrado." });

        var temAtendimento = await _db.Atendimentos.AnyAsync(at => at.IdAgendamento == id);

        // Só permite mudar a data/horário se ainda não houver atendimento
        // registrado para este agendamento.
        if (dto.Horario.HasValue && dto.Horario.Value != agendamento.Horario)
        {
            if (temAtendimento)
                return Conflict(new { mensagem = "Não é possível alterar a data: já existe um atendimento registrado para este agendamento." });

            agendamento.Horario = dto.Horario.Value;
        }

        agendamento.ValorConsulta = dto.ValorConsulta;
        agendamento.EstaPago      = dto.EstaPago;
        agendamento.Faltou        = dto.Faltou;

        // Mantém o lançamento financeiro sincronizado com o status de
        // pagamento do agendamento (calendário ↔ Financeiro). Ao desmarcar
        // "pago", o lançamento não é removido — apenas volta para "em
        // aberto" (a ver); a exclusão definitiva só acontece quando o
        // agendamento em si é excluído (cascata). Agendamentos criados
        // antes desta funcionalidade podem não ter lançamento ainda — é
        // criado aqui se for o caso.
        var lancamentoVinculado = await _db.Lancamentos
            .FirstOrDefaultAsync(l => l.IdAgendamento == id);

        SincronizarLancamento(agendamento, lancamentoVinculado);

        await _db.SaveChangesAsync();
        return Ok(ToDto(agendamento, temAtendimento));
    }

    // DELETE /api/agendamentos/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        var agendamento = await _db.Agendamentos.FindAsync(id);
        if (agendamento is null)
            return NotFound(new { mensagem = "Agendamento não encontrado." });

        // Ordem de exclusão: Pagamento → Atendimento → Agendamento. Não é
        // possível excluir o agendamento enquanto existir um atendimento
        // registrado para ele (deve ser excluído primeiro).
        var temAtendimento = await _db.Atendimentos.AnyAsync(at => at.IdAgendamento == id);
        if (temAtendimento)
            return Conflict(new { mensagem = "Não é possível excluir: existe um atendimento registrado para este agendamento. Exclua o atendimento primeiro." });

        _db.Agendamentos.Remove(agendamento);
        await _db.SaveChangesAsync();
        return Ok(new { mensagem = "Agendamento excluído com sucesso." });
    }

    // Cria (se necessário) e sincroniza o lançamento financeiro do
    // agendamento com o status de pagamento atual — o lançamento nasce
    // junto com o agendamento, já disponível no Financeiro para dar baixa,
    // e é atualizado sempre que o agendamento é editado.
    private void SincronizarLancamento(Agendamento agendamento, Lancamento? lancamento)
    {
        if (lancamento is null)
        {
            lancamento = new Lancamento
            {
                IdAluno       = agendamento.IdAluno,
                IdUsuario     = agendamento.IdUsuario,
                IdAgendamento = agendamento.Id,
            };
            _db.Lancamentos.Add(lancamento);
        }

        lancamento.ValorOriginal = agendamento.ValorConsulta;

        if (agendamento.EstaPago)
        {
            lancamento.ValorPago     = agendamento.ValorConsulta;
            lancamento.ValorRestante = 0;
            lancamento.Quitado       = true;
            lancamento.DataPagamento ??= DateTime.UtcNow;
        }
        else
        {
            lancamento.ValorPago     = 0;
            lancamento.ValorRestante = agendamento.ValorConsulta;
            lancamento.Quitado       = false;
            lancamento.DataPagamento = null;
        }
    }

    // ─── Mapeamento ───────────────────────────────────────
    private static AgendamentoResponseDto ToDto(Agendamento a, bool temAtendimento) => new()
    {
        Id               = a.Id,
        IdAluno          = a.IdAluno,
        NomeAluno        = a.Aluno?.Nome ?? "",
        ObservacoesAluno = a.Aluno?.Observacoes,
        IdUsuario        = a.IdUsuario,
        NomeUsuario      = a.Usuario?.Nome ?? "",
        Horario          = a.Horario,
        ValorConsulta    = a.ValorConsulta,
        EstaPago         = a.EstaPago,
        Faltou           = a.Faltou,
        TemAtendimento   = temAtendimento,
    };
}
