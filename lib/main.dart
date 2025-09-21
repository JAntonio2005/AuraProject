import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/capture/presentation/pages/capture_page.dart';

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
      theme: AppTheme.light, // Tema M3 centralizado
      initialRoute: '/capture',           // TEMP: arrancar en Tomar Foto
      routes: {
        '/': (_) => const HomePage(),     // Home disponible
        '/capture': (_) => const CapturePage(), // Tomar Foto (mockup)
      },
    );
  }
}
