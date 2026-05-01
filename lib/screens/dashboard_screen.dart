import 'package:flutter/material.dart';
import '../models/aluno.dart';
import '../widgets/neuro_widgets.dart';
import '../services/auth_service.dart';
import 'alunos_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<Aluno> alunos;

  const DashboardScreen({
    super.key,
    required this.alunos,
  });

  void abrirAlunos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlunosScreen(alunos: alunos),
      ),
    );
  }

  Future<void> sair(BuildContext context) async {
    // Limpa o token e dados do usuário salvos localmente
    await AuthService.logout();

    if (!context.mounted) return;

    // Volta para o login e remove todas as telas anteriores da pilha
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(alunos: alunos),
      ),
      (_) => false,
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
                const NeuroHeaderTitle(title: 'DASHBOARD'),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: NeuroPanel(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                    child: Column(
                      children: [
                        NeuroTopBar(
                          title: 'NEUROGEST',
                          right: NeuroPillButton(
                            text: 'SAIR',
                            width: 80,
                            height: 34,
                            fontSize: 11,
                            onPressed: () => sair(context),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 14,
                          children: [
                            NeuroPillButton(
                              text: 'ATENDIMENTOS',
                              onPressed: () {},
                            ),
                            NeuroPillButton(
                              text: 'ALUNOS',
                              onPressed: () => abrirAlunos(context),
                            ),
                            NeuroPillButton(
                              text: 'FINANCEIRO',
                              onPressed: () {},
                            ),
                            NeuroPillButton(
                              text: 'FUNCIONÁRIOS',
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: NeuroLogo(size: 82),
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
