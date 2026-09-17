using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace NeuroGest.API.Migrations
{
    /// <inheritdoc />
    public partial class AddMunicipioSexoEstadoAluno : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "municipio",
                table: "alunos",
                type: "varchar(100)",
                maxLength: 100,
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<string>(
                name: "sexo",
                table: "alunos",
                type: "varchar(20)",
                maxLength: 20,
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<string>(
                name: "estado",
                table: "alunos",
                type: "varchar(2)",
                maxLength: 2,
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "municipio",
                table: "alunos");

            migrationBuilder.DropColumn(
                name: "sexo",
                table: "alunos");

            migrationBuilder.DropColumn(
                name: "estado",
                table: "alunos");
        }
    }
}
