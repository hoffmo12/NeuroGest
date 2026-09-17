import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
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
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIcon,
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

class _OpcaoRadio extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _OpcaoRadio({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selecionado
                ? NeuroColors.primary.withOpacity(0.08)
                : NeuroColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selecionado ? NeuroColors.primary : NeuroColors.border,
              width: selecionado ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selecionado ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 18,
                color: selecionado ? NeuroColors.primary : NeuroColors.mutedText,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selecionado ? NeuroColors.primary : NeuroColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UsuarioFormScreen extends StatefulWidget {
  final Usuario? usuario;
  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _nomeCtrl        = TextEditingController();
  final _emailCtrl       = TextEditingController();
  final _senhaCtrl       = TextEditingController();
  final _cpfCtrl         = TextEditingController();
  final _tipoRegistroCtrl = TextEditingController();
  final _numRegistroCtrl  = TextEditingController();
  final _telCtrl         = TextEditingController();

  String _perfilSelecionado = 'profissional';
  String? _cboSelecionado;
  bool _obscureSenha = true;
  bool _carregando = false;

  String? _errNome;
  String? _errEmail;
  String? _errSenha;
  String? _errTelefone;
  String? _errCbo;

  final List<String> _perfis = ['admin', 'profissional', 'recepcao'];
  final List<String> _cbos = [
    'Fonoaudiólogo(a)',
    'Psicólogo(a)',
    'Psicopedagogo(a)',
    'Fisioterapeuta',
    'Terapeuta Ocupacional',
    'Nutricionista',
  ];
  final Map<String, String> _labelPerfil = {
    'admin':        'Administrador',
    'profissional': 'Profissional/Terapeuta',
    'recepcao':     'Recepção',
  };

  bool get _isEdicao => widget.usuario != null;

  @override
  void initState() {
    super.initState();
    if (_isEdicao) {
      final u = widget.usuario!;
      _nomeCtrl.text         = u.nome;
      _emailCtrl.text        = u.email;
      _cpfCtrl.text          = u.cpf ?? '';
      _tipoRegistroCtrl.text = u.tipoRegistro;
      _numRegistroCtrl.text  = u.numRegistro;
      _telCtrl.text          = u.telefone ?? '';
      _perfilSelecionado     = _perfis.contains(u.perfil) ? u.perfil : 'profissional';
      if (u.cbo.isNotEmpty) {
        if (!_cbos.contains(u.cbo)) _cbos.add(u.cbo);
        _cboSelecionado = u.cbo;
      }
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _cpfCtrl.dispose();
    _tipoRegistroCtrl.dispose();
    _numRegistroCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }

  bool _validar() {
    setState(() {
      _errNome  = _nomeCtrl.text.trim().isEmpty ? 'Nome é obrigatório.' : null;
      _errEmail = _emailCtrl.text.trim().isEmpty ? 'E-mail é obrigatório.' : null;
      if (!_isEdicao && _senhaCtrl.text.isEmpty) {
        _errSenha = 'Senha é obrigatória para novos usuários.';
      } else if (!_isEdicao && _senhaCtrl.text.length < 6) {
        _errSenha = 'A senha deve ter no mínimo 6 caracteres.';
      } else {
        _errSenha = null;
      }
      _errTelefone = !_isEdicao && _telCtrl.text.trim().isEmpty
          ? 'Telefone é obrigatório.'
          : null;
      _errCbo = _cboSelecionado == null ? 'Selecione a especialidade.' : null;
    });
    return _errNome == null &&
        _errEmail == null &&
        _errSenha == null &&
        _errTelefone == null &&
        _errCbo == null;
  }

  Future<void> _salvar() async {
    if (!_validar()) return;
    setState(() => _carregando = true);

    String? erro;

    if (_isEdicao) {
      erro = await UsuarioService.editar(
        id:           widget.usuario!.id,
        nome:         _nomeCtrl.text.trim(),
        email:        _emailCtrl.text.trim(),
        cpf:          _cpfCtrl.text.trim().isEmpty ? null : _cpfCtrl.text.trim(),
        cbo:          _cboSelecionado ?? '',
        tipoRegistro: _tipoRegistroCtrl.text.trim(),
        numRegistro:  _numRegistroCtrl.text.trim(),
        perfil:       _perfilSelecionado,
        telefone:     _telCtrl.text.trim().isEmpty ? null : _telCtrl.text.trim(),
        novaSenha:    _senhaCtrl.text.isNotEmpty ? _senhaCtrl.text : null,
      );
    } else {
      erro = await UsuarioService.criar(
        nome:         _nomeCtrl.text.trim(),
        email:        _emailCtrl.text.trim(),
        senha:        _senhaCtrl.text,
        cpf:          _cpfCtrl.text.trim().isEmpty ? null : _cpfCtrl.text.trim(),
        cbo:          _cboSelecionado ?? '',
        tipoRegistro: _tipoRegistroCtrl.text.trim(),
        numRegistro:  _numRegistroCtrl.text.trim(),
        perfil:       _perfilSelecionado,
        telefone:     _telCtrl.text.trim().isEmpty ? null : _telCtrl.text.trim(),
      );
    }

    setState(() => _carregando = false);
    if (!mounted) return;

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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
                  const NeuroHeaderTitle(title: 'USUÁRIOS'),
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
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isEdicao ? 'EDITAR USUÁRIO' : 'NOVO USUÁRIO',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: NeuroColors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // ── Dados principais ──
                                  _ValidatedField(
                                    label: 'Nome Completo *',
                                    hint: 'Ex: João da Silva',
                                    controller: _nomeCtrl,
                                    errorText: _errNome,
                                  ),
                                  const SizedBox(height: 12),
                                  _ValidatedField(
                                    label: 'E-mail de Acesso *',
                                    hint: 'Ex: joao@email.com',
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    errorText: _errEmail,
                                  ),
                                  const SizedBox(height: 12),
                                  _ValidatedField(
                                    label: _isEdicao
                                        ? 'Nova Senha (deixe em branco para manter)'
                                        : 'Senha de Acesso *',
                                    hint: 'No mínimo 6 caracteres',
                                    controller: _senhaCtrl,
                                    obscureText: _obscureSenha,
                                    errorText: _errSenha,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureSenha ? Icons.visibility : Icons.visibility_off,
                                        color: NeuroColors.mutedText,
                                      ),
                                      onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // ── Dados profissionais ──
                                  NeuroTextField(
                                    label: 'CPF',
                                    hint: '000.000.000-00',
                                    controller: _cpfCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [_CpfMask()],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Especialidade (CBO) *',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: NeuroColors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ..._cbos.map((c) => _OpcaoRadio(
                                        label: c,
                                        selecionado: _cboSelecionado == c,
                                        onTap: () => setState(() => _cboSelecionado = c),
                                      )),
                                  if (_errCbo != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8, left: 4),
                                      child: Text(
                                        _errCbo!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: NeuroTextField(
                                          label: 'Tipo de Registro',
                                          hint: 'Ex: CRP, CREFITO',
                                          controller: _tipoRegistroCtrl,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: NeuroTextField(
                                          label: 'Nº do Registro',
                                          hint: 'Ex: 12345/SP',
                                          controller: _numRegistroCtrl,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _ValidatedField(
                                    label: _isEdicao
                                        ? 'Telefone de Contato'
                                        : 'Telefone de Contato *',
                                    hint: '(00) 00000-0000',
                                    controller: _telCtrl,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [_TelefoneMask()],
                                    errorText: _errTelefone,
                                  ),
                                  const SizedBox(height: 20),

                                  // ── Perfil ──
                                  const Text(
                                    'Perfil de Permissão:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: NeuroColors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ..._perfis.map((p) => _OpcaoRadio(
                                        label: _labelPerfil[p] ?? p,
                                        selecionado: _perfilSelecionado == p,
                                        onTap: () => setState(() => _perfilSelecionado = p),
                                      )),
                                  const SizedBox(height: 24),

                                  // ── Botão salvar ──
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: _carregando
                                        ? const CircularProgressIndicator(
                                            color: NeuroColors.primary)
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