using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace NeuroGest.API.Models;

[Table("alunos")]
public class Aluno
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Required]
    [MaxLength(150)]
    [Column("nome")]
    public string Nome { get; set; } = string.Empty;

    [Required]
    [Column("data_nascimento")]
    public DateOnly DataNascimento { get; set; }

    // Calculado dinamicamente — não salvo no banco
    [NotMapped]
    public int Idade => CalcularIdade(DataNascimento);

    [MaxLength(150)]
    [Column("nome_pai")]
    public string? NomePai { get; set; }

    [Required]
    [MaxLength(150)]
    [Column("nome_mae")]
    public string NomeMae { get; set; } = string.Empty;

    [Required]
    [MaxLength(14)]
    [Column("cpf")]
    public string Cpf { get; set; } = string.Empty;

    [MaxLength(14)]
    [Column("cpf_pai")]
    public string? CpfPai { get; set; }

    [MaxLength(14)]
    [Column("cpf_mae")]
    public string? CpfMae { get; set; }

    [MaxLength(20)]
    [Column("telefone_responsavel")]
    public string? TelefoneResponsavel { get; set; }

    [MaxLength(200)]
    [Column("observacoes")]
    public string? Observacoes { get; set; }

    [Column("ativo")]
    public bool Ativo { get; set; } = true;

    [Column("criado_em")]
    public DateTime CriadoEm { get; set; } = DateTime.UtcNow;

    private static int CalcularIdade(DateOnly nascimento)
    {
        var hoje = DateOnly.FromDateTime(DateTime.Today);
        var idade = hoje.Year - nascimento.Year;
        if (nascimento > hoje.AddYears(-idade)) idade--;
        return idade;
    }
}
