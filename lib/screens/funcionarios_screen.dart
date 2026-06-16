import 'package:flutter/material.dart';
import 'package:neurogest_front/mock/mock_funcionario_repository.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';
import '../widgets/neuro_widgets.dart';
import 'funcionario_form_screen.dart';

class FuncionariosScreen extends StatefulWidget {
  const FuncionariosScreen({super.key});

  @override
  State<FuncionariosScreen> createState() => _FuncionariosScreenState();
}

class _FuncionariosScreenState extends State<FuncionariosScreen> {
  List<Funcionario> _todos = [];
  List<Funcionario> _filtrados = [];
  final _buscaController = TextEditingController();
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final lista = FuncionarioRepository().listar();
    setState(() {
      _todos = lista;
      _filtrados = lista;
      _carregando = false;
    });
  }

  void _filtrar(String termo) {
    final t = termo.toLowerCase();
    setState(() {
      _filtrados = _todos.where((f) {
        return f.nome.toLowerCase().contains(t) ||
            f.login.toLowerCase().contains(t) ||
            f.cbo.toLowerCase().contains(t);
      }).toList();
    });
  }

  Future<void> _abrirFormulario({Funcionario? funcionario}) async {
    // final atualizado = await Navigator.push<bool>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => FuncionarioFormScreen(funcionario: funcionario),
    //   ),
    // );
    // if (atualizado == true) _carregar();
  }

  Future<void> _alternarAtivo(Funcionario f) async {
    final ok = FuncionarioRepository().isActive(f.id, !f.ativo);
    if (ok) _carregar();
  }

  Widget _badgePerfil(String perfil) {
    final map = {
      'admin': (Colors.green, 'ADMIN'),
      'gerente': (Colors.blue, 'GERENTE'),
      'usuario': (Colors.grey, 'USUÁRIO'),
    };
    final (cor, label) = map[perfil] ?? (Colors.grey, perfil.toUpperCase());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  const NeuroHeaderTitle(title: 'FUNCIONÁRIOS'),
                  const SizedBox(height: 18),
                  Expanded(
                    child: NeuroPanel(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      child: Column(
                        children: [
                          NeuroTopBar(
                            title: 'NEUROGEST',
                            left: NeuroPillButton(
                              text: 'VOLTAR',
                              width: 95,
                              height: 34,
                              fontSize: 11,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Busca + botão adicionar ──
                          Row(
                            children: [
                              Expanded(
                                child: NeuroTextField(
                                  hint: 'BUSCAR FUNCIONÁRIO',
                                  controller: _buscaController,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () =>
                                        _filtrar(_buscaController.text),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              NeuroPillButton(
                                text: 'Novo Funcionário',
                                width: 140,
                                height: 46,
                                fontSize: 11,
                                onPressed: () => _abrirFormulario(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ── Lista ──
                          Expanded(
                            child: _carregando
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : _filtrados.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Nenhum funcionário encontrado.',
                                    ),
                                  )
                                : Scrollbar(
                                    thumbVisibility: true,
                                    child: ListView.separated(
                                      itemCount: _filtrados.length,

                                      separatorBuilder: (_, _) =>
                                          const SizedBox(height: 10),
                                      itemBuilder: (_, i) {
                                        final f = _filtrados[i];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: f.ativo
                                                ? NeuroColors.panel
                                                : Colors.grey.shade300,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: ListTile(
                                            enabled: f.ativo,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),

                                            title: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    f.nome.toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),

                                                const SizedBox(width: 8),

                                                _badgePerfil(f.nivelDeAcesso),

                                                if (!f.ativo) ...[
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.red.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            999,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors.black,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'INATIVO',
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),

                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${f.cbo} · ${f.login}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black54,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  f.telefone,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                _IconBtn(
                                                  icon: Icons.edit,
                                                  color: f.ativo
                                                      ? NeuroColors.primary
                                                      : NeuroColors.mutedText,
                                                  onTap: () => f.ativo
                                                      ? _abrirFormulario(
                                                          funcionario: f,
                                                        )
                                                      : null,
                                                ),
                                                const SizedBox(width: 6),
                                                _IconBtn(
                                                  icon: f.ativo
                                                      ? Icons.toggle_on
                                                      : Icons.toggle_off,
                                                  color: f.ativo
                                                      ? Colors.green.shade300
                                                      : Colors.orange.shade300,
                                                  onTap: () =>
                                                      _alternarAtivo(f),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: NeuroLogo(size: 72),
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
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Icon(icon, color: Colors.black, size: 18),
      ),
    );
  }
}
