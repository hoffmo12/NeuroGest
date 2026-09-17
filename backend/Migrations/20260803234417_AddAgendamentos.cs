using System;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace NeuroGest.API.Migrations
{
    /// <inheritdoc />
    public partial class AddAgendamentos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Agendamentos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    IdAluno = table.Column<int>(type: "int", nullable: false),
                    IdUsuario = table.Column<int>(type: "int", nullable: false),
                    Horario = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    ValorConsulta = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    EstaPago = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    Faltou = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    CriadoEm = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Agendamentos", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Agendamentos_Usuarios_IdUsuario",
                        column: x => x.IdUsuario,
                        principalTable: "Usuarios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Agendamentos_alunos_IdAluno",
                        column: x => x.IdAluno,
                        principalTable: "alunos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.UpdateData(
                table: "Usuarios",
                keyColumn: "Id",
                keyValue: 1,
                column: "SenhaHash",
                value: "$2a$11$PiinQDeT8UxheGaAgSBvtOmkLDeky5WeXwxhvJ1gcQB6pOmNBb6Tq");

            migrationBuilder.CreateIndex(
                name: "IX_Agendamentos_IdAluno",
                table: "Agendamentos",
                column: "IdAluno");

            migrationBuilder.CreateIndex(
                name: "IX_Agendamentos_IdUsuario",
                table: "Agendamentos",
                column: "IdUsuario");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Agendamentos");

            migrationBuilder.UpdateData(
                table: "Usuarios",
                keyColumn: "Id",
                keyValue: 1,
                column: "SenhaHash",
                value: "$2a$11$t62m1F6bPgAJVefw8RK5GOkbptZjmWBe/vqcwokfAJHr..x/WVOeW");
        }
    }
}
