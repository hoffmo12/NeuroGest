import 'package:neurogest_front/mock/mock_database.dart';

import '../models/aluno.dart';

class AlunoRepository {
  static final AlunoRepository _instance =
      AlunoRepository._internal();

  factory AlunoRepository() {
    return _instance;
  }

  AlunoRepository._internal();

  final MockDatabase _db = MockDatabase.instance;

  // ==========================
  // LISTAR TODOS
  // ==========================

  List<Aluno> listar() {
    return _db.alunos
        .where((a) => a.ativo)
        .toList();
  }

  // ==========================
  // BUSCAR POR ID
  // ==========================

  Aluno? buscarPorId(int id) {
    try {
      return _db.alunos.firstWhere(
        (a) => a.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // BUSCAR POR CPF
  // ==========================

  Aluno? buscarPorCpf(String cpf) {
    try {
      return _db.alunos.firstWhere(
        (a) => a.cpf == cpf,
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // BUSCAR POR NOME
  // ==========================

  Aluno? buscarPorNome(String nome) {
    return _db.alunos.where((aluno) {
      return aluno.ativo &&
          aluno.nome
              .toLowerCase().trim()
              .contains(nome.toLowerCase().trim());
    }).firstOrNull;
  }

  // ==========================
  // VERIFICAR CPF EXISTENTE
  // ==========================

  bool cpfJaExiste(String? cpf) {
    if (cpf == null || cpf.isEmpty) {
      return false;
    }

    return _db.alunos.any(
      (a) => a.cpf == cpf,
    );
  }

  // ==========================
  // CRIAR ALUNO
  // ==========================

  Aluno criar({
    required String nome,
    required DateTime dataNascimento,
    required int idade,
    String? municipio,
    String? sexo,
    String? estado,
    String? nomePai,
    String? nomeMae,
    String? cpf,
    String? telefoneResponsavel,
    String? observacoes,
  }) {
    if (cpfJaExiste(cpf)) {
      throw Exception(
        'Já existe um aluno com este CPF.',
      );
    }

    final aluno = Aluno(
      id: _gerarId(),
      nome: nome,
      dataNascimento: dataNascimento,
      idade: idade,
      municipio: municipio,
      sexo: sexo,
      estado: estado,
      nomePai: nomePai,
      nomeMae: nomeMae,
      cpf: cpf,
      telefoneResponsavel:
          telefoneResponsavel,
      observacoes: observacoes,
      ativo: true,
    );

    _db.alunos.add(aluno);

    return aluno;
  }

  // ==========================
  // ATUALIZAR
  // ==========================

  bool atualizar(Aluno alunoAtualizado) {
    final index = _db.alunos.indexWhere(
      (a) => a.id == alunoAtualizado.id,
    );

    if (index == -1) {
      return false;
    }

    _db.alunos[index] = alunoAtualizado;

    return true;
  }

  // ==========================
  // INATIVAR
  // ==========================

  bool inativar(int id) {
    final aluno = buscarPorId(id);

    if (aluno == null) {
      return false;
    }

    final index = _db.alunos.indexWhere(
      (a) => a.id == id,
    );

    _db.alunos[index] = Aluno(
      id: aluno.id,
      nome: aluno.nome,
      dataNascimento:
          aluno.dataNascimento,
      idade: aluno.idade,
      municipio: aluno.municipio,
      sexo: aluno.sexo,
      estado: aluno.estado,
      nomePai: aluno.nomePai,
      nomeMae: aluno.nomeMae,
      cpf: aluno.cpf,
      telefoneResponsavel:
          aluno.telefoneResponsavel,
      observacoes:
          aluno.observacoes,
      ativo: false,
    );

    return true;
  }

  // ==========================
  // GERAR ID
  // ==========================

  int _gerarId() {
    if (_db.alunos.isEmpty) {
      return 1;
    }

    return _db.alunos
            .map((a) => a.id)
            .reduce(
              (a, b) => a > b ? a : b,
            ) +
        1;
  }
}