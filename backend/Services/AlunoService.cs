using Microsoft.EntityFrameworkCore;
using NeuroGest.API.Data;
using NeuroGest.API.DTOs;
using NeuroGest.API.Models;

namespace NeuroGest.API.Services;

public class AlunoService : IAlunoService
{
    private readonly AppDbContext _db;

    public AlunoService(AppDbContext db)
    {
        _db = db;
    }

    // ─── Listar (com busca opcional) ──────────────────────
    public async Task<List<AlunoResponseDto>> ListarAsync(string? busca = null)
    {
        var query = _db.Alunos.AsQueryable();

        if (!string.IsNullOrWhiteSpace(busca))
        {
            busca = busca.ToLower();
            query = query.Where(a =>
                a.Nome.ToLower().Contains(busca) ||
                (a.NomePai != null && a.NomePai.ToLower().Contains(busca)) ||
                (a.NomeMae != null && a.NomeMae.ToLower().Contains(busca)));
        }

        var lista = await query.OrderBy(a => a.Nome).ToListAsync();
        return lista.Select(ToDto).ToList();
    }

    // ─── Buscar por ID ────────────────────────────────────
    public async Task<AlunoResponseDto?> BuscarPorIdAsync(int id)
    {
        var aluno = await _db.Alunos.FindAsync(id);
        return aluno is null ? null : ToDto(aluno);
    }

    // ─── Criar ────────────────────────────────────────────
    public async Task<AlunoResponseDto> CriarAsync(AlunoDto dto)
    {
        var aluno = new Aluno
        {
            Nome                = dto.Nome.Trim(),
            DataNascimento      = dto.DataNascimento,
            NomePai             = dto.NomePai?.Trim(),
            NomeMae             = dto.NomeMae?.Trim(),
            CpfPai              = dto.CpfPai?.Trim(),
            CpfMae              = dto.CpfMae?.Trim(),
            TelefoneResponsavel = dto.TelefoneResponsavel?.Trim(),
            Observacoes         = dto.Observacoes?.Trim(),
        };

        _db.Alunos.Add(aluno);
        await _db.SaveChangesAsync();
        return ToDto(aluno);
    }

    // ─── Editar ───────────────────────────────────────────
    public async Task<(AlunoResponseDto? dto, string? erro)> EditarAsync(int id, AlunoDto dto)
    {
        var aluno = await _db.Alunos.FindAsync(id);
        if (aluno is null)
            return (null, "Aluno não encontrado.");

        aluno.Nome                = dto.Nome.Trim();
        aluno.DataNascimento      = dto.DataNascimento;
        aluno.NomePai             = dto.NomePai?.Trim();
        aluno.NomeMae             = dto.NomeMae?.Trim();
        aluno.CpfPai              = dto.CpfPai?.Trim();
        aluno.CpfMae              = dto.CpfMae?.Trim();
        aluno.TelefoneResponsavel = dto.TelefoneResponsavel?.Trim();
        aluno.Observacoes         = dto.Observacoes?.Trim();

        await _db.SaveChangesAsync();
        return (ToDto(aluno), null);
    }

    // ─── Ativar / Desativar ───────────────────────────────
    public async Task<bool> AlternarAtivoAsync(int id)
    {
        var aluno = await _db.Alunos.FindAsync(id);
        if (aluno is null) return false;

        aluno.Ativo = !aluno.Ativo;
        await _db.SaveChangesAsync();
        return true;
    }

    // ─── Excluir ──────────────────────────────────────────
    public async Task<bool> ExcluirAsync(int id)
    {
        var aluno = await _db.Alunos.FindAsync(id);
        if (aluno is null) return false;

        _db.Alunos.Remove(aluno);
        await _db.SaveChangesAsync();
        return true;
    }

    // ─── Mapeamento ───────────────────────────────────────
    private static AlunoResponseDto ToDto(Aluno a) => new()
    {
        Id                  = a.Id,
        Nome                = a.Nome,
        DataNascimento      = a.DataNascimento,
        Idade               = a.Idade,
        NomePai             = a.NomePai,
        NomeMae             = a.NomeMae,
        CpfPai              = a.CpfPai,
        CpfMae              = a.CpfMae,
        TelefoneResponsavel = a.TelefoneResponsavel,
        Observacoes         = a.Observacoes,
        Ativo               = a.Ativo,
        CriadoEm           = a.CriadoEm,
    };
}
