import 'package:flutter/material.dart';
import '../models/aluno.dart';
import '../models/atendimento.dart';
import '../models/usuario.dart';
import '../services/atendimento_service.dart';
import '../services/lancamento_service.dart';
import '../widgets/neuro_widgets.dart';
import '../widgets/buscar_aluno_atendimento.dart';
import '../widgets/aluno_selecionado.dart';
import '../widgets/atendimento_infos.dart';

class NovoAtendimentoScreen extends StatefulWidget {
  final Usuario usuario;
  const NovoAtendimentoScreen({super.key, required this.usuario});

  @override
  State<NovoAtendimentoScreen> createState() => _NovoAtendimentoScreenState();
}

class _NovoAtendimentoScreenState extends State<NovoAtendimentoScreen> {
  final _motivoCtrl               = TextEditingController();
  final _anamneseCtrl             = TextEditingController();
  final _pesoCtrl                 = TextEditingController();
  final _alturaCtrl               = TextEditingController();
  final _perimetroCefalicoCtrl    = TextEditingController();
  final _circunferenciaAbdCtrl    = TextEditingController();
  final _perimetroPanturrilhaCtrl = TextEditingController();
  final _exameFisicoCtrl          = TextEditingController();
  final _diagnosticoCtrl          = TextEditingController();
  final _valorCtrl                = TextEditingController();

