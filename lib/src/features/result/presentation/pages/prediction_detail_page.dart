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
    final top1 = prediction.top1;
    final recognized = prediction.recognized;

    final theme = Theme.of(context);
    final prettyTop1 = _prettyLabel(top1.label);
    final confidence = (top1.score * 100).toStringAsFixed(1);
    final description = prediction.info?['description']?.toString().trim();
    final breedDescription = description != null && description.isNotEmpty
        ? description
        : 'Descripción no disponible para esta raza.';
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
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
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
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Descripción de la raza',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              breedDescription,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
