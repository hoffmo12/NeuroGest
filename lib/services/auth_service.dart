import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Se estiver testando no emulador Android, use: http://10.0.2.2:5000
  // Se estiver testando no celular físico ou Web, use o IP da sua máquina: http://192.168.x.x:5000
  // Se estiver testando no Windows/Desktop, use: http://localhost:5000
  static const String _baseUrl = 'http://localhost:5279';

  // ─── Login ────────────────────────────────────────────
  static Future<AuthResult> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _salvarToken(data['token'], data['nome'], data['email']);
        return AuthResult.sucesso(data['nome']);
      } else if (response.statusCode == 401) {
        return AuthResult.erro('E-mail ou senha inválidos.');
      } else {
        return AuthResult.erro('Erro inesperado. Tente novamente.');
      }
    } catch (e) {
      return AuthResult.erro('Não foi possível conectar ao servidor.\nVerifique se a API está rodando.');
    }
  }

  // ─── Salvar token localmente ──────────────────────────
  static Future<void> _salvarToken(String token, String nome, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('nome', nome);
    await prefs.setString('email', email);
  }

  // ─── Recuperar token salvo ────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ─── Recuperar nome do usuário logado ─────────────────
  static Future<String?> getNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nome');
  }

  // ─── Logout ───────────────────────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('nome');
    await prefs.remove('email');
  }

  // ─── Verificar se está logado ─────────────────────────
  static Future<bool> estaLogado() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

// ─── Classe auxiliar para retorno do login ────────────────
class AuthResult {
  final bool sucesso;
  final String? nomeUsuario;
  final String? mensagemErro;

  AuthResult._({required this.sucesso, this.nomeUsuario, this.mensagemErro});

  factory AuthResult.sucesso(String nome) =>
      AuthResult._(sucesso: true, nomeUsuario: nome);

  factory AuthResult.erro(String mensagem) =>
      AuthResult._(sucesso: false, mensagemErro: mensagem);
}
