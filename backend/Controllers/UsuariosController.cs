using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NeuroGest.API.DTOs;
using NeuroGest.API.Services;

namespace NeuroGest.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
[Authorize]
public class UsuariosController : ControllerBase
{
    private readonly IUsuarioService _service;

    public UsuariosController(IUsuarioService service)
    {
        _service = service;
    }

    private bool IsAdmin() =>
        User.Claims.FirstOrDefault(c => c.Type == "perfil")?.Value == "admin";

    // GET /api/usuarios
    /// <summary>Lista todos os usuários do sistema (Apenas Admin).</summary>
    [HttpGet]
    public async Task<IActionResult> Listar()
    {
        if (!IsAdmin()) return Forbid();
        var lista = await _service.ListarAsync();
        return Ok(lista);
    }

    // GET /api/usuarios/profissionais
    /// <summary>Lista básica (id/nome/cbo) dos usuários ativos, usada para o
    /// seletor de profissional do calendário. Diferente de GET /api/usuarios,
    /// aqui qualquer usuário autenticado tem acesso.</summary>
    [HttpGet("profissionais")]
    public async Task<IActionResult> ListarProfissionais()
    {
        var lista = await _service.ListarAsync();
        var profissionais = lista
            .Where(u => u.Ativo)
            .Select(u => new ProfissionalDto { Id = u.Id, Nome = u.Nome, Cbo = u.Cbo });
        return Ok(profissionais);
    }

    // GET /api/usuarios/{id}
    /// <summary>Busca um usuário pelo ID (Apenas Admin).</summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> BuscarPorId(int id)
    {
        if (!IsAdmin()) return Forbid();
        var usuario = await _service.BuscarPorIdAsync(id);
        if (usuario is null)
            return NotFound(new { mensagem = "Usuário não encontrado." });
        return Ok(usuario);
    }

    // POST /api/usuarios
    /// <summary>Cria um novo usuário administrativamente (Apenas Admin).</summary>
    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] CriarUsuarioDto dto)
    {
        if (!IsAdmin()) return Forbid();
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var (resultado, erro) = await _service.CriarAsync(dto);
        if (erro is not null)
            return Conflict(new { mensagem = erro });

        return CreatedAtAction(nameof(BuscarPorId), new { id = resultado!.Id }, resultado);
    }

    // PUT /api/usuarios/{id}
    /// <summary>Atualiza os dados de um usuário (Apenas Admin).</summary>
    [HttpPut("{id}")]
    public async Task<IActionResult> Editar(int id, [FromBody] EditarUsuarioDto dto)
    {
        if (!IsAdmin()) return Forbid();
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var (resultado, erro) = await _service.EditarAsync(id, dto);
        if (erro == "Usuário não encontrado.")
            return NotFound(new { mensagem = erro });
        if (erro is not null)
            return Conflict(new { mensagem = erro });

        return Ok(resultado);
    }

    // PATCH /api/usuarios/{id}/alternar-ativo
    /// <summary>Ativa ou desativa o acesso de um usuário (Apenas Admin).</summary>
    [HttpPatch("{id}/alternar-ativo")]
    public async Task<IActionResult> AlternarAtivo(int id)
    {
        if (!IsAdmin()) return Forbid();
        var ok = await _service.AlternarAtivoAsync(id);
        if (!ok)
            return NotFound(new { mensagem = "Usuário não encontrado." });

        return Ok(new { mensagem = "Status do usuário alterado com sucesso." });
    }

    // DELETE /api/usuarios/{id}
    /// <summary>Exclui definitivamente um usuário (Apenas Admin).</summary>
    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(int id)
    {
        if (!IsAdmin()) return Forbid();
        var ok = await _service.ExcluirAsync(id);
        if (!ok)
            return NotFound(new { mensagem = "Usuário não encontrado." });

        return Ok(new { mensagem = "Usuário excluído com sucesso." });
    }
}