class Calendario {
  final int id;
  final int idFuncionario;

  Calendario({
    required this.id,
    required this.idFuncionario,
  });

  factory Calendario.fromJson(Map<String, dynamic> json) {
    return Calendario(
      id: json['id'],
      idFuncionario: json['idFuncionario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idFuncionario': idFuncionario,
    };
  }
}