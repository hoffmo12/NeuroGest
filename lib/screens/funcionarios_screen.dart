import 'package:flutter/material.dart';
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
    final lista = await FuncionarioService.listar();
    setState(() {
      _todos     = lista;
      _filtrados = lista;
      _carregando = false;
    });
  }

  void _filtrar(String termo) {
    final t = termo.toLowerCase();
    setState(() {
      _filtrados = _todos.where((f) {
        return f.nome.toLowerCase().contains(t) ||
               f.email.toLowerCase().contains(t) ||
               f.funcao.toLowerCase().contains(t);
      }).toList();
    });
  }

  Future<void> _abrirFormulario({Funcionario? funcionario}) async {
    final atualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FuncionarioFormScreen(funcionario: funcionario),
      ),
    );
    if (atualizado == true) _carregar();
  }

  Future<void> _alternarAtivo(Funcionario f) async {
    final ok = await FuncionarioService.alternarAtivo(f.id);
    if (ok) _carregar();
  }

  Future<void> _excluir(Funcionario f) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir funcionário'),
        content: Text('Deseja excluir ${f.nome} permanentemente?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final ok = await FuncionarioService.excluir(f.id);
      if (ok) _carregar();
    }
  }

  // ─── Badge de perfil ──────────────────────────────────
  Widget _badgePerfil(String perfil) {
    final map = {
      'admin':   (Colors.green, 'ADMIN'),
      'gerente': (Colors.blue,  'GERENTE'),
      'usuario': (Colors.grey,  'USUÁRIO'),
    };
    final (cor, label) = map[perfil] ?? (Colors.grey, perfil.toUpperCase());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
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
                              width: 95, height: 34, fontSize: 11,
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
                                    onPressed: () => _filtrar(_buscaController.text),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              NeuroPillButton(
                                text: 'ADICIONAR',
                                width: 130, height: 46, fontSize: 11,
                                onPressed: () => _abrirFormulario(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ── Lista ──
                          Expanded(
                            child: _carregando
                                ? const Center(child: CircularProgressIndicator())
                                : _filtrados.isEmpty
                                    ? const Center(child: Text('Nenhum funcionário encontrado.'))
                                    : Scrollbar(
                                        thumbVisibility: true,
                                        child: ListView.separated(
                                          itemCount: _filtrados.length,
                                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                                          itemBuilder: (_, i) {
                                            final f = _filtrados[i];
                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: f.ativo
                                                    ? NeuroColors.panel
                                                    : Colors.grey.shade300,
                                                border: Border.all(color: Colors.black, width: 3),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Row(
                                                children: [
                                                  // ── Info ──
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                f.nome.toUpperCase(),
                                                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            _badgePerfil(f.perfil),
                                                            if (!f.ativo) ...[
                                                              const SizedBox(width: 6),
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.red.shade300,
                                                                  borderRadius: BorderRadius.circular(999),
                                                                  border: Border.all(color: Colors.black, width: 1.5),
                                                                ),
                                                                child: const Text('INATIVO',
                                                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text('${f.funcao} · ${f.email}',
                                                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                                                            overflow: TextOverflow.ellipsis),
                                                        if (f.telefone != null)
                                                          Text(f.telefone!,
                                                              style: const TextStyle(fontSize: 11, color: Colors.black45)),
                                                      ],
                                                    ),
                                                  ),

                                                  // ── Ações ──
                                                  Row(
                                                    children: [
                                                      // Editar
                                                      _IconBtn(
                                                        icon: Icons.edit,
                                                        color: const Color(0xFFB0B0B0),
                                                        onTap: () => _abrirFormulario(funcionario: f),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      // Ativar/Desativar
                                                      _IconBtn(
                                                        icon: f.ativo ? Icons.toggle_on : Icons.toggle_off,
                                                        color: f.ativo ? Colors.green.shade300 : Colors.orange.shade300,
                                                        onTap: () => _alternarAtivo(f),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      // Excluir
                                                      _IconBtn(
                                                        icon: Icons.delete,
                                                        color: Colors.red.shade300,
                                                        onTap: () => _excluir(f),
                                                      ),
                                                    ],
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

// ─── Botão de ícone circular ──────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36, height: 36,
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
