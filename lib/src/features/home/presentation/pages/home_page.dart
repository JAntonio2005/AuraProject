import 'package:flutter/material.dart';
import 'package:aura_pet/src/core/routes/app_destinations.dart';
import 'package:aura_pet/src/core/routes/services/auth_service.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/login_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/register_page.dart';
import 'package:aura_pet/src/widgets/app_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < DesignTokens.compactWidth;
    final isWide = width >= DesignTokens.wideWidth;
    final horizontalPadding = isCompact
        ? DesignTokens.space16
        : DesignTokens.space24;
    final verticalPadding = isCompact
        ? DesignTokens.space16
        : DesignTokens.space24;
    final heroImageSize = isCompact ? 140.0 : 180.0;
    final cardMaxWidth = isWide ? 560.0 : 420.0;
    final primaryCtaHeight = isCompact
        ? DesignTokens.buttonHeightCompact
        : DesignTokens.buttonHeightLarge;

    return Scaffold(
      body: AppBackground(
        opacity: DesignTokens.surfaceOpacityLow,
        child: Stack(
          children: [
            const _DogsBackgroundPlaceholder(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    verticalPadding,
                    horizontalPadding,
                    verticalPadding,
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    padding: const EdgeInsets.all(DesignTokens.space16),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radius16,
                      ),
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
                        const SizedBox(height: DesignTokens.space16),
                        Text(
                          'Bienvenido',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'a',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Aura',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: DesignTokens.space24),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isCompact ? 280 : 320,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Accion principal',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(height: 6),
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
                              const SizedBox(height: 8),
                              Text(
                                'o',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: isCompact ? 44 : 48,
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
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  onPressed: () {
                                    AuthService().signInAsGuest();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Ingresaste como invitado',
                                        ),
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
                              const SizedBox(height: DesignTokens.space8),
                              Text(
                                'Explora razas, comunidad y Cámara con una experiencia unificada.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 16),
                            ],
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
      ),
    );
  }
}

class _DogsBackgroundPlaceholder extends StatelessWidget {
  const _DogsBackgroundPlaceholder();

  @override
  Widget build(BuildContext context) {
    return PositionedFill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}

class PositionedFill extends StatelessWidget {
  final Widget child;

  const PositionedFill({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, left: 0, right: 0, bottom: 0, child: child);
  }
}
