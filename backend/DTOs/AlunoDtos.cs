using System.ComponentModel.DataAnnotations;

namespace NeuroGest.API.DTOs;

// ─── Criar / Editar aluno ─────────────────────────────────
public class AlunoDto
{
    [Required(ErrorMessage = "Nome é obrigatório.")]
    [MaxLength(150)]
    public string Nome { get; set; } = string.Empty;

    [Required(ErrorMessage = "Data de nascimento é obrigatória.")]
    public DateOnly DataNascimento { get; set; }

    [MaxLength(100)]
    public string? Municipio { get; set; }

    [MaxLength(20)]
    public string? Sexo { get; set; }

    [MaxLength(2)]
    public string? Estado { get; set; }

    [MaxLength(150)]
    public string? NomePai { get; set; }

    [Required(ErrorMessage = "Nome da mãe é obrigatório.")]
    [MaxLength(150)]
    public string NomeMae { get; set; } = string.Empty;

    [Required(ErrorMessage = "CPF do aluno é obrigatório.")]
    [MaxLength(14)]
    public string Cpf { get; set; } = string.Empty;

    [MaxLength(14)]
    public string? CpfPai { get; set; }

    [MaxLength(14)]
    public string? CpfMae { get; set; }

    [MaxLength(20)]
    public string? TelefoneResponsavel { get; set; }

    [MaxLength(200, ErrorMessage = "Observações devem ter no máximo 200 caracteres.")]
    public string? Observacoes { get; set; }
}

// ─── Resposta ─────────────────────────────────────────────
public class AlunoResponseDto
{
    public int      Id                  { get; set; }
    public string   Nome                { get; set; } = string.Empty;
    public DateOnly DataNascimento      { get; set; }
    public int      Idade               { get; set; }
    public string?  Municipio           { get; set; }
    public string?  Sexo                { get; set; }
    public string?  Estado              { get; set; }
    public string?  NomePai             { get; set; }
    public string   NomeMae             { get; set; } = string.Empty;
    public string   Cpf                 { get; set; } = string.Empty;
    public string?  CpfPai              { get; set; }
    public string?  CpfMae              { get; set; }
    public string?  TelefoneResponsavel { get; set; }
    public string?  Observacoes         { get; set; }
    public bool     Ativo               { get; set; }
    public DateTime CriadoEm           { get; set; }
}
