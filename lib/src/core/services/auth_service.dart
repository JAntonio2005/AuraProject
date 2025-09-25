// lib/src/core/services/auth_service.dart
import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String name;
  final bool isGuest;

  UserModel({required this.id, required this.name, this.isGuest = true});
}

class AuthService extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  // Crear sesión temporal en memoria
  void signInAsGuest({String name = "Invitado"}) {
    _user = UserModel(
      id: "mem_${DateTime.now().millisecondsSinceEpoch}",
      name: name,
      isGuest: true,
    );
    notifyListeners();
  }

  // Cerrar sesión
  void signOut() {
    _user = null;
    notifyListeners();
  }
}
