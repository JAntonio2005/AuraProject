import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:aura_pet/src/core/routes/services/api_client.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/widgets/app_navigation_bar.dart';

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
  bool _isAuthenticated = false;
  String? _organization;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final dio = ApiClient().dio;
      final res = await dio.get('/auth/me');

      final data = res.data as Map<String, dynamic>;

      setState(() {
        _name = (data['full_name'] ?? '').toString().trim();
        _email = (data['email'] ?? '').toString().trim();
        _organization = (data['organization'] ?? 'Refugio Huellas Seguras')
            .toString()
            .trim();
        _isAuthenticated = true;
        _loading = false;
      });
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) {
        setState(() {
          _isAuthenticated = false;
          _loading = false;
        });
      } else {
        setState(() {
          _isAuthenticated = false;
          _loading = false;
        });
      }
    } catch (_) {
      setState(() {
        _isAuthenticated = false;
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
    final isCompact = width < 380;
    final isWide = width >= 900;
    final maxWidth = isWide ? 700.0 : 560.0;

    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_isAuthenticated) {
      // Usuario autenticado
      final name = _name?.isNotEmpty == true ? _name! : 'Usuario Aura';
      final email = _email?.isNotEmpty == true ? _email! : 'usuario@aura.app';
      final organization = _organization?.isNotEmpty == true
          ? _organization!
          : 'Refugio Huellas Seguras';

      body = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isCompact ? DesignTokens.space12 : DesignTokens.space16,
              DesignTokens.space24,
              isCompact ? DesignTokens.space12 : DesignTokens.space16,
              DesignTokens.space24,
            ),
            child: Column(
              children: [
                // Tarjeta de perfil
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(DesignTokens.radius18),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            child: Text(
                              _buildInitials(),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: DesignTokens.space16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.space4),
                                Text(
                                  email,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.space16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Organización de rescate:',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.space4),
                                Text(
                                  organization,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.space24),

                // Botones de acción
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Editar datos'),
                  ),
                ),
                const SizedBox(height: DesignTokens.space12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _showAbout,
                    child: const Text('Acerca de'),
                  ),
                ),
                const SizedBox(height: DesignTokens.space12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                      side: BorderSide(color: Colors.red.shade600),
                    ),
                    child: const Text('Cerrar sesión'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Usuario invitado
      body = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isCompact ? DesignTokens.space12 : DesignTokens.space16,
              DesignTokens.space24,
              isCompact ? DesignTokens.space12 : DesignTokens.space16,
              DesignTokens.space24,
            ),
            child: Column(
              children: [
                // Tarjeta de usuario invitado
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(DesignTokens.radius18),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            child: Icon(
                              Icons.person_outline,
                              size: 28,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: DesignTokens.space16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Usuario Invitado',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.space4),
                                Text(
                                  'invitado@aura.app',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.space16),
                      Container(
                        padding: const EdgeInsets.all(DesignTokens.space12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radius12,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: DesignTokens.space8),
                            Expanded(
                              child: Text(
                                'Estás navegando como invitado. Inicia sesión para acceder a todas las funciones.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.space24),

                // Botones de acción
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Iniciar sesión'),
                  ),
                ),
                const SizedBox(height: DesignTokens.space12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _showAbout,
                    child: const Text('Acerca de'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Perfil'),
      ),
      body: AppBackground(opacity: DesignTokens.surfaceOpacityLow, child: body),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 3),
    );
  }
}
