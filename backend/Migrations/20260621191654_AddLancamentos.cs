using System;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace NeuroGest.API.Migrations
{
    /// <inheritdoc />
    public partial class AddLancamentos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Atendimentos_Usuarios_IdUsuario",
                table: "Atendimentos");

            migrationBuilder.DropForeignKey(
                name: "FK_Atendimentos_alunos_IdAluno",
                table: "Atendimentos");

            migrationBuilder.CreateTable(
                name: "Lancamentos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    IdAluno = table.Column<int>(type: "int", nullable: false),
                    IdAtendimento = table.Column<int>(type: "int", nullable: false),
                    IdUsuario = table.Column<int>(type: "int", nullable: false),
                    IdLancamentoPai = table.Column<int>(type: "int", nullable: true),
                    ValorOriginal = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    ValorPago = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    ValorRestante = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    Quitado = table.Column<bool>(type: "tinyint(1)", nullable: false),
                    DataLancamento = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    DataPagamento = table.Column<DateTime>(type: "datetime(6)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Lancamentos", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Lancamentos_Atendimentos_IdAtendimento",
                        column: x => x.IdAtendimento,
                        principalTable: "Atendimentos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Lancamentos_Lancamentos_IdLancamentoPai",
                        column: x => x.IdLancamentoPai,
                        principalTable: "Lancamentos",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Lancamentos_Usuarios_IdUsuario",
                        column: x => x.IdUsuario,
                        principalTable: "Usuarios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Lancamentos_alunos_IdAluno",
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
                value: "$2a$11$t62m1F6bPgAJVefw8RK5GOkbptZjmWBe/vqcwokfAJHr..x/WVOeW");

            migrationBuilder.CreateIndex(
                name: "IX_Lancamentos_IdAluno",
                table: "Lancamentos",
                column: "IdAluno");

            migrationBuilder.CreateIndex(
                name: "IX_Lancamentos_IdAtendimento",
                table: "Lancamentos",
                column: "IdAtendimento");

            migrationBuilder.CreateIndex(
                name: "IX_Lancamentos_IdLancamentoPai",
                table: "Lancamentos",
                column: "IdLancamentoPai");

            migrationBuilder.CreateIndex(
                name: "IX_Lancamentos_IdUsuario",
                table: "Lancamentos",
                column: "IdUsuario");

            migrationBuilder.AddForeignKey(
                name: "FK_Atendimentos_Usuarios_IdUsuario",
                table: "Atendimentos",
                column: "IdUsuario",
                principalTable: "Usuarios",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Atendimentos_alunos_IdAluno",
                table: "Atendimentos",
                column: "IdAluno",
                principalTable: "alunos",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Atendimentos_Usuarios_IdUsuario",
                table: "Atendimentos");

            migrationBuilder.DropForeignKey(
                name: "FK_Atendimentos_alunos_IdAluno",
                table: "Atendimentos");

            migrationBuilder.DropTable(
                name: "Lancamentos");

            migrationBuilder.UpdateData(
                table: "Usuarios",
                keyColumn: "Id",
                keyValue: 1,
                column: "SenhaHash",
                value: "$2a$11$dsNpbj0La3nZNw60YUtlbOugesfFZz7OlywuCpFOJ/F4Hw5gG8gtm");

            migrationBuilder.AddForeignKey(
                name: "FK_Atendimentos_Usuarios_IdUsuario",
                table: "Atendimentos",
                column: "IdUsuario",
                principalTable: "Usuarios",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Atendimentos_alunos_IdAluno",
                table: "Atendimentos",
                column: "IdAluno",
                principalTable: "alunos",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
