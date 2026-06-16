class Dia {
  final int id;
  final int idMes;
  final int numero;
  final DateTime data;

  Dia({
    required this.id,
    required this.idMes,
    required this.numero,
    required this.data,
  });

  factory Dia.fromJson(Map<String, dynamic> json) {
    return Dia(
      id: json['id'],
      idMes: json['idMes'],
      numero: json['numero'],
      data: DateTime.parse(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idMes': idMes,
      'numero': numero,
      'data': data.toIso8601String(),
    };
  }
}