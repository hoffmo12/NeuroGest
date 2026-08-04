import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/agendamento.dart';
import 'auth_service.dart';

class AgendamentoService {
  static const String _baseUrl = 'http://localhost:5279';

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── Profissionais (para o seletor) ────────────────────
  static Future<List<Profissional>> listarProfissionais() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/usuarios/profissionais'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((j) => Profissional.fromJson(j)).toList();
    }
    return [];
  }

  // ─── Agendamentos do mês de um profissional ────────────
  static Future<List<Agendamento>> listarDoMes({
    required int idUsuario,
    required int ano,
    required int mes,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/agendamentos/mes').replace(
      queryParameters: {
        'idUsuario': idUsuario.toString(),
        'ano': ano.toString(),
        'mes': mes.toString(),
      },
    );
    final response = await http.get(uri, headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((j) => Agendamento.fromJson(j)).toList();
    }
    return [];
  }

  // ─── Criar ──────────────────────────────────────────────
  static Future<String?> criar({
    required int idAluno,
    required int idUsuario,
    required DateTime horario,
    required double valorConsulta,
    bool estaPago = false,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/agendamentos'),
      headers: await _headers(),
      body: jsonEncode({
        'idAluno':       idAluno,
        'idUsuario':     idUsuario,
        'horario':       horario.toIso8601String(),
        'valorConsulta': valorConsulta,
        'estaPago':      estaPago,
      }),
    );
    if (response.statusCode == 201) return null;
    try {
      final body = jsonDecode(response.body);
      return body['mensagem'] ?? 'Erro ao criar agendamento.';
    } catch (_) {
      return 'Erro ao criar agendamento.';
    }
  }

  // ─── Editar (pagamento / falta) ────────────────────────
  static Future<String?> editar({
    required int id,
    required double valorConsulta,
    required bool estaPago,
    required bool faltou,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/agendamentos/$id'),
      headers: await _headers(),
      body: jsonEncode({
        'valorConsulta': valorConsulta,
        'estaPago':      estaPago,
        'faltou':        faltou,
      }),
    );
    if (response.statusCode == 200) return null;
    try {
      final body = jsonDecode(response.body);
      return body['mensagem'] ?? 'Erro ao editar agendamento.';
    } catch (_) {
      return 'Erro ao editar agendamento.';
    }
  }

  // ─── Excluir ────────────────────────────────────────────
  static Future<bool> excluir(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/agendamentos/$id'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }
}
