import 'package:flutter/material.dart';

import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/core/services/breeds_service.dart';
import 'package:aura_pet/src/core/models/breed_summary.dart';
import 'package:aura_pet/src/features/result/presentation/pages/breed_detail_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final _breedsService = BreedsService();
  final _searchCtrl = TextEditingController();

  List<BreedSummary> _allBreeds = [];
  List<BreedSummary> _filteredBreeds = [];
  bool _loading = true;
  String? _error;

  final int _navIndex = 0; // Razas

  @override
  void initState() {
    super.initState();
    _loadBreeds();
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadBreeds() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final breeds = await _breedsService.getAllBreeds();
      setState(() {
        _allBreeds = breeds;
        _filteredBreeds = breeds;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredBreeds = _allBreeds;
      });
      return;
    }

    setState(() {
      _filteredBreeds = _allBreeds.where((b) {
        final name = b.name.toLowerCase();
        final slug = b.slug.toLowerCase();
        final label = b.label.toLowerCase();
        return name.contains(query) ||
            slug.contains(query) ||
            label.contains(query);
      }).toList();
    });
  }

  void _onTapBreed(BreedSummary breed) {
    // Por ahora solo navegamos al detalle de raza.
    // Ajusta según cómo espere los argumentos tu BreedDetailPage.
    Navigator.pushNamed(
      context,
      '/result',
      arguments: {
        'slug': breed.slug,
        'id': breed.id,
        'name': breed.name,
        'label': breed.label,
        'description': breed.description,
        'imageUrl': breed.imageUrl,
      },
    );
  }

  void _onTapNav(int i) {
    switch (i) {
      case 0:
        break; // Ya estamos aquí
      case 1:
        Navigator.pushReplacementNamed(context, '/capture');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadBreeds,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else {
      body = Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar raza',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
              ),
            ),
          ),

          // Lista
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _filteredBreeds.length,
              itemBuilder: (context, index) {
                final breed = _filteredBreeds[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    onTap: () => _onTapBreed(breed),
                    leading: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      child: const Text('img'),
                    ),
                    title: Text(breed.name),
                    subtitle: Text(
                      breed.description?.isNotEmpty == true
                          ? breed.description!
                          : 'Raza de perro',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Colección de Razas')),
      body: AppBackground(opacity: 0.1, child: body),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTapNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Razas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera_outlined),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
