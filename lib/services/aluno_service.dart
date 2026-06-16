// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:neurogest_front/models/atendimento.dart';
// import '../models/aluno.dart';
// import 'auth_service.dart';

// class AlunoService {
//   static const String _baseUrl = 'http://localhost:5279';

//   static Future<Map<String, String>> _headers() async {
//     final token = await AuthService.getToken();
//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   static final List<Atendimento> atendimentos = [
//     Atendimento(
//       id: 1,
//       nomeAluno: "Lucas Andrade",
//       criadoEm: DateTime(2026, 3, 10, 14, 30),
//       profissional: "Dra. Paula Ribeiro",
//       profissionalCBO: "2251 - Médico Pediatra",
//     ),
//     Atendimento(
//       id: 2,
//       nomeAluno: "Lucas Andrade",
//       criadoEm: DateTime(2026, 4, 5, 9, 15),
//       profissional: "Psicólogo João Martins",
//       profissionalCBO: "2515 - Psicólogo Clínico",
//     ),

//     Atendimento(
//       id: 3,
//       nomeAluno: "Ana Beatriz Souza",
//       criadoEm: DateTime(2026, 2, 20, 10, 45),
//       profissional: "Enfermeira Carla Silva",
//       profissionalCBO: "2235 - Enfermeiro",
//     ),
//     Atendimento(
//       id: 4,
//       nomeAluno: "Ana Beatriz Souza",
//       criadoEm: DateTime(2026, 3, 18, 15, 00),
//       profissional: "Fonoaudióloga Renata Costa",
//       profissionalCBO: "2238 - Fonoaudiólogo",
//     ),
//     Atendimento(
//       id: 5,
//       nomeAluno: "Ana Beatriz Souza",
//       criadoEm: DateTime(2026, 5, 2, 11, 20),
//       profissional: "Psicopedagoga Maria Oliveira",
//       profissionalCBO: "2394 - Psicopedagogo",
//     ),
//   ];

//   static Future<void> add({required Atendimento atendimento}) async {
//     atendimentos.add(atendimento);
//   }

//   Future<List<Atendimento>> listarAtendimentos({String? alunoPesquisado}) async {
//   if (alunoPesquisado != null) {
//     final listafiltrada = atendimentos
//         .where(
//           (element) => element.nomeAluno.trim().toLowerCase().contains(
//                 alunoPesquisado.trim().toLowerCase(),
//               ),
//         )
//         .toList();
//     return listafiltrada;
//   } else {
//     return atendimentos;
//   }
// }


