using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace NeuroGest.API.Models;

public class Agendamento
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int IdAluno { get; set; }

    // Profissional para o qual a consulta foi agendada
    [Required]
    public int IdUsuario { get; set; }

    [Required]
    public DateTime Horario { get; set; }

    [Column(TypeName = "decimal(10,2)")]
    public decimal ValorConsulta { get; set; }

    public bool EstaPago { get; set; } = false;

    public bool Faltou { get; set; } = false;

    public DateTime CriadoEm { get; set; } = DateTime.UtcNow;

    // ─── Navegação ────────────────────────────────────────
    [ForeignKey("IdAluno")]
    public virtual Aluno? Aluno { get; set; }

    [ForeignKey("IdUsuario")]
    public virtual Usuario? Usuario { get; set; }
}
