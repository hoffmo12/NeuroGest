import 'package:flutter/material.dart';
import 'package:neurogest_front/mock/mock_aluno_repository.dart';
import 'package:neurogest_front/mock/mock_atendimento.dart';
import 'package:neurogest_front/mock/mock_funcionario_repository.dart';
import 'package:neurogest_front/models/aluno.dart';
import 'package:neurogest_front/models/atendimento.dart';
import 'package:neurogest_front/models/funcionario.dart';
import 'package:neurogest_front/models/usuario.dart';
import 'package:neurogest_front/services/aluno_service.dart';
import 'package:neurogest_front/services/funcionario_service.dart';
import 'package:neurogest_front/widgets/aluno_selecionado.dart';
import 'package:neurogest_front/widgets/atendimento_infos.dart';
import 'package:neurogest_front/widgets/buscar_aluno_atendimento.dart';
import 'package:neurogest_front/widgets/neuro_widgets.dart';

class NovoAtendimentoScreen extends StatefulWidget {
  final Funcionario funcionario;
  const NovoAtendimentoScreen({super.key, required this.funcionario});

  @override
  State<NovoAtendimentoScreen> createState() => _NovoAtendimentoScreenState();
}

class _NovoAtendimentoScreenState extends State<NovoAtendimentoScreen> {
  final TextEditingController motivoController = TextEditingController();
  final TextEditingController anamneseController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController perimetroCefalicoController =
      TextEditingController();
  final TextEditingController circunferenciaAbdominalController =
      TextEditingController();
  final TextEditingController perimetroPanturrilhaController =
      TextEditingController();
  final TextEditingController exameFisicoController = TextEditingController();
  final TextEditingController diagnosticoController = TextEditingController();

  double imc = 0;
  Aluno? alunoSelecionado;

  @override
  void initState() {
    super.initState();

    // pesoController.addListener(calcularIMC);
    // alturaController.addListener(calcularIMC);
    print(widget.funcionario.nome);
  }

  void calcularIMC() {
    final peso = double.tryParse(pesoController.text.replaceAll(',', '.'));
    final alturaCm = double.tryParse(
      alturaController.text.replaceAll(',', '.'),
    );

    if (peso != null && alturaCm != null && alturaCm > 0) {
      final alturaM = alturaCm / 100;
      setState(() {
        imc = peso / (alturaM * alturaM);
      });
    } else {
      setState(() {
        imc = 0;
      });
    }
  }

