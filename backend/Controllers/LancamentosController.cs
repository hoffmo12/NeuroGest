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
public class LancamentosController : ControllerBase
{
    private readonly AppDbContext _db;

    public LancamentosController(AppDbContext db)
    {
        _db = db;
    }

    // GET /api/lancamentos?mes=6&ano=2025
    [HttpGet]
    public async Task<IActionResult> Listar([FromQuery] int? mes, [FromQuery] int? ano)
    {
        var query = _db.Lancamentos
            .Include(l => l.Aluno)
            .Include(l => l.Usuario)
            .AsQueryable();

        if (mes.HasValue && ano.HasValue)
        {
            query = query.Where(l =>
                l.DataLancamento.Month == mes.Value &&
                l.DataLancamento.Year  == ano.Value);
        }

        var lista = await query
            .OrderByDescending(l => l.DataLancamento)
            .Select(l => ToDto(l))
            .ToListAsync();

        return Ok(lista);
    }

    // GET /api/lancamentos/resumo?mes=6&ano=2025
    [HttpGet("resumo")]
    public async Task<IActionResult> Resumo([FromQuery] int mes, [FromQuery] int ano)
    {
        var lancamentos = await _db.Lancamentos
            .Where(l => l.DataLancamento.Month == mes && l.DataLancamento.Year == ano)
            .ToListAsync();

        var totalRecebido = lancamentos.Sum(l => l.ValorPago);
        var totalEmAberto = lancamentos.Where(l => !l.Quitado).Sum(l => l.ValorRestante);

        var resumo = new ResumoFinanceiroDto
        {
            TotalRecebido  = totalRecebido,
            TotalEmAberto  = totalEmAberto,
            // Soma recebido + aberto em vez de ValorOriginal: lançamentos
            // filhos (pagamento parcial) repetem parte do valor original do
            // pai, então somar ValorOriginal de todos contaria o mesmo
            // débito mais de uma vez.
            TotalPrevisto  = totalRecebido + totalEmAberto,
            QtdPagos       = lancamentos.Count(l => l.Quitado),
            QtdEmAberto    = lancamentos.Count(l => !l.Quitado),
        };

        return Ok(resumo);
    }

    // GET /api/lancamentos/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> BuscarPorId(int id)
    {
        var l = await _db.Lancamentos
            .Include(l => l.Aluno)
            .Include(l => l.Usuario)
            .FirstOrDefaultAsync(l => l.Id == id);

        if (l is null)
            return NotFound(new { mensagem = "Lançamento não encontrado." });

        return Ok(ToDto(l));
    }

