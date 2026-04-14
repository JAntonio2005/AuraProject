// lib/src/core/routes/services/history_service.dart

import 'package:dio/dio.dart';

import 'package:aura_pet/src/core/routes/services/api_client.dart';
import 'package:aura_pet/src/core/models/prediction_history_item.dart';

class HistoryService {
  final Dio _dio;

  HistoryService({Dio? dio}) : _dio = dio ?? ApiClient().dio;

  /// Historial de PREDICCIONES del usuario logueado
  Future<List<PredictionHistoryItem>> getMyPredictionHistory() async {
    // Endpoint real según tu Swagger
    final res = await _dio.get('/history/predictions');

    final data = res.data;

    if (data is List) {
      print('⚡ history[0] = ${data[0]}');
      return data
          .map((e) => PredictionHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (data is Map<String, dynamic> && data['results'] is List) {
      final results = data['results'] as List;
      if (results.isNotEmpty) {
        print('⚡ history[0] = ${results[0]}');
      }
      return results
          .map((e) => PredictionHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  /// Historial de BÚSQUEDAS de razas (si lo quieres usar después)
  Future<List<PredictionHistoryItem>> getMySearchHistory() async {
    final res = await _dio.get('/history/searches');

    final data = res.data;

    if (data is List) {
      return data
          .map((e) => PredictionHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (data is Map<String, dynamic> && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => PredictionHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  /// 👇 NUEVO: registrar búsquedas
  // 👇 NUEVO: registrar búsqueda
  Future<void> logSearch({String? query, String? breedLabel}) async {
    try {
      final body = <String, dynamic>{};
      if (query != null && query.isNotEmpty) {
        body['query'] = query;
      }
      if (breedLabel != null && breedLabel.isNotEmpty) {
        body['breed_label'] = breedLabel;
      }

      if (body.isEmpty) return;

      print('[HistoryService] Enviando búsqueda: $body');
      await _dio.post('/history/searches', data: body);
      print('[HistoryService] Búsqueda registrada OK');
    } catch (e) {
      print('[HistoryService] Error al registrar búsqueda: $e');
    }
  }

  // opcional: para después, leer /history/searches
  // Future<List<SearchHistoryItem>> getMySearchHistory() async { ... }
}
