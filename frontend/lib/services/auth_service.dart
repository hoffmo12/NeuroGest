import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:5279';

  // ─── Login ────────────────────────────────────────────
  static Future<AuthResult> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _salvarSessao(
          token:        data['token']        ?? '',
          id:           data['id']           ?? 0,
          nome:         data['nome']         ?? '',
          email:        data['email']        ?? '',
          perfil:       data['perfil']       ?? '',
          cbo:          data['cbo']          ?? '',
          tipoRegistro: data['tipoRegistro'] ?? '',
          numRegistro:  data['numRegistro']  ?? '',
        );
        return AuthResult.sucesso(data['nome'], data['perfil']);
      } else if (response.statusCode == 401) {
        return AuthResult.erro('E-mail ou senha inválidos.');
      } else {
        return AuthResult.erro('Erro inesperado. Tente novamente.');
      }
    } catch (e) {
      return AuthResult.erro(
          'Não foi possível conectar ao servidor.\nVerifique se a API está rodando.');
    }
  }

  // ─── Salvar sessão ────────────────────────────────────
  static Future<void> _salvarSessao({
    required String token,
    required int    id,
    required String nome,
    required String email,
    required String perfil,
    required String cbo,
    required String tipoRegistro,
    required String numRegistro,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token',        token);
    await prefs.setInt   ('id',           id);
    await prefs.setString('nome',         nome);
    await prefs.setString('email',        email);
    await prefs.setString('perfil',       perfil);
    await prefs.setString('cbo',          cbo);
    await prefs.setString('tipoRegistro', tipoRegistro);
    await prefs.setString('numRegistro',  numRegistro);
  }

  // ─── Getters ──────────────────────────────────────────
  static Future<String?> getToken()        async =>
      (await SharedPreferences.getInstance()).getString('token');
  static Future<int?>    getId()           async =>
      (await SharedPreferences.getInstance()).getInt('id');
  static Future<String?> getNome()         async =>
      (await SharedPreferences.getInstance()).getString('nome');
  static Future<String?> getEmail()        async =>
      (await SharedPreferences.getInstance()).getString('email');
  static Future<String?> getPerfil()       async =>
      (await SharedPreferences.getInstance()).getString('perfil');
  static Future<String?> getCbo()          async =>
      (await SharedPreferences.getInstance()).getString('cbo');
  static Future<String?> getTipoRegistro() async =>
      (await SharedPreferences.getInstance()).getString('tipoRegistro');
  static Future<String?> getNumRegistro()  async =>
      (await SharedPreferences.getInstance()).getString('numRegistro');

  // ─── Logout ───────────────────────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('id');
    await prefs.remove('nome');
    await prefs.remove('email');
    await prefs.remove('perfil');
    await prefs.remove('cbo');
    await prefs.remove('tipoRegistro');
    await prefs.remove('numRegistro');
  }

  static Future<bool> estaLogado() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

// ─── Resultado do login ───────────────────────────────────
class AuthResult {
  final bool sucesso;
  final String? nomeUsuario;
  final String? perfil;
  final String? mensagemErro;

  AuthResult._({
    required this.sucesso,
    this.nomeUsuario,
    this.perfil,
    this.mensagemErro,
  });

  factory AuthResult.sucesso(String nome, String perfil) =>
      AuthResult._(sucesso: true, nomeUsuario: nome, perfil: perfil);

  factory AuthResult.erro(String mensagem) =>
      AuthResult._(sucesso: false, mensagemErro: mensagem);
}