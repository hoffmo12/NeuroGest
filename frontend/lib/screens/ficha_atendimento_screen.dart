import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../models/atendimento.dart';
import '../utils/ficha_atendimento_pdf.dart';
import '../widgets/neuro_widgets.dart';

// Tela que exibe a ficha de atendimento já preenchida em PDF,
// com opções de download, impressão e compartilhamento.
class FichaAtendimentoScreen extends StatelessWidget {
  final Atendimento atendimento;

  const FichaAtendimentoScreen({super.key, required this.atendimento});

  String get _nomeArquivo {
    final aluno = atendimento.nomeAluno.trim().isEmpty
        ? 'aluno'
        : atendimento.nomeAluno.trim().replaceAll(RegExp(r'\s+'), '_');
    return 'ficha_atendimento_${atendimento.id}_$aluno.pdf';
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
              constraints: const BoxConstraints(maxWidth: 900),
              child: NeuroPanel(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                child: Column(
                  children: [
                    NeuroTopBar(
                      title: 'Ficha de atendimento — ${atendimento.nomeAluno}',
                      left: NeuroPillButton(
                        text: 'VOLTAR',
                        width: 95,
                        height: 34,
                        fontSize: 11,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: PdfPreview(
                          build: (format) => gerarFichaAtendimentoPdf(atendimento),
                          pdfFileName: _nomeArquivo,
                          canChangePageFormat: false,
                          canDebug: false,
                          canChangeOrientation: false,
                          allowSharing: true,
                          allowPrinting: true,
                          dynamicLayout: false,
                          loadingWidget: const Center(
                            child: CircularProgressIndicator(
                              color: NeuroColors.primary,
                            ),
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
      ),
    );
  }
}
