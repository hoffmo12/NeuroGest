using System.ComponentModel.DataAnnotations;

namespace NeuroGest.API.DTOs;

// ─── Criar agendamento ─────────────────────────────────────
public class CriarAgendamentoDto
{
    [Required]
    public int IdAluno { get; set; }

    [Required]
    public int IdUsuario { get; set; }

    [Required]
    public DateTime Horario { get; set; }

    [Required]
    [Range(0, double.MaxValue, ErrorMessage = "Valor da consulta não pode ser negativo.")]
    public decimal ValorConsulta { get; set; }

    public bool EstaPago { get; set; } = false;
}

// ─── Editar agendamento (pagamento / falta / data) ─────────
public class EditarAgendamentoDto
{
    [Required]
    [Range(0, double.MaxValue, ErrorMessage = "Valor da consulta não pode ser negativo.")]
    public decimal ValorConsulta { get; set; }

    public bool EstaPago { get; set; }

    public bool Faltou { get; set; }

    // Novo horário do agendamento. Nulo = mantém o horário atual. Só é
    // aceito se ainda não existir atendimento registrado para o agendamento.
    public DateTime? Horario { get; set; }
}

// ─── Resposta ───────────────────────────────────────────────
public class AgendamentoResponseDto
{
    public int      Id            { get; set; }
    public int      IdAluno       { get; set; }
    public string   NomeAluno     { get; set; } = string.Empty;
    public string?  ObservacoesAluno { get; set; }
    public int      IdUsuario     { get; set; }
    public string   NomeUsuario   { get; set; } = string.Empty;
    public DateTime Horario       { get; set; }
    public decimal  ValorConsulta { get; set; }
    public bool     EstaPago      { get; set; }
    public bool     Faltou        { get; set; }
    public bool     TemAtendimento { get; set; }
}

// ─── Listagem simplificada de profissionais para o seletor do
//     calendário — qualquer usuário autenticado pode consultar,
//     diferente de /api/usuarios (restrito a admin).
public class ProfissionalDto
{
    public int    Id   { get; set; }
    public string Nome { get; set; } = string.Empty;
    public string Cbo  { get; set; } = string.Empty;
}
