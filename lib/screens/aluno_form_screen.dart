import 'package:flutter/material.dart';
import '../models/aluno.dart';
import '../widgets/neuro_widgets.dart';

class AlunoFormScreen extends StatefulWidget {
  final Aluno? aluno;

  const AlunoFormScreen({
    super.key,
    this.aluno,
  });

  @override
  State<AlunoFormScreen> createState() => _AlunoFormScreenState();
}

class _AlunoFormScreenState extends State<AlunoFormScreen> {
  late TextEditingController nomeController;
  late TextEditingController idadeController;
  late TextEditingController dataController;

  bool get editando => widget.aluno != null;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.aluno?.nome ?? '');
    idadeController = TextEditingController(text: widget.aluno?.idade ?? '');
    dataController = TextEditingController(
      text: widget.aluno?.dataNascimento ?? '',
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    idadeController.dispose();
    dataController.dispose();
    super.dispose();
  }

  void salvar() {
    final nome = nomeController.text.trim();
    final idade = idadeController.text.trim();
    final data = dataController.text.trim();

    if (nome.isEmpty || idade.isEmpty || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    final aluno = Aluno(
      nome: nome,
      idade: idade,
      dataNascimento: data,
    );

    Navigator.pop(context, aluno);
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
                NeuroHeaderTitle(
                  title: editando ? 'EDITAR ALUNO' : 'ADICIONAR ALUNO',
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: NeuroPanel(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
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
                        const SizedBox(height: 18),
                        NeuroTextField(
                          label: 'Nome:',
                          hint: 'Nome do aluno',
                          controller: nomeController,
                        ),
                        const SizedBox(height: 16),
                        NeuroTextField(
                          label: 'Idade:',
                          hint: 'Ex: 10',
                          controller: idadeController,
                        ),
                        const SizedBox(height: 16),
                        NeuroTextField(
                          label: 'Data de nascimento:',
                          hint: 'Ex: 10/04/2015',
                          controller: dataController,
                        ),
                        const SizedBox(height: 26),
                        Align(
                          alignment: Alignment.centerRight,
                          child: NeuroPillButton(
                            text: 'SALVAR',
                            width: 130,
                            height: 42,
                            onPressed: salvar,
                          ),
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