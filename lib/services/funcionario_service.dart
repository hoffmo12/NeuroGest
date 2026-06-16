// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/funcionario.dart';
// import 'auth_service.dart';

// class FuncionarioService {
//   static const String _baseUrl = 'http://localhost:5279';

//   // ─── Headers com JWT ──────────────────────────────────
//   static Future<Map<String, String>> _headers() async {
//     final token = await AuthService.getToken();
//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   // ─── Listar todos ─────────────────────────────────────
//   static Future<List<Funcionario>> listar() async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/api/funcionarios'),
//       headers: await _headers(),
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> lista = jsonDecode(response.body);
//       return lista.map((j) => Funcionario.fromJson(j)).toList();
//     }
//     return [];
//   }

//   // ─── Criar ────────────────────────────────────────────
//   static Future<String?> criar({
//     required String nome,
//     required String email,
//     required String senha,
//     required String funcao,
//     required String perfil,
//     String? telefone,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/api/funcionarios'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'nome': nome,
//         'email': email,
//         'senha': senha,
//         'funcao': funcao,
//         'perfil': perfil,
//         'telefone': telefone,
//       }),
//     );

//     if (response.statusCode == 201) return null;
//     final body = jsonDecode(response.body);
//     return body['mensagem'] ?? 'Erro ao criar funcionário.';
//   }

//   // ─── Editar ───────────────────────────────────────────
//   static Future<String?> editar({
//     required int id,
//     required String nome,
//     required String email,
//     required String funcao,
//     required String perfil,
//     String? telefone,
//     String? novaSenha,
//   }) async {
//     final response = await http.put(
//       Uri.parse('$_baseUrl/api/funcionarios/$id'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'nome': nome,
//         'email': email,
//         'funcao': funcao,
//         'perfil': perfil,
//         'telefone': telefone,
//         'novaSenha': novaSenha,
//       }),
//     );

//     if (response.statusCode == 200) return null;
//     final body = jsonDecode(response.body);
//     return body['mensagem'] ?? 'Erro ao editar funcionário.';
//   }

//   // ─── Alternar ativo/inativo ───────────────────────────
//   static Future<bool> alternarAtivo(int id) async {
//     final response = await http.patch(
//       Uri.parse('$_baseUrl/api/funcionarios/$id/alternar-ativo'),
//       headers: await _headers(),
//     );
//     return response.statusCode == 200;
//   }

//   // ─── Excluir ──────────────────────────────────────────
//   static Future<bool> excluir(int id) async {
//     final response = await http.delete(
//       Uri.parse('$_baseUrl/api/funcionarios/$id'),
//       headers: await _headers(),
//     );
//     return response.statusCode == 200;
//   }

//   final List<String> cboPermitidoAtendimento = ['Psicólogo Clinico', ''];
// }

// class CBOPermitido {
//   static bool motivoDaConsulta(String cbo) {
//     final List<String> cbosPermitidos = [
//       'Fisioterapeuta Geral',
//       'Psicólogo Clínico',
//       'Nutricionista',
//       'Fonoaudiólogo',
//       'Terapeuta Ocupacional',
//       'Psicopedagogo',
//     ].toList();
//     return cbosPermitidos.any(
//       (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
//     );
//   }

//   static bool anamnese(String cbo) {
//     final List<String> cbosPermitidos = [
//       'Fisioterapeuta Geral',
//       'Psicólogo Clínico',
//       'Nutricionista',
//       'Fonoaudiólogo',
//       'Terapeuta Ocupacional',
//       'Psicopedagogo',
//     ];
//     return cbosPermitidos.any(
//       (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
//     );
//   }

//   static bool antropometria(String cbo) {
//     final List<String> cbosPermitidos = [
//       'Fisioterapeuta Geral',
//       'Terapeuta Ocupacional',
//     ];
//     return cbosPermitidos.any(
//       (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
//     );
//   }

//   static bool examefisico(String cbo) {
//     final List<String> cbosPermitidos = [
//       'Fisioterapeuta Geral',
//       'Terapeuta Ocupacional',
//     ];
//     return cbosPermitidos.any(
//       (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
//     );
//   }

//   static bool diagnostico(String cbo) {
//     final List<String> cbosPermitidos = [
//       'Fisioterapeuta Geral',
//       'Psicólogo Clínico',
//       'Nutricionista',
//       'Fonoaudiólogo',
//       'Terapeuta Ocupacional',
//       'Psicopedagogo',
//     ];
//     return cbosPermitidos.any(
//       (element) => element.toLowerCase().trim() == cbo.toLowerCase().trim(),
//     );
//   }
// }
