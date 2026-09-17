class Lancamento {
  final int id;
  final int idAluno;
  final String nomeAluno;
  final int? idAtendimento;
  final int? idAgendamento;
  final int idUsuario;
  final String nomeUsuario;
  final int? idLancamentoPai;
  final double valorOriginal;
  final double valorPago;
  final double valorRestante;
  final bool quitado;
  final DateTime dataLancamento;
  final DateTime? dataPagamento;

  const Lancamento({
    required this.id,
    required this.idAluno,
    this.nomeAluno = '',
    this.idAtendimento,
    this.idAgendamento,
    required this.idUsuario,
    this.nomeUsuario = '',
    this.idLancamentoPai,
    required this.valorOriginal,
    required this.valorPago,
    required this.valorRestante,
    required this.quitado,
    required this.dataLancamento,
    this.dataPagamento,
  });

  factory Lancamento.fromJson(Map<String, dynamic> json) {
    return Lancamento(
      id:               json['id'] as int,
      idAluno:          json['idAluno'] as int,
      nomeAluno:        json['nomeAluno'] as String? ?? '',
      idAtendimento:    json['idAtendimento'] as int?,
      idAgendamento:    json['idAgendamento'] as int?,
      idUsuario:        json['idUsuario'] as int,
      nomeUsuario:      json['nomeUsuario'] as String? ?? '',
      idLancamentoPai:  json['idLancamentoPai'] as int?,
      valorOriginal:    (json['valorOriginal'] as num).toDouble(),
      valorPago:        (json['valorPago'] as num).toDouble(),
      valorRestante:    (json['valorRestante'] as num).toDouble(),
      quitado:          json['quitado'] as bool,
      dataLancamento:   DateTime.parse(json['dataLancamento'] as String),
      dataPagamento:    json['dataPagamento'] != null
          ? DateTime.parse(json['dataPagamento'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':             id,
    'idAluno':        idAluno,
    'idAtendimento':  idAtendimento,
    'idUsuario':      idUsuario,
    'valorOriginal':  valorOriginal,
    'valorPago':      valorPago,
    'valorRestante':  valorRestante,
    'quitado':        quitado,
    'dataLancamento': dataLancamento.toIso8601String(),
  };
}

class ResumoFinanceiro {
  final double totalRecebido;
  final double totalEmAberto;
  final double totalPrevisto;
  final int qtdPagos;
  final int qtdEmAberto;

  const ResumoFinanceiro({
    required this.totalRecebido,
    required this.totalEmAberto,
    required this.totalPrevisto,
    required this.qtdPagos,
    required this.qtdEmAberto,
  });

  factory ResumoFinanceiro.fromJson(Map<String, dynamic> json) {
    return ResumoFinanceiro(
      totalRecebido: (json['totalRecebido'] as num).toDouble(),
      totalEmAberto: (json['totalEmAberto'] as num).toDouble(),
      totalPrevisto: (json['totalPrevisto'] as num).toDouble(),
      qtdPagos:      json['qtdPagos'] as int,
      qtdEmAberto:   json['qtdEmAberto'] as int,
    );
  }
}