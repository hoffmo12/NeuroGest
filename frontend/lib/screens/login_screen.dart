import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../widgets/neuro_widgets.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> entrar() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro('Preencha o e-mail e a senha.');
      return;
    }

    setState(() => _carregando = true);
    final resultado = await AuthService.login(email, senha);
    setState(() => _carregando = false);

    if (!mounted) return;

    if (resultado.sucesso) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      _mostrarErro(resultado.mensagemErro ?? 'Erro desconhecido.');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensagem),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const NeuroHeaderTitle(title: 'TELA DE LOGIN'),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: NeuroPanel(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
                    child: Column(
                      children: [
                        const Text('NEUROGEST',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),
                        const NeuroLogo(size: 85, animated: true),
                        const SizedBox(height: 24),
                        NeuroTextField(
                          label: 'Email:',
                          hint: 'Digite seu email',
                          controller: emailController,
                        ),
                        const SizedBox(height: 18),
                        NeuroTextField(
                          label: 'Senha:',
                          hint: 'Digite sua senha',
                          controller: senhaController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        _carregando
                            ? const CircularProgressIndicator(color: Colors.black)
                            : NeuroPillButton(
                                text: 'ENTRAR',
                                width: 120,
                                height: 42,
                                onPressed: entrar,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}