namespace NeuroGest.API.DTOs;

// ─── Criar atendimento ────────────────────────────────────
public class CriarAtendimentoDto
{
    public int    IdAluno                 { get; set; }
    public int    IdUsuario               { get; set; }
    public string MotivoDaConsulta        { get; set; } = string.Empty;
    public string Anamnese                { get; set; } = string.Empty;
    public decimal Peso                   { get; set; }
    public decimal Altura                 { get; set; }
    public decimal Imc                    { get; set; }
    public decimal PerimetroCefalico      { get; set; }
    public decimal CircunferenciaAbdominal{ get; set; }
    public decimal PerimetroPanturrilha   { get; set; }
    public string ExameFisico             { get; set; } = string.Empty;
    public string Diagnostico             { get; set; } = string.Empty;
    public DateTime DataAtendimento       { get; set; } = DateTime.UtcNow;
}

// ─── Resposta de atendimento ──────────────────────────────
public class AtendimentoResponseDto
{
    public int      Id                       { get; set; }
    public int      IdAluno                  { get; set; }
    public string   NomeAluno                { get; set; } = string.Empty;
    public int      IdUsuario                { get; set; }
    public string   NomeUsuario              { get; set; } = string.Empty;
    public string   CboUsuario               { get; set; } = string.Empty;
    public string   MotivoDaConsulta         { get; set; } = string.Empty;
    public string   Anamnese                 { get; set; } = string.Empty;
    public decimal  Peso                     { get; set; }
    public decimal  Altura                   { get; set; }
    public decimal  Imc                      { get; set; }
    public decimal  PerimetroCefalico        { get; set; }
    public decimal  CircunferenciaAbdominal  { get; set; }
    public decimal  PerimetroPanturrilha     { get; set; }
    public string   ExameFisico              { get; set; } = string.Empty;
    public string   Diagnostico              { get; set; } = string.Empty;
    public DateTime DataAtendimento          { get; set; }
}