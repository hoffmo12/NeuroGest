import 'package:flutter/material.dart';
import '../models/aluno.dart';
import '../widgets/neuro_widgets.dart';
import 'aluno_form_screen.dart';

class AlunosScreen extends StatefulWidget {
  final List<Aluno> alunos;

  const AlunosScreen({
    super.key,
    required this.alunos,
  });

  @override
  State<AlunosScreen> createState() => _AlunosScreenState();
}

class _AlunosScreenState extends State<AlunosScreen> {
  final buscaController = TextEditingController();

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }

  List<Aluno> get alunosFiltrados {
    final termo = buscaController.text.trim().toLowerCase();

    if (termo.isEmpty) return widget.alunos;

    return widget.alunos.where((aluno) {
      final texto = '${aluno.nome} ${aluno.idade} ${aluno.dataNascimento}'.toLowerCase();
      return texto.contains(termo);
    }).toList();
  }

  Future<void> adicionarAluno() async {
    final novoAluno = await Navigator.push<Aluno>(
      context,
      MaterialPageRoute(
        builder: (_) => const AlunoFormScreen(),
      ),
    );

    if (novoAluno != null) {
      setState(() {
        widget.alunos.add(novoAluno);
      });
    }
  }

  Future<void> editarAluno(int indexReal, Aluno aluno) async {
    final alunoEditado = await Navigator.push<Aluno>(
      context,
      MaterialPageRoute(
        builder: (_) => AlunoFormScreen(aluno: aluno),
      ),
    );

    if (alunoEditado != null) {
      setState(() {
        widget.alunos[indexReal] = alunoEditado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final listaFiltrada = alunosFiltrados;

    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                children: [
                  const NeuroHeaderTitle(title: 'TELA DE ALUNOS'),
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
                          Row(
                            children: [
                              Expanded(
                                child: NeuroTextField(
                                  hint: 'BUSCAR ALUNO',
                                  controller: buscaController,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              NeuroPillButton(
                                text: 'ADICIONAR ALUNO',
                                width: 170,
                                height: 46,
                                fontSize: 11,
                                onPressed: adicionarAluno,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView.separated(
                                itemCount: listaFiltrada.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final aluno = listaFiltrada[index];
                                  final indexReal = widget.alunos.indexOf(aluno);

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: NeuroColors.panel,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${aluno.nome.toUpperCase()} - ${aluno.idade} ANOS - ${aluno.dataNascimento}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () => editarAluno(indexReal, aluno),
                                          borderRadius: BorderRadius.circular(999),
                                          child: Container(
                                            width: 38,
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFB0B0B0),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.settings,
                                              color: Colors.black,
                                              size: 22,
                                            ),
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