import 'package:neurogest_front/mock/mock_database.dart';

import '../models/mes.dart';
import '../models/dia.dart';
import '../models/aluno_agendado.dart';

class CalendarioRepository {
  static final CalendarioRepository _instance =
      CalendarioRepository._internal();

  factory CalendarioRepository() {
    return _instance;
  }

  CalendarioRepository._internal();

  final MockDatabase _db = MockDatabase.instance;

  // ==========================
  // BUSCAR MÊS POR ID
  // ==========================

  Mes? buscarMes(int idMes) {
    try {
      return _db.meses.firstWhere((mes) => mes.id == idMes);
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // BUSCAR MÊS POR NÚMERO
  // ==========================

  Mes? buscarMesPorNumero(int numero) {
    try {
      return _db.meses.firstWhere((mes) => mes.numero == numero);
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // LISTAR TODOS OS MESES
  // ==========================

  List<Mes> listarMeses() {
    return List.from(_db.meses);
  }

  // ==========================
  // BUSCAR DIAS DO MÊS
  // ==========================

  List<Dia> buscarDiasDoMes(int idMes) {
    final dias = _db.dias.where((dia) => dia.idMes == idMes);

    final lista = dias.toList();

    lista.sort((a, b) => a.numero.compareTo(b.numero));

    return lista;
  }

  // ==========================
  // BUSCAR DIA ESPECÍFICO
  // ==========================

  Dia? buscarDia(int idDia) {
    try {
      return _db.dias.firstWhere((dia) => dia.id == idDia);
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // AGENDAMENTOS DO DIA
  // ==========================

  List<AlunoAgendado> buscarAgendamentosDoDia(int idDia) {
    final agendamentos = _db.agendamentos.where(
      (agendamento) => agendamento.idDia == idDia,
    );

    final lista = agendamentos.toList();

    lista.sort((a, b) => a.horario.compareTo(b.horario));

    return lista;
  }

  // ==========================
  // AGENDAMENTOS DO MÊS
  // ==========================

  List<AlunoAgendado> buscarAgendamentosDoMes(int idMes) {
    final idsDias = _db.dias
        .where((d) => d.idMes == idMes)
        .map((d) => d.id)
        .toSet();

    return _db.agendamentos
        .where((agendamento) => idsDias.contains(agendamento.idDia))
        .toList();
  }

  // ==========================
  // QUANTIDADE DE
  // AGENDAMENTOS NO DIA
  // ==========================

  int quantidadeAgendamentosDia(int idDia) {
    return _db.agendamentos.where((a) => a.idDia == idDia).length;
  }

  // ==========================
  // CRIAR AGENDAMENTO
  // ==========================

  AlunoAgendado criarAgendamento({
    required int idAluno,
    required int idFuncionario,
    required int idDia,
    required String horario,
    required double valorDaConsulta,
    bool estaPago = false,
    bool faltou = false,
  }) {
    final novoAgendamento = AlunoAgendado(
      id: _gerarIdAgendamento(),
      idAluno: idAluno,
      idFuncionario: idFuncionario,
      idDia: idDia,
      horario: horario,
      valorDaConsulta: valorDaConsulta,
      estaPago: estaPago,
      faltou: faltou,
    );

    _db.agendamentos.add(novoAgendamento);

    return novoAgendamento;
  }

  // ==========================
  // BUSCAR AGENDAMENTO
  // ==========================

  AlunoAgendado? buscarAgendamento(int idAgendamento) {
    try {
      return _db.agendamentos.firstWhere(
        (agendamento) => agendamento.id == idAgendamento,
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // ATUALIZAR AGENDAMENTO
  // ==========================

  bool atualizarAgendamento(AlunoAgendado agendamentoAtualizado) {
    final index = _db.agendamentos.indexWhere(
      (agendamento) => agendamento.id == agendamentoAtualizado.id,
    );

    if (index == -1) {
      return false;
    }

    _db.agendamentos[index] = agendamentoAtualizado;

    return true;
  }

  // ==========================
  // EXCLUIR AGENDAMENTO
  // ==========================

  bool excluirAgendamento(int idAgendamento) {
    final tamanhoAnterior = _db.agendamentos.length;

    _db.agendamentos.removeWhere(
      (agendamento) => agendamento.id == idAgendamento,
    );

    return _db.agendamentos.length < tamanhoAnterior;
  }

  // ==========================
  // GERADOR DE ID
  // ==========================

  int _gerarIdAgendamento() {
    if (_db.agendamentos.isEmpty) {
      return 1;
    }

    return _db.agendamentos.map((a) => a.id).reduce((a, b) => a > b ? a : b) +
        1;
  }
}
