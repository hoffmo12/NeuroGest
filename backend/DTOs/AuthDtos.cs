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

    public string Perfil { get; set; } = "profissional";
}

// ─── Resposta de autenticação — agora com todos os campos ─
public class AuthResponseDto
{
    public int      Id           { get; set; }
    public string   Token        { get; set; } = string.Empty;
    public string   Nome         { get; set; } = string.Empty;
    public string   Email        { get; set; } = string.Empty;
    public string   Perfil       { get; set; } = string.Empty;
    public string   Cbo          { get; set; } = string.Empty;
    public string   TipoRegistro { get; set; } = string.Empty;
    public string   NumRegistro  { get; set; } = string.Empty;
    public DateTime ExpiraEm     { get; set; }
}

// ─── Criar usuário ────────────────────────────────────────
public class CriarUsuarioDto
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

    [MaxLength(14)]
    public string? Cpf { get; set; }

    [MaxLength(100)]
    public string Cbo { get; set; } = string.Empty;

    [MaxLength(50)]
    public string TipoRegistro { get; set; } = string.Empty;

    [MaxLength(50)]
    public string NumRegistro { get; set; } = string.Empty;

    [Required(ErrorMessage = "Perfil é obrigatório.")]
    public string Perfil { get; set; } = "profissional";

    [MaxLength(20)]
    public string? Telefone { get; set; }
}

// ─── Editar usuário ───────────────────────────────────────
public class EditarUsuarioDto
{
    [Required(ErrorMessage = "Nome é obrigatório.")]
    [MaxLength(150)]
    public string Nome { get; set; } = string.Empty;

    [Required(ErrorMessage = "Email é obrigatório.")]
    [EmailAddress(ErrorMessage = "Email inválido.")]
    public string Email { get; set; } = string.Empty;

    [MaxLength(14)]
    public string? Cpf { get; set; }

    [MaxLength(100)]
    public string Cbo { get; set; } = string.Empty;

    [MaxLength(50)]
    public string TipoRegistro { get; set; } = string.Empty;

    [MaxLength(50)]
    public string NumRegistro { get; set; } = string.Empty;

    [Required(ErrorMessage = "Perfil é obrigatório.")]
    public string Perfil { get; set; } = "profissional";

    [MaxLength(20)]
    public string? Telefone { get; set; }

    [MinLength(6, ErrorMessage = "A nova senha deve ter ao menos 6 caracteres.")]
    public string? NovaSenha { get; set; }
}

// ─── Resposta de usuário ──────────────────────────────────
public class UsuarioResponseDto
{
    public int      Id           { get; set; }
    public string   Nome         { get; set; } = string.Empty;
    public string   Email        { get; set; } = string.Empty;
    public string?  Cpf          { get; set; }
    public string   Cbo          { get; set; } = string.Empty;
    public string   TipoRegistro { get; set; } = string.Empty;
    public string   NumRegistro  { get; set; } = string.Empty;
    public string   Perfil       { get; set; } = string.Empty;
    public string?  Telefone     { get; set; }
    public bool     Ativo        { get; set; }
    public DateTime CriadoEm     { get; set; }
}