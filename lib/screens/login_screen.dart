import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../models/aluno.dart';
import '../widgets/neuro_widgets.dart';

class LoginScreen extends StatefulWidget {
  final List<Aluno> alunos;

  const LoginScreen({
    super.key,
    required this.alunos,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void entrar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(alunos: widget.alunos),
      ),
    );
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 26,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'NEUROGEST',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const NeuroLogo(size: 85),
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
                        NeuroPillButton(
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