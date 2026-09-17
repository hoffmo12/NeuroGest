import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/aluno.dart';
import 'auth_service.dart';

class AlunoService {
  static const String _baseUrl = 'https://api.neurogest.online';

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── Listar ───────────────────────────────────────────
  static Future<List<Aluno>> listar({String? busca}) async {
    final uri = Uri.parse('$_baseUrl/api/alunos')
        .replace(queryParameters: busca != null && busca.isNotEmpty ? {'busca': busca} : null);

    final response = await http.get(uri, headers: await _headers());

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((j) => Aluno.fromJson(j)).toList();
    }
    return [];
  }

  // ─── Buscar por ID ────────────────────────────────────
  static Future<Aluno?> buscarPorId(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/alunos/$id'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return Aluno.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // ─── Criar ────────────────────────────────────────────
  static Future<String?> criar({
    required String nome,
    required String dataNascimento,
    String? municipio,
    String? sexo,
    String? estado,
    String? nomePai,
    required String nomeMae,
    required String cpf,
    String? telefoneResponsavel,
    String? observacoes,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/alunos'),
      headers: await _headers(),
      body: jsonEncode({
        'nome':                nome,
        'dataNascimento':      dataNascimento, // formato: yyyy-MM-dd
        'municipio':           municipio,
        'sexo':                sexo,
        'estado':              estado,
        'nomePai':             nomePai,
        'nomeMae':             nomeMae,
        'cpf':                 cpf,
        'telefoneResponsavel': telefoneResponsavel,
        'observacoes':         observacoes,
      }),
    );

    if (response.statusCode == 201) return null;
    try {
      final body = jsonDecode(response.body);
      return body['mensagem'] ?? 'Erro ao criar aluno.';
    } catch (_) {
      return 'Erro ao criar aluno.';
    }
  }

  // ─── Editar ───────────────────────────────────────────
  static Future<String?> editar({
    required int id,
    required String nome,
    required String dataNascimento,
    String? municipio,
    String? sexo,
    String? estado,
    String? nomePai,
    required String nomeMae,
    required String cpf,
    String? telefoneResponsavel,
    String? observacoes,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/alunos/$id'),
      headers: await _headers(),
      body: jsonEncode({
        'nome':                nome,
        'dataNascimento':      dataNascimento,
        'municipio':           municipio,
        'sexo':                sexo,
        'estado':              estado,
        'nomePai':             nomePai,
        'nomeMae':             nomeMae,
        'cpf':                 cpf,
        'telefoneResponsavel': telefoneResponsavel,
        'observacoes':         observacoes,
      }),
    );

    if (response.statusCode == 200) return null;
    try {
      final body = jsonDecode(response.body);
      return body['mensagem'] ?? 'Erro ao editar aluno.';
    } catch (_) {
      return 'Erro ao editar aluno.';
    }
  }

  // ─── Excluir ──────────────────────────────────────────
  static Future<bool> excluir(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/alunos/$id'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }
}