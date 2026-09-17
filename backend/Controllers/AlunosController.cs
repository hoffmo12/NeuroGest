using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NeuroGest.API.DTOs;
using NeuroGest.API.Services;

namespace NeuroGest.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
[Authorize]
public class AlunosController : ControllerBase
{
    private readonly IAlunoService _service;

    public AlunosController(IAlunoService service)
    {
        _service = service;
    }

    // GET /api/alunos?busca=nome
    [HttpGet]
    public async Task<IActionResult> Listar([FromQuery] string? busca)
    {
        var lista = await _service.ListarAsync(busca);
        return Ok(lista);
    }

    // GET /api/alunos/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> BuscarPorId(int id)
    {
        var aluno = await _service.BuscarPorIdAsync(id);
        if (aluno is null)
            return NotFound(new { mensagem = "Aluno não encontrado." });
        return Ok(aluno);
    }

    // POST /api/alunos
    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] AlunoDto dto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var resultado = await _service.CriarAsync(dto);
        return CreatedAtAction(nameof(BuscarPorId), new { id = resultado.Id }, resultado);
    }

    // PUT /api/alunos/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> Editar(int id, [FromBody] AlunoDto dto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var (resultado, erro) = await _service.EditarAsync(id, dto);

        if (erro == "Aluno não encontrado.")
            return NotFound(new { mensagem = erro });

        return Ok(resultado);
    }

    // PATCH /api/alunos/{id}/alternar-ativo
    [HttpPatch("{id}/alternar-ativo")]
    public async Task<IActionResult> AlternarAtivo(int id)
    {
        var ok = await _service.AlternarAtivoAsync(id);
        if (!ok) return NotFound(new { mensagem = "Aluno não encontrado." });
        return Ok(new { mensagem = "Status alterado com sucesso." });
    }

    // DELETE /api/alunos/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        var (ok, erro) = await _service.ExcluirAsync(id);
        if (!ok && erro == "Aluno não encontrado.")
            return NotFound(new { mensagem = erro });
        if (!ok)
            return Conflict(new { mensagem = erro });
        return Ok(new { mensagem = "Aluno excluído com sucesso." });
    }
}
