import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/k_spacers.dart';
import '../state/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authControllerProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/');
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryNavy,
              AppTheme.backgroundDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: KPadding.a24,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo e título
                    Text(
                      'CityLabSecurity',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    KSpacer.v8,
                    Text(
                      'Faça login para continuar',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    KSpacer.v48,

                    // Campo de e-mail
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(BootstrapIcons.envelope),
                        hintText: 'Seu email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu e-mail';
                        }
                        if (!value.contains('@')) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    KSpacer.v16,

                    // Campo de senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(BootstrapIcons.lock),
                        hintText: 'Sua senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? BootstrapIcons.eye_slash
                                : BootstrapIcons.eye,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'Senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    KSpacer.v8,

                    // Esqueci minha senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Recuperação de senha - Em desenvolvimento'),
                            ),
                          );
                        },
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),
                    KSpacer.v24,

                    // Botão Entrar
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleLogin,
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryNavy,
                                  ),
                                ),
                              )
                            : const Text('Entrar'),
                      ),
                    ),
                    KSpacer.v24,

                    // Divisor OU
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: KPadding.h16,
                          child: Text(
                            'OU',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    KSpacer.v24,

                    // Botão Google
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login com Google - Em desenvolvimento'),
                          ),
                        );
                      },
                      icon: const Icon(BootstrapIcons.google),
                      label: const Text('Logar com o Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    KSpacer.v48,

                    // Cadastre-se
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem uma conta? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cadastro - Em desenvolvimento'),
                              ),
                            );
                          },
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentCyan,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Mensagem de erro
                    if (authState.errorMessage != null) ...[
                      KSpacer.v16,
                      Container(
                        padding: KPadding.a16,
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(color: AppTheme.errorRed),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              BootstrapIcons.exclamation_triangle,
                              color: AppTheme.errorRed,
                            ),
                            KSpacer.h12,
                            Expanded(
                              child: Text(
                                authState.errorMessage!,
                                style: const TextStyle(color: AppTheme.errorRed),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
