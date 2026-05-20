import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/funcionario.dart';
import '../services/funcionario_service.dart';
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
      // 9 dígitos → celular: (xx) xxxxx-xxxx
      // 8 dígitos → fixo:    (xx) xxxx-xxxx
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


class _NeuroValidatedField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const _NeuroValidatedField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.errorText,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

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
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: hasError ? Colors.red.shade50 : NeuroColors.panel,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade700 : Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade700 : Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(999),
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
                    style: TextStyle(fontSize: 11, color: Colors.red.shade700, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}


class FuncionarioFormScreen extends StatefulWidget {
  final Funcionario? funcionario;

  const FuncionarioFormScreen({super.key, this.funcionario});

  @override
  State<FuncionarioFormScreen> createState() => _FuncionarioFormScreenState();
}

class _FuncionarioFormScreenState extends State<FuncionarioFormScreen> {
  final _nomeController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _senhaController    = TextEditingController();
  final _confirmarController = TextEditingController();
  final _funcaoController   = TextEditingController();
  final _telefoneController = TextEditingController();

  String _perfilSelecionado = 'usuario';
  bool _carregando  = false;
  bool _verSenha    = false;
  bool _verConfirmar = false;

 
  String? _erroNome;
  String? _erroEmail;
  String? _erroSenha;
  String? _erroConfirmar;
  String? _erroFuncao;
  String? _erroTelefone;

  bool get _editando => widget.funcionario != null;

  final List<String> _perfis = ['usuario', 'gerente', 'admin'];
  final Map<String, String> _labelPerfil = {
    'usuario': 'Usuário — Atendimentos e Alunos',
    'gerente': 'Gerente — + Financeiro',
    'admin':   'Admin — Acesso total',
  };

  @override
  void initState() {
    super.initState();
    if (_editando) {
      final f = widget.funcionario!;
      _nomeController.text     = f.nome;
      _emailController.text    = f.email;
      _funcaoController.text   = f.funcao;
      _telefoneController.text = f.telefone ?? '';
      _perfilSelecionado       = f.perfil;
    }

    // Limpa erro do campo ao digitar
    _nomeController.addListener(()      => _limparErro(() => _erroNome = null));
    _emailController.addListener(()     => _limparErro(() => _erroEmail = null));
    _senhaController.addListener(()     => _limparErro(() => _erroSenha = null));
    _confirmarController.addListener(() => _limparErro(() => _erroConfirmar = null));
    _funcaoController.addListener(()    => _limparErro(() => _erroFuncao = null));
    _telefoneController.addListener(()  => _limparErro(() => _erroTelefone = null));
  }

