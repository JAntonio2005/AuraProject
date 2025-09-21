import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/collection/presentation/pages/collection_page.dart';

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
      // TEMP: iniciamos en Colección para trabajar la UI post-login
      initialRoute: '/collection',
      routes: {
        '/': (_) => const HomePage(),            // Home (queda disponible)
        '/collection': (_) => const CollectionPage(), // Colección (ventana inicial post-login)
      },
    );
  }
}
