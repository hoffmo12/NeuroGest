import 'package:flutter/material.dart';
import 'package:neurogest_front/models/usuario.dart';
import 'package:neurogest_front/screens/atendimento_screen.dart';
import 'package:neurogest_front/screens/financeiro_screen.dart';
import '../widgets/neuro_widgets.dart';
import '../services/auth_service.dart';
import 'alunos_screen.dart';
import 'funcionarios_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String email;
  const DashboardScreen(this.email, {super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _nome = '';
  String _cbo = '';
  String _tipoRegistro = '';
  String _numRegistro = '';
  String _perfil = '';
  Color cardColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    // final nome = await AuthService.getNome() ?? ''; //TODO: buscar da API o usuário correto
    // final CBO = await AuthService.getCBO() ?? '';
    // final perfil = await AuthService.getPerfil() ?? 'usuario';
    final nome = widget.email.contains('bruno')
        ? 'Bruno Braga de Moura Breitwisser'
        : 'João da Silva dos Santos';
    final cbo = widget.email.contains('bruno')
        ? 'Fisioterapeuta Geral'
        : 'Psicólogo Clínico';
    final tipoRegistro = widget.email.contains('bruno') ? 'CREFITO' : 'CRP';
    final numRegistro = widget.email.contains('bruno') ? '123456-F' : 'PR/1234';
    final perfil = 'admin';
    setState(() {
      _nome = nome;
      _cbo = cbo;
      _tipoRegistro = tipoRegistro;
      _numRegistro = numRegistro;
      _perfil = perfil;
    });
  }

  bool get _podeVerAtendimentos => true;
  bool get _podeVerAlunos => true;
  bool get _podeVerFinanceiro => _perfil == 'admin' || _perfil == 'gerente';
  bool get _podeVerFuncionarios => _perfil == 'admin';

  void _bloqueado(String funcao) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Acesso negado: seu perfil não permite acessar $funcao.'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
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

  // ─── Iniciais do nome ─────────────────────────────────
  String get _iniciais {
    final partes = _nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return _nome.isNotEmpty ? _nome[0].toUpperCase() : '?';
  }

  // ─── Badge de perfil ──────────────────────────────────
  Widget _badgePerfil() {
    final map = {
      'admin': (const Color(0xFF4CAF50), 'ADMIN'),
      'gerente': (const Color(0xFF2196F3), 'GERENTE'),
      'usuario': (const Color(0xFF9E9E9E), 'USUÁRIO'),
    };
    final (cor, label) =
        map[_perfil] ?? (const Color(0xFF9E9E9E), 'Não identificado');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ─── Card de módulo ───────────────────────────────────
  Widget _moduloCard({
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    required String titulo,
    required String subtitulo,
    required IconData icone,
    required Color corIcone,
    required bool liberado,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: liberado ? 1.0 : 0.4,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: liberado ? onTap : () => _bloqueado(titulo),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // color: const Color(0xFFF8FAFC),
              color: cardColor,
              border: Border.all(color: NeuroColors.border, width: 1.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: corIcone,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icone, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 12),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: NeuroColors.text,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: NeuroColors.mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!liberado)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.lock_outline,
                      size: 13,
                      color: NeuroColors.mutedText,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: NeuroPanel(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── TopBar ──
                      NeuroTopBar(
                        title: 'NEUROGEST',
                        right: NeuroPillButton(
                          text: 'SAIR',
                          width: 80,
                          height: 34,
                          fontSize: 11,
                          onPressed: _sair,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_nome.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: NeuroColors.border,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: NeuroColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  //TODO: alterar avatar
                                  child: Text(
                                    _iniciais,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Olá, $_nome!',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: NeuroColors.text,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _cbo,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: NeuroColors.mutedText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              _badgePerfil(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: NeuroColors.border,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'MÓDULOS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: NeuroColors.mutedText,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: NeuroColors.border,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        child: _moduloCard(
                          titulo: 'Calendário',
                          subtitulo: 'Gerenciar agendamentos',
                          crossAxisAlignment: CrossAxisAlignment.center,
                          icone: Icons.calendar_today_rounded,
                          corIcone: Colors.deepPurpleAccent,
                          liberado: _podeVerAtendimentos,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AtendimentoScreen(
                                usuario: Usuario(
                                  nome: _nome,
                                  CBO: _cbo,
                                  tipoRegistro: _tipoRegistro,
                                  numRegistro: _numRegistro,
                                  perfil: _perfil,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 6),
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.6,
                        children: [
                          _moduloCard(
                            titulo: 'ATENDIMENTOS',
                            subtitulo: 'Gerenciar sessões',
                            icone: Icons.assignment,
                            corIcone: const Color(0xFFF2C94C),
                            liberado: _podeVerAtendimentos,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AtendimentoScreen(
                                  usuario: Usuario(
                                    nome: _nome,
                                    CBO: _cbo,
                                    tipoRegistro: _tipoRegistro,
                                    numRegistro: _numRegistro,
                                    perfil: _perfil,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _moduloCard(
                            titulo: 'ALUNOS',
                            subtitulo: 'Cadastros e dados',
                            icone: Icons.school_rounded,
                            corIcone: const Color(0xFF56CCF2),
                            liberado: _podeVerAlunos,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AlunosScreen(),
                              ),
                            ),
                          ),
                          _moduloCard(
                            //TODO: financeiro
                            titulo: 'FINANCEIRO',
                            subtitulo: 'Controle financeiro',
                            icone: Icons.attach_money_rounded,
                            corIcone: const Color(0xFF6FCF97),
                            liberado: _podeVerFinanceiro,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FinanceiroScreen(),
                              ),
                            ),
                          ),
                          _moduloCard(
                            //TODO: funcionários
                            titulo: 'FUNCIONÁRIOS',
                            subtitulo: 'Equipe e acessos',
                            icone: Icons.people_rounded,
                            corIcone: const Color(0xFFEB5757),
                            liberado: _podeVerFuncionarios,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FuncionariosScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Logo ──
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: NeuroLogo(size: 72, animated: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
