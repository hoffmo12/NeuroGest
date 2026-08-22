using Microsoft.EntityFrameworkCore;
using NeuroGest.API.Data;
using NeuroGest.API.DTOs;
using NeuroGest.API.Models;

namespace NeuroGest.API.Services;

public class UsuarioService : IUsuarioService
{
    private readonly AppDbContext _db;
    private static readonly string[] PerfisValidos = ["admin", "profissional", "recepcao"];

    public UsuarioService(AppDbContext db)
    {
        _db = db;
    }

    public async Task<IEnumerable<UsuarioResponseDto>> ListarAsync()
    {
        return await _db.Usuarios
            .OrderBy(u => u.Nome)
            .Select(u => ToDto(u))
            .ToListAsync();
    }

    public async Task<UsuarioResponseDto?> BuscarPorIdAsync(int id)
    {
        var u = await _db.Usuarios.FindAsync(id);
        return u is null ? null : ToDto(u);
    }

    public async Task<(UsuarioResponseDto? resultado, string? erro)> CriarAsync(CriarUsuarioDto dto)
    {
        if (await _db.Usuarios.AnyAsync(u => u.Email == dto.Email.ToLower()))
            return (null, "Este e-mail já está cadastrado.");

        if (!PerfisValidos.Contains(dto.Perfil))
            return (null, "Perfil inválido. Use: admin, profissional ou recepcao.");

        var usuario = new Usuario
        {
            Nome         = dto.Nome.Trim(),
            Email        = dto.Email.Trim().ToLower(),
            SenhaHash    = BCrypt.Net.BCrypt.HashPassword(dto.Senha),
            Cpf          = dto.Cpf?.Trim(),
            Cbo          = dto.Cbo.Trim(),
            TipoRegistro = dto.TipoRegistro.Trim(),
            NumRegistro  = dto.NumRegistro.Trim(),
            Perfil       = dto.Perfil,
            Telefone     = dto.Telefone?.Trim(),
        };

        _db.Usuarios.Add(usuario);
        await _db.SaveChangesAsync();
        return (ToDto(usuario), null);
    }

    public async Task<(UsuarioResponseDto? resultado, string? erro)> EditarAsync(int id, EditarUsuarioDto dto)
    {
        var usuario = await _db.Usuarios.FindAsync(id);
        if (usuario is null)
            return (null, "Usuário não encontrado.");

        if (await _db.Usuarios.AnyAsync(u => u.Email == dto.Email.ToLower() && u.Id != id))
            return (null, "Este e-mail já está em uso por outro usuário.");

        if (!PerfisValidos.Contains(dto.Perfil))
            return (null, "Perfil inválido. Use: admin, profissional ou recepcao.");

        usuario.Nome         = dto.Nome.Trim();
        usuario.Email        = dto.Email.Trim().ToLower();
        usuario.Cpf          = dto.Cpf?.Trim();
        usuario.Cbo          = dto.Cbo.Trim();
        usuario.TipoRegistro = dto.TipoRegistro.Trim();
        usuario.NumRegistro  = dto.NumRegistro.Trim();
        usuario.Perfil       = dto.Perfil;
        usuario.Telefone     = dto.Telefone?.Trim();

        if (!string.IsNullOrWhiteSpace(dto.NovaSenha))
            usuario.SenhaHash = BCrypt.Net.BCrypt.HashPassword(dto.NovaSenha);

        await _db.SaveChangesAsync();
        return (ToDto(usuario), null);
    }

    public async Task<bool> AlternarAtivoAsync(int id)
    {
        var usuario = await _db.Usuarios.FindAsync(id);
        if (usuario is null) return false;
        usuario.Ativo = !usuario.Ativo;
        await _db.SaveChangesAsync();
        return true;
    }

    public async Task<(bool ok, string? erro)> ExcluirAsync(int id)
    {
        var usuario = await _db.Usuarios.FindAsync(id);
        if (usuario is null) return (false, "Usuário não encontrado.");

        _db.Usuarios.Remove(usuario);
        try
        {
            await _db.SaveChangesAsync();
        }
        catch (DbUpdateException)
        {
            return (false, "Não é possível excluir: existem atendimentos, agendamentos ou lançamentos vinculados a este usuário.");
        }
        return (true, null);
    }

    private static UsuarioResponseDto ToDto(Usuario u) => new()
    {
        Id           = u.Id,
        Nome         = u.Nome,
        Email        = u.Email,
        Cpf          = u.Cpf,
        Cbo          = u.Cbo,
        TipoRegistro = u.TipoRegistro,
        NumRegistro  = u.NumRegistro,
        Perfil       = u.Perfil,
        Telefone     = u.Telefone,
        Ativo        = u.Ativo,
        CriadoEm    = u.CriadoEm,
    };
}