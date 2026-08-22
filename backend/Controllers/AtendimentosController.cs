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
public class AtendimentosController : ControllerBase
{
    private readonly AppDbContext _db;

    public AtendimentosController(AppDbContext db)
    {
        _db = db;
    }

    // GET /api/atendimentos
    [HttpGet]
    public async Task<IActionResult> ListarTodos()
    {
        var lista = await _db.Atendimentos
            .Include(a => a.Aluno)
            .Include(a => a.Usuario)
            .OrderByDescending(a => a.DataAtendimento)
            .Select(a => ToDto(a))
            .ToListAsync();
        return Ok(lista);
    }

    // GET /api/atendimentos/aluno/{idAluno}
    [HttpGet("aluno/{idAluno}")]
    public async Task<IActionResult> ListarPorAluno(int idAluno)
    {
        var lista = await _db.Atendimentos
            .Include(a => a.Aluno)
            .Include(a => a.Usuario)
            .Where(a => a.IdAluno == idAluno)
            .OrderByDescending(a => a.DataAtendimento)
            .Select(a => ToDto(a))
            .ToListAsync();
        return Ok(lista);
    }

    // GET /api/atendimentos/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> BuscarPorId(int id)
    {
        var a = await _db.Atendimentos
            .Include(a => a.Aluno)
            .Include(a => a.Usuario)
            .FirstOrDefaultAsync(a => a.Id == id);
        if (a is null)
            return NotFound(new { mensagem = "Atendimento não encontrado." });
        return Ok(ToDto(a));
    }

    // GET /api/atendimentos/aluno/{idAluno}/ultimo
    [HttpGet("aluno/{idAluno}/ultimo")]
    public async Task<IActionResult> UltimoAtendimento(int idAluno)
    {
        var a = await _db.Atendimentos
            .Include(a => a.Aluno)
            .Include(a => a.Usuario)
            .Where(a => a.IdAluno == idAluno)
            .OrderByDescending(a => a.DataAtendimento)
            .FirstOrDefaultAsync();
        if (a is null)
            return NotFound(new { mensagem = "Nenhum atendimento encontrado para este aluno." });
        return Ok(ToDto(a));
    }

    // POST /api/atendimentos
    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] CriarAtendimentoDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var alunoExiste   = await _db.Alunos.AnyAsync(a => a.Id == dto.IdAluno);
        var usuarioExiste = await _db.Usuarios.AnyAsync(u => u.Id == dto.IdUsuario);

        if (!alunoExiste)
            return Conflict(new { mensagem = "Aluno não encontrado." });
        if (!usuarioExiste)
            return Conflict(new { mensagem = "Usuário não encontrado." });

        // O atendimento só pode ser registrado a partir de um agendamento
        // prévio, do mesmo aluno, que ainda não tenha sido atendido.
        var agendamento = await _db.Agendamentos.FindAsync(dto.IdAgendamento);
        if (agendamento is null)
            return Conflict(new { mensagem = "Agendamento não encontrado." });
        if (agendamento.IdAluno != dto.IdAluno)
            return Conflict(new { mensagem = "O agendamento selecionado não pertence a este aluno." });

        var agendamentoJaAtendido = await _db.Atendimentos.AnyAsync(at => at.IdAgendamento == dto.IdAgendamento);
        if (agendamentoJaAtendido)
            return Conflict(new { mensagem = "Este agendamento já possui um atendimento registrado." });

        var atendimento = new Atendimento
        {
            IdAluno                 = dto.IdAluno,
            IdUsuario               = dto.IdUsuario,
            IdAgendamento           = dto.IdAgendamento,
            MotivoDaConsulta        = dto.MotivoDaConsulta.Trim(),
            Anamnese                = dto.Anamnese.Trim(),
            Peso                    = dto.Peso,
            Altura                  = dto.Altura,
            Imc                     = dto.Imc,
            PerimetroCefalico       = dto.PerimetroCefalico,
            CircunferenciaAbdominal = dto.CircunferenciaAbdominal,
            PerimetroPanturrilha    = dto.PerimetroPanturrilha,
            ExameFisico             = dto.ExameFisico.Trim(),
            Diagnostico             = dto.Diagnostico.Trim(),
            DataAtendimento         = dto.DataAtendimento,
        };

        _db.Atendimentos.Add(atendimento);
        await _db.SaveChangesAsync();

        await _db.Entry(atendimento).Reference(a => a.Aluno).LoadAsync();
        await _db.Entry(atendimento).Reference(a => a.Usuario).LoadAsync();

        return CreatedAtAction(nameof(BuscarPorId), new { id = atendimento.Id }, ToDto(atendimento));
    }

    // DELETE /api/atendimentos/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        var atendimento = await _db.Atendimentos.FindAsync(id);
        if (atendimento is null)
            return NotFound(new { mensagem = "Atendimento não encontrado." });

        _db.Atendimentos.Remove(atendimento);
        try
        {
            await _db.SaveChangesAsync();
        }
        catch (DbUpdateException)
        {
            return Conflict(new { mensagem = "Não é possível excluir: existem lançamentos vinculados a este atendimento." });
        }
        return Ok(new { mensagem = "Atendimento excluído com sucesso." });
    }

    // ─── Mapeamento ───────────────────────────────────────
    private static AtendimentoResponseDto ToDto(Atendimento a) => new()
    {
        Id                      = a.Id,
        IdAluno                 = a.IdAluno,
        NomeAluno               = a.Aluno?.Nome ?? "",
        IdUsuario               = a.IdUsuario,
        NomeUsuario             = a.Usuario?.Nome ?? "",
        CboUsuario              = a.Usuario?.Cbo ?? "",
        IdAgendamento           = a.IdAgendamento,
        MotivoDaConsulta        = a.MotivoDaConsulta,
        Anamnese                = a.Anamnese,
        Peso                    = a.Peso,
        Altura                  = a.Altura,
        Imc                     = a.Imc,
        PerimetroCefalico       = a.PerimetroCefalico,
        CircunferenciaAbdominal = a.CircunferenciaAbdominal,
        PerimetroPanturrilha    = a.PerimetroPanturrilha,
        ExameFisico             = a.ExameFisico,
        Diagnostico             = a.Diagnostico,
        DataAtendimento         = a.DataAtendimento,
    };
}