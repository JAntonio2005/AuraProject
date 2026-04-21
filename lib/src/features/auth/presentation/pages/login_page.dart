import 'package:flutter/material.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:aura_pet/src/widgets/slow_bg.dart'; // <-- fondo con paneo/crossfade
import 'package:aura_pet/src/core/routes/services/auth_service.dart';
import 'package:aura_pet/src/core/routes/app_destinations.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  final _authService = AuthService();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingresa tu correo';
    final emailRegex = RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'Formato de correo no válido';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingresa tu contraseña';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();

    setState(() => _loading = true);
    try {
      // 🧠 Llamamos a FastAPI via AuthService
      await _authService.login(email: email, password: password);

      if (!mounted) return;

      // Mensaje de éxito
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('¡Bienvenido! 😎')));

      // Aquí ya tienes el token guardado en secure storage.
      // Navega a tu pantalla principal (ajusta la ruta si usas otra):
      Navigator.pushReplacementNamed(context, AppDestinations.collection);
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo iniciar sesión: $msg')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onGuestContinue() async {
    setState(() => _loading = true);
    try {
      _authService.signInAsGuest();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingresaste como invitado')));
      Navigator.pushReplacementNamed(context, AppDestinations.collection);
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo iniciar como invitado: $msg')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < DesignTokens.compactWidth;
    final isWide = width >= DesignTokens.wideWidth;
    final horizontalPadding = isCompact
        ? DesignTokens.space16
        : DesignTokens.space24;
    final verticalPadding = isCompact
        ? DesignTokens.space12
        : DesignTokens.space20;
    final cardMaxWidth = isWide ? 560.0 : 460.0;
    final primaryCtaHeight = isCompact
        ? DesignTokens.buttonHeightCompact
        : DesignTokens.buttonHeightLarge;

    return Scaffold(
      extendBodyBehindAppBar: true, // para que el fondo cubra toda la pantalla
      body: Stack(
        children: [
          // ===== Fondo con paneo lento y atenuación =====
          const Positioned.fill(
            child: SlowBackground(
              images: [
                AssetImage('assets/images/bg_dogs.png'),
                // Puedes agregar más imágenes aquí para crossfade:
                // AssetImage('assets/images/bg_paws.png'),
              ],
              panDuration: Duration(seconds: 18),
              swapInterval: Duration(seconds: 22),
              dimOpacity: 0.26, // ajuste 0.22–0.32 según gusto
            ),
          ),

          // ===== Contenido =====
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardMaxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    verticalPadding,
                    horizontalPadding,
                    verticalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Inicia Sesión',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bienvenido a Aura',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: .7,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignTokens.space24),

                      Container(
                        padding: const EdgeInsets.all(DesignTokens.space16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.82,
                          ),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radius16,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.22,
                            ),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [
                                  AutofillHints.username,
                                  AutofillHints.email,
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Correo',
                                  hintText: 'holamundo@gmail.com',
                                  prefixIcon: Icon(Icons.alternate_email),
                                ),
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: DesignTokens.space12),
                              TextFormField(
                                controller: _passCtrl,
                                obscureText: _obscure,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _onSubmit(),
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    tooltip: _obscure ? 'Mostrar' : 'Ocultar',
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                              const SizedBox(height: DesignTokens.space8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      ForgotPasswordPage.routeName,
                                    );
                                  },
                                  child: const Text('Recuperar contraseña'),
                                ),
                              ),
                              const SizedBox(height: DesignTokens.space8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Accion principal',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: DesignTokens.space8),
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
                              const SizedBox(height: DesignTokens.space12),
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: OutlinedButton.icon(
                                  onPressed: _loading ? null : _onGuestContinue,
                                  icon: const Icon(Icons.person_outline),
                                  label: const Text('Entrar como invitado'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¿No tienes cuenta? ',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: const Text('¡Crea la tuya!'),
                                  ),
                                ],
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
        ],
      ),
    );
  }
}
