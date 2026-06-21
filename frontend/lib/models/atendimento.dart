class Atendimento {
  final int id;
  final int idAluno;
  final int idUsuario;
  final String nomeAluno;
  final String nomeUsuario;
  final String cboUsuario;
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

  const Atendimento({
    required this.id,
    required this.idAluno,
    required this.idUsuario,
    this.nomeAluno = '',
    this.nomeUsuario = '',
    this.cboUsuario = '',
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
      id:                     json['id'] as int,
      idAluno:                json['idAluno'] as int,
      idUsuario:              json['idUsuario'] as int,
      nomeAluno:              json['nomeAluno'] as String? ?? '',
      nomeUsuario:            json['nomeUsuario'] as String? ?? '',
      cboUsuario:             json['cboUsuario'] as String? ?? '',
      motivoDaConsulta:       json['motivoDaConsulta'] as String,
      anamnese:               json['anamnese'] as String,
      peso:                   (json['peso'] as num).toDouble(),
      altura:                 (json['altura'] as num).toDouble(),
      imc:                    (json['imc'] as num).toDouble(),
      perimetroCefalico:      (json['perimetroCefalico'] as num).toDouble(),
      circunferenciaAbdominal:(json['circunferenciaAbdominal'] as num).toDouble(),
      perimetroPanturrilha:   (json['perimetroPanturrilha'] as num).toDouble(),
      exameFisico:            json['exameFisico'] as String,
      diagnostico:            json['diagnostico'] as String,
      dataAtendimento:        DateTime.parse(json['dataAtendimento'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':                     id,
      'idAluno':                idAluno,
      'idUsuario':              idUsuario,
      'motivoDaConsulta':       motivoDaConsulta,
      'anamnese':               anamnese,
      'peso':                   peso,
      'altura':                 altura,
      'imc':                    imc,
      'perimetroCefalico':      perimetroCefalico,
      'circunferenciaAbdominal':circunferenciaAbdominal,
      'perimetroPanturrilha':   perimetroPanturrilha,
      'exameFisico':            exameFisico,
      'diagnostico':            diagnostico,
      'dataAtendimento':        dataAtendimento.toIso8601String(),
    };
  }
}