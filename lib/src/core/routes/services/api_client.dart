// lib/src/core/services/api_client.dart
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String _resolveBaseUrl() {
  const envBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
  if (envBaseUrl.isNotEmpty) {
    return envBaseUrl;
  }

  return 'https://aura-ml-api-latest.onrender.com';
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
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(AuthInterceptor());

    // DEBUG: para estar 100% seguros
    // ignore: avoid_print
    print('[ApiClient] baseUrl = ${dio.options.baseUrl}');
  }
}
