using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace NeuroGest.API.Migrations
{
    /// <inheritdoc />
    public partial class VincularAtendimentoAgendamento : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "IdAgendamento",
                table: "Atendimentos",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Atendimentos_IdAgendamento",
                table: "Atendimentos",
                column: "IdAgendamento",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Atendimentos_Agendamentos_IdAgendamento",
                table: "Atendimentos",
                column: "IdAgendamento",
                principalTable: "Agendamentos",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Atendimentos_Agendamentos_IdAgendamento",
                table: "Atendimentos");

            migrationBuilder.DropIndex(
                name: "IX_Atendimentos_IdAgendamento",
                table: "Atendimentos");

            migrationBuilder.DropColumn(
                name: "IdAgendamento",
                table: "Atendimentos");
        }
    }
}