//   // ─── Listar ───────────────────────────────────────────
//   static Future<List<Aluno>> listar({String? busca}) async {
//     final alunosTeste = [
//       Aluno(
//         id: 1,
//         nome: "Lucas Andrade",
//         dataNascimento: DateTime(2010, 5, 12),
//         idade: 16,
//         municipio: "Curitiba",
//         sexo: "Masculino",
//         estado: "PR",
//         nomePai: "Carlos Andrade",
//         nomeMae: "Mariana Andrade",
//         cpfPai: "123.456.789-00",
//         cpfMae: "987.654.321-00",
//         cpf: "111.222.333-44",
//         telefoneResponsavel: "(41) 99999-1111",
//         observacoes: "Aluno dedicado",
//         ativo: true,
//       ),
//       Aluno(
//         id: 2,
//         nome: "Ana Beatriz Souza",
//         dataNascimento: DateTime(2012, 8, 23),
//         idade: 14,
//         municipio: "Guarapuava",
//         sexo: "Feminino",
//         estado: "PR",
//         nomePai: "João Souza",
//         nomeMae: "Clara Souza",
//         cpfPai: "222.333.444-55",
//         cpfMae: "555.444.333-22",
//         cpf: "999.888.777-66",
//         telefoneResponsavel: "(42) 98888-2222",
//         observacoes: "Participa de olimpíadas de matemática",
//         ativo: true,
//       ),
//       Aluno(
//         id: 3,
//         nome: "Pedro Henrique Lima",
//         dataNascimento: DateTime(2009, 1, 30),
//         idade: 17,
//         municipio: "São Paulo",
//         sexo: "Masculino",
//         estado: "SP",
//         nomePai: "Roberto Lima",
//         nomeMae: "Fernanda Lima",
//         cpfPai: "333.444.555-66",
//         cpfMae: "666.555.444-33",
//         cpf: "123.987.456-00",
//         telefoneResponsavel: "(11) 97777-3333",
//         observacoes: "Bom desempenho em esportes",
//         ativo: true,
//       ),
//       Aluno(
//         id: 4,
//         nome: "Juliana Martins",
//         dataNascimento: DateTime(2011, 11, 15),
//         idade: 15,
//         municipio: "Londrina",
//         sexo: "Feminino",
//         estado: "PR",
//         nomePai: "Marcelo Martins",
//         nomeMae: "Patrícia Martins",
//         cpfPai: "444.555.666-77",
//         cpfMae: "777.666.555-44",
//         cpf: "321.654.987-11",
//         telefoneResponsavel: "(43) 96666-4444",
//         observacoes: "Interesse em artes",
//         ativo: false,
//       ),
//       Aluno(
//         id: 5,
//         nome: "Rafael Oliveira",
//         dataNascimento: DateTime(2013, 3, 5),
//         idade: 13,
//         municipio: "Rio de Janeiro",
//         sexo: "Masculino",
//         estado: "RJ",
//         nomePai: "Eduardo Oliveira",
//         nomeMae: "Camila Oliveira",
//         cpfPai: "555.666.777-88",
//         cpfMae: "888.777.666-55",
//         cpf: "456.123.789-22",
//         telefoneResponsavel: "(21) 95555-5555",
//         observacoes: "Precisa de reforço em matemática",
//         ativo: true,
//       ),
//       Aluno(
//         id: 6,
//         nome: "Mariana Costa",
//         dataNascimento: DateTime(2010, 7, 19),
//         idade: 16,
//         municipio: "Belo Horizonte",
//         sexo: "Feminino",
//         estado: "MG",
//         nomePai: "André Costa",
//         nomeMae: "Luciana Costa",
//         cpfPai: "666.777.888-99",
//         cpfMae: "999.888.777-66",
//         cpf: "789.456.123-33",
//         telefoneResponsavel: "(31) 94444-6666",
//         observacoes: "Excelente em redação",
//         ativo: true,
//       ),
//       Aluno(
//         id: 7,
//         nome: "Gabriel Santos",
//         dataNascimento: DateTime(2008, 9, 10),
//         idade: 18,
//         municipio: "Porto Alegre",
//         sexo: "Masculino",
//         estado: "RS",
//         nomePai: "Ricardo Santos",
//         nomeMae: "Helena Santos",
//         cpfPai: "777.888.999-00",
//         cpfMae: "000.999.888-77",
//         cpf: "654.321.987-44",
//         telefoneResponsavel: "(51) 93333-7777",
//         observacoes: "Aluno veterano",
//         ativo: false,
//       ),
//       Aluno(
//         id: 8,
//         nome: "Isabela Ferreira",
//         dataNascimento: DateTime(2014, 2, 25),
//         idade: 12,
//         municipio: "Florianópolis",
//         sexo: "Feminino",
//         estado: "SC",
//         nomePai: "Paulo Ferreira",
//         nomeMae: "Renata Ferreira",
//         cpfPai: "888.999.000-11",
//         cpfMae: "111.000.999-88",
//         cpf: "987.123.654-55",
//         telefoneResponsavel: "(48) 92222-8888",
//         observacoes: "Gosta de música",
//         ativo: true,
//       ),
//       Aluno(
//         id: 9,
//         nome: "Thiago Mendes",
//         dataNascimento: DateTime(2012, 6, 8),
//         idade: 14,
//         municipio: "Fortaleza",
//         sexo: "Masculino",
//         estado: "CE",
//         nomePai: "Fábio Mendes",
//         nomeMae: "Carla Mendes",
//         cpfPai: "999.000.111-22",
//         cpfMae: "222.111.000-99",
//         cpf: "654.987.321-66",
//         telefoneResponsavel: "(85) 91111-9999",
//         observacoes: "Bom em ciências",
//         ativo: true,
//       ),
//       Aluno(
//         id: 10,
//         nome: "Sofia Almeida",
//         dataNascimento: DateTime(2011, 12, 1),
//         idade: 15,
//         municipio: "Recife",
//         sexo: "Feminino",
//         estado: "PE",
//         nomePai: "Gustavo Almeida",
//         nomeMae: "Tatiane Almeida",
//         cpfPai: "000.111.222-33",
//         cpfMae: "333.222.111-00",
//         cpf: "321.789.654-77",
//         telefoneResponsavel: "(81) 90000-1111",
//         observacoes: "Participa de teatro",
//         ativo: true,
//       ),
//     ];

