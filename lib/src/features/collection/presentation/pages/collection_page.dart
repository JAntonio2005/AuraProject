import 'package:flutter/material.dart';

import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/core/routes/services/breeds_service.dart';
import 'package:aura_pet/src/core/models/breed_summary.dart';
import 'package:aura_pet/src/features/result/presentation/pages/breed_detail_page.dart';
import 'package:aura_pet/src/core/routes/services/history_service.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final _breedsService = BreedsService();
  final _searchCtrl = TextEditingController();
  final _historyService = HistoryService();

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

  /// 🔹 Cuando el usuario pulsa "buscar" en el teclado
  ///    o el botón de la lupita dentro del TextField
  Future<void> _onSearchSubmitted(String value) async {
    final query = value.trim();
    if (query.isEmpty) {
      _applyFilter();
      return;
    }

    // Guardar búsqueda libre en el historial
    try {
      await _historyService.logSearch(query: query);
      // si falla, no rompemos la UI:
    } catch (e) {
      debugPrint('[CollectionPage] Error registrando búsqueda: $e');
    }

    _applyFilter();
  }

  /// 🔹 Cuando el usuario toca una raza específica
  Future<void> _onTapBreed(BreedSummary breed) async {
    // 1) Guardar como búsqueda de raza específica
    try {
      await _historyService.logSearch(
        breedLabel: breed.label.isNotEmpty ? breed.label : breed.name,
      );
    } catch (e) {
      debugPrint('[CollectionPage] Error registrando búsqueda de raza: $e');
    }

    // 2) Navegar al detalle de la raza usando BreedDetailArgs
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      BreedDetailPage.routeName, // '/result'
      arguments: BreedDetailArgs(
        id: breed.id.toString(),
        name: breed.name,
        description: breed.description,
        imageUrl: breed.imageUrl,
        confidence: null, // aquí normalmente no hay confianza de IA
      ),
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
        Navigator.pushReplacementNamed(context, '/community');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 4:
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
          // 🔍 Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onSubmitted: _onSearchSubmitted, // teclado (botón buscar)
              decoration: InputDecoration(
                hintText: 'Buscar raza',
                prefixIcon: const Icon(Icons.search),
                // 👇 botón dentro del TextField que también dispara el guardado
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _onSearchSubmitted(_searchCtrl.text),
                ),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _onTapNav,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Razas',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_camera_outlined),
            selectedIcon: Icon(Icons.photo_camera),
            label: 'Cámara',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Comunidad',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
