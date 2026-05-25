using NeuroGest.API.DTOs;

namespace NeuroGest.API.Services;

public interface IAuthService
{
    /// <summary>Registra um novo usuário. Retorna null se o e-mail já existe.</summary>
    Task<AuthResponseDto?> CadastrarAsync(CadastroDto dto);

    /// <summary>Autentica o usuário. Retorna null se credenciais inválidas.</summary>
    Task<AuthResponseDto?> LoginAsync(LoginDto dto);
}
