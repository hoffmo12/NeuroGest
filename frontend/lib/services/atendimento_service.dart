import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/atendimento.dart';
import 'auth_service.dart';

class AtendimentoSalvoResult {
  final Atendimento? atendimento;
  final String? erro;
  AtendimentoSalvoResult({this.atendimento, this.erro});
}

class AtendimentoService {
  static const String _baseUrl = 'http://localhost:5279/api/atendimentos';

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── Listar todos ─────────────────────────────────────
  static Future<List<Atendimento>> listarTodos() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((j) => Atendimento.fromJson(j)).toList();
    }
    return [];
  }

  // ─── Listar por aluno ─────────────────────────────────
  static Future<List<Atendimento>> listarPorAluno(int idAluno) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/aluno/$idAluno'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((j) => Atendimento.fromJson(j)).toList();
    }
    return [];
  }

  // ─── Buscar por ID ────────────────────────────────────
  static Future<Atendimento?> buscarPorId(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return Atendimento.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // ─── Último atendimento do aluno ──────────────────────
  static Future<Atendimento?> ultimoAtendimentoAluno(int idAluno) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/aluno/$idAluno/ultimo'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return Atendimento.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // ─── Salvar (retorna só erro) ─────────────────────────
  static Future<String?> salvar(Atendimento atendimento) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: await _headers(),
      body: jsonEncode(atendimento.toJson()),
    );
    if (response.statusCode == 201) return null;
    final body = jsonDecode(response.body);
    return body['mensagem'] ?? 'Erro ao salvar atendimento.';
  }

  // ─── Salvar e retornar o atendimento criado ───────────
  static Future<AtendimentoSalvoResult> salvarComRetorno(
      Atendimento atendimento) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: await _headers(),
      body: jsonEncode(atendimento.toJson()),
    );
    if (response.statusCode == 201) {
      final criado = Atendimento.fromJson(jsonDecode(response.body));
      return AtendimentoSalvoResult(atendimento: criado);
    }
    final body = jsonDecode(response.body);
    return AtendimentoSalvoResult(
      erro: body['mensagem'] ?? 'Erro ao salvar atendimento.',
    );
  }

  // ─── Excluir ──────────────────────────────────────────
  // Retorna null em caso de sucesso, ou a mensagem de erro do backend
  // (ex.: quando existem lançamentos financeiros vinculados).
  static Future<String?> excluir(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) return null;
    try {
      final body = jsonDecode(response.body);
      return body['mensagem'] ?? 'Erro ao excluir atendimento.';
    } catch (_) {
      return 'Erro ao excluir atendimento.';
    }
  }
}