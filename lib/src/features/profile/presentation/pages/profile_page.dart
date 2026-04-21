import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:aura_pet/src/core/routes/services/api_client.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/widgets/app_navigation_bar.dart';
import 'package:aura_pet/src/widgets/state_panels.dart';

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

  @override
  void initState() {
    super.initState();
    _loadProfile();
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
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < DesignTokens.compactWidth;
    final isWide = width >= DesignTokens.wideWidth;
    final maxWidth = isWide ? 700.0 : 560.0;
    final horizontalPadding = isCompact
        ? DesignTokens.space12
        : DesignTokens.space16;
    final avatarRadius = isCompact ? 38.0 : 46.0;

    Widget body;
    if (_loading) {
      body = StatePanels.loading();
    } else if (_error != null) {
      body = StatePanels.error(
        context: context,
        message: _error!,
        onRetry: _loadProfile,
      );
    } else {
      final name = _name?.isNotEmpty == true ? _name! : 'Usuario Aura';
      final email = _email?.isNotEmpty == true ? _email! : 'usuario@aura.app';

      body = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              DesignTokens.space24,
              horizontalPadding,
              DesignTokens.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: avatarRadius,
                  child: Text(
                    _buildInitials(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.space16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Accion principal',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.space4),

                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: DesignTokens.space4),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: DesignTokens.space32),

                // Nombre (solo lectura)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DesignTokens.space12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(DesignTokens.radius16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radius12,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: Text(name),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.space16),

                // Correo (solo lectura)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DesignTokens.space12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(DesignTokens.radius16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Correo',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radius12,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: Text(email),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: DesignTokens.space32),

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
                const SizedBox(height: DesignTokens.space8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _showAbout,
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Acerca de Aura Pet'),
                  ),
                ),

                const SizedBox(height: DesignTokens.space16),
                // Aquí luego podrías meter un botón de Cerrar sesión, por ejemplo
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 👈 SIN flecha de back
        title: const Text('Mi perfil'),
      ),
      body: AppBackground(opacity: DesignTokens.surfaceOpacityLow, child: body),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 4),
    );
  }
}
