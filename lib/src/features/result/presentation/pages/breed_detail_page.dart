import 'package:flutter/material.dart';

class BreedDetailArgs {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl; // URL futura del backend (opcional)
  final double? confidence; // % de confianza si viene de IA (0–1, opcional)

  const BreedDetailArgs({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.confidence,
  });
}

class BreedDetailPage extends StatelessWidget {
  // Opcional, por si quieres usarlo en las rutas:
  // routes: { BreedDetailPage.routeName: (_) => const BreedDetailPage() }
  static const routeName = '/result';

  const BreedDetailPage({super.key});

  /// Acepta tanto:
  /// - BreedDetailArgs
  /// - Map<String, dynamic> (como el que estabas mandando desde CollectionPage)
  BreedDetailArgs _getArgs(BuildContext context) {
    final raw = ModalRoute.of(context)?.settings.arguments;

    // Caso 1: ya viene como BreedDetailArgs (lo ideal)
    if (raw is BreedDetailArgs) return raw;

    // Caso 2: viene como Map (lo que te estaba causando el error)
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);

      return BreedDetailArgs(
        id: (map['id'] ?? '').toString(),
        // Si no hay 'name', intentamos con 'label'
        name: (map['name'] ?? map['label'] ?? 'Raza desconocida').toString(),
        description: map['description'] as String?,
        imageUrl: map['imageUrl'] as String?,
        confidence: map['confidence'] is num
            ? (map['confidence'] as num).toDouble()
            : null,
      );
    }

    // Caso 3: no vino nada o vino algo raro → fallback seguro
    return const BreedDetailArgs(id: '', name: 'Raza desconocida');
  }

  @override
  Widget build(BuildContext context) {
    final args = _getArgs(context);

    final name = args.name;
    final desc = args.description ?? 'Datos relevantes de la raza.';
    final imageUrl = args.imageUrl;
    final conf = args.confidence; // se asume 0–1

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
            // Imagen principal
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black12,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : Stack(
                          alignment: Alignment.center,
                          children: const [
                            Icon(Icons.pets, size: 96, color: Colors.blue),
                            Positioned(top: 8, child: Text('Imagen del perro')),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nombre + chip de confianza (si viene)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                ),
                if (conf != null)
                  Chip(
                    label: Text(
                      '${(conf * 100).toStringAsFixed(1)}%',
                    ), // 0–1 → %
                    avatar: const Icon(Icons.verified, size: 18),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Sección de datos
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos relevantes de la raza',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(desc, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
