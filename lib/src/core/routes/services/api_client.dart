// lib/src/core/services/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _defaultBaseUrl = 'https://aura-ml-api-rag-ollama.onrender.com';

String _resolveBaseUrl() {
  const envBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
  final configuredBaseUrl = envBaseUrl.trim();
  if (configuredBaseUrl.isNotEmpty) {
    return configuredBaseUrl;
  }

  return _defaultBaseUrl;
}

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'access_token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: _resolveBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 90),
      ),
    );

    dio.interceptors.add(AuthInterceptor());

    if (kDebugMode) {
      debugPrint('[ApiClient] baseUrl = ${dio.options.baseUrl}');
    }
  }
}
