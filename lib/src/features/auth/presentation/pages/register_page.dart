import 'package:flutter/material.dart';

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

    setState(() => _loading = true);
    try {
      // TODO: sustituir por tu lógica real de registro (API/Firebase/etc.)
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada correctamente')),
      );

      // Ejemplo de navegación después de registrar:
      // Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo registrar: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Registrar',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Correo
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                            hintText: 'holomundo@gmail.com',
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 12),

                        // Nombre de usuario
                        TextFormField(
                          controller: _userCtrl,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          decoration: const InputDecoration(
                            labelText: 'Nombre de usuario',
                            hintText: 'pepito piernas largas',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: _validateUser,
                        ),
                        const SizedBox(height: 12),

                        // Contraseña
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure1,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed:
                                  () => setState(() => _obscure1 = !_obscure1),
                              icon: Icon(
                                _obscure1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              tooltip: _obscure1 ? 'Mostrar' : 'Ocultar',
                            ),
                          ),
                          validator: _validatePass,
                        ),
                        const SizedBox(height: 12),

                        // Confirmar contraseña
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
                              onPressed:
                                  () => setState(() => _obscure2 = !_obscure2),
                              icon: Icon(
                                _obscure2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              tooltip: _obscure2 ? 'Mostrar' : 'Ocultar',
                            ),
                          ),
                          validator: _validateConfirm,
                        ),
                        const SizedBox(height: 16),

                        // Botón Continuar
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: _loading ? null : _onSubmit,
                            child:
                                _loading
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

                        // ¿Ya tienes cuenta? ¡Inicia Sesión!
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes cuenta? ',
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/login',
                                ); // sin importar LoginPage
                              },
                              child: const Text('¡Inicia Sesión!'),
                            ),
                          ],
                        ),
                      ],
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
