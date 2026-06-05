class AssistantBreed {
  final String? label;
  final String? name;

  const AssistantBreed({this.label, this.name});

  factory AssistantBreed.fromJson(Map<String, dynamic> json) {
    return AssistantBreed(
      label: _readNullableString(json['label']),
      name: _readNullableString(json['name']),
    );
  }
}

class AssistantResponse {
  final String answer;
  final String? intent;
  final AssistantBreed? breed;
  final String? safetyLevel;
  final String? disclaimer;
  final bool recommendVet;
  final List<String> sources;
  final List<String> suggestedFollowups;

  const AssistantResponse({
    required this.answer,
    this.intent,
    this.breed,
    this.safetyLevel,
    this.disclaimer,
    this.recommendVet = false,
    this.sources = const [],
    this.suggestedFollowups = const [],
  });

  factory AssistantResponse.fromJson(Map<String, dynamic> json) {
    return AssistantResponse(
      answer: _readNullableString(json['answer']) ?? '',
      intent: _readNullableString(json['intent']),
      breed: json['breed'] is Map<String, dynamic>
          ? AssistantBreed.fromJson(json['breed'] as Map<String, dynamic>)
          : null,
      safetyLevel: _readNullableString(json['safety_level']),
      disclaimer: _readNullableString(json['disclaimer']),
      recommendVet: _readBool(json['recommend_vet']),
      sources: _readStringList(json['sources']),
      suggestedFollowups: _readStringList(json['suggested_followups']),
    );
  }
}

String? _readNullableString(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

bool _readBool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }
  return false;
}

List<String> _readStringList(Object? value) {
  if (value is! List) return const [];
  return value
      .map(_readNullableString)
      .whereType<String>()
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}
