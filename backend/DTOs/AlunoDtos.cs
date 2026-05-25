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

    [MaxLength(150)]
    public string? NomePai { get; set; }

    [MaxLength(150)]
    public string? NomeMae { get; set; }

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
    public string?  NomePai             { get; set; }
    public string?  NomeMae             { get; set; }
    public string?  CpfPai              { get; set; }
    public string?  CpfMae              { get; set; }
    public string?  TelefoneResponsavel { get; set; }
    public string?  Observacoes         { get; set; }
    public bool     Ativo               { get; set; }
    public DateTime CriadoEm           { get; set; }
}
