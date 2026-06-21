import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import 'auth_service.dart';

class UsuarioService {
  static const String _baseUrl = 'http://localhost:5279';

  // ─── Headers com JWT ──────────────────────────────────
  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── Listar todos ─────────────────────────────────────
  static Future<List<Usuario>> listar() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/usuarios'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((j) => Usuario.fromJson(j)).toList();
    }
    return [];
  }

  // ─── Criar ────────────────────────────────────────────
  static Future<String?> criar({
    required String nome,
    required String email,
    required String senha,
    required String cbo,
    required String tipoRegistro,
    required String numRegistro,
    required String perfil,
    String? cpf,
    String? telefone,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/usuarios'),
      headers: await _headers(),
      body: jsonEncode({
        'nome':         nome,
        'email':        email,
        'senha':        senha,
        'cpf':          cpf,
        'cbo':          cbo,
        'tipoRegistro': tipoRegistro,
        'numRegistro':  numRegistro,
        'perfil':       perfil,
        'telefone':     telefone,
      }),
    );
    if (response.statusCode == 201) return null;
    final body = jsonDecode(response.body);
    return body['mensagem'] ?? 'Erro ao criar usuário.';
  }

  // ─── Editar ───────────────────────────────────────────
  static Future<String?> editar({
    required int id,
    required String nome,
    required String email,
    required String cbo,
    required String tipoRegistro,
    required String numRegistro,
    required String perfil,
    String? cpf,
    String? telefone,
    String? novaSenha,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/usuarios/$id'),
      headers: await _headers(),
      body: jsonEncode({
        'nome':         nome,
        'email':        email,
        'cpf':          cpf,
        'cbo':          cbo,
        'tipoRegistro': tipoRegistro,
        'numRegistro':  numRegistro,
        'perfil':       perfil,
        'telefone':     telefone,
        'novaSenha':    novaSenha,
      }),
    );
    if (response.statusCode == 200) return null;
    final body = jsonDecode(response.body);
    return body['mensagem'] ?? 'Erro ao editar usuário.';
  }

  // ─── Alternar ativo/inativo ───────────────────────────
  static Future<bool> alternarAtivo(int id) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/api/usuarios/$id/alternar-ativo'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }

  // ─── Excluir ──────────────────────────────────────────
  static Future<bool> excluir(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/usuarios/$id'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }
}