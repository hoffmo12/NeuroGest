using Microsoft.AspNetCore.Mvc;
using NeuroGest.API.DTOs;
using NeuroGest.API.Services;

namespace NeuroGest.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    // POST /api/auth/cadastro
    /// <summary>Cadastra um novo usuário e retorna o token JWT.</summary>
    [HttpPost("cadastro")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Cadastro([FromBody] CadastroDto dto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var resultado = await _authService.CadastrarAsync(dto);

        if (resultado is null)
            return Conflict(new { mensagem = "Este e-mail já está cadastrado." });

        return CreatedAtAction(nameof(Cadastro), resultado);
    }

    // POST /api/auth/login
    /// <summary>Autentica o usuário e retorna o token JWT.</summary>
    [HttpPost("login")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Login([FromBody] LoginDto dto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var resultado = await _authService.LoginAsync(dto);

        if (resultado is null)
            return Unauthorized(new { mensagem = "E-mail ou senha inválidos." });

        return Ok(resultado);
    }
}
