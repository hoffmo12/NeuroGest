class Funcionario {
  final int id;
  final String nome;
  final String email;
  final String funcao;
  final String perfil;
  final String? telefone;
  final bool ativo;
  final DateTime criadoEm;

  Funcionario({
    required this.id,
    required this.nome,
    required this.email,
    required this.funcao,
    required this.perfil,
    this.telefone,
    required this.ativo,
    required this.criadoEm,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      id:       json['id'],
      nome:     json['nome'],
      email:    json['email'],
      funcao:   json['funcao'],
      perfil:   json['perfil'],
      telefone: json['telefone'],
      ativo:    json['ativo'],
      criadoEm: DateTime.parse(json['criadoEm']),
    );
  }
}
