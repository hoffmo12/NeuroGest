class Aluno {
  final int id;
  final String nome;
  final DateTime dataNascimento;
  final int idade;
  final String? municipio;
  final String? sexo;
  final String? estado;
  final String? nomePai;
  final String? nomeMae;
  final String? cpf;
  final String? telefoneResponsavel;
  final String? observacoes;
  final bool ativo;

  Aluno({
    required this.id,
    required this.nome,
    required this.dataNascimento,
    required this.idade,
    this.nomePai,
    this.municipio,
    this.sexo,
    this.estado,
    this.nomeMae,
    this.cpf,
    this.telefoneResponsavel,
    this.observacoes,
    required this.ativo,
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['id'],
      nome: json['nome'],
      dataNascimento: DateTime.parse(json['dataNascimento'].toString()),
      idade: json['idade'],
      municipio: json['municipio'],
      sexo: json['sexo'],
      estado: json['estado'],
      nomePai: json['nomePai'],
      nomeMae: json['nomeMae'],
      cpf: json['cpf'],
      telefoneResponsavel: json['telefoneResponsavel'],
      observacoes: json['observacoes'],
      ativo: json['ativo'],
    );
  }

  String get dataNascimentoFormatada {
    return '${dataNascimento.day.toString().padLeft(2, '0')}/'
        '${dataNascimento.month.toString().padLeft(2, '0')}/'
        '${dataNascimento.year}';
  }
}