  Widget buildCard({required String titulo, required Widget child}) {
    return Card(
      color: NeuroColors.background,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget buildTextArea({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget buildCampo({
    required String label,
    required String suffix,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: suffix,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: NeuroPanel(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NeuroTopBar(
                              title: 'Novo Atendimento',
                              right: NeuroPillButton(
                                text: 'Voltar',
                                width: 80,
                                height: 34,
                                fontSize: 11,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(height: 12),
                            AtendimentoInfos(funcionario: widget.funcionario),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: BuscarAlunoAtendimento(
                                onAlunoSelecionado: (Aluno aluno) {
                                  setState(() {
                                    alunoSelecionado = aluno;
                                  });
                                },
                              ),
                            ),
                            if (alunoSelecionado != null) ...[
                              AlunoSelecionado(aluno: alunoSelecionado!),
                            ],
                            if (CBOPermitido.motivoDaConsulta(
                              widget.funcionario.cbo,
                            )) ...[
                              // MOTIVO DA CONSULTA
                              buildCard(
                                titulo: 'Motivos da consulta',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Motivos da consulta*',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    buildTextArea(
                                      hint:
                                          'Percepções do paciente: descreva o motivo da consulta relacionado pelo paciente',
                                      controller: motivoController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (CBOPermitido.anamnese(
                              widget.funcionario.cbo,
                            )) ...[
                              // ANAMNESE
                              buildCard(
                                titulo: 'Anamnese',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Anamnese',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    buildTextArea(
                                      hint:
                                          'Informe dados relevantes observados durante o atendimento',
                                      controller: anamneseController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (CBOPermitido.antropometria(
                              widget.funcionario.cbo,
                            )) ...[
                              // // ANTROPOMETRIA
                              buildCard(
                                titulo: 'Antropometria',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Antropometria',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    Row(
                                      children: [
                                        buildCampo(
                                          label: 'Peso',
                                          suffix: 'kg',
                                          controller: pesoController,
                                        ),
                                        const SizedBox(width: 16),
                                        buildCampo(
                                          label: 'Altura',
                                          suffix: 'cm',
                                          controller: alturaController,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'IMC',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                height: 58,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  imc.toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    Row(
                                      children: [
                                        buildCampo(
                                          label: 'Perímetro cefálico',
                                          suffix: 'cm',
                                          controller:
                                              perimetroCefalicoController,
                                        ),
                                        const SizedBox(width: 16),
                                        buildCampo(
                                          label: 'Circunferência abdominal',
                                          suffix: 'cm',
                                          controller:
                                              circunferenciaAbdominalController,
                                        ),
                                        const SizedBox(width: 16),
                                        buildCampo(
                                          label: 'Perímetro panturrilha',
                                          suffix: 'cm',
                                          controller:
                                              perimetroPanturrilhaController,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (CBOPermitido.examefisico(
                              widget.funcionario.cbo,
                            )) ...[
                              // // EXAME FÍSICO
                              buildCard(
                                titulo: 'Exame físico',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Exame Físico',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    buildTextArea(
                                      hint: 'Informe o exame físico realizado',
                                      controller: exameFisicoController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (CBOPermitido.diagnostico(
                              widget.funcionario.cbo,
                            )) ...[
                              // DIAGNÓSTICO
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Diagnóstico',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              buildCard(
                                titulo: 'Diagnóstico',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Descrição da sua avaliação do paciente*',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    buildTextArea(
                                      hint:
                                          'Descreva sua avaliação do paciente',
                                      controller: diagnosticoController,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.blueAccent,
                                    ),
                                  ),
                                  onPressed: alunoSelecionado != null
                                      ? () async {
                                          AtendimentoRepository().criar(
                                            idAluno: alunoSelecionado!.id,
                                            idFuncionario:
                                                widget.funcionario.id,
                                            motivoDaConsulta:
                                                motivoController.text,
                                            anamnese: anamneseController.text,
                                            peso: double.parse(
                                              pesoController.text,
                                            ),
                                            altura: double.parse(
                                              alturaController.text,
                                            ),
                                            imc: imc,
                                            perimetroCefalico: double.parse(
                                              perimetroCefalicoController.text,
                                            ),
                                            circunferenciaAbdominal: double.parse(
                                              circunferenciaAbdominalController
                                                  .text,
                                            ),
                                            perimetroPanturrilha: double.parse(
                                              perimetroPanturrilhaController
                                                  .text,
                                            ),
                                            exameFisico:
                                                exameFisicoController.text,
                                            diagnostico:
                                                diagnosticoController.text,
                                            dataAtendimento: DateTime.now(),
                                          );
                                          await Future.delayed(
                                            const Duration(seconds: 1),
                                          );
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context, true);
                                        }
                                      : () {
                                          _showAlunoError();
                                        },
                                  child: const Text(
                                    'Salvar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
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

  @override
  void dispose() {
    motivoController.dispose();
    anamneseController.dispose();
    pesoController.dispose();
    alturaController.dispose();
    perimetroCefalicoController.dispose();
    circunferenciaAbdominalController.dispose();
    perimetroPanturrilhaController.dispose();
    exameFisicoController.dispose();
    diagnosticoController.dispose();

    super.dispose();
  }

  Future<void> _showAlunoError() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Atenção!'),
        content: Text('Selecione o aluno para salvar a ficha de atendimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}
