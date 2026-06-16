import '../models/aluno.dart';
import '../models/funcionario.dart';
import '../models/atendimento.dart';
import '../models/calendario.dart';
import '../models/mes.dart';
import '../models/dia.dart';
import '../models/aluno_agendado.dart';

class MockDatabase {
  static final MockDatabase instance = MockDatabase._internal();

  MockDatabase._internal() {
    funcionarios.addAll([
      Funcionario(
        id: 1,
        nome: 'Bruno Breitwisser',
        login: 'bruno@gmail.com',
        senha: '123123',
        cpf: '111.359.909-05',
        cbo: 'Fisioterapeuta Geral',
        tipoRegistro: 'CREFITO',
        numRegistro: '123456-F',
        nivelDeAcesso: 'admin',
        telefone: '42988071863',
        ativo: true,
        criadoEm: DateTime.now(),
      ),
      Funcionario(
        id: 2,
        nome: 'Nathaly Hoffmann',
        login: 'nath@gmail.com',
        senha: 'abc123',
        cpf: '123.456.789-10',
        cbo: 'Psicólogo Clínico',
        tipoRegistro: 'CRP',
        numRegistro: '08/1234',
        nivelDeAcesso: 'gerente',
        telefone: '42998595785',
        ativo: true,
        criadoEm: DateTime.now(),
      ),
      Funcionario(
        id: 3,
        nome: 'Guilherme Meneguini',
        login: 'guigo@gmail.com',
        senha: '654321',
        cpf: '987.654.321-00',
        cbo: 'Nutricionista',
        tipoRegistro: 'CRN',
        numRegistro: '8-1234',
        nivelDeAcesso: 'usuario',
        telefone: '42999468293',
        ativo: true,
        criadoEm: DateTime.now(),
      ),
    ]);
  }

  final List<Aluno> alunos = [];

  final List<Funcionario> funcionarios = [];

  final List<Atendimento> atendimentos = [];

  final List<Calendario> calendarios = [];

  final List<Mes> meses = [];

  final List<Dia> dias = [];

  final List<AlunoAgendado> agendamentos = [];
}
