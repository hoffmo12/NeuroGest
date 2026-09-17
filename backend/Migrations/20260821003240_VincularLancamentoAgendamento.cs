using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace NeuroGest.API.Migrations
{
    /// <inheritdoc />
    public partial class VincularLancamentoAgendamento : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "IdAtendimento",
                table: "Lancamentos",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "IdAgendamento",
                table: "Lancamentos",
                type: "int",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Usuarios",
                keyColumn: "Id",
                keyValue: 1,
                column: "SenhaHash",
                value: "$2a$11$dn30xoMysmvboqaaza3Uzev827tIHCemDz/M6hmdOsr/Njl6HbgXG");

            migrationBuilder.CreateIndex(
                name: "IX_Lancamentos_IdAgendamento",
                table: "Lancamentos",
                column: "IdAgendamento");

            migrationBuilder.AddForeignKey(
                name: "FK_Lancamentos_Agendamentos_IdAgendamento",
                table: "Lancamentos",
                column: "IdAgendamento",
                principalTable: "Agendamentos",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Lancamentos_Agendamentos_IdAgendamento",
                table: "Lancamentos");

            migrationBuilder.DropIndex(
                name: "IX_Lancamentos_IdAgendamento",
                table: "Lancamentos");

            migrationBuilder.DropColumn(
                name: "IdAgendamento",
                table: "Lancamentos");

            migrationBuilder.AlterColumn<int>(
                name: "IdAtendimento",
                table: "Lancamentos",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.UpdateData(
                table: "Usuarios",
                keyColumn: "Id",
                keyValue: 1,
                column: "SenhaHash",
                value: "$2a$11$PiinQDeT8UxheGaAgSBvtOmkLDeky5WeXwxhvJ1gcQB6pOmNBb6Tq");
        }
    }
}