  void _limparErro(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    _funcaoController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

 
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

      // E-mail
      final email = _emailController.text.trim();
      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
      if (email.isEmpty) {
        _erroEmail = 'O e-mail é obrigatório.';
        valido = false;
      } else if (!emailRegex.hasMatch(email)) {
        _erroEmail = 'Digite um e-mail válido. Ex: nome@dominio.com';
        valido = false;
      } else {
        _erroEmail = null;
      }

      // Senha
      final senha = _senhaController.text;
      if (!_editando) {
        if (senha.isEmpty) {
          _erroSenha = 'A senha é obrigatória.';
          valido = false;
        } else if (senha.length < 6) {
          _erroSenha = 'A senha deve ter ao menos 6 caracteres.';
          valido = false;
        } else if (!RegExp(r'[A-Za-z]').hasMatch(senha)) {
          _erroSenha = 'A senha deve conter ao menos uma letra.';
          valido = false;
        } else if (!RegExp(r'[0-9]').hasMatch(senha)) {
          _erroSenha = 'A senha deve conter ao menos um número.';
          valido = false;
        } else {
          _erroSenha = null;
        }

        // Confirmar senha
        if (_confirmarController.text.isEmpty) {
          _erroConfirmar = 'Confirme a senha.';
          valido = false;
        } else if (_confirmarController.text != senha) {
          _erroConfirmar = 'As senhas não coincidem.';
          valido = false;
        } else {
          _erroConfirmar = null;
        }
      } else if (senha.isNotEmpty) {
        // Editando e digitou nova senha
        if (senha.length < 6) {
          _erroSenha = 'A nova senha deve ter ao menos 6 caracteres.';
          valido = false;
        } else if (!RegExp(r'[A-Za-z]').hasMatch(senha)) {
          _erroSenha = 'A senha deve conter ao menos uma letra.';
          valido = false;
        } else if (!RegExp(r'[0-9]').hasMatch(senha)) {
          _erroSenha = 'A senha deve conter ao menos um número.';
          valido = false;
        } else {
          _erroSenha = null;
        }

        if (_confirmarController.text != senha) {
          _erroConfirmar = 'As senhas não coincidem.';
          valido = false;
        } else {
          _erroConfirmar = null;
        }
      } else {
        _erroSenha = null;
        _erroConfirmar = null;
      }

      // Função
      final funcao = _funcaoController.text.trim();
      if (funcao.isEmpty) {
        _erroFuncao = 'A função é obrigatória.';
        valido = false;
      } else if (funcao.length < 3) {
        _erroFuncao = 'Digite uma função válida. Ex: Terapeuta.';
        valido = false;
      } else {
        _erroFuncao = null;
      }

      // Telefone (opcional, mas se preenchido valida o formato)
      final tel = _telefoneController.text.trim();
      if (tel.isNotEmpty) {
        final digits = tel.replaceAll(RegExp(r'\D'), '');
        if (digits.length < 10 || digits.length > 11) {
          _erroTelefone = 'Formato inválido. Use (xx) xxxx-xxxx ou (xx) xxxxx-xxxx.';
          valido = false;
        } else {
          _erroTelefone = null;
        }
      } else {
        _erroTelefone = null;
      }
    });

    return valido;
  }

  Future<void> _salvar() async {
    if (!_validar()) return;

    setState(() => _carregando = true);

    final nome     = _nomeController.text.trim();
    final email    = _emailController.text.trim();
    final senha    = _senhaController.text;
    final funcao   = _funcaoController.text.trim();
    final telefone = _telefoneController.text.trim();

    String? erro;

    if (_editando) {
      erro = await FuncionarioService.editar(
        id:        widget.funcionario!.id,
        nome:      nome,
        email:     email,
        funcao:    funcao,
        perfil:    _perfilSelecionado,
        telefone:  telefone.isEmpty ? null : telefone,
        novaSenha: senha.isEmpty ? null : senha,
      );
    } else {
      erro = await FuncionarioService.criar(
        nome:     nome,
        email:    email,
        senha:    senha,
        funcao:   funcao,
        perfil:   _perfilSelecionado,
        telefone: telefone.isEmpty ? null : telefone,
      );
    }

    setState(() => _carregando = false);
    if (!mounted) return;

    if (erro != null) {
      // Erro vindo do backend (ex: e-mail já cadastrado)
      if (erro.toLowerCase().contains('e-mail')) {
        setState(() => _erroEmail = erro);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(erro),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } else {
      Navigator.pop(context, true);
    }
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
                  title: _editando ? 'EDITAR FUNCIONÁRIO' : 'NOVO FUNCIONÁRIO',
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
                          left: NeuroPillButton(
                            text: 'VOLTAR',
                            width: 95, height: 34, fontSize: 11,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Nome ──
                        _NeuroValidatedField(
                          label: 'Nome:',
                          hint: 'Nome completo',
                          controller: _nomeController,
                          errorText: _erroNome,
                        ),
                        const SizedBox(height: 14),

                        // ── E-mail ──
                        _NeuroValidatedField(
                          label: 'E-mail:',
                          hint: 'email@exemplo.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          errorText: _erroEmail,
                        ),
                        const SizedBox(height: 14),

                        // ── Senha ──
                        _NeuroValidatedField(
                          label: _editando
                              ? 'Nova senha (deixe vazio para não alterar):'
                              : 'Senha:',
                          hint: _editando
                              ? 'Nova senha (opcional)'
                              : 'Mínimo 6 caracteres, letras e números',
                          controller: _senhaController,
                          obscureText: !_verSenha,
                          errorText: _erroSenha,
                          suffixIcon: IconButton(
                            icon: Icon(_verSenha ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _verSenha = !_verSenha),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Confirmar senha ──
                        _NeuroValidatedField(
                          label: 'Confirmar senha:',
                          hint: 'Repita a senha',
                          controller: _confirmarController,
                          obscureText: !_verConfirmar,
                          errorText: _erroConfirmar,
                          suffixIcon: IconButton(
                            icon: Icon(_verConfirmar ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _verConfirmar = !_verConfirmar),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Função ──
                        _NeuroValidatedField(
                          label: 'Função:',
                          hint: 'Ex: Terapeuta, Recepcionista, Coordenador',
                          controller: _funcaoController,
                          errorText: _erroFuncao,
                        ),
                        const SizedBox(height: 14),

                        // ── Telefone com máscara ──
                        _NeuroValidatedField(
                          label: 'Telefone (opcional):',
                          hint: '(xx) xxxxx-xxxx',
                          controller: _telefoneController,
                          keyboardType: TextInputType.phone,
                          errorText: _erroTelefone,
                          inputFormatters: [_TelefoneMask()],
                        ),
                        const SizedBox(height: 18),

                        // ── Nível de acesso ──
                        const Padding(
                          padding: EdgeInsets.only(left: 6, bottom: 8),
                          child: Text('Nível de acesso:',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                        ..._perfis.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () => setState(() => _perfilSelecionado = p),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: _perfilSelecionado == p ? NeuroColors.panel : Colors.white,
                                border: Border.all(
                                  color: _perfilSelecionado == p ? Colors.black : Colors.grey,
                                  width: _perfilSelecionado == p ? 3 : 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _perfilSelecionado == p
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _labelPerfil[p] ?? p,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),

                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _carregando
                              ? const CircularProgressIndicator(color: Colors.black)
                              : NeuroPillButton(
                                  text: 'SALVAR',
                                  width: 130, height: 42,
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
