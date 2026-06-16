class Atendimento {
  final int id;
  final int idAluno;
  final int idFuncionario;

  final String motivoDaConsulta;
  final String anamnese;

  final double peso;
  final double altura;
  final double imc;

  final double perimetroCefalico;
  final double circunferenciaAbdominal;
  final double perimetroPanturrilha;

  final String exameFisico;
  final String diagnostico;

  final DateTime dataAtendimento;

  Atendimento({
    required this.id,
    required this.idAluno,
    required this.idFuncionario,
    required this.motivoDaConsulta,
    required this.anamnese,
    required this.peso,
    required this.altura,
    required this.imc,
    required this.perimetroCefalico,
    required this.circunferenciaAbdominal,
    required this.perimetroPanturrilha,
    required this.exameFisico,
    required this.diagnostico,
    required this.dataAtendimento,
  });

  factory Atendimento.fromJson(Map<String, dynamic> json) {
    return Atendimento(
      id: json['id'],
      idAluno: json['idAluno'],
      idFuncionario: json['idFuncionario'],
      motivoDaConsulta: json['motivoDaConsulta'],
      anamnese: json['anamnese'],
      peso: (json['peso'] as num).toDouble(),
      altura: (json['altura'] as num).toDouble(),
      imc: (json['imc'] as num).toDouble(),
      perimetroCefalico:
          (json['perimetroCefalico'] as num).toDouble(),
      circunferenciaAbdominal:
          (json['circunferenciaAbdominal'] as num).toDouble(),
      perimetroPanturrilha:
          (json['perimetroPanturrilha'] as num).toDouble(),
      exameFisico: json['exameFisico'],
      diagnostico: json['diagnostico'],
      dataAtendimento:
          DateTime.parse(json['dataAtendimento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idAluno': idAluno,
      'idFuncionario': idFuncionario,
      'motivoDaConsulta': motivoDaConsulta,
      'anamnese': anamnese,
      'peso': peso,
      'altura': altura,
      'imc': imc,
      'perimetroCefalico': perimetroCefalico,
      'circunferenciaAbdominal': circunferenciaAbdominal,
      'perimetroPanturrilha': perimetroPanturrilha,
      'exameFisico': exameFisico,
      'diagnostico': diagnostico,
      'dataAtendimento': dataAtendimento.toIso8601String(),
    };
  }
}