    // POST /api/lancamentos
    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] CriarLancamentoDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var alunoExiste       = await _db.Alunos.AnyAsync(a => a.Id == dto.IdAluno);
        var atendimentoExiste = await _db.Atendimentos.AnyAsync(a => a.Id == dto.IdAtendimento);
        var usuarioExiste     = await _db.Usuarios.AnyAsync(u => u.Id == dto.IdUsuario);

        if (!alunoExiste)       return Conflict(new { mensagem = "Aluno não encontrado." });
        if (!atendimentoExiste) return Conflict(new { mensagem = "Atendimento não encontrado." });
        if (!usuarioExiste)     return Conflict(new { mensagem = "Usuário não encontrado." });

        var lancamento = new Lancamento
        {
            IdAluno       = dto.IdAluno,
            IdAtendimento = dto.IdAtendimento,
            IdUsuario     = dto.IdUsuario,
            ValorOriginal = dto.ValorOriginal,
            ValorRestante = dto.ValorOriginal,
            ValorPago     = 0,
            Quitado       = false,
        };

        _db.Lancamentos.Add(lancamento);
        await _db.SaveChangesAsync();

        await _db.Entry(lancamento).Reference(l => l.Aluno).LoadAsync();
        await _db.Entry(lancamento).Reference(l => l.Usuario).LoadAsync();

        return CreatedAtAction(nameof(BuscarPorId), new { id = lancamento.Id }, ToDto(lancamento));
    }

    // PUT /api/lancamentos/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> Editar(int id, [FromBody] EditarLancamentoDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var lancamento = await _db.Lancamentos.FindAsync(id);
        if (lancamento is null)
            return NotFound(new { mensagem = "Lançamento não encontrado." });

        if (lancamento.Quitado)
            return Conflict(new { mensagem = "Não é possível editar um lançamento já quitado." });

        lancamento.ValorOriginal = dto.ValorOriginal;
        lancamento.ValorRestante = dto.ValorOriginal - lancamento.ValorPago;

        await _db.SaveChangesAsync();
        return Ok(ToDto(lancamento));
    }

    // POST /api/lancamentos/{id}/pagar
    [HttpPost("{id}/pagar")]
    public async Task<IActionResult> Pagar(int id, [FromBody] PagarLancamentoDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var lancamento = await _db.Lancamentos
            .Include(l => l.Aluno)
            .Include(l => l.Usuario)
            .FirstOrDefaultAsync(l => l.Id == id);

        if (lancamento is null)
            return NotFound(new { mensagem = "Lançamento não encontrado." });

        if (lancamento.Quitado)
            return Conflict(new { mensagem = "Este lançamento já está quitado." });

        if (dto.ValorPago > lancamento.ValorRestante)
            return Conflict(new { mensagem = "Valor pago maior que o saldo restante." });

        lancamento.ValorPago     += dto.ValorPago;
        lancamento.ValorRestante -= dto.ValorPago;

        // Pagamento total
        if (lancamento.ValorRestante <= 0)
        {
            lancamento.Quitado        = true;
            lancamento.ValorRestante  = 0;
            lancamento.DataPagamento  = DateTime.UtcNow;
            await _db.SaveChangesAsync();
            return Ok(new { lancamento = ToDto(lancamento), novoLancamento = (object?)null });
        }

        // Pagamento parcial → cria novo lançamento com o saldo restante
        // e encerra este, pois o saldo em aberto passa a ser controlado
        // pelo novo lançamento (evita contar o mesmo débito duas vezes).
        var saldoRestante = lancamento.ValorRestante;
        lancamento.Quitado       = true;
        lancamento.ValorRestante = 0;
        lancamento.DataPagamento = DateTime.UtcNow;

        var novoLancamento = new Lancamento
        {
            IdAluno          = lancamento.IdAluno,
            IdAtendimento    = lancamento.IdAtendimento,
            IdUsuario        = lancamento.IdUsuario,
            IdLancamentoPai  = lancamento.Id,
            ValorOriginal    = saldoRestante,
            ValorRestante    = saldoRestante,
            ValorPago        = 0,
            Quitado          = false,
        };

        _db.Lancamentos.Add(novoLancamento);
        await _db.SaveChangesAsync();

        await _db.Entry(novoLancamento).Reference(l => l.Aluno).LoadAsync();
        await _db.Entry(novoLancamento).Reference(l => l.Usuario).LoadAsync();

        return Ok(new
        {
            lancamento      = ToDto(lancamento),
            novoLancamento  = ToDto(novoLancamento),
        });
    }

    // DELETE /api/lancamentos/{id}
    // Ordem de importância: Pagamento → Atendimento → Agendamento. Um
    // lançamento gerado a partir de um agendamento (IdAgendamento
    // preenchido) nunca é removido do banco por aqui — "excluir" apenas
    // volta o pagamento para "em aberto" (a ver); a remoção definitiva só
    // acontece quando o agendamento correspondente é excluído (cascata).
    // Lançamentos manuais (sem agendamento vinculado) são excluídos de
    // verdade, como antes.
    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        var lancamento = await _db.Lancamentos
            .Include(l => l.Agendamento)
            .FirstOrDefaultAsync(l => l.Id == id);
        if (lancamento is null)
            return NotFound(new { mensagem = "Lançamento não encontrado." });

        if (lancamento.IdAgendamento is not null)
        {
            lancamento.Quitado       = false;
            lancamento.ValorPago     = 0;
            lancamento.ValorRestante = lancamento.ValorOriginal;
            lancamento.DataPagamento = null;

            if (lancamento.Agendamento is not null)
                lancamento.Agendamento.EstaPago = false;

            await _db.SaveChangesAsync();
            return Ok(new { mensagem = "Pagamento revertido para \"em aberto\". Ele será removido definitivamente ao excluir o agendamento." });
        }

        _db.Lancamentos.Remove(lancamento);
        try
        {
            await _db.SaveChangesAsync();
        }
        catch (DbUpdateException)
        {
            return Conflict(new { mensagem = "Não é possível excluir: existe um lançamento de parcela vinculado a este." });
        }
        return Ok(new { mensagem = "Lançamento excluído com sucesso." });
    }

    // ─── Mapeamento ───────────────────────────────────────
    private static LancamentoResponseDto ToDto(Lancamento l) => new()
    {
        Id              = l.Id,
        IdAluno         = l.IdAluno,
        NomeAluno       = l.Aluno?.Nome ?? "",
        IdAtendimento   = l.IdAtendimento,
        IdAgendamento   = l.IdAgendamento,
        IdUsuario       = l.IdUsuario,
        NomeUsuario     = l.Usuario?.Nome ?? "",
        IdLancamentoPai = l.IdLancamentoPai,
        ValorOriginal   = l.ValorOriginal,
        ValorPago       = l.ValorPago,
        ValorRestante   = l.ValorRestante,
        Quitado         = l.Quitado,
        DataLancamento  = l.DataLancamento,
        DataPagamento   = l.DataPagamento,
    };
}