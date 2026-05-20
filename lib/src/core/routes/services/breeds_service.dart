import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_client.dart';
import '../../models/breed_summary.dart';

class BreedsService {
  final Dio _dio;

  BreedsService() : _dio = ApiClient().dio;

  Future<List<BreedSummary>> getAllBreeds() async {
    try {
      if (kDebugMode) {
        debugPrint('[BreedsService] Cargando lista de razas...');
      }

      final res = await _dio.get(
        '/breeds/',
        queryParameters: {
          'limit': 150, // 👈 pide más que 120 para que entren todas
          'offset': 0,
        },
      );

      final data = res.data;

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(
              (item) =>
                  BreedSummary.fromJson(item, baseUrl: _dio.options.baseUrl),
            )
            .toList();
      }

      if (data is Map && data['items'] is List) {
        return (data['items'] as List)
            .whereType<Map<String, dynamic>>()
            .map(
              (item) =>
                  BreedSummary.fromJson(item, baseUrl: _dio.options.baseUrl),
            )
            .toList();
      }

      throw Exception('Formato de respuesta no esperado en /breeds/');
    } on DioException {
      // ...
      rethrow;
    }
  }

  Future<BreedSummary> getBreedBySlug(String slug) async {
    try {
      final encodedSlug = Uri.encodeComponent(slug);
      final res = await _dio.get('/breeds/$encodedSlug');
      return _parseBreed(res.data, '/breeds/$slug');
    } on DioException {
      rethrow;
    }
  }

  Future<BreedSummary> getBreedByLabel(String label) async {
    try {
      final encodedLabel = Uri.encodeComponent(label);
      final res = await _dio.get('/breeds/by-label/$encodedLabel');
      return _parseBreed(res.data, '/breeds/by-label/$label');
    } on DioException {
      rethrow;
    }
  }

  BreedSummary _parseBreed(Object? data, String endpoint) {
    if (data is Map<String, dynamic>) {
      return BreedSummary.fromJson(data, baseUrl: _dio.options.baseUrl);
    }

    throw Exception('Formato de respuesta no esperado en $endpoint');
  }
}
