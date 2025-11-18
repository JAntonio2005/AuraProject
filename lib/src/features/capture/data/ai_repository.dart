import 'dart:io';
import 'package:dio/dio.dart';
import '../../result/data/models/breed_info.dart';
import '../../../core/network/api_client.dart';

class AiRepository {
  final ApiClient api;
  AiRepository(this.api);

  Future<BreedInfo> detectBreed(
    File imageFile, {
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final fileName = imageFile.uri.pathSegments.isNotEmpty
          ? imageFile.uri.pathSegments.last
          : 'upload.jpg';

      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final res = await api.dio.post(
        '/ai/detect',
        data: form,
        onSendProgress: onSendProgress, // para UI: progreso de subida
        cancelToken: cancelToken,
        options: Options(
          // Dio detecta multipart solo por FormData; esto es opcional.
          contentType: 'multipart/form-data',
          responseType: ResponseType.json,
        ),
      );

      // Seguridad: esperamos 200/201 y un objeto JSON
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        if (data is Map<String, dynamic>) {
          return BreedInfo.fromJson(data);
        } else {
          throw 'Formato inesperado. Se esperaba objeto JSON.';
        }
      }
      throw 'Respuesta HTTP ${res.statusCode}';
    } on DioException catch (e) {
      // Mensaje más claro para la UI
      final status = e.response?.statusCode;
      final body = e.response?.data;
      throw 'Error de red${status != null ? ' ($status)' : ''}: ${body ?? e.message}';
    } catch (e) {
      throw 'Error al procesar la imagen: $e';
    }
  }

  Future<List<BreedInfo>> getHistory() async {
    try {
      final res = await api.dio.get(
        '/ai/history',
        options: Options(responseType: ResponseType.json),
      );

      if (res.statusCode == 200) {
        final data = res.data;
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(BreedInfo.fromJson)
              .toList();
        } else {
          throw 'Formato inesperado. Se esperaba lista JSON.';
        }
      }
      throw 'Respuesta HTTP ${res.statusCode}';
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      throw 'Error de red${status != null ? ' ($status)' : ''}: ${body ?? e.message}';
    } catch (e) {
      throw 'Error al obtener historial: $e';
    }
  }
}
