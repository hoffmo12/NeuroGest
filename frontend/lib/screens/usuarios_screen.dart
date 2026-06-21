import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../widgets/neuro_widgets.dart';
import 'usuario_form_screen.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Usuario> _todos     = [];
  List<Usuario> _filtrados = [];
  final _buscaController   = TextEditingController();
  bool _carregando         = true;

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
    final lista = await UsuarioService.listar();
    setState(() {
      _todos     = lista;
      _filtrados = lista;
      _carregando = false;
    });
  }

  void _filtrar(String termo) {
    final t = termo.toLowerCase();
    setState(() {
      _filtrados = _todos.where((u) {
        return u.nome.toLowerCase().contains(t) ||
               u.email.toLowerCase().contains(t) ||
               u.cbo.toLowerCase().contains(t);
      }).toList();
    });
  }

  Future<void> _alternarAtivo(Usuario usuario) async {
    final ok = await UsuarioService.alternarAtivo(usuario.id);
    if (ok) {
      _carregar();
    } else {
      _mostrarErro('Não foi possível alterar o status do usuário.');
    }
  }

  Future<void> _excluir(Usuario usuario) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir usuário'),
        content: Text('Deseja excluir ${usuario.nome} permanentemente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final ok = await UsuarioService.excluir(usuario.id);
      if (ok) _carregar();
      else _mostrarErro('Erro ao excluir usuário.');
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700),
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
                  const NeuroHeaderTitle(title: 'USUÁRIOS'),
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
                              width: 95, height: 34, fontSize: 11,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Busca + botão ──
                          Row(
                            children: [
                              Expanded(
                                child: NeuroTextField(
                                  hint: 'BUSCAR USUÁRIO',
                                  controller: _buscaController,
                                  onChanged: _filtrar,
                                  suffixIcon: const Icon(Icons.search),
                                ),
                              ),
                              const SizedBox(width: 12),
                              NeuroPillButton(
                                text: 'NOVO USUÁRIO',
                                width: 140, height: 46, fontSize: 11,
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const UsuarioFormScreen(),
                                    ),
                                  );
                                  _carregar();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ── Lista ──
                          Expanded(
                            child: _carregando
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: NeuroColors.primary,
                                    ),
                                  )
                                : _filtrados.isEmpty
                                    ? const Center(
                                        child: Text('Nenhum usuário encontrado.'),
                                      )
                                    : Scrollbar(
                                        thumbVisibility: true,
                                        child: ListView.separated(
                                          itemCount: _filtrados.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (_, i) {
                                            final u = _filtrados[i];
                                            return Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12),
                                              decoration: BoxDecoration(
                                                color: NeuroColors.panel,
                                                border: Border.all(
                                                    color: Colors.black, width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          u.nome.toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w800,
                                                            decoration: u.ativo
                                                                ? null
                                                                : TextDecoration.lineThrough,
                                                            color: u.ativo
                                                                ? NeuroColors.text
                                                                : NeuroColors.mutedText,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        const SizedBox(height: 3),
                                                        Text(
                                                          '${u.email} · ${u.cbo.isEmpty ? "Sem CBO" : u.cbo} · ${u.perfil.toUpperCase()}',
                                                          style: const TextStyle(
                                                            fontSize: 11,
                                                            color: NeuroColors.mutedText,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),

                                                  // Editar
                                                  _IconBtn(
                                                    icon: Icons.edit,
                                                    color: const Color(0xFFB0B0B0),
                                                    onTap: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              UsuarioFormScreen(usuario: u),
                                                        ),
                                                      );
                                                      _carregar();
                                                    },
                                                  ),
                                                  const SizedBox(width: 8),

                                                  // Ativar/Desativar
                                                  _IconBtn(
                                                    icon: u.ativo
                                                        ? Icons.block
                                                        : Icons.check_circle_outline,
                                                    color: u.ativo
                                                        ? Colors.orange.shade300
                                                        : Colors.green.shade300,
                                                    onTap: () => _alternarAtivo(u),
                                                  ),
                                                  const SizedBox(width: 8),

                                                  // Excluir
                                                  _IconBtn(
                                                    icon: Icons.delete,
                                                    color: Colors.red.shade300,
                                                    onTap: () => _excluir(u),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          ),
                          const SizedBox(height: 10),
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
        width: 38, height: 38,
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