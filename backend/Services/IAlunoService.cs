using NeuroGest.API.DTOs;

namespace NeuroGest.API.Services;

public interface IAlunoService
{
    Task<List<AlunoResponseDto>> ListarAsync(string? busca = null);
    Task<AlunoResponseDto?> BuscarPorIdAsync(int id);
    Task<AlunoResponseDto> CriarAsync(AlunoDto dto);
    Task<(AlunoResponseDto? dto, string? erro)> EditarAsync(int id, AlunoDto dto);
    Task<bool> AlternarAtivoAsync(int id);
    Task<(bool ok, string? erro)> ExcluirAsync(int id);
}
