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
        var lista = await _db.Agendamentos
            .Include(a => a.Aluno)
            .Include(a => a.Usuario)
            .Where(a => a.IdUsuario == idUsuario
                     && a.Horario.Year == ano
                     && a.Horario.Month == mes)
            .OrderBy(a => a.Horario)
            .Select(a => ToDto(a))
            .ToListAsync();

        return Ok(lista);
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
        return Ok(ToDto(a));
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

        await _db.Entry(agendamento).Reference(a => a.Aluno).LoadAsync();
        await _db.Entry(agendamento).Reference(a => a.Usuario).LoadAsync();

        return CreatedAtAction(nameof(BuscarPorId), new { id = agendamento.Id }, ToDto(agendamento));
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

        agendamento.ValorConsulta = dto.ValorConsulta;
        agendamento.EstaPago      = dto.EstaPago;
        agendamento.Faltou        = dto.Faltou;

        await _db.SaveChangesAsync();
        return Ok(ToDto(agendamento));
    }

    // DELETE /api/agendamentos/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        var agendamento = await _db.Agendamentos.FindAsync(id);
        if (agendamento is null)
            return NotFound(new { mensagem = "Agendamento não encontrado." });

        _db.Agendamentos.Remove(agendamento);
        await _db.SaveChangesAsync();
        return Ok(new { mensagem = "Agendamento excluído com sucesso." });
    }

    // ─── Mapeamento ───────────────────────────────────────
    private static AgendamentoResponseDto ToDto(Agendamento a) => new()
    {
        Id            = a.Id,
        IdAluno       = a.IdAluno,
        NomeAluno     = a.Aluno?.Nome ?? "",
        IdUsuario     = a.IdUsuario,
        NomeUsuario   = a.Usuario?.Nome ?? "",
        Horario       = a.Horario,
        ValorConsulta = a.ValorConsulta,
        EstaPago      = a.EstaPago,
        Faltou        = a.Faltou,
    };
}
