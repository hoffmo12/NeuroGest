using System.ComponentModel.DataAnnotations;

namespace NeuroGest.API.DTOs;

// ─── Login ────────────────────────────────────────────────
public class LoginDto
{
    [Required(ErrorMessage = "Email é obrigatório.")]
    [EmailAddress(ErrorMessage = "Email inválido.")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Senha é obrigatória.")]
    [MinLength(6, ErrorMessage = "A senha deve ter ao menos 6 caracteres.")]
    public string Senha { get; set; } = string.Empty;
}

// ─── Cadastro (auto-registro) ─────────────────────────────
public class CadastroDto
{
    [Required(ErrorMessage = "Nome é obrigatório.")]
    [MaxLength(150)]
    public string Nome { get; set; } = string.Empty;

    [Required(ErrorMessage = "Email é obrigatório.")]
    [EmailAddress(ErrorMessage = "Email inválido.")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Senha é obrigatória.")]
    [MinLength(6)]
    public string Senha { get; set; } = string.Empty;

    [Required]
    [Compare("Senha", ErrorMessage = "As senhas não coincidem.")]
    public string ConfirmarSenha { get; set; } = string.Empty;

    public string Perfil { get; set; } = "usuario";
}

// ─── Resposta de autenticação ─────────────────────────────
public class AuthResponseDto
{
    public string Token    { get; set; } = string.Empty;
    public string Nome     { get; set; } = string.Empty;
    public string Email    { get; set; } = string.Empty;
    public string Perfil   { get; set; } = string.Empty;
    public DateTime ExpiraEm { get; set; }
}

// ─── Criar funcionário (admin cria na tabela usuarios) ────
public class CriarFuncionarioDto
{
    [Required(ErrorMessage = "Nome é obrigatório.")]
    [MaxLength(150)]
    public string Nome { get; set; } = string.Empty;

    [Required(ErrorMessage = "Email é obrigatório.")]
    [EmailAddress(ErrorMessage = "Email inválido.")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Senha é obrigatória.")]
    [MinLength(6, ErrorMessage = "A senha deve ter ao menos 6 caracteres.")]
    public string Senha { get; set; } = string.Empty;

    [Required(ErrorMessage = "Função é obrigatória.")]
    [MaxLength(100)]
    public string Funcao { get; set; } = string.Empty;

    [Required(ErrorMessage = "Perfil é obrigatório.")]
    public string Perfil { get; set; } = "usuario";

    [MaxLength(20)]
    public string? Telefone { get; set; }
}

// ─── Editar funcionário ───────────────────────────────────
public class EditarFuncionarioDto
{
    [Required(ErrorMessage = "Nome é obrigatório.")]
    [MaxLength(150)]
    public string Nome { get; set; } = string.Empty;

    [Required(ErrorMessage = "Email é obrigatório.")]
    [EmailAddress(ErrorMessage = "Email inválido.")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Função é obrigatória.")]
    [MaxLength(100)]
    public string Funcao { get; set; } = string.Empty;

    [Required(ErrorMessage = "Perfil é obrigatório.")]
    public string Perfil { get; set; } = "usuario";

    [MaxLength(20)]
    public string? Telefone { get; set; }

    [MinLength(6, ErrorMessage = "A nova senha deve ter ao menos 6 caracteres.")]
    public string? NovaSenha { get; set; }
}

// ─── Resposta de funcionário ──────────────────────────────
public class FuncionarioResponseDto
{
    public int      Id       { get; set; }
    public string   Nome     { get; set; } = string.Empty;
    public string   Email    { get; set; } = string.Empty;
    public string?  Funcao   { get; set; }
    public string   Perfil   { get; set; } = string.Empty;
    public string?  Telefone { get; set; }
    public bool     Ativo    { get; set; }
    public DateTime CriadoEm { get; set; }
}
