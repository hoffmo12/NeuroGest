using System;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace NeuroGest.API.Migrations
{
    /// <inheritdoc />
    public partial class AdicionadoAtendimentos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Atendimentos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("MySql:ValueGenerationStrategy", MySqlValueGenerationStrategy.IdentityColumn),
                    IdAluno = table.Column<int>(type: "int", nullable: false),
                    IdUsuario = table.Column<int>(type: "int", nullable: false),
                    MotivoDaConsulta = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    Anamnese = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    Peso = table.Column<decimal>(type: "decimal(5,2)", nullable: false),
                    Altura = table.Column<decimal>(type: "decimal(4,2)", nullable: false),
                    Imc = table.Column<decimal>(type: "decimal(4,2)", nullable: false),
                    PerimetroCefalico = table.Column<decimal>(type: "decimal(4,2)", nullable: false),
                    CircunferenciaAbdominal = table.Column<decimal>(type: "decimal(4,2)", nullable: false),
                    PerimetroPanturrilha = table.Column<decimal>(type: "decimal(4,2)", nullable: false),
                    ExameFisico = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    Diagnostico = table.Column<string>(type: "longtext", nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    DataAtendimento = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Atendimentos", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Atendimentos_Usuarios_IdUsuario",
                        column: x => x.IdUsuario,
                        principalTable: "Usuarios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Atendimentos_alunos_IdAluno",
                        column: x => x.IdAluno,
                        principalTable: "alunos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.UpdateData(
                table: "Usuarios",
                keyColumn: "Id",
                keyValue: 1,
                column: "SenhaHash",
                value: "$2a$11$zp9JfGWTIf8cQ6ShEenfmu2R3FCpP0d0eG0KFODh.yvpfn2Ao/aYS");

            migrationBuilder.CreateIndex(
                name: "IX_Atendimentos_IdAluno",
                table: "Atendimentos",
                column: "IdAluno");

            migrationBuilder.CreateIndex(
                name: "IX_Atendimentos_IdUsuario",
                table: "Atendimentos",
                column: "IdUsuario");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Atendimentos");

            migrationBuilder.UpdateData(
                table: "Usuarios",
                keyColumn: "Id",
                keyValue: 1,
                column: "SenhaHash",
                value: "$2a$11$VahVgxsRzueAM.GheaWqZ.UImRxIse5OtjuKe7mIoDe9FvGxk.poG");
        }
    }
}
