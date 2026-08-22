using Microsoft.EntityFrameworkCore;
using NeuroGest.API.Models;

namespace NeuroGest.API.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Usuario>     Usuarios     { get; set; }
    public DbSet<Aluno>       Alunos       { get; set; }
    public DbSet<Atendimento> Atendimentos { get; set; }
    public DbSet<Lancamento>  Lancamentos  { get; set; }
    public DbSet<Agendamento> Agendamentos { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Usuario>()
            .HasIndex(u => u.Email)
            .IsUnique();

        // Atendimento → Aluno
        modelBuilder.Entity<Atendimento>()
            .HasOne(a => a.Aluno)
            .WithMany()
            .HasForeignKey(a => a.IdAluno)
            .OnDelete(DeleteBehavior.Restrict);

        // Atendimento → Usuario
        modelBuilder.Entity<Atendimento>()
            .HasOne(a => a.Usuario)
            .WithMany()
            .HasForeignKey(a => a.IdUsuario)
            .OnDelete(DeleteBehavior.Restrict);

        // Atendimento → Agendamento (o atendimento nasce de um
        // agendamento prévio). Restrict: não é possível excluir o
        // agendamento enquanto existir um atendimento registrado para ele
        // — a ordem de exclusão exigida é Pagamento → Atendimento →
        // Agendamento.
        modelBuilder.Entity<Atendimento>()
            .HasOne(a => a.Agendamento)
            .WithMany()
            .HasForeignKey(a => a.IdAgendamento)
            .OnDelete(DeleteBehavior.Restrict);

        // Um agendamento só pode gerar um atendimento (impede registrar o
        // mesmo horário agendado duas vezes). MySQL trata múltiplos NULLs
        // como distintos num índice único, então atendimentos antigos sem
        // agendamento (IdAgendamento nulo) não são afetados.
        modelBuilder.Entity<Atendimento>()
            .HasIndex(a => a.IdAgendamento)
            .IsUnique();

        // Lancamento → Aluno
        modelBuilder.Entity<Lancamento>()
            .HasOne(l => l.Aluno)
            .WithMany()
            .HasForeignKey(l => l.IdAluno)
            .OnDelete(DeleteBehavior.Restrict);

        // Lancamento → Atendimento
        modelBuilder.Entity<Lancamento>()
            .HasOne(l => l.Atendimento)
            .WithMany()
            .HasForeignKey(l => l.IdAtendimento)
            .OnDelete(DeleteBehavior.Restrict);

        // Lancamento → Agendamento (gerado automaticamente ao marcar um
        // agendamento como pago). Se o agendamento for excluído, o
        // lançamento auto-gerado é removido junto.
        modelBuilder.Entity<Lancamento>()
            .HasOne(l => l.Agendamento)
            .WithMany()
            .HasForeignKey(l => l.IdAgendamento)
            .OnDelete(DeleteBehavior.Cascade);

        // Lancamento → Usuario
        modelBuilder.Entity<Lancamento>()
            .HasOne(l => l.Usuario)
            .WithMany()
            .HasForeignKey(l => l.IdUsuario)
            .OnDelete(DeleteBehavior.Restrict);

        // Lancamento → LancamentoPai (auto-referência)
        modelBuilder.Entity<Lancamento>()
            .HasOne(l => l.LancamentoPai)
            .WithMany()
            .HasForeignKey(l => l.IdLancamentoPai)
            .OnDelete(DeleteBehavior.Restrict);

        // Agendamento → Aluno
        modelBuilder.Entity<Agendamento>()
            .HasOne(a => a.Aluno)
            .WithMany()
            .HasForeignKey(a => a.IdAluno)
            .OnDelete(DeleteBehavior.Restrict);

        // Agendamento → Usuario
        modelBuilder.Entity<Agendamento>()
            .HasOne(a => a.Usuario)
            .WithMany()
            .HasForeignKey(a => a.IdUsuario)
            .OnDelete(DeleteBehavior.Restrict);

        // ─── Seed: admin padrão ───────────────────────────
        modelBuilder.Entity<Usuario>().HasData(new Usuario
        {
            Id           = 1,
            Nome         = "Administrador",
            Email        = "admin@neurogect.com",
            SenhaHash    = BCrypt.Net.BCrypt.HashPassword("admin123"),
            Cpf          = null,
            Cbo          = "",
            TipoRegistro = "",
            NumRegistro  = "",
            Perfil       = "admin",
            Telefone     = null,
            Ativo        = true,
            CriadoEm     = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc),
        });
    }
}