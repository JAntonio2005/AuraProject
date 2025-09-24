import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/home/presentation/pages/home_page.dart';

// Auth
import 'package:aura_pet/src/features/auth/presentation/pages/login_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/register_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/new_password_page.dart';

// Colección
import 'package:aura_pet/src/features/collection/presentation/pages/collection_page.dart';

// Resultado IA (rama de tu compa)
import 'package:aura_pet/src/features/result/presentation/pages/breed_detail_page.dart';

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

        // Auth
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        ForgotPasswordPage.routeName: (_) => const ForgotPasswordPage(),
        NewPasswordPage.routeName: (_) => const NewPasswordPage(),

        // Colección (alias en español y la original por si la usan)
        '/coleccion': (_) => const CollectionPage(),
        '/collection': (_) => const CollectionPage(),

        // Resultado IA
        // Si BreedDetailPage trae static routeName, puedes agregarlo también;
        // por ahora dejamos una ruta literal estable:
        '/result': (_) => const BreedDetailPage(),
      },
    );
  }
}
