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

class PredictionDetailPage extends StatelessWidget {
  static const routeName = '/prediction-detail';

  const PredictionDetailPage({super.key});

  String _prettyLabel(String raw) {
    var label = raw;
    if (label.contains('-')) {
      label = label.split('-').last;
    }
    label = label.replaceAll('_', ' ');
    if (label.isNotEmpty) {
      label = label[0].toUpperCase() + label.substring(1);
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as PredictionDetailArgs;
    final prediction = args.prediction;
    final top1 = prediction.top1;

    final theme = Theme.of(context);
    final prettyTop1 = _prettyLabel(top1.label);
    final confidence = (top1.score * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado de la predicción')),
      body: AppBackground(
        opacity: 0.08,
        child: SingleChildScrollView(
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
              Text(
                'Raza principal detectada',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                              prettyTop1,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Confianza: $confidence %',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Otras posibles razas',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...prediction.top5.map((item) {
                final label = _prettyLabel(item.label);
                final conf = (item.score * 100).toStringAsFixed(1);
                final isMain = item.label == top1.label;

                return ListTile(
                  leading: Icon(
                    isMain ? Icons.star : Icons.pets,
                    color: isMain
                        ? theme.colorScheme.primary
                        : theme.iconTheme.color,
                  ),
                  title: Text(label),
                  subtitle: Text('Confianza: $conf %'),
                );
              }).toList(),
              const SizedBox(height: 12),
              Text(
                'Log ID: ${prediction.logId}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