//     if (busca != null) {
//       final listafiltrada = alunosTeste
//           .where(
//             (element) => element.nome.trim().toLowerCase().contains(
//               busca.trim().toLowerCase(),
//             ),
//           )
//           .toList();
//       return listafiltrada;
//     } else {
//       return alunosTeste;
//     }
//     final uri = Uri.parse('$_baseUrl/api/alunos').replace(
//       queryParameters: busca != null && busca.isNotEmpty
//           ? {'busca': busca}
//           : null,
//     );

//     final response = await http.get(uri, headers: await _headers());

//     if (response.statusCode == 200) {
//       final List<dynamic> lista = jsonDecode(response.body);
//       return lista.map((j) => Aluno.fromJson(j)).toList();
//     }
//     return [];
//   }

//   // ─── Criar ────────────────────────────────────────────
//   static Future<String?> criar({
//     required String nome,
//     required String dataNascimento,
//     String? nomePai,
//     String? nomeMae,
//     String? cpfPai,
//     String? cpfMae,
//     String? telefoneResponsavel,
//     String? observacoes,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/api/alunos'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'nome': nome,
//         'dataNascimento': dataNascimento, // formato: yyyy-MM-dd
//         'nomePai': nomePai,
//         'nomeMae': nomeMae,
//         'cpfPai': cpfPai,
//         'cpfMae': cpfMae,
//         'telefoneResponsavel': telefoneResponsavel,
//         'observacoes': observacoes,
//       }),
//     );

//     if (response.statusCode == 201) return null;
//     try {
//       final body = jsonDecode(response.body);
//       return body['mensagem'] ?? 'Erro ao criar aluno.';
//     } catch (_) {
//       return 'Erro ao criar aluno.';
//     }
//   }

//   // ─── Editar ───────────────────────────────────────────
//   static Future<String?> editar({
//     required int id,
//     required String nome,
//     required String dataNascimento,
//     String? nomePai,
//     String? nomeMae,
//     String? cpfPai,
//     String? cpfMae,
//     String? telefoneResponsavel,
//     String? observacoes,
//   }) async {
//     final response = await http.put(
//       Uri.parse('$_baseUrl/api/alunos/$id'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'nome': nome,
//         'dataNascimento': dataNascimento,
//         'nomePai': nomePai,
//         'nomeMae': nomeMae,
//         'cpfPai': cpfPai,
//         'cpfMae': cpfMae,
//         'telefoneResponsavel': telefoneResponsavel,
//         'observacoes': observacoes,
//       }),
//     );

//     if (response.statusCode == 200) return null;
//     try {
//       final body = jsonDecode(response.body);
//       return body['mensagem'] ?? 'Erro ao editar aluno.';
//     } catch (_) {
//       return 'Erro ao editar aluno.';
//     }
//   }

//   // ─── Excluir ──────────────────────────────────────────
//   static Future<bool> excluir(int id) async {
//     final response = await http.delete(
//       Uri.parse('$_baseUrl/api/alunos/$id'),
//       headers: await _headers(),
//     );
//     return response.statusCode == 200;
//   }

//   //buscar atendimento de aluno específico
//   static Future<List<Aluno>> atendimentosss({String? paciente}) async {
//     List<Aluno> atendimentosTeste = [
//       Aluno(
//         id: 1,
//         nome: 'Ana Silva',
//         dataNascimento: DateTime(2005, 3, 12),
//         idade: 19,
//         ativo: true,
//       ),
//       Aluno(
//         id: 2,
//         nome: 'Ana Silva',
//         dataNascimento: DateTime(2004, 7, 25),
//         idade: 20,
//         ativo: true,
//       ),
//       Aluno(
//         id: 3,
//         nome: 'Ana Silva',
//         dataNascimento: DateTime(2003, 11, 8),
//         idade: 21,
//         ativo: false,
//       ),
//       Aluno(
//         id: 4,
//         nome: 'Daniela Souza',
//         dataNascimento: DateTime(2006, 1, 15),
//         idade: 18,
//         ativo: true,
//       ),
//     ];
//     final listafiltrada = atendimentosTeste
//         .where(
//           (element) => element.nome.trim().toLowerCase().contains(
//             paciente!.trim().toLowerCase(),
//           ),
//         )
//         .toList();
//     return listafiltrada;
//     final uri = Uri.parse('$_baseUrl/api/alunos/atendimentos').replace(
//       queryParameters: paciente != null && paciente.isNotEmpty
//           ? {'paciente': paciente}
//           : null,
//     );

//     final response = await http.get(uri, headers: await _headers());

//     if (response.statusCode == 200) {
//       final List<dynamic> lista = jsonDecode(response.body);
//       // return lista.map((j) => Atendimento.fromJson(j)).toList();
//     }
//     return [];
//   }
// }
