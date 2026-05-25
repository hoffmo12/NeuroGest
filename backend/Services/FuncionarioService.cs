using Microsoft.EntityFrameworkCore;
using NeuroGest.API.Data;
using NeuroGest.API.DTOs;
using NeuroGest.API.Models;

namespace NeuroGest.API.Services;

public class FuncionarioService : IFuncionarioService
{
    private readonly AppDbContext _db;
    private static readonly string[] PerfisValidos = ["admin", "gerente", "usuario"];

    public FuncionarioService(AppDbContext db)
    {
        _db = db;
    }

    // ─── Listar todos os usuários ─────────────────────────
    public async Task<List<FuncionarioResponseDto>> ListarAsync()
    {
        return await _db.Usuarios
            .OrderBy(u => u.Nome)
            .Select(u => ToDto(u))
            .ToListAsync();
    }

    // ─── Buscar por ID ────────────────────────────────────
    public async Task<FuncionarioResponseDto?> BuscarPorIdAsync(int id)
    {
        var u = await _db.Usuarios.FindAsync(id);
        return u is null ? null : ToDto(u);
    }

    // ─── Criar usuário ────────────────────────────────────
    public async Task<(FuncionarioResponseDto? dto, string? erro)> CriarAsync(CriarFuncionarioDto dto)
    {
        if (await _db.Usuarios.AnyAsync(u => u.Email == dto.Email.ToLower()))
            return (null, "Este e-mail já está cadastrado.");

        if (!PerfisValidos.Contains(dto.Perfil))
            return (null, "Perfil inválido. Use: admin, gerente ou usuario.");

        var usuario = new Usuario
        {
            Nome      = dto.Nome.Trim(),
            Email     = dto.Email.Trim().ToLower(),
            SenhaHash = BCrypt.Net.BCrypt.HashPassword(dto.Senha),
            Funcao    = dto.Funcao.Trim(),
            Perfil    = dto.Perfil,
            Telefone  = dto.Telefone?.Trim(),
        };

        _db.Usuarios.Add(usuario);
        await _db.SaveChangesAsync();
        return (ToDto(usuario), null);
    }

    // ─── Editar usuário ───────────────────────────────────
    public async Task<(FuncionarioResponseDto? dto, string? erro)> EditarAsync(int id, EditarFuncionarioDto dto)
    {
        var usuario = await _db.Usuarios.FindAsync(id);
        if (usuario is null)
            return (null, "Funcionário não encontrado.");

        if (await _db.Usuarios.AnyAsync(u => u.Email == dto.Email.ToLower() && u.Id != id))
            return (null, "Este e-mail já está em uso por outro funcionário.");

        if (!PerfisValidos.Contains(dto.Perfil))
            return (null, "Perfil inválido. Use: admin, gerente ou usuario.");

        usuario.Nome     = dto.Nome.Trim();
        usuario.Email    = dto.Email.Trim().ToLower();
        usuario.Funcao   = dto.Funcao.Trim();
        usuario.Perfil   = dto.Perfil;
        usuario.Telefone = dto.Telefone?.Trim();

        if (!string.IsNullOrWhiteSpace(dto.NovaSenha))
            usuario.SenhaHash = BCrypt.Net.BCrypt.HashPassword(dto.NovaSenha);

        await _db.SaveChangesAsync();
        return (ToDto(usuario), null);
    }

    // ─── Ativar / Desativar ───────────────────────────────
    public async Task<bool> AlternarAtivoAsync(int id)
    {
        var usuario = await _db.Usuarios.FindAsync(id);
        if (usuario is null) return false;

        usuario.Ativo = !usuario.Ativo;
        await _db.SaveChangesAsync();
        return true;
    }

    // ─── Excluir ──────────────────────────────────────────
    public async Task<bool> ExcluirAsync(int id)
    {
        var usuario = await _db.Usuarios.FindAsync(id);
        if (usuario is null) return false;

        _db.Usuarios.Remove(usuario);
        await _db.SaveChangesAsync();
        return true;
    }

    // ─── Mapeamento ───────────────────────────────────────
    private static FuncionarioResponseDto ToDto(Usuario u) => new()
    {
        Id       = u.Id,
        Nome     = u.Nome,
        Email    = u.Email,
        Funcao   = u.Funcao,
        Perfil   = u.Perfil,
        Telefone = u.Telefone,
        Ativo    = u.Ativo,
        CriadoEm = u.CriadoEm,
    };
}
