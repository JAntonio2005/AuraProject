// lib/src/core/models/prediction_history_item.dart

/// Representa un registro del historial de predicciones o búsquedas.
///
/// OJO: Ajusta las keys del fromJson según te responda tu API.
/// Revisa en Swagger / Postman qué campos vienen realmente.
class PredictionHistoryItem {
  final String id;
  final String title; // nombre “bonito” de la raza
  final String? imageName; // nombre de la imagen en el servidor
  final double? confidence; // porcentaje de confianza 0–100
  final DateTime? createdAt;

  const PredictionHistoryItem({
    required this.id,
    required this.title,
    this.imageName,
    this.confidence,
    this.createdAt,
  });

  // Convierte "n02110958-pug" -> "Pug"
  static String _parseBreedName(String raw) {
    if (raw.isEmpty) return 'Sin título';

    // nos quedamos con la parte después del guion
    final parts = raw.split('-');
    final labelPart = parts.length > 1 ? parts.sublist(1).join('-') : raw;

    // reemplazar guiones bajos por espacios y capitalizar
    final clean = labelPart.replaceAll('_', ' ');
    return clean
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  factory PredictionHistoryItem.fromJson(Map<String, dynamic> json) {
    final rawLabel = json['top1_label']?.toString() ?? '';

    return PredictionHistoryItem(
      id: json['id']?.toString() ?? json['log_id']?.toString() ?? '',
      title: _parseBreedName(rawLabel), // 👈 AQUÍ
      imageName: json['image_name']?.toString(),
      confidence:
          json['top1_score'] !=
              null // 👈 score -> %
          ? (double.tryParse(json['top1_score'].toString()) ?? 0) * 100
          : null,
      // created_at viene sin zona horaria; por ahora lo parseamos directo
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (imageName != null) 'image_name': imageName,
      if (confidence != null) 'top1_score': confidence! / 100,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
