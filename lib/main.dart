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

// Resultado IA
import 'package:aura_pet/src/features/result/presentation/pages/breed_detail_page.dart';

import 'package:aura_pet/src/features/capture/presentation/pages/capture_page.dart';

// TODO (siguiente paso): agregar import de la pantalla de cámara cuando confirmemos su ruta real.
// import 'package:aura_pet/src/features/tomar_foto/presentation/pages/tomar_foto_page.dart';
// import 'package:aura_pet/src/features/camera/presentation/pages/camera_page.dart';
// import 'package:aura_pet/src/features/take_photo/presentation/pages/take_photo_page.dart';

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

      home: const HomePage(),

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
        '/result': (_) => const BreedDetailPage(),

        // TODO (siguiente paso): registrar la ruta real de Tomar Foto
        '/capture': (_) => const CapturePage(),
        '/tomar-foto': (_) => const CapturePage(), // alias opcional
        // '/tomar-foto': (_) => const TomarFotoPage(),
        // '/take-photo': (_) => const TakePhotoPage(),
        // '/camera': (_) => const CameraPage(),
      },
    );
  }
}
