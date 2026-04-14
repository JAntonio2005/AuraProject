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
      index: json['index'] as int,
      label: json['label'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }
}

class PredictResponse {
  final int logId;
  final PredictionItem top1;
  final List<PredictionItem> top5;

  PredictResponse({
    required this.logId,
    required this.top1,
    required this.top5,
  });

  factory PredictResponse.fromJson(Map<String, dynamic> json) {
    return PredictResponse(
      logId: json['log_id'] as int,
      top1: PredictionItem.fromJson(json['top1'] as Map<String, dynamic>),
      top5: (json['top5'] as List<dynamic>)
          .map((e) => PredictionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
