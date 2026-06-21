using System.ComponentModel.DataAnnotations;

namespace NeuroGest.API.DTOs;

// ─── Criar lançamento (gerado ao salvar atendimento) ─────
public class CriarLancamentoDto
{
    [Required]
    public int IdAluno { get; set; }

    [Required]
    public int IdAtendimento { get; set; }

    [Required]
    public int IdUsuario { get; set; }

    [Required]
    [Range(0.01, double.MaxValue, ErrorMessage = "Valor deve ser maior que zero.")]
    public decimal ValorOriginal { get; set; }
}

// ─── Editar valor do lançamento ───────────────────────────
public class EditarLancamentoDto
{
    [Required]
    [Range(0.01, double.MaxValue, ErrorMessage = "Valor deve ser maior que zero.")]
    public decimal ValorOriginal { get; set; }
}

// ─── Registrar pagamento ──────────────────────────────────
public class PagarLancamentoDto
{
    [Required]
    [Range(0.01, double.MaxValue, ErrorMessage = "Valor pago deve ser maior que zero.")]
    public decimal ValorPago { get; set; }
}

// ─── Resposta de lançamento ───────────────────────────────
public class LancamentoResponseDto
{
    public int      Id                { get; set; }
    public int      IdAluno           { get; set; }
    public string   NomeAluno         { get; set; } = string.Empty;
    public int      IdAtendimento     { get; set; }
    public int      IdUsuario         { get; set; }
    public string   NomeUsuario       { get; set; } = string.Empty;
    public int?     IdLancamentoPai   { get; set; }
    public decimal  ValorOriginal     { get; set; }
    public decimal  ValorPago         { get; set; }
    public decimal  ValorRestante     { get; set; }
    public bool     Quitado           { get; set; }
    public DateTime DataLancamento    { get; set; }
    public DateTime? DataPagamento    { get; set; }
}

// ─── Resumo financeiro mensal ─────────────────────────────
public class ResumoFinanceiroDto
{
    public decimal TotalRecebido      { get; set; }
    public decimal TotalEmAberto      { get; set; }
    public decimal TotalPrevisto      { get; set; }
    public int     QtdPagos           { get; set; }
    public int     QtdEmAberto        { get; set; }
}