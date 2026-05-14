import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _resolveBaseUrl() {
  const envBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
  if (envBaseUrl.isNotEmpty) {
    return envBaseUrl;
  }

  if (kIsWeb) {
    return 'http://127.0.0.1:8000';
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'http://10.0.2.2:8000';
    default:
      return 'http://127.0.0.1:8000';
  }
}

class ApiClient {
  final Dio dio;
  ApiClient._(this.dio);

  static Future<ApiClient> create() async {
    final base = _resolveBaseUrl();

    final dio = Dio(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    return ApiClient._(dio);
  }
}
