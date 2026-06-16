import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neurogest_front/mock/mock_aluno_repository.dart';
import '../models/aluno.dart';
import '../services/aluno_service.dart';
import '../widgets/neuro_widgets.dart';

// ─── Máscara CPF: 000.000.000-00 ─────────────────────────
class _CpfMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue novo,
  ) {
    final digits = novo.text.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 3 || i == 6) buf.write('.');
      if (i == 9) buf.write('-');
      buf.write(digits[i]);
    }
    final result = buf.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

// ─── Máscara Telefone ─────────────────────────────────────
class _TelefoneMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue novo,
  ) {
    final digits = novo.text.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 0) buf.write('(');
      if (i == 2) buf.write(') ');
      if (digits.length == 11 && i == 7) buf.write('-');
      if (digits.length <= 10 && i == 6) buf.write('-');
      buf.write(digits[i]);
    }
    final result = buf.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

// ─── Campo com erro visual ────────────────────────────────
class _Campo extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffixIcon;

  const _Campo({
    required this.label,
    required this.hint,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final isMultiline = maxLines != null && maxLines! > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: hasError ? Colors.red.shade50 : NeuroColors.panel,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            suffixIcon: suffixIcon,
            counterText: maxLength != null ? null : '',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade700 : Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(isMultiline ? 16 : 999),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade700 : Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(isMultiline ? 16 : 999),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 14, top: 5),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 13, color: Colors.red.shade700),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
  final _nomeController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _nomePaiController = TextEditingController();
  final _nomeMaeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _sexoController = TextEditingController();
  final _municipioController = TextEditingController();
  final _estadoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _obsController = TextEditingController();

  String? _erroNome;
  String? _erroData;
  String? _erroCpf;
  String? _erroTelefone;

  DateTime? _dataSelecionada;
  int _idadeCalculada = 0;
  bool _carregando = false;

  bool get _editando => widget.aluno != null;

  @override
  void initState() {
    super.initState();
    if (_editando) {
      final a = widget.aluno!;
      _nomeController.text = a.nome;
      _dataNascController.text = a.dataNascimentoFormatada;
      _nomePaiController.text = a.nomePai ?? '';
      _nomeMaeController.text = a.nomeMae ?? '';
      _cpfController.text = a.cpf ?? '';
      _telefoneController.text = a.telefoneResponsavel ?? '';
      _obsController.text = a.observacoes ?? '';
      _dataSelecionada = a.dataNascimento;
      _idadeCalculada = a.idade;
    }

    _nomeController.addListener(() => _limpar(() => _erroNome = null));
    _dataNascController.addListener(() => _limpar(() => _erroData = null));
    _cpfController.addListener(() => _limpar(() => _erroCpf = null));
    _telefoneController.addListener(() => _limpar(() => _erroTelefone = null));
  }

  void _limpar(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascController.dispose();
    _nomePaiController.dispose();
    _nomeMaeController.dispose();
    _cpfController.dispose();
    _municipioController.dispose();
    _sexoController.dispose();
    _telefoneController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  // ─── Seletor de data ──────────────────────────────────
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
        _dataNascController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        _idadeCalculada = _calcularIdade(picked);
        _erroData = null;
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

  // ─── Validações ───────────────────────────────────────
  bool _validar() {
    bool valido = true;

    setState(() {
      // Nome
      final nome = _nomeController.text.trim();
      if (nome.isEmpty) {
        _erroNome = 'O nome é obrigatório.';
        valido = false;
      } else if (nome.length < 3) {
        _erroNome = 'O nome deve ter ao menos 3 caracteres.';
        valido = false;
      } else {
        _erroNome = null;
      }

      // Data de nascimento
      if (_dataSelecionada == null) {
        _erroData = 'Selecione a data de nascimento.';
        valido = false;
      } else {
        _erroData = null;
      }

      // CPF pai (opcional, mas se preenchido valida)
      final cpf = _cpfController.text.replaceAll(RegExp(r'\D'), '');
      if (cpf.isNotEmpty && cpf.length != 11) {
        _erroCpf = 'CPF inválido. Digite os 11 dígitos.';
        valido = false;
      } else {
        _erroCpf = null;
      }

      // Telefone (opcional, mas se preenchido valida)
      final tel = _telefoneController.text.replaceAll(RegExp(r'\D'), '');
      if (tel.isNotEmpty && (tel.length < 10 || tel.length > 11)) {
        _erroTelefone =
            'Formato inválido. Use (xx) xxxx-xxxx ou (xx) xxxxx-xxxx.';
        valido = false;
      } else {
        _erroTelefone = null;
      }
    });

    return valido;
  }

  Future<void> _salvar() async {
    // if (!_validar()) return;

    setState(() => _carregando = true);

    String? erro;

    if (_editando) {
      // erro = await AlunoService.editar(
      //   id: widget.aluno!.id,
      //   nome: _nomeController.text.trim(),
      //   dataNascimento: dataApi,
      //   nomePai: _nomePaiController.text.trim().isEmpty
      //       ? null
      //       : _nomePaiController.text.trim(),
      //   nomeMae: _nomeMaeController.text.trim().isEmpty
      //       ? null
      //       : _nomeMaeController.text.trim(),
      //   cpfPai: _cpfPaiController.text.trim().isEmpty
      //       ? null
      //       : _cpfPaiController.text.trim(),
      //   cpfMae: _cpfMaeController.text.trim().isEmpty
      //       ? null
      //       : _cpfMaeController.text.trim(),
      //   telefoneResponsavel: _telefoneController.text.trim().isEmpty
      //       ? null
      //       : _telefoneController.text.trim(),
      //   observacoes: _obsController.text.trim().isEmpty
      //       ? null
      //       : _obsController.text.trim(),
      // );
    } else {
      AlunoRepository().criar(
        nome: _nomeController.text,
        cpf: _cpfController.text,
        // dataNascimento: DateTime.parse(_dataNascController.text),
        dataNascimento: DateTime(2000, 3, 20),
        idade:
            DateTime.now().year - DateTime.parse(_dataNascController.text).year,
        nomeMae: _nomeMaeController.text,
        nomePai: _nomePaiController.text,
        municipio: _municipioController.text,
        observacoes: _obsController.text,
        telefoneResponsavel: _telefoneController.text,
        sexo: _sexoController.text,
      );
    }

    setState(() => _carregando = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aluno criado com sucesso!'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                  title: _editando ? 'EDITAR ALUNO' : 'CADASTRAR ALUNO',
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: NeuroPanel(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NeuroTopBar(
                          title: 'NEUROGEST',
                          right: NeuroPillButton(
                            text: 'VOLTAR',
                            width: 95,
                            height: 34,
                            fontSize: 11,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Nome ──
                        _Campo(
                          label: 'Nome completo:',
                          hint: 'Nome do aluno',
                          controller: _nomeController,
                          errorText: _erroNome,
                        ),
                        const SizedBox(height: 14),

                        // ── Data de nascimento + idade calculada ──
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 6, bottom: 6),
                              child: Text(
                                'Data de nascimento:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: null,
                                    // onTap: _selecionarData,
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: _dataNascController,
                                        decoration: InputDecoration(
                                          hintText: 'Toque para selecionar',
                                          filled: true,
                                          fillColor: _erroData != null
                                              ? Colors.red.shade50
                                              : NeuroColors.panel,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical: 14,
                                              ),
                                          suffixIcon: const Icon(
                                            Icons.calendar_today,
                                            size: 20,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _erroData != null
                                                  ? Colors.red.shade700
                                                  : Colors.black,
                                              width: 3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _erroData != null
                                                  ? Colors.red.shade700
                                                  : Colors.black,
                                              width: 3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_dataSelecionada != null) ...[
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: NeuroColors.panel,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      '$_idadeCalculada anos',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (_erroData != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 14,
                                  top: 5,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 13,
                                      color: Colors.red.shade700,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _erroData!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _Campo(
                          label: 'CPF:',
                          hint: '000.000.000-00',
                          controller: _cpfController,
                          errorText: _erroCpf,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_CpfMask()],
                        ),
                        const SizedBox(height: 18),
                        _Campo(
                          label: 'Sexo:',
                          hint: '',
                          controller: _sexoController,
                          errorText: 'Informe um sexo',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 14),

                        // ── Divisor ──
                        const Padding(
                          padding: EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Expanded(child: Divider(thickness: 2)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'RESPONSÁVEIS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(thickness: 2)),
                            ],
                          ),
                        ),

                        _Campo(
                          label: 'Nome da mãe:',
                          hint: 'Nome completo da mãe',
                          controller: _nomeMaeController,
                          maxLength: 70,
                        ),
                        const SizedBox(height: 14),
                        // ── Nome pai ──
                        _Campo(
                          label: 'Nome do pai (opcional):',
                          hint: 'Nome completo do pai',
                          controller: _nomePaiController,
                          maxLength: 70,
                        ),
                        const SizedBox(height: 14),

                        // ── CPF pai ──

                        // ── Nome mãe ──

                        // ── Telefone ──
                        _Campo(
                          label: 'Telefone do responsável (opcional):',
                          hint: '(xx) xxxxx-xxxx',
                          controller: _telefoneController,
                          errorText: _erroTelefone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [_TelefoneMask()],
                        ),
                        const SizedBox(height: 18),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Expanded(child: Divider(thickness: 2)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'INFORMAÇÕES COMPLEMENTARES',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(thickness: 2)),
                            ],
                          ),
                        ),
                        _Campo(
                          label: 'Município:',
                          hint: 'Exemplo: Guarapuava',
                          controller: _municipioController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 18),
                        _Campo(
                          label: 'Estado:',
                          hint: 'Exemplo: PR',
                          controller: _estadoController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 18),
                        // ── Divisor ──
                        const Padding(
                          padding: EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Expanded(child: Divider(thickness: 2)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'OBSERVAÇÕES',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(thickness: 2)),
                            ],
                          ),
                        ),

                        // ── Observações (200 chars) ──
                        _Campo(
                          label: 'Observações (opcional):',
                          hint: 'Informações adicionais sobre o aluno...',
                          controller: _obsController,
                          maxLines: 4,
                          maxLength: 200,
                        ),

                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _carregando
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
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
    );
  }
}
