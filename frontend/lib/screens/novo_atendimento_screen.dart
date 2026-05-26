import 'package:flutter/material.dart';
import 'package:neurogest_front/models/aluno.dart';
import 'package:neurogest_front/models/atendimento.dart';
import 'package:neurogest_front/models/usuario.dart';
import 'package:neurogest_front/services/aluno_service.dart';
import 'package:neurogest_front/services/funcionario_service.dart';
import 'package:neurogest_front/widgets/aluno_selecionado.dart';
import 'package:neurogest_front/widgets/atendimento_infos.dart';
import 'package:neurogest_front/widgets/buscar_aluno_atendimento.dart';
import 'package:neurogest_front/widgets/neuro_widgets.dart';

class NovoAtendimentoScreen extends StatefulWidget {
  final Usuario usuario;
  const NovoAtendimentoScreen({super.key, required this.usuario});

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

    pesoController.addListener(calcularIMC);
    alturaController.addListener(calcularIMC);
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
                            AtendimentoInfos(usuario: widget.usuario),
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
                              widget.usuario.CBO,
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
                            if (CBOPermitido.anamnese(widget.usuario.CBO)) ...[
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
                              widget.usuario.CBO,
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
                              widget.usuario.CBO,
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
                              widget.usuario.CBO,
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
                                  onPressed: () async {
                                    AlunoService.add(
                                      atendimento: Atendimento(
                                        id:
                                            AlunoService.atendimentos.length +
                                            1,
                                        nomeAluno: alunoSelecionado!.nome,
                                        criadoEm: DateTime.now(),
                                        profissional: widget.usuario.nome,
                                        profissionalCBO: widget.usuario.CBO,
                                      ),
                                    );
                                    await Future.delayed(
                                      const Duration(seconds: 1),
                                    );
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context, true);
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
}
