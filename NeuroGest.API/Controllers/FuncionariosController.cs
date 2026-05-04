using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NeuroGest.API.DTOs;
using NeuroGest.API.Services;

namespace NeuroGest.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
[Authorize] // Exige JWT válido em todos os endpoints
public class FuncionariosController : ControllerBase
{
    private readonly IFuncionarioService _service;

    public FuncionariosController(IFuncionarioService service)
    {
        _service = service;
    }

    // Verifica se quem chama é admin
    private bool IsAdmin() =>
        User.Claims.FirstOrDefault(c => c.Type == "perfil")?.Value == "admin";

    // GET /api/funcionarios
    [HttpGet]
    public async Task<IActionResult> Listar()
    {
        if (!IsAdmin())
            return Forbid();

        var lista = await _service.ListarAsync();
        return Ok(lista);
    }

    // GET /api/funcionarios/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> BuscarPorId(int id)
    {
        if (!IsAdmin())
            return Forbid();

        var funcionario = await _service.BuscarPorIdAsync(id);
        if (funcionario is null)
            return NotFound(new { mensagem = "Funcionário não encontrado." });

        return Ok(funcionario);
    }

    // POST /api/funcionarios
    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] CriarFuncionarioDto dto)
    {
        if (!IsAdmin())
            return Forbid();

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var (resultado, erro) = await _service.CriarAsync(dto);

        if (erro is not null)
            return Conflict(new { mensagem = erro });

        return CreatedAtAction(nameof(BuscarPorId), new { id = resultado!.Id }, resultado);
    }

    // PUT /api/funcionarios/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> Editar(int id, [FromBody] EditarFuncionarioDto dto)
    {
        if (!IsAdmin())
            return Forbid();

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var (resultado, erro) = await _service.EditarAsync(id, dto);

        if (erro == "Funcionário não encontrado.")
            return NotFound(new { mensagem = erro });

        if (erro is not null)
            return Conflict(new { mensagem = erro });

        return Ok(resultado);
    }

    // PATCH /api/funcionarios/{id}/alternar-ativo
    [HttpPatch("{id}/alternar-ativo")]
    public async Task<IActionResult> AlternarAtivo(int id)
    {
        if (!IsAdmin())
            return Forbid();

        var ok = await _service.AlternarAtivoAsync(id);
        if (!ok)
            return NotFound(new { mensagem = "Funcionário não encontrado." });

        return Ok(new { mensagem = "Status alterado com sucesso." });
    }

    // DELETE /api/funcionarios/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        if (!IsAdmin())
            return Forbid();

        var ok = await _service.ExcluirAsync(id);
        if (!ok)
            return NotFound(new { mensagem = "Funcionário não encontrado." });

        return Ok(new { mensagem = "Funcionário excluído com sucesso." });
    }
}
