import 'package:flutter/material.dart';
import 'package:neurogest_front/mock/mock_database.dart';
import 'package:neurogest_front/mock/mock_funcionario_repository.dart';
import 'dashboard_screen.dart';
import '../widgets/neuro_widgets.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool _carregando = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> entrar() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    final bool isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // setState(() => _carregando = true);
    await Future.delayed(const Duration(seconds: 1));
    // final resultado = await AuthService.login(email, senha); //todo: corrigir depois
    final resultado = FuncionarioRepository().autenticar(email, senha);

    if (!mounted) return;

    // if (resultado.sucesso) {
    if (resultado != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(email)),
      );
    } else {
      // _mostrarErro(resultado.mensagemErro ?? 'Erro desconhecido.');
      _mostrarErro(
        'Erro ao logar! Verifique o E-mail e/ou Senha e tente novamente!',
      );
      setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuroColors.background,
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const NeuroHeaderTitle(title: 'LOGIN'),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: NeuroPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 26,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'NEUROGEST',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const NeuroLogo(size: 92, animated: true),
                        const SizedBox(height: 24),
                        NeuroTextField(
                          label: 'Email:',
                          hint: 'Digite seu email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        const SizedBox(height: 18),
                        NeuroTextField(
                          label: 'Senha:',
                          hint: 'Digite sua senha',
                          controller: senhaController,
                          obscureText: true,
                          validator: passValidator,
                        ),
                        const SizedBox(height: 24),
                        NeuroPillButton(
                          loading: _carregando, //TODO: depois verifico a lógica
                          text: 'ENTRAR',
                          width: 120,
                          height: 42,
                          onPressed: entrar,
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

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'O E-mail é obrigatório';
    }
    if (!value.contains('@') || value.split('@').last.isEmpty) {
      return 'E-mail inválido';
    }
    if (value.length != value.replaceAll(' ', '').length) {
      return 'O E-mail não deve conter espaços';
    }
    if (value.length < 5) {
      return 'O E-mail deve conter ao menos 5 caracteres';
    }
    if (value.length > 100) {
      return 'O E-mail não pode conter mais do que 100 caracteres';
    }
    return null;
  }

  String? passValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'A senha é obrigatória';
    }
    if (value.length != value.replaceAll(' ', '').length) {
      return 'A senha não pode conter espaços';
    }
    if (value.length > 50) {
      return 'A senha não pode conter mais do que 50 caracteres';
    }
    if (value.length < 6) {
      return 'A senha deve conter ao menos 6 caracteres';
    }
    return null;
  }
}
