class BreedSummary {
  final int id;
  final String name;
  final String slug;
  final String label; // ej: n02098413-lhasa
  final String? description;
  final String? imageUrl;

  BreedSummary({
    required this.id,
    required this.name,
    required this.slug,
    required this.label,
    this.description,
    this.imageUrl,
  });

  factory BreedSummary.fromJson(Map<String, dynamic> json) {
    return BreedSummary(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
