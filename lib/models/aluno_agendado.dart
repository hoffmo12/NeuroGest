class AlunoAgendado {
  final int id;

  final int idAluno;
  final int idFuncionario;
  final int idDia;

  final String horario;

  final double valorDaConsulta;

  final bool estaPago;
  final bool faltou;

  AlunoAgendado({
    required this.id,
    required this.idAluno,
    required this.idFuncionario,
    required this.idDia,
    required this.horario,
    required this.valorDaConsulta,
    required this.estaPago,
    required this.faltou,
  });

  factory AlunoAgendado.fromJson(
    Map<String, dynamic> json,
  ) {
    return AlunoAgendado(
      id: json['id'],
      idAluno: json['idAluno'],
      idFuncionario: json['idFuncionario'],
      idDia: json['idDia'],
      horario: json['horario'],
      valorDaConsulta:
          (json['valorDaConsulta'] as num).toDouble(),
      estaPago: json['estaPago'],
      faltou: json['faltou'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idAluno': idAluno,
      'idFuncionario': idFuncionario,
      'idDia': idDia,
      'horario': horario,
      'valorDaConsulta': valorDaConsulta,
      'estaPago': estaPago,
      'faltou': faltou,
    };
  }
}