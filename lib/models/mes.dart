class Mes {
  final int id;
  final int idCalendario;
  final String nome;
  final int numero;

  Mes({
    required this.id,
    required this.idCalendario,
    required this.nome,
    required this.numero,
  });

  factory Mes.fromJson(Map<String, dynamic> json) {
    return Mes(
      id: json['id'],
      idCalendario: json['idCalendario'],
      nome: json['nome'],
      numero: json['numero'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCalendario': idCalendario,
      'nome': nome,
      'numero': numero,
    };
  }
}