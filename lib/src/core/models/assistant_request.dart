class AssistantRequest {
  final String message;
  final String? intent;
  final String? breed;
  final Map<String, dynamic>? dogContext;
  final String language;
  final bool includeDisclaimer;

  const AssistantRequest({
    required this.message,
    this.intent,
    this.breed,
    this.dogContext,
    this.language = 'es',
    this.includeDisclaimer = true,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'message': message,
      'language': language,
      'include_disclaimer': includeDisclaimer,
    };

    if (intent != null && intent!.trim().isNotEmpty) {
      json['intent'] = intent;
    }
    if (breed != null && breed!.trim().isNotEmpty) {
      json['breed'] = breed;
    }
    if (dogContext != null && dogContext!.isNotEmpty) {
      json['dog_context'] = dogContext;
    }

    return json;
  }
}
