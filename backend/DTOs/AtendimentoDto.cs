using System.ComponentModel.DataAnnotations;

namespace NeuroGest.API.DTOs;

// ─── Criar atendimento ────────────────────────────────────
public class CriarAtendimentoDto
{
    public int    IdAluno                 { get; set; }
    public int    IdUsuario               { get; set; }

    [Required(ErrorMessage = "É necessário selecionar um agendamento prévio para registrar o atendimento.")]
    public int?   IdAgendamento           { get; set; }

    [StringLength(1000, ErrorMessage = "Motivo da consulta deve ter no máximo 1000 caracteres.")]
    public string MotivoDaConsulta        { get; set; } = string.Empty;

    [StringLength(1000, ErrorMessage = "Anamnese deve ter no máximo 1000 caracteres.")]
    public string Anamnese                { get; set; } = string.Empty;

    public decimal Peso                   { get; set; }
    public decimal Altura                 { get; set; }
    public decimal Imc                    { get; set; }
    public decimal PerimetroCefalico      { get; set; }
    public decimal CircunferenciaAbdominal{ get; set; }
    public decimal PerimetroPanturrilha   { get; set; }

    [StringLength(1000, ErrorMessage = "Exame físico deve ter no máximo 1000 caracteres.")]
    public string ExameFisico             { get; set; } = string.Empty;

    [StringLength(1000, ErrorMessage = "Diagnóstico deve ter no máximo 1000 caracteres.")]
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
    public int?     IdAgendamento            { get; set; }
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