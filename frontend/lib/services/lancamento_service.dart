import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lancamento.dart';
import 'auth_service.dart';

class PagarResult {
  final String? erro;
  final Lancamento? novoLancamento;
  PagarResult({this.erro, this.novoLancamento});
}

class LancamentoService {
  static const String _baseUrl = 'https://api.neurogest.online/api/lancamentos';

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── Listar por mês/ano ───────────────────────────────
  static Future<List<Lancamento>> listar({int? mes, int? ano}) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      if (mes != null) 'mes': '$mes',
      if (ano != null) 'ano': '$ano',
    });
    final response = await http.get(uri, headers: await _headers());
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((j) => Lancamento.fromJson(j)).toList();
    }
    return [];
  }

  // ─── Resumo mensal ────────────────────────────────────
  static Future<ResumoFinanceiro?> resumo({required int mes, required int ano}) async {
    final uri = Uri.parse('$_baseUrl/resumo')
        .replace(queryParameters: {'mes': '$mes', 'ano': '$ano'});
    final response = await http.get(uri, headers: await _headers());
    if (response.statusCode == 200) {
      return ResumoFinanceiro.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // ─── Criar lançamento ─────────────────────────────────
  static Future<String?> criar({
    required int idAluno,
    required int idAtendimento,
    required int idUsuario,
    // required double valorOriginal,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: await _headers(),
      body: jsonEncode({
        'idAluno':       idAluno,
        'idAtendimento': idAtendimento,
        'idUsuario':     idUsuario,
        // 'valorOriginal': valorOriginal,
      }),
    );
    if (response.statusCode == 201) return null;
    final body = jsonDecode(response.body);
    return body['mensagem'] ?? 'Erro ao criar lançamento.';
  }

  // ─── Editar valor ─────────────────────────────────────
  static Future<String?> editar({
    required int id,
    required double valorOriginal,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: await _headers(),
      body: jsonEncode({'valorOriginal': valorOriginal}),
    );
    if (response.statusCode == 200) return null;
    final body = jsonDecode(response.body);
    return body['mensagem'] ?? 'Erro ao editar lançamento.';
  }

  // ─── Pagar (parcial ou total) ─────────────────────────
  static Future<PagarResult> pagar({
    required int id,
    required double valorPago,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$id/pagar'),
      headers: await _headers(),
      body: jsonEncode({'valorPago': valorPago}),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final novo = body['novoLancamento'] != null
          ? Lancamento.fromJson(body['novoLancamento'])
          : null;
      return PagarResult(novoLancamento: novo);
    }
    final body = jsonDecode(response.body);
    return PagarResult(
      erro: body['mensagem'] ?? 'Erro ao registrar pagamento.',
    );
  }

  // ─── Excluir ─────────────────────────────────────────
  static Future<String?> excluir(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) return null;
    final body = jsonDecode(response.body);
    return body['mensagem'] ?? 'Erro ao excluir lançamento.';
  }
}