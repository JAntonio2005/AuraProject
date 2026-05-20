import 'package:flutter/material.dart';
import 'package:aura_pet/src/core/models/breed_summary.dart';
import 'package:aura_pet/src/core/routes/services/breeds_service.dart';

class BreedDetailArgs {
  final String id;
  final String name;
  final String? slug;
  final String? label;
  final String? description;
  final String? imageUrl;
  final List<String> images;
  final String? temperament;
  final String? origin;
  final String? size;
  final String? lifeSpan;
  final double? confidence;

  const BreedDetailArgs({
    required this.id,
    required this.name,
    this.slug,
    this.label,
    this.description,
    this.imageUrl,
    this.images = const [],
    this.temperament,
    this.origin,
    this.size,
    this.lifeSpan,
    this.confidence,
  });

  factory BreedDetailArgs.fromBreed(BreedSummary breed) {
    return BreedDetailArgs(
      id: breed.id.toString(),
      name: breed.name,
      slug: breed.slug,
      label: breed.label,
      description: breed.description,
      imageUrl: breed.imageUrl,
      images: breed.images,
      temperament: breed.temperament,
      origin: breed.origin,
      size: breed.size,
      lifeSpan: breed.lifeSpan,
    );
  }
}

class BreedDetailPage extends StatefulWidget {
  static const routeName = '/result';

  const BreedDetailPage({super.key});

  @override
  State<BreedDetailPage> createState() => _BreedDetailPageState();
}

class _BreedDetailPageState extends State<BreedDetailPage> {
  final _breedsService = BreedsService();

