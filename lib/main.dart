import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/home/presentation/pages/home_page.dart';
// 👇 importa la nueva pantalla
import 'src/features/auth/presentation/pages/login_page.dart';
import 'src/features/auth/presentation/pages/register_page.dart';

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

      // 👇 muestra Login primero
      home: const HomePage(),

      // (opcional) deja registrada Home por si la navegas luego
      routes: {
        '/home': (_) => const HomePage(),
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
      },
    );
  }
}
