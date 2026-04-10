import 'package:flutter/material.dart';

enum BreedSize { small, medium, large }

enum BreedEnergy { low, medium, high }

enum CoatType { short, long, curly }

class BreedItem {
  final String name;
  final String description;
  final BreedSize size;
  final BreedEnergy energy;
  final Set<String> temperaments;
  final CoatType coatType;

  const BreedItem({
    required this.name,
    required this.description,
    required this.size,
    required this.energy,
    required this.temperaments,
    required this.coatType,
  });
}

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});
  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final TextEditingController _search = TextEditingController();
  // Índices: 0=Razas (esta), 1=Cámara, 2=Instituciones, 3=Perfil
  final int _navIndex = 0;

  final List<BreedItem> _breeds = const [
    BreedItem(
      name: 'Chihuahua',
      description: 'Pequeño y muy alerta',
      size: BreedSize.small,
      energy: BreedEnergy.high,
      temperaments: {'Amigable', 'Juguetón', 'Independiente'},
      coatType: CoatType.short,
    ),
    BreedItem(
      name: 'Pug',
      description: 'Compañero y sociable',
      size: BreedSize.small,
      energy: BreedEnergy.medium,
      temperaments: {'Amigable', 'Juguetón'},
      coatType: CoatType.short,
    ),
    BreedItem(
      name: 'Border Collie',
      description: 'Inteligente y activo',
      size: BreedSize.medium,
      energy: BreedEnergy.high,
      temperaments: {'Protector', 'Juguetón'},
      coatType: CoatType.long,
    ),
    BreedItem(
      name: 'Bulldog Inglés',
      description: 'Tranquilo y leal',
      size: BreedSize.medium,
      energy: BreedEnergy.low,
      temperaments: {'Amigable', 'Protector'},
      coatType: CoatType.short,
    ),
    BreedItem(
      name: 'Golden Retriever',
      description: 'Familiar y obediente',
      size: BreedSize.large,
      energy: BreedEnergy.medium,
      temperaments: {'Amigable', 'Juguetón', 'Protector'},
      coatType: CoatType.long,
    ),
    BreedItem(
      name: 'Pastor Alemán',
      description: 'Leal y de trabajo',
      size: BreedSize.large,
      energy: BreedEnergy.high,
      temperaments: {'Protector', 'Independiente'},
      coatType: CoatType.long,
    ),
    BreedItem(
      name: 'Caniche',
      description: 'Activo y muy inteligente',
      size: BreedSize.medium,
      energy: BreedEnergy.medium,
      temperaments: {'Amigable', 'Juguetón'},
      coatType: CoatType.curly,
    ),
    BreedItem(
      name: 'Bichón Frisé',
      description: 'Alegre y cariñoso',
      size: BreedSize.small,
      energy: BreedEnergy.medium,
      temperaments: {'Amigable', 'Juguetón'},
      coatType: CoatType.curly,
    ),
  ];

  BreedSize? _selectedSize;
  BreedEnergy? _selectedEnergy;
  CoatType? _selectedCoatType;
  Set<String> _selectedTemperaments = <String>{};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<BreedItem> get _filteredBreeds {
    return _breeds.where((breed) {
      final matchesSize = _selectedSize == null || breed.size == _selectedSize;
      final matchesEnergy =
          _selectedEnergy == null || breed.energy == _selectedEnergy;
      final matchesCoat =
          _selectedCoatType == null || breed.coatType == _selectedCoatType;
      final matchesTemperament =
          _selectedTemperaments.isEmpty ||
          _selectedTemperaments.every(breed.temperaments.contains);
      return matchesSize && matchesEnergy && matchesCoat && matchesTemperament;
    }).toList();
  }

  Future<void> _openFiltersSheet() async {
    final result = await showModalBottomSheet<_FilterResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _BreedFiltersSheet(
          selectedSize: _selectedSize,
          selectedEnergy: _selectedEnergy,
          selectedCoatType: _selectedCoatType,
          selectedTemperaments: _selectedTemperaments,
        );
      },
    );

    if (result == null || !mounted) return;
    setState(() {
      _selectedSize = result.size;
      _selectedEnergy = result.energy;
      _selectedCoatType = result.coatType;
      _selectedTemperaments = result.temperaments;
    });
  }

  String _sizeLabel(BreedSize size) {
    switch (size) {
      case BreedSize.small:
        return 'Pequeño';
      case BreedSize.medium:
        return 'Mediano';
      case BreedSize.large:
        return 'Grande';
    }
  }

  String _energyLabel(BreedEnergy energy) {
    switch (energy) {
      case BreedEnergy.low:
        return 'Baja';
      case BreedEnergy.medium:
        return 'Media';
      case BreedEnergy.high:
        return 'Alta';
    }
  }

  String _coatLabel(CoatType coatType) {
    switch (coatType) {
      case CoatType.short:
        return 'Corto';
      case CoatType.long:
        return 'Largo';
      case CoatType.curly:
        return 'Rizado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredBreeds = _filteredBreeds;

    return Scaffold(
      appBar: AppBar(title: const Text('Colección de Razas')),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _search,
                    decoration: const InputDecoration(
                      hintText: 'search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted:
                        (_) {}, // TODO: conectar a repo cuando haya backend
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _openFiltersSheet,
                      icon: const Icon(Icons.filter_list),
                      label: const Text(
                        'Filtros',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredBreeds.isEmpty
                ? const Center(child: Text('No hay razas con esos filtros'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: filteredBreeds.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final breed = filteredBreeds[i];
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'img',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          title: Text(breed.name),
                          subtitle: Text(
                            '${breed.description} · ${_sizeLabel(breed.size)} · ${_energyLabel(breed.energy)} · ${_coatLabel(breed.coatType)}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {}, // TODO: ir a detalle
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Barra inferior fija
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Razas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera_outlined),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Instituciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        onTap: (i) {
          // Índices: 0=Razas, 1=Cámara, 2=Instituciones, 3=Perfil
          if (i == 1) {
            Navigator.pushNamed(context, '/capture'); // <- Cámara
            return;
          }
          if (i == 2) {
            Navigator.pushNamed(context, '/institutions');
            return;
          }
          if (i == 3) {
            Navigator.pushNamed(context, '/profile'); // <- Perfil
            return;
          }
          // i == 0 -> estás en Razas/Inicio de esta sección
        },
      ),
    );
  }
}

class _FilterResult {
  final BreedSize? size;
  final BreedEnergy? energy;
  final CoatType? coatType;
  final Set<String> temperaments;

  const _FilterResult({
    required this.size,
    required this.energy,
    required this.coatType,
    required this.temperaments,
  });
}

class _BreedFiltersSheet extends StatefulWidget {
  final BreedSize? selectedSize;
  final BreedEnergy? selectedEnergy;
  final CoatType? selectedCoatType;
  final Set<String> selectedTemperaments;

  const _BreedFiltersSheet({
    required this.selectedSize,
    required this.selectedEnergy,
    required this.selectedCoatType,
    required this.selectedTemperaments,
  });

  @override
  State<_BreedFiltersSheet> createState() => _BreedFiltersSheetState();
}

class _BreedFiltersSheetState extends State<_BreedFiltersSheet> {
  static const List<String> _temperamentOptions = [
    'Amigable',
    'Protector',
    'Juguetón',
    'Independiente',
  ];

  BreedSize? _size;
  BreedEnergy? _energy;
  CoatType? _coatType;
  late Set<String> _temperaments;

  @override
  void initState() {
    super.initState();
    _size = widget.selectedSize;
    _energy = widget.selectedEnergy;
    _coatType = widget.selectedCoatType;
    _temperaments = {...widget.selectedTemperaments};
  }

  void _clearAndApplyFilters() {
    Navigator.pop(
      context,
      const _FilterResult(
        size: null,
        energy: null,
        coatType: null,
        temperaments: <String>{},
      ),
    );
  }

  String _sizeLabel(BreedSize size) {
    switch (size) {
      case BreedSize.small:
        return 'Pequeño';
      case BreedSize.medium:
        return 'Mediano';
      case BreedSize.large:
        return 'Grande';
    }
  }

  String _energyLabel(BreedEnergy energy) {
    switch (energy) {
      case BreedEnergy.low:
        return 'Baja';
      case BreedEnergy.medium:
        return 'Media';
      case BreedEnergy.high:
        return 'Alta';
    }
  }

  String _coatLabel(CoatType coatType) {
    switch (coatType) {
      case CoatType.short:
        return 'Corto';
      case CoatType.long:
        return 'Largo';
      case CoatType.curly:
        return 'Rizado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtros',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Text(
                'Tamaño',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              ...BreedSize.values.map(
                (size) => RadioListTile<BreedSize>(
                  value: size,
                  groupValue: _size,
                  toggleable: true,
                  onChanged: (value) => setState(() => _size = value),
                  title: Text(_sizeLabel(size)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Energía',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              ...BreedEnergy.values.map(
                (energy) => RadioListTile<BreedEnergy>(
                  value: energy,
                  groupValue: _energy,
                  toggleable: true,
                  onChanged: (value) => setState(() => _energy = value),
                  title: Text(_energyLabel(energy)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Temperamento',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _temperamentOptions.map((option) {
                  final selected = _temperaments.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _temperaments.add(option);
                        } else {
                          _temperaments.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Tipo de pelaje',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              ...CoatType.values.map(
                (coat) => RadioListTile<CoatType>(
                  value: coat,
                  groupValue: _coatType,
                  toggleable: true,
                  onChanged: (value) => setState(() => _coatType = value),
                  title: Text(_coatLabel(coat)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearAndApplyFilters,
                      child: const Text('Limpiar filtros'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          _FilterResult(
                            size: _size,
                            energy: _energy,
                            coatType: _coatType,
                            temperaments: {..._temperaments},
                          ),
                        );
                      },
                      child: const Text('Aplicar filtros'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
