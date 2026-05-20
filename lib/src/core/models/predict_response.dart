// lib/src/core/models/predict_response.dart
class PredictionItem {
  final int index;
  final String label;
  final double score;

  PredictionItem({
    required this.index,
    required this.label,
    required this.score,
  });

  factory PredictionItem.fromJson(Map<String, dynamic> json) {
    return PredictionItem(
      index: _readInt(json['index']),
      label: json['label']?.toString() ?? '',
      score: _readDouble(json['score']),
    );
  }

  static int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _readDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class BreedDetailInfo {
  final Map<String, dynamic> raw;
  final int? index;
  final List<String> traits;
  final Map<String, dynamic>? care;

  BreedDetailInfo({
    required this.raw,
    this.index,
    this.traits = const [],
    this.care,
  });

  factory BreedDetailInfo.fromJson(Map<String, dynamic> json) {
    return BreedDetailInfo(
      raw: json,
      index: _readNullableInt(json['index']),
      traits: _readStringList(json['traits']),
      care: json['care'] is Map<String, dynamic>
          ? json['care'] as Map<String, dynamic>
          : null,
    );
  }

  static int? _readNullableInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}

class BreedDetail {
  final BreedDetailInfo? info;
  final List<String> images;

  BreedDetail({this.info, this.images = const []});

  factory BreedDetail.fromJson(Map<String, dynamic> json, {String? baseUrl}) {
    return BreedDetail(
      info: json['info'] is Map<String, dynamic>
          ? BreedDetailInfo.fromJson(json['info'] as Map<String, dynamic>)
          : null,
      images: _readStringList(json['images'], baseUrl: baseUrl),
    );
  }
}

class PredictResponse {
  final int logId;
  final bool recognized;
  final String? message;
  final Map<String, dynamic>? info;
  final PredictionItem top1;
  final List<PredictionItem> top5;
  final String? breed;
  final double? confidence;
  final List<PredictionItem> possibleBreeds;
  final BreedDetail? breedDetail;
  final String? modelDir;

  PredictResponse({
    required this.logId,
    required this.recognized,
    this.message,
    this.info,
    required this.top1,
    required this.top5,
    this.breed,
    this.confidence,
    this.possibleBreeds = const [],
    this.breedDetail,
    this.modelDir,
  });

  factory PredictResponse.fromJson(
    Map<String, dynamic> json, {
    String? baseUrl,
  }) {
    final top5 = _readPredictionList(json['top5']);
    final possibleBreeds = _readPredictionList(json['possible_breeds']);

    return PredictResponse(
      logId: _readInt(json['log_id']),
      recognized: json['recognized'] as bool? ?? true,
      message: _readNullableString(json['message']),
      info: json['info'] is Map<String, dynamic>
          ? json['info'] as Map<String, dynamic>
          : null,
      top1: json['top1'] is Map<String, dynamic>
          ? PredictionItem.fromJson(json['top1'] as Map<String, dynamic>)
          : PredictionItem(
              index: 0,
              label: json['breed']?.toString() ?? '',
              score: 0,
            ),
      top5: top5,
      breed: _readNullableString(json['breed']),
      confidence: _readNullableDouble(json['confidence']),
      possibleBreeds: possibleBreeds.isNotEmpty ? possibleBreeds : top5,
      breedDetail: json['breed_detail'] is Map<String, dynamic>
          ? BreedDetail.fromJson(
              json['breed_detail'] as Map<String, dynamic>,
              baseUrl: baseUrl,
            )
          : null,
      modelDir: _readNullableString(json['model_dir']),
    );
  }

  String? get displayName => _readNullableString(info?['display_name']);

  String? get canonicalLabel => _readNullableString(info?['canonical_label']);

  String? get description => _readNullableString(info?['description']);

  String? get basicCare => _readNullableString(info?['basic_care']);

  String? get feeding => _readNullableString(info?['feeding']);

  double get primaryConfidence => confidence ?? top1.score;

  static int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _readNullableDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static String? _readNullableString(Object? value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  static List<PredictionItem> _readPredictionList(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map<String, dynamic>>()
        .map(PredictionItem.fromJson)
        .toList(growable: false);
  }
}

List<String> _readStringList(Object? value, {String? baseUrl}) {
  if (value is! List) return const [];
  return value
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .map((item) => _resolveUrl(item, baseUrl))
      .toList(growable: false);
}

String _resolveUrl(String value, String? baseUrl) {
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  if (!value.startsWith('/') || baseUrl == null || baseUrl.isEmpty) {
    return value;
  }

  final normalizedBase = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;
  return '$normalizedBase$value';
}
