using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace NeuroGest.API.Models;

public class Lancamento
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int IdAluno { get; set; }

    [Required]
    public int IdAtendimento { get; set; }

    // Usuário que registrou o lançamento
    [Required]
    public int IdUsuario { get; set; }

    // Se veio de um parcelamento anterior
    public int? IdLancamentoPai { get; set; }

    [Column(TypeName = "decimal(10,2)")]
    public decimal ValorOriginal { get; set; }

    [Column(TypeName = "decimal(10,2)")]
    public decimal ValorPago { get; set; } = 0;

    [Column(TypeName = "decimal(10,2)")]
    public decimal ValorRestante { get; set; }

    public bool Quitado { get; set; } = false;

    public DateTime DataLancamento { get; set; } = DateTime.UtcNow;

    public DateTime? DataPagamento { get; set; }

    // ─── Navegação ────────────────────────────────────────
    [ForeignKey("IdAluno")]
    public virtual Aluno? Aluno { get; set; }

    [ForeignKey("IdAtendimento")]
    public virtual Atendimento? Atendimento { get; set; }

    [ForeignKey("IdUsuario")]
    public virtual Usuario? Usuario { get; set; }

    [ForeignKey("IdLancamentoPai")]
    public virtual Lancamento? LancamentoPai { get; set; }
}