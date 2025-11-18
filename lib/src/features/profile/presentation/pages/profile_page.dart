import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:aura_pet/src/core/services/api_client.dart';
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
            // Aquí luego podrías meter un botón de Cerrar sesión, por ejemplo
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: AppBackground(opacity: 0.04, child: body),
    );
  }
}
