using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace NeuroGest.API.Migrations
{
    /// <inheritdoc />
    public partial class SeedAdmin : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "usuarios",
                columns: new[] { "id", "ativo", "criado_em", "email", "funcao", "nome", "perfil", "senha_hash", "telefone" },
                values: new object[] { 1, true, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "admin@neurogest.com", "Administrador", "Administrador", "admin", "$2a$11$.3/Dw4GlKXYL5x1CAJMxnulov2QF4t.s/U2oLhNTFrkW2WuI6szCW", null });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "usuarios",
                keyColumn: "id",
                keyValue: 1);
        }
    }
}
