import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:aura_pet/src/core/routes/services/api_client.dart';
import 'package:aura_pet/src/widgets/app_background.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = true;
  String? _name;
  String? _email;
  String? _error;

  final int _navIndex = 4; // 👈 Perfil

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _onTapNav(int i) {
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/collection');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/capture');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/community');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 4:
        // ya estamos en Perfil
        break;
    }
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final dio = ApiClient().dio;
      final res = await dio.get('/auth/me');

      final data = res.data as Map<String, dynamic>;

      setState(() {
        _name = (data['full_name'] ?? '').toString().trim();
        _email = (data['email'] ?? '').toString().trim();
        _loading = false;
      });
    } on DioException catch (e) {
      String message = 'No se pudo cargar tu perfil';

      final status = e.response?.statusCode;
      if (status == 401) {
        message = 'Sesión expirada. Inicia sesión de nuevo.';
      }

      setState(() {
        _error = message;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = 'Error inesperado al cargar tu perfil';
        _loading = false;
      });
    }
  }

  String _buildInitials() {
    final n = _name ?? _email ?? '';
    if (n.isEmpty) return '?';
    final parts = n.split(' ');
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // 🔹 Diálogo "Acerca de"
  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Aura Pet',
      applicationVersion: '1.0.2',
      applicationIcon: Image.asset(
        'assets/images/iconDog.png',
        width: 48,
        height: 48,
      ),
      children: const [
        SizedBox(height: 8),
        Text(
          'Aura Pet es una aplicación creada como proyecto escolar para '
          'identificar razas de perros usando inteligencia artificial y una '
          'colección de 120 razas.\n\n'
          'Desarrollada como parte de la experiencia educativa de Diseño de Software '
          'en la Universidad Veracruzana, región Córdoba–Orizaba, en la Facultad de '
          'Negocios y Tecnologías, programa educativo de Ingeniería de Software.\n\n'
          'Desarrollada por los estudiantes José Antonio Ortiz Hernández y '
          'José Ricardo Rojas Trujillo.\n\n'
          'Bajo la asesoría del Dr. Adolfo Centeno Téllez.\n\n'
          'Esta versión es únicamente para fines académicos y de demostración.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadProfile,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else {
      final name = _name?.isNotEmpty == true ? _name! : 'Usuario Aura';
      final email = _email?.isNotEmpty == true ? _email! : 'usuario@aura.app';

      body = SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 46,
              child: Text(
                _buildInitials(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Nombre (solo lectura)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nombre',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              child: Text(name),
            ),
            const SizedBox(height: 16),

            // Correo (solo lectura)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Correo',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              child: Text(email),
            ),

            const SizedBox(height: 32),

            // 🔹 Sección "Acerca de"
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Acerca de',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAbout,
                icon: const Icon(Icons.info_outline),
                label: const Text('Acerca de Aura Pet'),
              ),
            ),

            const SizedBox(height: 16),
            // Aquí luego podrías meter un botón de Cerrar sesión, por ejemplo
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 👈 SIN flecha de back
        title: const Text('Mi perfil'),
      ),
      body: AppBackground(opacity: 0.04, child: body),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _onTapNav,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Razas',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_camera_outlined),
            selectedIcon: Icon(Icons.photo_camera),
            label: 'Cámara',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Comunidad',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
