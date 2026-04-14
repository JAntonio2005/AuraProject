// lib/src/core/services/auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_client.dart'; // 👈 Ajusta la ruta si tu ApiClient está en otro lado

class UserModel {
  final String id;
  final String name;
  final bool isGuest;

  UserModel({required this.id, required this.name, this.isGuest = true});
}

class AuthService extends ChangeNotifier {
  final Dio _dio = ApiClient().dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserModel? _user;
  String? _accessToken;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null && !_user!.isGuest;
  bool get isGuest => _user?.isGuest ?? false;

  // ===========================
  //  G U E S T   L O G I N
  // ===========================
  void signInAsGuest({String name = "Invitado"}) {
    _user = UserModel(
      id: "mem_${DateTime.now().millisecondsSinceEpoch}",
      name: name,
      isGuest: true,
    );
    _accessToken = null;
    if (kDebugMode) {
      print('[AuthService] Sesión invitado creada');
    }
    notifyListeners();
  }

  // ===========================
  //  R E G I S T E R   /auth/register
  // ===========================
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final res = await _dio.post(
        '/auth/register',
        data: {'email': email, 'password': password, 'full_name': fullName},
      );

      if (kDebugMode) {
        print('[AuthService] Registro OK: ${res.statusCode}');
      }
      // si tu backend devuelve el usuario aquí puedes actualizar _user
    } on DioException catch (e) {
      if (kDebugMode) {
        print('[AuthService] Error al registrar: ${e.response?.data}');
      }
      throw Exception(_mapError(e));
    }
  }

  // ===========================
  //  L O G I N   /auth/login
  // ===========================
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          // 👇 igual que en tu Postman (x-www-form-urlencoded)
          'username': email,
          'password': password,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['access_token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('Respuesta inválida del servidor');
      }

      _accessToken = token;

      // Guardar token para que el interceptor lo use en /predict, etc.
      await _storage.write(key: 'access_token', value: token);

      // Usuario "básico" en memoria (puedes mejorarlo si tu backend devuelve más info)
      _user = UserModel(
        id: 'remote_user', // podrías poner el id real si lo devuelves
        name: email.split('@').first,
        isGuest: false,
      );

      if (kDebugMode) {
        print('[AuthService] Login OK, token guardado');
      }

      notifyListeners();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('[AuthService] Error al hacer login: ${e.response?.data}');
      }
      throw Exception(_mapError(e));
    }
  }

  // ===========================
  //  C A R G A R   S E S I Ó N
  //  (ej. al iniciar la app)
  // ===========================
  Future<void> loadSessionFromStorage() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      if (kDebugMode) {
        print('[AuthService] No había token guardado');
      }
      return;
    }

    _accessToken = token;

    // Si no tienes endpoint /users/me, al menos marca como logueado
    _user ??= UserModel(id: 'remote_user', name: 'Usuario', isGuest: false);

    if (kDebugMode) {
      print('[AuthService] Sesión restaurada desde storage');
    }
    notifyListeners();
  }

  // ===========================
  //  L O G O U T
  // ===========================
  Future<void> signOut() async {
    _user = null;
    _accessToken = null;
    await _storage.delete(key: 'access_token');
    if (kDebugMode) {
      print('[AuthService] Sesión cerrada');
    }
    notifyListeners();
  }

  // ===========================
  //  H E L P E R   E R R O R E S
  // ===========================
  String _mapError(DioException e) {
    final status = e.response?.statusCode;
    final detail = e.response?.data is Map
        ? (e.response?.data['detail']?.toString() ?? '')
        : '';

    if (status == 400 || status == 401) {
      return detail.isNotEmpty ? detail : 'Credenciales inválidas';
    }
    if (status == 409) {
      return detail.isNotEmpty ? detail : 'El usuario ya existe';
    }
    if (status == null) return 'Error de red (sin respuesta del servidor)';
    return 'Error de red ($status)';
  }
}