  BreedDetailArgs? _initialArgs;
  BreedSummary? _detail;
  bool _loadingDetail = false;
  String? _loadMessage;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    final args = _getArgs(context);
    _initialArgs = args;
    _detail = _breedFromArgs(args);
    _loadBackendDetail(args);
  }

  BreedDetailArgs _getArgs(BuildContext context) {
    final raw = ModalRoute.of(context)?.settings.arguments;

    if (raw is BreedDetailArgs) return raw;
    if (raw is BreedSummary) return BreedDetailArgs.fromBreed(raw);

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      return BreedDetailArgs(
        id: (map['id'] ?? '').toString(),
        name: (map['name'] ?? map['label'] ?? 'Raza desconocida').toString(),
        slug: _readString(map['slug']),
        label: _readString(map['label']),
        description: _readString(map['description']),
        imageUrl: _readString(map['imageUrl'] ?? map['image_url']),
        images: _readImages(map['images']),
        temperament: _readString(map['temperament']),
        origin: _readString(map['origin']),
        size: _readString(map['size']),
        lifeSpan: _readString(map['lifeSpan'] ?? map['life_span']),
        confidence: map['confidence'] is num
            ? (map['confidence'] as num).toDouble()
            : null,
      );
    }

    return const BreedDetailArgs(id: '', name: 'Raza desconocida');
  }

  BreedSummary _breedFromArgs(BreedDetailArgs args) {
    final images = args.images.isNotEmpty
        ? args.images
        : [
            if (args.imageUrl != null && args.imageUrl!.isNotEmpty)
              args.imageUrl!,
          ];

    return BreedSummary(
      id: int.tryParse(args.id) ?? 0,
      name: args.name,
      slug: args.slug ?? '',
      label: args.label ?? '',
      description: args.description,
      imageUrl: args.imageUrl ?? (images.isNotEmpty ? images.first : null),
      temperament: args.temperament,
      origin: args.origin,
      size: args.size,
      lifeSpan: args.lifeSpan,
      images: images,
    );
  }

  Future<void> _loadBackendDetail(BreedDetailArgs args) async {
    final slug = args.slug?.trim();
    final explicitLabel = args.label?.trim();
    final inferredLabel = _inferLabelFromName(args.name);
    final label = explicitLabel?.isNotEmpty == true
        ? explicitLabel
        : inferredLabel;

    if ((slug == null || slug.isEmpty) && (label == null || label.isEmpty)) {
      setState(() {
        _loadMessage = 'No se recibió slug o label para cargar más detalle.';
      });
      return;
    }

    setState(() {
      _loadingDetail = true;
      _loadMessage = null;
    });

    try {
      BreedSummary loaded;
      if (slug != null && slug.isNotEmpty) {
        loaded = await _breedsService.getBreedBySlug(slug);
      } else {
        loaded = await _breedsService.getBreedByLabel(label!);
      }

      if (!mounted) return;
      setState(() {
        _detail = loaded;
        _loadingDetail = false;
      });
    } catch (_) {
      if (label == null || label.isEmpty) {
        if (!mounted) return;
        setState(() {
          _loadingDetail = false;
          _loadMessage =
              'No se pudo cargar el detalle completo. Se muestran datos básicos.';
        });
        return;
      }

      try {
        final loaded = await _breedsService.getBreedByLabel(label);
        if (!mounted) return;
        setState(() {
          _detail = loaded;
          _loadingDetail = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _loadingDetail = false;
          _loadMessage =
              'No se pudo cargar el detalle completo. Se muestran datos básicos.';
        });
      }
    }
  }

  static String? _readString(Object? value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  static List<String> _readImages(Object? value) {
    if (value is! List) return const [];
    return value
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  static String? _inferLabelFromName(String name) {
    final normalized = name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return normalized.isEmpty ? null : normalized;
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    final initialArgs = _initialArgs;
    final confidence = initialArgs?.confidence;

    if (detail == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle de raza')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final imageUrl = detail.imageUrl;
    final galleryImages = detail.images.isNotEmpty
        ? detail.images
        : [if (imageUrl != null && imageUrl.isNotEmpty) imageUrl];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de raza'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_loadingDetail) const LinearProgressIndicator(minHeight: 2),
            if (_loadingDetail) const SizedBox(height: 12),
            if (_loadMessage != null) ...[
              _StatusNotice(message: _loadMessage!),
              const SizedBox(height: 12),
            ],
            _HeroImage(imageUrl: imageUrl),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    detail.name.isNotEmpty ? detail.name : 'Raza desconocida',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                ),
                if (confidence != null)
                  Chip(
                    label: Text('${(confidence * 100).toStringAsFixed(1)}%'),
                    avatar: const Icon(Icons.verified, size: 18),
                  ),
              ],
            ),
            if (detail.label.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(detail.label, style: TextStyle(color: Colors.grey.shade700)),
            ],
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Descripción',
              child: Text(
                detail.description?.isNotEmpty == true
                    ? detail.description!
                    : 'Datos relevantes de la raza.',
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            _FactsCard(detail: detail),
            if (galleryImages.isNotEmpty) ...[
              const SizedBox(height: 12),
              _GalleryCard(images: galleryImages),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String? imageUrl;

  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.black12,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _ImageFallback(),
                )
              : const _ImageFallback(),
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.pets, size: 96, color: Colors.blue),
        Positioned(top: 8, child: Text('Imagen del perro')),
      ],
    );
  }
}

class _StatusNotice extends StatelessWidget {
  final String message;

  const _StatusNotice({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
      ),
      child: Text(message, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _FactsCard extends StatelessWidget {
  final BreedSummary detail;

  const _FactsCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final facts = <MapEntry<String, String>>[
      if (detail.temperament?.isNotEmpty == true)
        MapEntry('Temperamento', detail.temperament!),
      if (detail.origin?.isNotEmpty == true) MapEntry('Origen', detail.origin!),
      if (detail.size?.isNotEmpty == true) MapEntry('Tamaño', detail.size!),
      if (detail.lifeSpan?.isNotEmpty == true)
        MapEntry('Esperanza de vida', detail.lifeSpan!),
    ];

    if (facts.isEmpty) return const SizedBox.shrink();

    return _InfoCard(
      title: 'Datos de la raza',
      child: Column(
        children: facts
            .map(
              (fact) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 128,
                      child: Text(
                        fact.key,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(child: Text(fact.value)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  final List<String> images;

  const _GalleryCard({required this.images});

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Imágenes',
      child: SizedBox(
        height: 112,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[index],
                width: 148,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 148,
                  height: 112,
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: const Icon(Icons.pets),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
