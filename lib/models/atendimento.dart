class Atendimento {
  final int id;
  final String nomeAluno;
  final String profissional;
  final String profissionalCBO;
  final DateTime criadoEm;
  

  Atendimento({
    required this.id,
    required this.nomeAluno,
    required this.criadoEm,
    required this.profissional,
    required this.profissionalCBO,
    
  });

  factory Atendimento.fromJson(Map<String, dynamic> json) {
    return Atendimento(
      id: json['id'],
      nomeAluno: json['nomeAluno'],
      criadoEm: DateTime.parse(json['criadoEm'].toString()),
      profissional: json['profissional'],
      profissionalCBO: json['profissionalCBO'],
    );
  }
}
