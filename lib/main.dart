import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/home/presentation/pages/home_page.dart';

// Rutas de auth (import por paquete)
import 'package:aura_pet/src/features/auth/presentation/pages/login_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/register_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/new_password_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      // Home por defecto
      home: const HomePage(),

      // Rutas registradas
      routes: {
        '/home': (_) => const HomePage(),
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        ForgotPasswordPage.routeName: (_) => const ForgotPasswordPage(),
        NewPasswordPage.routeName: (_) => const NewPasswordPage(),
      },
    );
  }
}
