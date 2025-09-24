import 'package:flutter/material.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/login_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/register_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          const _DogsBackgroundPlaceholder(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/iconDog.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bienvenido',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'a',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Aura',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
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

                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/coleccion',
                                ); // usa la ruta literal que registraste
                              },
                              child: const Text('Ir a Colección'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

/// Helper para ocupar todo el espacio (equivalente a Positioned.fill)
class PositionedFill extends StatelessWidget {
  final Widget child;
  const PositionedFill({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, left: 0, right: 0, bottom: 0, child: child);
  }
}
