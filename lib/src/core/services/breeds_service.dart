import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_client.dart';
import '../models/breed_summary.dart';

class BreedsService {
  final Dio _dio;

  BreedsService() : _dio = ApiClient().dio;

  // lib/src/core/services/breeds_service.dart

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
            .map((e) => BreedSummary.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data is Map && data['items'] is List) {
        return (data['items'] as List)
            .map((e) => BreedSummary.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Formato de respuesta no esperado en /breeds/');
    } on DioException catch (e) {
      // ...
      rethrow;
    }
  }
}
