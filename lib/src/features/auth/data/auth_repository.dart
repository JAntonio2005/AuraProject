import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient api;
  AuthRepository(this.api);

  Future<void> login(String email, String password) async {
    final res = await api.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final token = res.data['token'] as String;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> register(String email, String password, String username) async {
    await api.dio.post(
      '/auth/register',
      data: {'email': email, 'password': password, 'username': username},
    );
  }

  Future<void> requestPasswordReset(String email) async {
    await api.dio.post('/auth/password/reset/request', data: {'email': email});
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    await api.dio.post(
      '/auth/password/reset/confirm',
      data: {'code': code, 'newPassword': newPassword},
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
