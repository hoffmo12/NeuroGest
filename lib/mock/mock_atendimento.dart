import 'package:neurogest_front/mock/mock_database.dart';

import '../models/atendimento.dart';

class AtendimentoRepository {
  static final AtendimentoRepository _instance =
      AtendimentoRepository._internal();

  factory AtendimentoRepository() {
    return _instance;
  }

  AtendimentoRepository._internal();

  final MockDatabase _db = MockDatabase.instance;

  // ==========================
  // CRIAR ATENDIMENTO
  // ==========================

  Atendimento criar({
    required int idAluno,
    required int idFuncionario,
    required String motivoDaConsulta,
    required String anamnese,
    required double peso,
    required double altura,
    required double imc,
    required double perimetroCefalico,
    required double circunferenciaAbdominal,
    required double perimetroPanturrilha,
    required String exameFisico,
    required String diagnostico,
    required DateTime dataAtendimento,
  }) {
    final atendimento = Atendimento(
      id: _gerarId(),
      idAluno: idAluno,
      idFuncionario: idFuncionario,
      motivoDaConsulta: motivoDaConsulta,
      anamnese: anamnese,
      peso: peso,
      altura: altura,
      imc: imc,
      perimetroCefalico: perimetroCefalico,
      circunferenciaAbdominal:
          circunferenciaAbdominal,
      perimetroPanturrilha:
          perimetroPanturrilha,
      exameFisico: exameFisico,
      diagnostico: diagnostico,
      dataAtendimento: dataAtendimento,
    );

    _db.atendimentos.add(atendimento);

    return atendimento;
  }

  // ==========================
  // EXCLUIR
  // ==========================

  bool excluir(int idAtendimento) {
    final quantidadeAnterior =
        _db.atendimentos.length;

    _db.atendimentos.removeWhere(
      (a) => a.id == idAtendimento,
    );

    return _db.atendimentos.length <
        quantidadeAnterior;
  }

  // ==========================
  // LISTAR TODOS
  // ==========================

  List<Atendimento> listarTodos() {
    return List.from(_db.atendimentos);
  }

  // ==========================
  // LISTAR POR ALUNO
  // ==========================

  List<Atendimento> listarPorAluno(
    int idAluno,
  ) {
    final atendimentos =
        _db.atendimentos.where(
      (a) => a.idAluno == idAluno,
    );

    final lista = atendimentos.toList();

    lista.sort(
      (a, b) => b.dataAtendimento.compareTo(
        a.dataAtendimento,
      ),
    );

    return lista;
  }

  // ==========================
  // BUSCAR ATENDIMENTO
  // DE UM ALUNO
  // ==========================

  Atendimento? buscarAtendimentoAluno({
    required int idAluno,
    required int idAtendimento,
  }) {
    try {
      return _db.atendimentos.firstWhere(
        (a) =>
            a.id == idAtendimento &&
            a.idAluno == idAluno,
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // ÚLTIMO ATENDIMENTO
  // ==========================

  Atendimento? ultimoAtendimentoAluno(
    int idAluno,
  ) {
    final atendimentos =
        listarPorAluno(idAluno);

    if (atendimentos.isEmpty) {
      return null;
    }

    return atendimentos.first;
  }

  // ==========================
  // GERAR ID
  // ==========================

  int _gerarId() {
    if (_db.atendimentos.isEmpty) {
      return 1;
    }

    return _db.atendimentos
            .map((a) => a.id)
            .reduce(
              (a, b) => a > b ? a : b,
            ) +
        1;
  }
}