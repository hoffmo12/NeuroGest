using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace NeuroGest.API.Models;

[Table("funcionarios")]
public class Funcionario
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Required]
    [MaxLength(150)]
    [Column("nome")]
    public string Nome { get; set; } = string.Empty;

    [Required]
    [MaxLength(200)]
    [Column("email")]
    public string Email { get; set; } = string.Empty;

    [Required]
    [Column("senha_hash")]
    public string SenhaHash { get; set; } = string.Empty;

    // Ex: "Terapeuta", "Recepcionista", "Coordenador"
    [Required]
    [MaxLength(100)]
    [Column("funcao")]
    public string Funcao { get; set; } = string.Empty;

    // "admin" | "gerente" | "usuario"
    [Required]
    [MaxLength(20)]
    [Column("perfil")]
    public string Perfil { get; set; } = "usuario";

    [MaxLength(20)]
    [Column("telefone")]
    public string? Telefone { get; set; }

    [Column("ativo")]
    public bool Ativo { get; set; } = true;

    [Column("criado_em")]
    public DateTime CriadoEm { get; set; } = DateTime.UtcNow;
}
