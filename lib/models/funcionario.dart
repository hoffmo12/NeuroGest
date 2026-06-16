class Funcionario {
  final int id;
  final String nome;
  final String login;
  final String senha;
  final String cpf;
  final String cbo;
  final String tipoRegistro;
  final String numRegistro;
  final String nivelDeAcesso;
  final String telefone;
  final bool ativo;
  final DateTime criadoEm;

  Funcionario({
    required this.id,
    required this.nome,
    required this.login,
    required this.senha,
    required this.cpf,
    required this.cbo,
    required this.tipoRegistro,
    required this.numRegistro,
    required this.nivelDeAcesso,
    required this.telefone,
    required this.ativo,
    required this.criadoEm,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      id: json['id'],
      nome: json['nome'],
      login: json['login'],
      senha: json['senha'],
      cpf: json['cpf'],
      cbo: json['cbo'],
      tipoRegistro: json['tipoRegistro'],
      numRegistro: json['numRegistro'],
      nivelDeAcesso: json['nivelDeAcesso'],
      telefone: json['telefone'],
      ativo: json['ativo'],
      criadoEm: DateTime.parse(json['criadoEm'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'login': login,
      'senha': senha,
      'cpf': cpf,
      'cbo': cbo,
      'tipoRegistro': tipoRegistro,
      'numRegistro': numRegistro,
      'nivelDeAcesso': nivelDeAcesso,
      'ativo': ativo,
      'criadoEm': criadoEm,
    };
  }
}
