import 'package:flutter/material.dart';
import '../models/aluno.dart';
import '../services/aluno_service.dart';
import '../widgets/neuro_widgets.dart';
import 'aluno_form_screen.dart';

class AlunosScreen extends StatefulWidget {
  const AlunosScreen({super.key});

  @override
  State<AlunosScreen> createState() => _AlunosScreenState();
}

class _AlunosScreenState extends State<AlunosScreen> {
  List<Aluno> _alunos = [];
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

  Future<void> _carregar({String? busca}) async {
    setState(() => _carregando = true);
    final lista = await AlunoService.listar(busca: busca);
    setState(() {
      _alunos    = lista;
      _carregando = false;
    });
  }

  Future<void> _abrirFormulario({Aluno? aluno}) async {
    final atualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AlunoFormScreen(aluno: aluno)),
    );
    if (atualizado == true) _carregar();
  }

  Future<void> _excluir(Aluno aluno) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir aluno'),
        content: Text('Deseja excluir ${aluno.nome} permanentemente?'),
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
      final ok = await AlunoService.excluir(aluno.id);
      if (ok) _carregar();
    }
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
                  const NeuroHeaderTitle(title: 'ALUNOS'),
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
                                  hint: 'BUSCAR ALUNO',
                                  controller: _buscaController,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () => _carregar(busca: _buscaController.text),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              NeuroPillButton(
                                text: 'ADICIONAR ALUNO',
                                width: 160, height: 46, fontSize: 11,
                                onPressed: () => _abrirFormulario(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ── Lista ──
                          Expanded(
                            child: _carregando
                                ? const Center(child: CircularProgressIndicator())
                                : _alunos.isEmpty
                                    ? const Center(child: Text('Nenhum aluno encontrado.'))
                                    : Scrollbar(
                                        thumbVisibility: true,
                                        child: ListView.separated(
                                          itemCount: _alunos.length,
                                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                                          itemBuilder: (_, i) {
                                            final aluno = _alunos[i];
                                            return Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12),
                                              decoration: BoxDecoration(
                                                color: NeuroColors.panel,
                                                border: Border.all(color: Colors.black, width: 3),
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          aluno.nome.toUpperCase(),
                                                          style: const TextStyle(
                                                              fontSize: 13, fontWeight: FontWeight.w800),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        const SizedBox(height: 3),
                                                        Text(
                                                          '${aluno.idade} anos · ${aluno.dataNascimentoFormatada}',
                                                          style: const TextStyle(
                                                              fontSize: 11, color: Colors.black54),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Editar
                                                  InkWell(
                                                    onTap: () => _abrirFormulario(aluno: aluno),
                                                    borderRadius: BorderRadius.circular(999),
                                                    child: Container(
                                                      width: 38, height: 38,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFB0B0B0),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.black, width: 2),
                                                      ),
                                                      child: const Icon(Icons.edit, size: 18),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Excluir
                                                  InkWell(
                                                    onTap: () => _excluir(aluno),
                                                    borderRadius: BorderRadius.circular(999),
                                                    child: Container(
                                                      width: 38, height: 38,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red.shade300,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: Colors.black, width: 2),
                                                      ),
                                                      child: const Icon(Icons.delete, size: 18),
                                                    ),
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
