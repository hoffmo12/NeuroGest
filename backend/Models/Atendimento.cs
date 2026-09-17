using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace NeuroGest.API.Models
{
    public class Atendimento
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int IdAluno { get; set; }

        [Required]
        public int IdUsuario { get; set; }

        // Agendamento que originou este atendimento. Nulo apenas em
        // atendimentos antigos, anteriores a esta exigência — novos
        // atendimentos sempre exigem um agendamento prévio (validado no
        // controller, já que registros existentes impedem tornar a coluna
        // obrigatória no banco).
        public int? IdAgendamento { get; set; }

        [Required]
        public string MotivoDaConsulta { get; set; } = string.Empty;

        [Required]
        public string Anamnese { get; set; } = string.Empty;

        [Column(TypeName = "decimal(5,2)")]
        public decimal Peso { get; set; }

        [Column(TypeName = "decimal(4,2)")]
        public decimal Altura { get; set; }

        [Column(TypeName = "decimal(4,2)")]
        public decimal Imc { get; set; }

        [Column(TypeName = "decimal(4,2)")]
        public decimal PerimetroCefalico { get; set; }

        [Column(TypeName = "decimal(4,2)")]
        public decimal CircunferenciaAbdominal { get; set; }

        [Column(TypeName = "decimal(4,2)")]
        public decimal PerimetroPanturrilha { get; set; }

        [Required]
        public string ExameFisico { get; set; } = string.Empty;

        [Required]
        public string Diagnostico { get; set; } = string.Empty;

        [Required]
        public DateTime DataAtendimento { get; set; } = DateTime.UtcNow;

        // Propriedades de Navegação para o Entity Framework (Opcional, mas recomendado)
        [ForeignKey("IdAluno")]
        public virtual Aluno? Aluno { get; set; }

        [ForeignKey("IdUsuario")]
        public virtual Usuario? Usuario { get; set; }

        [ForeignKey("IdAgendamento")]
        public virtual Agendamento? Agendamento { get; set; }
    }
}