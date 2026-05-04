using Microsoft.EntityFrameworkCore;
using NeuroGest.API.Data;
using NeuroGest.API.DTOs;
using NeuroGest.API.Helpers;
using NeuroGest.API.Models;

namespace NeuroGest.API.Services;

public class AuthService : IAuthService
{
    private readonly AppDbContext _db;
    private readonly JwtHelper _jwt;

    public AuthService(AppDbContext db, JwtHelper jwt)
    {
        _db = db;
        _jwt = jwt;
    }

    // ─── Cadastro ─────────────────────────────────────────
    public async Task<AuthResponseDto?> CadastrarAsync(CadastroDto dto)
    {
        bool emailExistente = await _db.Usuarios
            .AnyAsync(u => u.Email == dto.Email.ToLower());

        if (emailExistente)
            return null;

        // Garante que só perfis válidos sejam aceitos
        var perfisValidos = new[] { "admin", "gerente", "usuario" };
        var perfil = perfisValidos.Contains(dto.Perfil) ? dto.Perfil : "usuario";

        var usuario = new Usuario
        {
            Nome      = dto.Nome.Trim(),
            Email     = dto.Email.Trim().ToLower(),
            SenhaHash = BCrypt.Net.BCrypt.HashPassword(dto.Senha),
            Perfil    = perfil,
        };

        _db.Usuarios.Add(usuario);
        await _db.SaveChangesAsync();

        return GerarResposta(usuario);
    }

    // ─── Login ────────────────────────────────────────────
    public async Task<AuthResponseDto?> LoginAsync(LoginDto dto)
    {
        var usuario = await _db.Usuarios
            .FirstOrDefaultAsync(u => u.Email == dto.Email.ToLower() && u.Ativo);

        if (usuario is null)
            return null;

        if (!BCrypt.Net.BCrypt.Verify(dto.Senha, usuario.SenhaHash))
            return null;

        return GerarResposta(usuario);
    }

    // ─── Privado ──────────────────────────────────────────
    private AuthResponseDto GerarResposta(Usuario usuario)
    {
        var (token, expiraEm) = _jwt.GerarToken(usuario);

        return new AuthResponseDto
        {
            Token    = token,
            Nome     = usuario.Nome,
            Email    = usuario.Email,
            Perfil   = usuario.Perfil,
            ExpiraEm = expiraEm,
        };
    }
}
