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
            Municipio           = dto.Municipio?.Trim(),
            Sexo                = dto.Sexo?.Trim(),
            Estado              = dto.Estado?.Trim(),
            NomePai             = dto.NomePai?.Trim(),
            NomeMae             = dto.NomeMae.Trim(),
            Cpf                 = dto.Cpf.Trim(),
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
        aluno.Municipio           = dto.Municipio?.Trim();
        aluno.Sexo                = dto.Sexo?.Trim();
        aluno.Estado              = dto.Estado?.Trim();
        aluno.NomePai             = dto.NomePai?.Trim();
        aluno.NomeMae             = dto.NomeMae.Trim();
        aluno.Cpf                 = dto.Cpf.Trim();
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
    public async Task<(bool ok, string? erro)> ExcluirAsync(int id)
    {
        var aluno = await _db.Alunos.FindAsync(id);
        if (aluno is null) return (false, "Aluno não encontrado.");

        _db.Alunos.Remove(aluno);
        try
        {
            await _db.SaveChangesAsync();
        }
        catch (DbUpdateException)
        {
            return (false, "Não é possível excluir: existem atendimentos, agendamentos ou lançamentos vinculados a este aluno.");
        }
        return (true, null);
    }

    // ─── Mapeamento ───────────────────────────────────────
    private static AlunoResponseDto ToDto(Aluno a) => new()
    {
        Id                  = a.Id,
        Nome                = a.Nome,
        DataNascimento      = a.DataNascimento,
        Idade               = a.Idade,
        Municipio           = a.Municipio,
        Sexo                = a.Sexo,
        Estado              = a.Estado,
        NomePai             = a.NomePai,
        NomeMae             = a.NomeMae,
        Cpf                 = a.Cpf,
        CpfPai              = a.CpfPai,
        CpfMae              = a.CpfMae,
        TelefoneResponsavel = a.TelefoneResponsavel,
        Observacoes         = a.Observacoes,
        Ativo               = a.Ativo,
        CriadoEm           = a.CriadoEm,
    };
}
