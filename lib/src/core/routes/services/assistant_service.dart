import 'package:dio/dio.dart';

import '../../models/assistant_request.dart';
import '../../models/assistant_response.dart';
import 'api_client.dart';

class AssistantService {
  final Dio _dio;

  AssistantService({Dio? dio}) : _dio = dio ?? ApiClient().dio;

  Future<AssistantResponse> sendMessage(AssistantRequest request) async {
    try {
      final response = await _dio.post('/assistant', data: request.toJson());
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return AssistantResponse.fromJson(data);
      }

      throw const FormatException('Formato inesperado en /assistant');
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  String _mapError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    if (status == null) {
      return 'No pude conectar con Aura Assistant. Revisa tu conexion e intentalo de nuevo.';
    }
    if (status >= 500) {
      return 'Aura Assistant no esta disponible por el momento. Intentalo de nuevo en unos minutos.';
    }
    return 'No pude enviar tu mensaje. Intentalo de nuevo.';
  }
}
