import 'package:flutter/material.dart';

class BreedDetailArgs {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;     // URL futura del backend (opcional)
  final double? confidence;   // % de confianza si viene de IA (opcional)

  const BreedDetailArgs({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.confidence,
  });
}

class BreedDetailPage extends StatelessWidget {
  const BreedDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as BreedDetailArgs?;
    final name = args?.name ?? 'Nombre de la raza de perro';
    final desc = args?.description ?? 'Datos relevantes de la raza';
    final imageUrl = args?.imageUrl;
    final conf = args?.confidence;

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
                  child: imageUrl != null
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

            // Nombre + (opcional) chip de confianza
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700, color: Colors.blue,
                    ),
                  ),
                ),
                if (conf != null)
                  Chip(
                    label: Text('${(conf * 100).toStringAsFixed(1)}%'),
                    avatar: const Icon(Icons.verified, size: 18),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Sección de datos
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Datos relevantes de la raza',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: const TextStyle(fontSize: 14),
                    ),
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
