class Usuario {
  final int id;
  final String nome;
  final String email;
  final String? cpf;
  final String cbo;
  final String tipoRegistro;
  final String numRegistro;
  final String perfil;
  final String? telefone;
  final bool ativo;
  final DateTime criadoEm;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.cpf,
    required this.cbo,
    required this.tipoRegistro,
    required this.numRegistro,
    required this.perfil,
    this.telefone,
    required this.ativo,
    required this.criadoEm,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id:           json['id'] as int,
      nome:         json['nome'] as String,
      email:        json['email'] as String,
      cpf:          json['cpf'] as String?,
      cbo:          json['cbo'] as String? ?? '',
      tipoRegistro: json['tipoRegistro'] as String? ?? '',
      numRegistro:  json['numRegistro'] as String? ?? '',
      perfil:       json['perfil'] as String,
      telefone:     json['telefone'] as String?,
      ativo:        json['ativo'] as bool,
      criadoEm:     DateTime.parse(json['criadoEm'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':           id,
      'nome':         nome,
      'email':        email,
      'cpf':          cpf,
      'cbo':          cbo,
      'tipoRegistro': tipoRegistro,
      'numRegistro':  numRegistro,
      'perfil':       perfil,
      'telefone':     telefone,
      'ativo':        ativo,
      'criadoEm':     criadoEm.toIso8601String(),
    };
  }
}