  double _imc = 0;
  Aluno? _alunoSelecionado;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _pesoCtrl.addListener(_calcularImc);
    _alturaCtrl.addListener(_calcularImc);
  }

  @override
  void dispose() {
    _motivoCtrl.dispose();
    _anamneseCtrl.dispose();
    _pesoCtrl.dispose();
    _alturaCtrl.dispose();
    _perimetroCefalicoCtrl.dispose();
    _circunferenciaAbdCtrl.dispose();
    _perimetroPanturrilhaCtrl.dispose();
    _exameFisicoCtrl.dispose();
    _diagnosticoCtrl.dispose();
    _valorCtrl.dispose();
    super.dispose();
  }

  void _calcularImc() {
    final peso     = double.tryParse(_pesoCtrl.text.replaceAll(',', '.'));
    final alturaCm = double.tryParse(_alturaCtrl.text.replaceAll(',', '.'));
    setState(() {
      if (peso != null && alturaCm != null && alturaCm > 0) {
        // altura é digitada em cm, mas a fórmula do IMC usa metros
        final alturaM = alturaCm / 100;
        _imc = peso / (alturaM * alturaM);
      } else {
        _imc = 0;
      }
    });
  }

  double _toDouble(String texto) =>
      double.tryParse(texto.trim().replaceAll(',', '.')) ?? 0.0;

  Future<void> _salvar() async {
    if (_alunoSelecionado == null) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Atenção!'),
          content: const Text('Selecione o aluno para salvar a ficha.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    // 1. Salvar atendimento
    final atendimento = Atendimento(
      id:                      0,
      idAluno:                 _alunoSelecionado!.id,
      idUsuario:               widget.usuario.id,
      motivoDaConsulta:        _motivoCtrl.text.trim(),
      anamnese:                _anamneseCtrl.text.trim(),
      peso:                    _toDouble(_pesoCtrl.text),
      altura:                  _toDouble(_alturaCtrl.text),
      imc:                     _imc,
      perimetroCefalico:       _toDouble(_perimetroCefalicoCtrl.text),
      circunferenciaAbdominal: _toDouble(_circunferenciaAbdCtrl.text),
      perimetroPanturrilha:    _toDouble(_perimetroPanturrilhaCtrl.text),
      exameFisico:             _exameFisicoCtrl.text.trim(),
      diagnostico:             _diagnosticoCtrl.text.trim(),
      dataAtendimento:         DateTime.now().toUtc(),
    );

    final resultado = await AtendimentoService.salvarComRetorno(atendimento);

    if (!mounted) return;

    if (resultado.erro != null) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado.erro!), backgroundColor: Colors.red.shade700),
      );
      return;
    }

    // 2. Criar lançamento financeiro se valor foi informado
    final valor = _toDouble(_valorCtrl.text);
    if (valor > 0 && resultado.atendimento != null) {
      await LancamentoService.criar(
        idAluno:       _alunoSelecionado!.id,
        idAtendimento: resultado.atendimento!.id,
        idUsuario:     widget.usuario.id,
        valorOriginal: valor,
      );
    }

    setState(() => _salvando = false);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Widget _card(Widget child) => Card(
        color: NeuroColors.background,
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      );

  Widget _textArea(String hint, TextEditingController ctrl) => TextFormField(
        controller: ctrl,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        ),
      );

  Widget _campo(String label, String suffix, TextEditingController ctrl) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: ctrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                suffixText: suffix,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ],
        ),
      );

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
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NeuroTopBar(
                              title: 'Novo Atendimento',
                              right: NeuroPillButton(
                                text: 'VOLTAR',
                                width: 80, height: 34, fontSize: 11,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ── Card do profissional ──
                            AtendimentoInfos(usuario: widget.usuario),
                            const SizedBox(height: 16),

                            // ── Busca de aluno ──
                            BuscarAlunoAtendimento(
                              onAlunoSelecionado: (aluno) =>
                                  setState(() => _alunoSelecionado = aluno),
                            ),
                            if (_alunoSelecionado != null) ...[
                              const SizedBox(height: 12),
                              AlunoSelecionado(aluno: _alunoSelecionado!),
                            ],
                            const SizedBox(height: 20),

                            // ── Motivo da consulta ──
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Motivo da Consulta',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  _textArea(
                                    'Percepções do paciente: descreva o motivo da consulta',
                                    _motivoCtrl,
                                  ),
                                ],
                              ),
                            ),

                            // ── Anamnese ──
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Anamnese',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  _textArea(
                                    'Informe dados relevantes observados durante o atendimento',
                                    _anamneseCtrl,
                                  ),
                                ],
                              ),
                            ),

                            // ── Antropometria ──
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Antropometria',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      _campo('Peso', 'kg', _pesoCtrl),
                                      const SizedBox(width: 16),
                                      _campo('Altura', 'cm', _alturaCtrl),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('IMC',
                                                style: TextStyle(fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 58,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade400),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                _imc.toStringAsFixed(1),
                                                style: const TextStyle(fontSize: 20),
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
                                      _campo('Perímetro cefálico', 'cm', _perimetroCefalicoCtrl),
                                      const SizedBox(width: 16),
                                      _campo('Circunferência abdominal', 'cm', _circunferenciaAbdCtrl),
                                      const SizedBox(width: 16),
                                      _campo('Perímetro panturrilha', 'cm', _perimetroPanturrilhaCtrl),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ── Exame físico ──
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Exame Físico',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  _textArea(
                                    'Informe o exame físico realizado',
                                    _exameFisicoCtrl,
                                  ),
                                ],
                              ),
                            ),

                            // ── Diagnóstico ──
                            const Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 12),
                              child: Text('Diagnóstico',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Descrição da sua avaliação do paciente *',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  _textArea(
                                    'Descreva sua avaliação do paciente',
                                    _diagnosticoCtrl,
                                  ),
                                ],
                              ),
                            ),
                            // ── Valor do atendimento ──
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cobrança',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _valorCtrl,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    decoration: InputDecoration(
                                      labelText: 'Valor do atendimento (R\$)',
                                      hintText: 'Ex: 150,00 — deixe em branco se não houver cobrança',
                                      prefixText: 'R\$ ',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ── Botão salvar ──
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: NeuroPillButton(
                                text: _salvando ? '' : 'SALVAR ATENDIMENTO',
                                onPressed: _salvando ? () {} : _salvar,
                                width: double.infinity,
                                height: 50,
                              ),
                            ),
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
}