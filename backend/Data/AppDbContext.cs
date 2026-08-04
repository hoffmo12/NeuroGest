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