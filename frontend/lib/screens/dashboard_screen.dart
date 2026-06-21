import 'package:flutter/material.dart';
import '../widgets/neuro_widgets.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import 'alunos_screen.dart';
import 'usuarios_screen.dart';
import 'atendimento_screen.dart';
import 'login_screen.dart';
import 'financeiro_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Usuario? _usuario;
  String? _idCardFocado;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final id = await AuthService.getId() ?? 0;
    final nome = await AuthService.getNome() ?? '';
    final email = await AuthService.getEmail() ?? '';
    final perfil = await AuthService.getPerfil() ?? 'profissional';
    final cbo = await AuthService.getCbo() ?? '';
    final tipoRegistro = await AuthService.getTipoRegistro() ?? '';
    final numRegistro = await AuthService.getNumRegistro() ?? '';

    setState(() {
      _usuario = Usuario(
        id: id,
        nome: nome,
        email: email,
        perfil: perfil,
        cbo: cbo,
        tipoRegistro: tipoRegistro,
        numRegistro: numRegistro,
        ativo: true,
        criadoEm: DateTime.now(),
      );
    });
  }

  String get _nome => _usuario?.nome ?? '';
  String get _perfil => _usuario?.perfil ?? '';

  bool get _podeVerAtendimentos => true;
  bool get _podeVerAlunos => true;
  bool get _podeVerFinanceiro => _perfil == 'admin';
  bool get _podeVerUsuarios => _perfil == 'admin';

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

  String get _iniciais {
    final partes = _nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return _nome.isNotEmpty ? _nome[0].toUpperCase() : '?';
  }

  Widget _badgePerfil() {
    final map = {
      'admin': (const Color(0xFF4CAF50), 'ADMIN'),
      'profissional': (const Color(0xFF2196F3), 'PROFISSIONAL'),
      'recepcao': (const Color(0xFF9E9E9E), 'RECEPÇÃO'),
    };
    final (cor, label) =
        map[_perfil] ?? (const Color(0xFF9E9E9E), _perfil.toUpperCase());
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

  Widget _moduloCard({
    required String titulo,
    required String subtitulo,
    required IconData icone,
    required Color corIcone,
    required bool liberado,
    required VoidCallback onTap,
  }) {
    final isHovered = _idCardFocado == titulo;
    return Opacity(
      opacity: liberado ? 1.0 : 0.4,
      child: MouseRegion(
        cursor: liberado ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) {
          if (liberado) setState(() => _idCardFocado = titulo);
        },
        onExit: (_) {
          if (liberado) setState(() => _idCardFocado = null);
        },
        child: GestureDetector(
          onTap: liberado ? onTap : () => _bloqueado(titulo),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isHovered
                  ? const Color(0xFFEDF2F7)
                  : const Color(0xFFF8FAFC),
              border: Border.all(
                color: isHovered ? Colors.black : NeuroColors.border,
                width: isHovered ? 1.8 : 1.2,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
    // Enquanto carrega o usuário mostra loading
    if (_usuario == null) {
      return const Scaffold(
        backgroundColor: NeuroColors.background,
        body: Center(
          child: CircularProgressIndicator(color: NeuroColors.primary),
        ),
      );
    }

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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                        // ── Card de boas-vindas ──
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const Text(
                                        'Bem-vindo de volta ao sistema',
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

                        // ── Divisor MÓDULOS ──
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
                              icone: Icons.calendar_today_rounded,
                              corIcone: const Color(0xFFF2C94C),
                              liberado: _podeVerAtendimentos,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AtendimentoScreen(usuario: _usuario!),
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
                              titulo: 'USUÁRIOS',
                              subtitulo: 'Equipe e acessos',
                              icone: Icons.people_rounded,
                              corIcone: const Color(0xFFEB5757),
                              liberado: _podeVerUsuarios,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UsuariosScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
      ),
    );
  }
}
