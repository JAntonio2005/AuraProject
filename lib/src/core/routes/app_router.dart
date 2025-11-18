// lib/src/core/routes/app_router.dart
import 'package:flutter/material.dart';
import '../../features/result/presentation/pages/breed_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/result':
        // La página leerá los argumentos con ModalRoute.of(context)
        return MaterialPageRoute(builder: (_) => const BreedDetailPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
