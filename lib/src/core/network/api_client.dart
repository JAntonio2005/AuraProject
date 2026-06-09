import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _defaultBaseUrl = 'https://aura-ml-api-rag-ollama.onrender.com';

String _resolveBaseUrl() {
  const envBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
  final configuredBaseUrl = envBaseUrl.trim();
  if (configuredBaseUrl.isNotEmpty) {
    return configuredBaseUrl;
  }

  return _defaultBaseUrl;
}

class ApiClient {
  final Dio dio;
  ApiClient._(this.dio);

  static Future<ApiClient> create() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: _resolveBaseUrl(),
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

    if (kDebugMode) {
      debugPrint('[ApiClient] baseUrl = ${dio.options.baseUrl}');
    }

    return ApiClient._(dio);
  }
}
