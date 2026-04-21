class BreedInfo {
  final String id;
  final String name;
  final String description;
  final List<String> images; // máx. 6 URLs
  final double? confidence; // 0..1 opcional

  BreedInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    this.confidence,
  });

  factory BreedInfo.fromJson(Map<String, dynamic> j) {
    // Tolerancia por si tu backend cambia a snake_case
    final rawImages = j['images'] ?? j['gallery'] ?? j['imgs'] ?? [];

    List<String> imgs;
    if (rawImages is List) {
      imgs = rawImages.map((e) => e.toString()).toList();
    } else {
      imgs = const [];
    }

    // Limitar a 6 por el requerimiento de UI
    if (imgs.length > 6) imgs = imgs.take(6).toList();

    final conf = j['confidence'] ?? j['score'] ?? j['probability'];

    return BreedInfo(
      id: (j['id'] ?? '').toString(),
      name: (j['name'] ?? j['breed'] ?? '').toString(),
      description: (j['description'] ?? j['desc'] ?? '').toString(),
      images: imgs,
      confidence: conf == null ? null : double.tryParse(conf.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'images': images,
    if (confidence != null) 'confidence': confidence,
  };
}
