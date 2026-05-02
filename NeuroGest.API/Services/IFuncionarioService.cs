using NeuroGest.API.DTOs;

namespace NeuroGest.API.Services;

public interface IFuncionarioService
{
    Task<List<FuncionarioResponseDto>> ListarAsync();
    Task<FuncionarioResponseDto?> BuscarPorIdAsync(int id);
    Task<(FuncionarioResponseDto? dto, string? erro)> CriarAsync(CriarFuncionarioDto dto);
    Task<(FuncionarioResponseDto? dto, string? erro)> EditarAsync(int id, EditarFuncionarioDto dto);
    Task<bool> AlternarAtivoAsync(int id);
    Task<bool> ExcluirAsync(int id);
}
