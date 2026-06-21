using System.ComponentModel.DataAnnotations;

namespace NeuroGest.API.Models;

public class Usuario
{
    public int Id { get; set; }

    [Required, MaxLength(150)]
    public string Nome { get; set; } = string.Empty;

    [Required, MaxLength(150)]
    public string Email { get; set; } = string.Empty;

    [Required]
    public string SenhaHash { get; set; } = string.Empty;

    [MaxLength(14)]
    public string? Cpf { get; set; }

    [MaxLength(100)]
    public string Cbo { get; set; } = string.Empty;

    [MaxLength(50)]
    public string TipoRegistro { get; set; } = string.Empty;

    [MaxLength(50)]
    public string NumRegistro { get; set; } = string.Empty;

    // "admin" | "profissional" | "recepcao"
    [Required, MaxLength(30)]
    public string Perfil { get; set; } = "profissional";

    [MaxLength(20)]
    public string? Telefone { get; set; }

    public bool Ativo { get; set; } = true;

    public DateTime CriadoEm { get; set; } = DateTime.UtcNow;
}