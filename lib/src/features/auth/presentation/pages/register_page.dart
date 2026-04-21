import 'package:flutter/material.dart';
import 'package:aura_pet/src/core/routes/services/auth_service.dart'; // 👈 IMPORTANTE
import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  final _authService = AuthService();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingresa tu correo';
    final emailRegex = RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'Formato de correo no válido';
    return null;
  }

  String? _validateUser(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingresa tu nombre de usuario';
    if (value.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  String? _validatePass(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingresa tu contraseña';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _validateConfirm(String? v) {
    final value = (v ?? '').trim();
    if (value != _passCtrl.text.trim()) return 'Las contraseñas no coinciden';
    return null;
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailCtrl.text.trim();
    final fullName = _userCtrl.text.trim();
    final password = _passCtrl.text.trim();

    setState(() => _loading = true);
    try {
      await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo registrar: $msg')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 380;
    final isWide = width >= 900;
    final horizontalPadding = isCompact ? 16.0 : 24.0;
    final cardMaxWidth = isWide ? 560.0 : 460.0;
    final primaryCtaHeight = isCompact ? 46.0 : 52.0;

    return Scaffold(
      body: AppBackground(
        opacity: DesignTokens.surfaceOpacityLow,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardMaxWidth),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  16,
                ),
                child: Container(
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(DesignTokens.radius16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Crear cuenta',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Completa tus datos para crear tu cuenta.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                            hintText: 'holamundo@gmail.com',
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _userCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de usuario',
                            hintText: 'pepito piernas largas',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: _validateUser,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure1,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure1 = !_obscure1),
                              icon: Icon(
                                _obscure1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: _validatePass,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confCtrl,
                          obscureText: _obscure2,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onSubmit(),
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            prefixIcon: const Icon(Icons.lock_reset),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure2 = !_obscure2),
                              icon: Icon(
                                _obscure2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: _validateConfirm,
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Accion principal',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          height: primaryCtaHeight,
                          child: FilledButton(
                            onPressed: _loading ? null : _onSubmit,
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Continuar'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes cuenta? ',
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                              child: const Text('¡Inicia Sesión!'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
