import 'package:neurogest_front/mock/mock_database.dart';

import '../models/funcionario.dart';

class FuncionarioRepository {
  static final FuncionarioRepository _instance =
      FuncionarioRepository._internal();

  factory FuncionarioRepository() {
    return _instance;
  }

  FuncionarioRepository._internal();

  final MockDatabase _db = MockDatabase.instance;

  // ==========================
  // LISTAR
  // ==========================

  List<Funcionario> listar() {
    return _db.funcionarios.toList();
  }

  // ==========================
  // BUSCAR POR ID
  // ==========================

  Funcionario? buscarPorId(int id) {
    try {
      return _db.funcionarios.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // BUSCAR POR LOGIN
  // ==========================

  Funcionario? buscarPorLogin(String login) {
    try {
      return _db.funcionarios.firstWhere(
        (f) => f.login.toLowerCase() == login.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // VALIDAR LOGIN
  // ==========================

  Funcionario? autenticar(String login, String senha) {
    try {
      return _db.funcionarios.firstWhere(
        (f) => f.login == login && f.senha == senha && f.ativo,
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // VERIFICAR LOGIN EXISTENTE
  // ==========================

  bool loginJaExiste(String login) {
    return _db.funcionarios.any(
      (f) => f.login.toLowerCase() == login.toLowerCase(),
    );
  }

  // ==========================
  // CADASTRAR
  // ==========================

  Funcionario criar({
    required String nome,
    required String login,
    required String senha,
    required String cpf,
    required String cbo,
    required String tipoRegistro,
    required String numRegistro,
    required String nivelDeAcesso,
    required String telefone,
  }) {
    if (loginJaExiste(login)) {
      throw Exception('Já existe um funcionário com este login.');
    }

    final novoFuncionario = Funcionario(
      id: _gerarId(),
      nome: nome,
      login: login,
      senha: senha,
      cpf: cpf,
      cbo: cbo,
      tipoRegistro: tipoRegistro,
      numRegistro: numRegistro,
      nivelDeAcesso: nivelDeAcesso,
      telefone: telefone,
      ativo: true,
      criadoEm: DateTime.now(),
    );

    _db.funcionarios.add(novoFuncionario);

    return novoFuncionario;
  }

  // ==========================
  // EDITAR
  // ==========================

  bool atualizar(Funcionario funcionarioAtualizado) {
    final index = _db.funcionarios.indexWhere(
      (f) => f.id == funcionarioAtualizado.id,
    );

    if (index == -1) {
      return false;
    }

    _db.funcionarios[index] = funcionarioAtualizado;

    return true;
  }

  // ==========================
  // EXCLUIR (LÓGICO)
  // ==========================

  bool isActive(int id, ativo) {
    final funcionario = buscarPorId(id);

    if (funcionario == null) {
      return false;
    }

    final index = _db.funcionarios.indexWhere((f) => f.id == id);

    _db.funcionarios[index] = Funcionario(
      id: funcionario.id,
      nome: funcionario.nome,
      login: funcionario.login,
      senha: funcionario.senha,
      cpf: funcionario.cpf,
      cbo: funcionario.cbo,
      tipoRegistro: funcionario.tipoRegistro,
      numRegistro: funcionario.numRegistro,
      nivelDeAcesso: funcionario.nivelDeAcesso,
      telefone: funcionario.telefone,
      ativo: ativo, //ativa/inativa o funcionário
      criadoEm: DateTime.now(),
    );

    return true;
  }

  // ==========================
  // GERADOR DE ID
  // ==========================

  int _gerarId() {
    if (_db.funcionarios.isEmpty) {
      return 1;
    }

    return _db.funcionarios.map((f) => f.id).reduce((a, b) => a > b ? a : b) +
        1;
  }
}

class CBOPermitido {
  static bool motivoDaConsulta(String cbo) {
    final List<String> cbosPermitidos = [
      'Fisioterapeuta Geral',
      'Psicólogo Clínico',
      'Nutricionista',
      'Fonoaudiólogo',
      'Terapeuta Ocupacional',
      'Psicopedagogo',
    ].toList();
    return cbosPermitidos.any(
      (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
    );
  }

  static bool anamnese(String cbo) {
    final List<String> cbosPermitidos = [
      'Fisioterapeuta Geral',
      'Psicólogo Clínico',
      'Nutricionista',
      'Fonoaudiólogo',
      'Terapeuta Ocupacional',
      'Psicopedagogo',
    ];
    return cbosPermitidos.any(
      (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
    );
  }

  static bool antropometria(String cbo) {
    final List<String> cbosPermitidos = [
      'Fisioterapeuta Geral',
      'Terapeuta Ocupacional',
    ];
    return cbosPermitidos.any(
      (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
    );
  }

  static bool examefisico(String cbo) {
    final List<String> cbosPermitidos = [
      'Fisioterapeuta Geral',
      'Terapeuta Ocupacional',
    ];
    return cbosPermitidos.any(
      (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
    );
  }

  static bool diagnostico(String cbo) {
    final List<String> cbosPermitidos = [
      'Fisioterapeuta Geral',
      'Psicólogo Clínico',
      'Nutricionista',
      'Fonoaudiólogo',
      'Terapeuta Ocupacional',
      'Psicopedagogo',
    ];
    return cbosPermitidos.any(
      (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
    );
  }
}
