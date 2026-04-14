import 'package:flutter/material.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/routes/app_router.dart';
import 'src/core/routes/app_destinations.dart';
import 'src/features/home/presentation/pages/home_page.dart';

import 'package:aura_pet/src/features/auth/presentation/pages/login_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/register_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:aura_pet/src/features/auth/presentation/pages/new_password_page.dart';

import 'package:aura_pet/src/features/collection/presentation/pages/collection_page.dart';
import 'package:aura_pet/src/features/result/presentation/pages/breed_detail_page.dart';

import 'package:aura_pet/src/features/capture/presentation/pages/capture_page.dart';

import 'package:aura_pet/src/features/result/presentation/pages/prediction_detail_page.dart';

// import 'package:aura_pet/src/features/camera/presentation/pages/camera_page.dart';

import 'package:aura_pet/src/features/history/presentation/pages/history_page.dart';
import 'package:aura_pet/src/features/profile/presentation/pages/profile_page.dart';
import 'package:aura_pet/src/features/community/presentation/pages/community_page.dart';

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

      // Arranca en la pantalla de bienvenida (HomePage con botones)
      home: const HomePage(),
      onGenerateRoute: AppRouter.onGenerateRoute,

      routes: {
        AppDestinations.home: (context) => const HomePage(),

        // Auth
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
        NewPasswordPage.routeName: (context) => const NewPasswordPage(),
        PredictionDetailPage.routeName: (_) => const PredictionDetailPage(),
        // Colección
        AppDestinations.collection: (context) => const CollectionPage(),
        '/coleccion': (context) => const CollectionPage(),

        // Cámara / Captura
        AppDestinations.capture: (context) => const CapturePage(),
        '/tomar-foto': (context) => const CapturePage(),

        // Resultado IA
        '/result': (context) => const BreedDetailPage(),

        // Perfil
        AppDestinations.profile: (context) => const ProfilePage(),
        '/perfil': (context) => const ProfilePage(),

        // Historial
        AppDestinations.history: (context) => const HistoryPage(),
        '/historial': (context) => const HistoryPage(),

        // Comunidad
        AppDestinations.community: (context) => const CommunityPage(),
      },
    );
  }
}
