class BreedSummary {
  final int id;
  final String name;
  final String slug;
  final String label;
  final String? description;
  final String? imageUrl;
  final String? temperament;
  final String? origin;
  final String? size;
  final String? lifeSpan;
  final List<String> images;

  BreedSummary({
    required this.id,
    required this.name,
    required this.slug,
    required this.label,
    this.description,
    this.imageUrl,
    this.temperament,
    this.origin,
    this.size,
    this.lifeSpan,
    this.images = const [],
  });

  factory BreedSummary.fromJson(Map<String, dynamic> json, {String? baseUrl}) {
    final images = _readStringList(json['images'], baseUrl: baseUrl);
    final explicitImageUrl = json['image_url']?.toString();

    return BreedSummary(
      id: _readInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      description: _readNullableString(json['description']),
      imageUrl: explicitImageUrl?.trim().isNotEmpty == true
          ? _resolveUrl(explicitImageUrl!, baseUrl)
          : images.isNotEmpty
          ? images.first
          : null,
      temperament: _readNullableString(json['temperament']),
      origin: _readNullableString(json['origin']),
      size: _readNullableString(json['size']),
      lifeSpan: _readNullableString(json['life_span']),
      images: images,
    );
  }

  static int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String? _readNullableString(Object? value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  static List<String> _readStringList(Object? value, {String? baseUrl}) {
    if (value is! List) return const [];
    return value
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty)
        .map((item) => _resolveUrl(item, baseUrl))
        .toList(growable: false);
  }

  static String _resolveUrl(String value, String? baseUrl) {
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
}
