class Agendamento {
  final int id;
  final int idAluno;
  final String nomeAluno;
  final int idUsuario;
  final String nomeUsuario;
  final DateTime horario;
  final double valorConsulta;
  final bool estaPago;
  final bool faltou;

  Agendamento({
    required this.id,
    required this.idAluno,
    required this.nomeAluno,
    required this.idUsuario,
    required this.nomeUsuario,
    required this.horario,
    required this.valorConsulta,
    required this.estaPago,
    required this.faltou,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id:            json['id'],
      idAluno:       json['idAluno'],
      nomeAluno:     json['nomeAluno'] ?? '',
      idUsuario:     json['idUsuario'],
      nomeUsuario:   json['nomeUsuario'] ?? '',
      horario:       DateTime.parse(json['horario'].toString()),
      valorConsulta: (json['valorConsulta'] as num).toDouble(),
      estaPago:      json['estaPago'],
      faltou:        json['faltou'],
    );
  }
}

// ─── Profissional para o seletor do calendário ────────────
class Profissional {
  final int id;
  final String nome;
  final String cbo;

  Profissional({required this.id, required this.nome, required this.cbo});

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      id: json['id'],
      nome: json['nome'] ?? '',
      cbo: json['cbo'] ?? '',
    );
  }
}
