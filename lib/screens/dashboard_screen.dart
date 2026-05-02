import 'package:flutter/material.dart';
import '../widgets/neuro_widgets.dart';
import '../services/auth_service.dart';
import 'alunos_screen.dart';
import 'funcionarios_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _nome   = '';
  String _perfil = '';

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final nome   = await AuthService.getNome()   ?? '';
    final perfil = await AuthService.getPerfil() ?? 'usuario';
    setState(() { _nome = nome; _perfil = perfil; });
  }

  bool get _podeVerAtendimentos => true;
  bool get _podeVerAlunos       => true;
  bool get _podeVerFinanceiro   => _perfil == 'admin' || _perfil == 'gerente';
  bool get _podeVerFuncionarios => _perfil == 'admin';

  void _bloqueado(String funcao) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Acesso negado: seu perfil não permite acessar $funcao.'),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _sair() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Widget _badgePerfil() {
    final map = {
      'admin':   (const Color(0xFF4CAF50), 'ADMIN'),
      'gerente': (const Color(0xFF2196F3), 'GERENTE'),
      'usuario': (const Color(0xFF9E9E9E), 'USUÁRIO'),
    };
    final (cor, label) = map[_perfil] ?? (const Color(0xFF9E9E9E), 'USUÁRIO');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NeuroTopBar(
                          title: 'NEUROGEST',
                          right: NeuroPillButton(
                            text: 'SAIR', width: 80, height: 34, fontSize: 11,
                            onPressed: _sair,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_nome.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('Olá, $_nome!',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(width: 8),
                                _badgePerfil(),
                              ],
                            ),
                          ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 14,
                          children: [
                            _BotaoMenu(
                              texto: 'ATENDIMENTOS',
                              liberado: _podeVerAtendimentos,
                              onPressed: () {},
                              onBloqueado: () => _bloqueado('Atendimentos'),
                            ),
                            _BotaoMenu(
                              texto: 'ALUNOS',
                              liberado: _podeVerAlunos,
                              onPressed: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const AlunosScreen())),
                              onBloqueado: () => _bloqueado('Alunos'),
                            ),
                            _BotaoMenu(
                              texto: 'FINANCEIRO',
                              liberado: _podeVerFinanceiro,
                              onPressed: () {},
                              onBloqueado: () => _bloqueado('Financeiro'),
                            ),
                            _BotaoMenu(
                              texto: 'FUNCIONÁRIOS',
                              liberado: _podeVerFuncionarios,
                              onPressed: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const FuncionariosScreen())),
                              onBloqueado: () => _bloqueado('Funcionários'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                        const Align(alignment: Alignment.bottomRight, child: NeuroLogo(size: 82)),
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

class _BotaoMenu extends StatelessWidget {
  final String texto;
  final bool liberado;
  final VoidCallback onPressed;
  final VoidCallback onBloqueado;

  const _BotaoMenu({
    required this.texto, required this.liberado,
    required this.onPressed, required this.onBloqueado,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: liberado ? 1.0 : 0.4,
      child: NeuroPillButton(
        text: liberado ? texto : '🔒 $texto',
        onPressed: liberado ? onPressed : onBloqueado,
      ),
    );
  }
}