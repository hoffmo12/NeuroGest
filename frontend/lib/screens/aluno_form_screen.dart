import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/aluno.dart';
import '../services/aluno_service.dart';
import '../widgets/neuro_widgets.dart';

class _TelefoneMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (digits.length == 11 && i == 7) buffer.write('-');
      if (digits.length <= 10 && i == 6) buffer.write('-');
      buffer.write(digits[i]);
    }
    final result = buffer.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class _CpfMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(digits[i]);
    }
    final result = buffer.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class _ValidatedField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? errorText;

  const _ValidatedField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.inputFormatters,
    this.keyboardType,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeuroTextField(
          label: label,
          hint: hint,
          controller: controller,
          obscureText: obscureText,
          suffixIcon: suffixIcon,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class AlunoFormScreen extends StatefulWidget {
  final Aluno? aluno;
  const AlunoFormScreen({super.key, this.aluno});

  @override
  State<AlunoFormScreen> createState() => _AlunoFormScreenState();
}

class _AlunoFormScreenState extends State<AlunoFormScreen> {
  final _nomeCtrl      = TextEditingController();
  final _dataNascCtrl  = TextEditingController();
  final _municipioCtrl = TextEditingController();
  final _sexoCtrl      = TextEditingController();
  final _estadoCtrl    = TextEditingController();
  final _nomePaiCtrl   = TextEditingController();
  final _nomeMaeCtrl   = TextEditingController();
  final _cpfCtrl       = TextEditingController();
  final _telCtrl       = TextEditingController();
  final _obsCtrl       = TextEditingController();

  String? _errNome;
  String? _errData;
  String? _errCpf;
  String? _errTelefone;

  DateTime? _dataSelecionada;
  int _idadeCalculada = 0;
  bool _carregando = false;

  bool get _isEdicao => widget.aluno != null;

  @override
  void initState() {
    super.initState();
    if (_isEdicao) {
      final a = widget.aluno!;
      _nomeCtrl.text      = a.nome;
      _dataNascCtrl.text  = a.dataNascimentoFormatada;
      _municipioCtrl.text = a.municipio ?? '';
      _sexoCtrl.text      = a.sexo ?? '';
      _estadoCtrl.text    = a.estado ?? '';
      _nomePaiCtrl.text   = a.nomePai ?? '';
      _nomeMaeCtrl.text   = a.nomeMae ?? '';
      _cpfCtrl.text       = a.cpf ?? '';
      _telCtrl.text       = a.telefoneResponsavel ?? '';
      _obsCtrl.text       = a.observacoes ?? '';
      _dataSelecionada    = a.dataNascimento;
      _idadeCalculada     = a.idade;
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _dataNascCtrl.dispose();
    _municipioCtrl.dispose();
    _sexoCtrl.dispose();
    _estadoCtrl.dispose();
    _nomePaiCtrl.dispose();
    _nomeMaeCtrl.dispose();
    _cpfCtrl.dispose();
    _telCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime(2015),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
      helpText: 'DATA DE NASCIMENTO',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
    );

    if (picked != null) {
      setState(() {
        _dataSelecionada = picked;
        _dataNascCtrl.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        _idadeCalculada = _calcularIdade(picked);
        _errData = null;
      });
    }
  }

  int _calcularIdade(DateTime nascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }
    return idade;
  }

  bool _validar() {
    setState(() {
      final nome = _nomeCtrl.text.trim();
      if (nome.isEmpty) {
        _errNome = 'O nome é obrigatório.';
      } else if (nome.length < 3) {
        _errNome = 'O nome deve ter ao menos 3 caracteres.';
      } else {
        _errNome = null;
      }

      _errData = _dataSelecionada == null ? 'Selecione a data de nascimento.' : null;

      final cpf = _cpfCtrl.text.replaceAll(RegExp(r'\D'), '');
      _errCpf = (cpf.isNotEmpty && cpf.length != 11) ? 'CPF inválido. Digite os 11 dígitos.' : null;

      final tel = _telCtrl.text.replaceAll(RegExp(r'\D'), '');
      _errTelefone = (tel.isNotEmpty && (tel.length < 10 || tel.length > 11))
          ? 'Formato inválido. Use (xx) xxxxx-xxxx.'
          : null;
    });

    return _errNome == null && _errData == null && _errCpf == null && _errTelefone == null;
  }

  Future<void> _salvar() async {
    if (!_validar()) return;
    setState(() => _carregando = true);

    final dataApi =
        '${_dataSelecionada!.year}-${_dataSelecionada!.month.toString().padLeft(2, '0')}-${_dataSelecionada!.day.toString().padLeft(2, '0')}';

    String? erro;

    final String? municipio = _municipioCtrl.text.trim().isEmpty ? null : _municipioCtrl.text.trim();
    final String? sexo = _sexoCtrl.text.trim().isEmpty ? null : _sexoCtrl.text.trim();
    final String? estado = _estadoCtrl.text.trim().isEmpty ? null : _estadoCtrl.text.trim();
    final String? nomePai = _nomePaiCtrl.text.trim().isEmpty ? null : _nomePaiCtrl.text.trim();
    final String? nomeMae = _nomeMaeCtrl.text.trim().isEmpty ? null : _nomeMaeCtrl.text.trim();
    final String? cpf = _cpfCtrl.text.trim().isEmpty ? null : _cpfCtrl.text.trim();
    final String? telefoneResponsavel = _telCtrl.text.trim().isEmpty ? null : _telCtrl.text.trim();
    final String? observacoes = _obsCtrl.text.trim().isEmpty ? null : _obsCtrl.text.trim();

    if (_isEdicao) {
      erro = await AlunoService.editar(
        id:                  widget.aluno!.id,
        nome:                _nomeCtrl.text.trim(),
        dataNascimento:      dataApi,
        municipio:           municipio,
        sexo:                sexo,
        estado:              estado,
        nomePai:             nomePai,
        nomeMae:             nomeMae,
        cpf:                 cpf,
        telefoneResponsavel: telefoneResponsavel,
        observacoes:         observacoes,
      );
    } else {
      erro = await AlunoService.criar(
        nome:                _nomeCtrl.text.trim(),
        dataNascimento:      dataApi,
        municipio:           municipio,
        sexo:                sexo,
        estado:              estado,
        nomePai:             nomePai,
        nomeMae:             nomeMae,
        cpf:                 cpf,
        telefoneResponsavel: telefoneResponsavel,
        observacoes:         observacoes,
      );
    }

    setState(() => _carregando = false);
    if (!mounted) return;

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aluno salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red.shade700),
      );
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
                  NeuroHeaderTitle(title: _isEdicao ? 'EDITAR ALUNO' : 'ADICIONAR ALUNO'),
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
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Nome ──
                                  _ValidatedField(
                                    label: 'Nome completo:',
                                    hint: 'Nome do aluno',
                                    controller: _nomeCtrl,
                                    errorText: _errNome,
                                  ),
                                  const SizedBox(height: 14),

                                  // ── Data de Nascimento ──
                                  GestureDetector(
                                    onTap: _selecionarData,
                                    child: AbsorbPointer(
                                      child: _ValidatedField(
                                        label: 'Data de nascimento:',
                                        hint: 'Toque para selecionar',
                                        controller: _dataNascCtrl,
                                        errorText: _errData,
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (_dataSelecionada != null)
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8),
                                                child: Text(
                                                  '$_idadeCalculada anos',
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            const Icon(Icons.calendar_today, size: 20),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // ── Sexo & CPF ──
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: _ValidatedField(
                                          label: 'Sexo (opcional):',
                                          hint: 'Ex: Masculino',
                                          controller: _sexoCtrl,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _ValidatedField(
                                          label: 'CPF do aluno (opcional):',
                                          hint: '000.000.000-00',
                                          controller: _cpfCtrl,
                                          errorText: _errCpf,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [_CpfMask()],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // ── Localização (Município e Estado) ──
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: _ValidatedField(
                                          label: 'Município (opcional):',
                                          hint: 'Cidade',
                                          controller: _municipioCtrl,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 1,
                                        child: _ValidatedField(
                                          label: 'UF (opcional):',
                                          hint: 'PR',
                                          controller: _estadoCtrl,
                                          inputFormatters: [LengthLimitingTextInputFormatter(2)],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // ── Divisor Responsáveis ──
                                  const Row(
                                    children: [
                                      Expanded(child: Divider(thickness: 2)),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('RESPONSÁVEIS',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                                      ),
                                      Expanded(child: Divider(thickness: 2)),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // ── Nome Pai ──
                                  _ValidatedField(
                                    label: 'Nome do pai (opcional):',
                                    hint: 'Nome completo do pai',
                                    controller: _nomePaiCtrl,
                                  ),
                                  const SizedBox(height: 14),

                                  // ── Nome Mãe ──
                                  _ValidatedField(
                                    label: 'Nome da mãe (opcional):',
                                    hint: 'Nome completo da mãe',
                                    controller: _nomeMaeCtrl,
                                  ),
                                  const SizedBox(height: 14),

                                  // ── Telefone ──
                                  _ValidatedField(
                                    label: 'Telefone do responsável (opcional):',
                                    hint: '(xx) xxxxx-xxxx',
                                    controller: _telCtrl,
                                    errorText: _errTelefone,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [_TelefoneMask()],
                                  ),
                                  const SizedBox(height: 20),

                                  // ── Divisor Observações ──
                                  const Row(
                                    children: [
                                      Expanded(child: Divider(thickness: 2)),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('OBSERVAÇÕES',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                                      ),
                                      Expanded(child: Divider(thickness: 2)),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // ── Observações ──
                                  _ValidatedField(
                                    label: 'Observações (opcional):',
                                    hint: 'Informações adicionais...',
                                    controller: _obsCtrl,
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _carregando
                                ? const CircularProgressIndicator(color: Colors.black)
                                : NeuroPillButton(
                                    text: 'SALVAR',
                                    width: 130,
                                    height: 42,
                                    onPressed: _salvar,
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
      ),
    );
  }
}