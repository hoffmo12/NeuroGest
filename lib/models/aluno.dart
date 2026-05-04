class Aluno {
  final int id;
  final String nome;
  final DateTime dataNascimento;
  final int idade;
  final String? nomePai;
  final String? nomeMae;
  final String? cpfPai;
  final String? cpfMae;
  final String? telefoneResponsavel;
  final String? observacoes;
  final bool ativo;

  Aluno({
    required this.id,
    required this.nome,
    required this.dataNascimento,
    required this.idade,
    this.nomePai,
    this.nomeMae,
    this.cpfPai,
    this.cpfMae,
    this.telefoneResponsavel,
    this.observacoes,
    required this.ativo,
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id:                  json['id'],
      nome:                json['nome'],
      dataNascimento:      DateTime.parse(json['dataNascimento'].toString()),
      idade:               json['idade'],
      nomePai:             json['nomePai'],
      nomeMae:             json['nomeMae'],
      cpfPai:              json['cpfPai'],
      cpfMae:              json['cpfMae'],
      telefoneResponsavel: json['telefoneResponsavel'],
      observacoes:         json['observacoes'],
      ativo:               json['ativo'],
    );
  }

  String get dataNascimentoFormatada {
    return '${dataNascimento.day.toString().padLeft(2, '0')}/'
        '${dataNascimento.month.toString().padLeft(2, '0')}/'
        '${dataNascimento.year}';
  }
}
