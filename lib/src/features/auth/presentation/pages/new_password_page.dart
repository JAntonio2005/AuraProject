import 'package:flutter/material.dart';
import 'package:aura_pet/src/core/routes/services/auth_service.dart';
import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';

class NewPasswordPage extends StatefulWidget {
  static const routeName = '/new-password';
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confCtrl = TextEditingController();

  bool _hasExternalCode = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;
  final _authService = AuthService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty && !_hasExternalCode) {
      _codeCtrl.text = args;
      _hasExternalCode = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  String? _validateCode(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingresa el código de verificación';
    return null;
  }

  String? _validatePass(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingresa tu nueva contraseña';
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

    final code = _codeCtrl.text.trim();
    final newPassword = _passCtrl.text.trim();

    setState(() => _loading = true);
    try {
      await _authService.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo actualizar: $msg')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 380;
    final isWide = width >= 900;
    final maxWidth = isWide ? 560.0 : 460.0;
    final horizontalPad = isCompact ? 16.0 : 24.0;
    final ctaHeight = isCompact ? 46.0 : 52.0;
    return Scaffold(
      body: AppBackground(
        opacity: DesignTokens.surfaceOpacityLow,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPad,
                  16,
                  horizontalPad,
                  16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cambia tu contraseña',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ingresa tu nueva contraseña',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: .75,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.space16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radius16,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_hasExternalCode) ...[
                              TextFormField(
                                controller: _codeCtrl,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Código de verificación',
                                  hintText: 'XXXXXXX',
                                  prefixIcon: Icon(Icons.verified_outlined),
                                ),
                                validator: _validateCode,
                              ),
                              const SizedBox(height: 12),
                            ],
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscure1,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Nueva contraseña',
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
                            SizedBox(
                              width: double.infinity,
                              height: ctaHeight,
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
                                    : const Text('Guardar'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Volver'),
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
      ),
    );
  }
}
