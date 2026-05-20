import 'dart:io';

import 'package:flutter/material.dart';
import 'package:aura_pet/src/core/models/predict_response.dart';
import 'package:aura_pet/src/widgets/app_background.dart';

class PredictionDetailArgs {
  final String imagePath;
  final PredictResponse prediction;

  const PredictionDetailArgs({
    required this.imagePath,
    required this.prediction,
  });
}

class PredictionDetailPage extends StatefulWidget {
  static const routeName = '/prediction-detail';

  const PredictionDetailPage({super.key});

  @override
  State<PredictionDetailPage> createState() => _PredictionDetailPageState();
}

class _PredictionDetailPageState extends State<PredictionDetailPage> {
  bool _dialogShown = false;

  String _prettyLabel(String raw) {
    var label = raw.trim();
    if (label.contains('-')) {
      label = label.split('-').last;
    }
    label = label.replaceAll('_', ' ');
    if (label.isNotEmpty) {
      label = label[0].toUpperCase() + label.substring(1);
    }
    return label;
  }

  void _showThresholdDialog(String message) {
    if (_dialogShown || !mounted) return;
    _dialogShown = true;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Escaneo no disponible'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as PredictionDetailArgs;
    final prediction = args.prediction;
    final recognized = prediction.recognized;
    final theme = Theme.of(context);

    final rawBreed =
        prediction.breed ?? prediction.canonicalLabel ?? prediction.top1.label;
    final displayName = prediction.displayName ?? _prettyLabel(rawBreed);
    final confidence = (prediction.primaryConfidence * 100).toStringAsFixed(1);
    final breedDescription =
        prediction.description ?? 'Descripción no disponible para esta raza.';
    final possibleBreeds = prediction.possibleBreeds.isNotEmpty
        ? prediction.possibleBreeds
        : prediction.top5;
    final enrichedImages = prediction.breedDetail?.images ?? const <String>[];
    final traits = prediction.breedDetail?.info?.traits ?? const <String>[];
    final care = prediction.breedDetail?.info?.care;
    final thresholdMessage =
        prediction.message ??
        'Lo sentimos.\nNo fue posible generar un resultado confiable para esta imagen.\n\nSugerencias: asegúrate de que aparezca un perro claramente visible, con buen encuadre, iluminación uniforme y enfoque adecuado.';

    if (!recognized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showThresholdDialog(thresholdMessage);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado de la predicción')),
      body: AppBackground(
        opacity: 0.08,
        child: recognized
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(args.imagePath),
                        height: 260,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ResultHeaderCard(
                      displayName: displayName,
                      rawBreed: rawBreed,
                      confidence: confidence,
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      title: 'Descripción de la raza',
                      body: breedDescription,
                    ),
                    if (prediction.basicCare != null) ...[
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: 'Cuidados básicos',
                        body: prediction.basicCare!,
                      ),
                    ],
                    if (prediction.feeding != null) ...[
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: 'Alimentación',
                        body: prediction.feeding!,
                      ),
                    ],
                    if (traits.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _TraitsCard(traits: traits),
                    ],
                    if (care != null && care.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _CareCard(care: care),
                    ],
                    if (enrichedImages.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _BreedImagesCard(images: enrichedImages),
                    ],
                    if (possibleBreeds.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _PossibleBreedsCard(
                        breeds: possibleBreeds,
                        prettyLabel: _prettyLabel,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      'Log ID: ${prediction.logId}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        thresholdMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ResultHeaderCard extends StatelessWidget {
  final String displayName;
  final String rawBreed;
  final String confidence;

  const _ResultHeaderCard({
    required this.displayName,
    required this.rawBreed,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.pets, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rawBreed,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Confianza: $confidence %',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;

  const _InfoCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _TraitsCard extends StatelessWidget {
  final List<String> traits;

  const _TraitsCard({required this.traits});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Características',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: traits
                  .map((trait) => Chip(label: Text(trait)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareCard extends StatelessWidget {
  final Map<String, dynamic> care;

  const _CareCard({required this.care});

  @override
  Widget build(BuildContext context) {
    final entries = care.entries
        .where((entry) => entry.value != null)
        .map((entry) => MapEntry(entry.key, entry.value.toString()))
        .where((entry) => entry.value.trim().isNotEmpty)
        .toList(growable: false);

    if (entries.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuidado recomendado',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('${entry.key}: ${entry.value}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreedImagesCard extends StatelessWidget {
  final List<String> images;

  const _BreedImagesCard({required this.images});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Imágenes de referencia',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
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
          ],
        ),
      ),
    );
  }
}

class _PossibleBreedsCard extends StatelessWidget {
  final List<PredictionItem> breeds;
  final String Function(String raw) prettyLabel;

  const _PossibleBreedsCard({required this.breeds, required this.prettyLabel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posibles razas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...breeds.map(
              (breed) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(prettyLabel(breed.label)),
                subtitle: Text(breed.label),
                trailing: Text('${(breed.score * 100).toStringAsFixed(1)}%'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
