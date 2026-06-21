using NeuroGest.API.DTOs;

namespace NeuroGest.API.Services;

public interface IUsuarioService
{
    Task<IEnumerable<UsuarioResponseDto>> ListarAsync();
    Task<UsuarioResponseDto?> BuscarPorIdAsync(int id);
    Task<(UsuarioResponseDto? resultado, string? erro)> CriarAsync(CriarUsuarioDto dto);
    Task<(UsuarioResponseDto? resultado, string? erro)> EditarAsync(int id, EditarUsuarioDto dto);
    Task<bool> AlternarAtivoAsync(int id);
    Task<bool> ExcluirAsync(int id);
}