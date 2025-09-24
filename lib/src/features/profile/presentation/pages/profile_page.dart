import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 48,
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: t.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Usuario Aura',
                    style: t.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'usuario@aura.app',
                    style: t.textTheme.bodyMedium?.copyWith(
                      color: t.colorScheme.onSurface.withValues(alpha: .7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Datos (placeholders)
                  _Item(label: 'Nombre', value: 'Usuario Aura'),
                  _Item(label: 'Correo', value: 'usuario@aura.app'),
                  _Item(label: 'País', value: 'México'),

                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        // TODO: Cerrar sesión real
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sesión cerrada (demo)'),
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (_) => false,
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar sesión'),
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

class _Item extends StatelessWidget {
  final String label;
  final String value;
  const _Item({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: t.textTheme.labelLarge),
      subtitle: Text(value, style: t.textTheme.titleMedium),
      trailing: IconButton(
        onPressed: () {
          // TODO: Navegar a edición
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Editar $label (pendiente)')));
        },
        icon: const Icon(Icons.edit_outlined),
        tooltip: 'Editar',
      ),
    );
  }
}
