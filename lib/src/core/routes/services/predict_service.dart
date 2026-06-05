// lib/src/core/services/predict_service.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // 👈 para debugPrint y kDebugMode

import '../../models/predict_response.dart';
import 'api_client.dart';

class PredictService {
  final Dio _dio;

  PredictService() : _dio = ApiClient().dio;

  /// POST /predict con Bearer Token (se agrega solo por el interceptor)
  Future<PredictResponse> predict(File imageFile) async {
    final stopwatch = Stopwatch()..start();
    try {
      if (kDebugMode) {
        debugPrint('[PredictService] Iniciando /predict: ${imageFile.path}');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
      });

      final response = await _dio.post('/predict', data: formData);
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint(
          '[PredictService] /predict completado en '
          '${stopwatch.elapsedMilliseconds} ms | status ${response.statusCode}',
        );
        debugPrint('[PredictService] Respuesta /predict: ${response.data}');
      }

      return PredictResponse.fromJson(
        response.data as Map<String, dynamic>,
        baseUrl: _dio.options.baseUrl,
      );
    } on DioException catch (e) {
      stopwatch.stop();
      if (kDebugMode) {
        debugPrint(
          '[PredictService] /predict falló tras '
          '${stopwatch.elapsedMilliseconds} ms',
        );
        debugPrint('[PredictService] Dio error type: ${e.type}');
        debugPrint('[PredictService] Dio message: ${e.message}');
        debugPrint('[PredictService] Dio response: ${e.response?.data}');
        debugPrint('[PredictService] Dio url: ${e.requestOptions.uri}');
      }
      // 👇 En vez de solo el statusCode, devolvemos mensaje más útil
      throw Exception(_mapError(e));
    }
  }

  String _mapError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    String? detail;

    if (data is Map && data['detail'] != null) {
      detail = data['detail'].toString();
    }

    if (status == 401) {
      return detail ?? 'No autorizado. Vuelve a iniciar sesión.';
    }
    if (status == 413) {
      return 'La imagen es demasiado grande.';
    }
    if (status == null) {
      return 'No se pudo conectar con el servidor';
    }
    return detail ?? 'Error al predecir (HTTP $status)';
  }
}
