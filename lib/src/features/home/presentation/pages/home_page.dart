import 'package:flutter/material.dart';
import 'package:aura_pet/src/core/routes/app_destinations.dart';
import 'package:aura_pet/src/core/routes/services/auth_service.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/login_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/register_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 380;
    final horizontalPadding = isCompact ? 20.0 : 28.0;
    final contentMaxWidth = size.width >= 700 ? 430.0 : double.infinity;
    final heroImageSize = isCompact ? 118.0 : 148.0;
    final primaryCtaHeight = isCompact ? 48.0 : 54.0;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primary.withValues(alpha: 0.14),
              const Color(0xFFF8FBF7),
              cs.secondary.withValues(alpha: 0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/images/bg_paws.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: DesignTokens.space24,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: contentMaxWidth,
                          minHeight:
                              constraints.maxHeight - DesignTokens.space24 * 2,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/iconDog.png',
                              width: heroImageSize,
                              height: heroImageSize,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: isCompact ? 18 : 24),
                            Text(
                              'Bienvenido',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                              ),
                            ),
                            Text(
                              'a Aura',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Explora razas, comunidad y Cámara con una experiencia simple y cercana.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.72),
                                height: 1.35,
                              ),
                            ),
                            SizedBox(height: isCompact ? 28 : 38),
                            SizedBox(
                              width: double.infinity,
                              height: primaryCtaHeight,
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    LoginPage.routeName,
                                  );
                                },
                                child: const Text('Iniciar sesión'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: isCompact ? 46 : 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RegisterPage.routeName,
                                  );
                                },
                                child: const Text('Registrarse'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: isCompact ? 46 : 50,
                              child: TextButton.icon(
                                onPressed: () {
                                  AuthService().signInAsGuest();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ingresaste como invitado'),
                                    ),
                                  );
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppDestinations.collection,
                                  );
                                },
                                icon: const Icon(Icons.person_outline),
                                label: const Text('Entrar como invitado'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
