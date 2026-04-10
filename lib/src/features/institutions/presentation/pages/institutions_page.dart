import 'package:flutter/material.dart';

enum LocationFilter { nearby, city }

enum AvailabilityFilter { openNow, allDay, limited }

enum OrganizationType { ngo, government, private }

class RescueGroup {
  final String name;
  final String description;
  final String city;
  final bool isNearby;
  final Set<String> services;
  final AvailabilityFilter availability;
  final OrganizationType organizationType;

  const RescueGroup({
    required this.name,
    required this.description,
    required this.city,
    required this.isNearby,
    required this.services,
    required this.availability,
    required this.organizationType,
  });
}

class InstitutionsPage extends StatefulWidget {
  static const routeName = '/institutions';

  const InstitutionsPage({super.key});

  @override
  State<InstitutionsPage> createState() => _InstitutionsPageState();
}

class _InstitutionsPageState extends State<InstitutionsPage> {
  static const int _navIndex = 2;
  static const String _cityName = 'Monterrey';

  final TextEditingController _search = TextEditingController();

  final List<RescueGroup> _groups = const [
    RescueGroup(
      name: 'Huellas al Rescate',
      description: 'Rescate y rehabilitación de perros en situación de calle.',
      city: 'Monterrey',
      isNearby: true,
      services: {'Rescate', 'Refugio'},
      availability: AvailabilityFilter.openNow,
      organizationType: OrganizationType.ngo,
    ),
    RescueGroup(
      name: 'Refugio Patitas Felices',
      description: 'Hogar temporal y campañas de adopción responsable.',
      city: 'Monterrey',
      isNearby: true,
      services: {'Adopción', 'Refugio'},
      availability: AvailabilityFilter.limited,
      organizationType: OrganizationType.ngo,
    ),
    RescueGroup(
      name: 'Centro Veterinario Municipal',
      description: 'Atención básica y esterilización comunitaria.',
      city: 'Monterrey',
      isNearby: false,
      services: {'Veterinaria', 'Rescate'},
      availability: AvailabilityFilter.allDay,
      organizationType: OrganizationType.government,
    ),
    RescueGroup(
      name: 'Adopta Norte',
      description: 'Vinculación de familias con mascotas rescatadas.',
      city: 'Saltillo',
      isNearby: false,
      services: {'Adopción'},
      availability: AvailabilityFilter.openNow,
      organizationType: OrganizationType.private,
    ),
    RescueGroup(
      name: 'Clínica PetCare Solidaria',
      description: 'Servicio veterinario con cuotas preferenciales.',
      city: 'Monterrey',
      isNearby: true,
      services: {'Veterinaria'},
      availability: AvailabilityFilter.limited,
      organizationType: OrganizationType.private,
    ),
    RescueGroup(
      name: 'Red Global de Refugios',
      description: 'Coordinación nacional de traslados y refugio.',
      city: 'Guadalajara',
      isNearby: false,
      services: {'Rescate', 'Refugio', 'Adopción'},
      availability: AvailabilityFilter.allDay,
      organizationType: OrganizationType.ngo,
    ),
  ];

  LocationFilter? _selectedLocation;
  AvailabilityFilter? _selectedAvailability;
  OrganizationType? _selectedOrganization;
  Set<String> _selectedServices = <String>{};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<RescueGroup> get _filteredGroups {
    final query = _search.text.trim().toLowerCase();
    return _groups.where((group) {
      final matchesQuery =
          query.isEmpty ||
          group.name.toLowerCase().contains(query) ||
          group.description.toLowerCase().contains(query) ||
          group.city.toLowerCase().contains(query);

      final matchesLocation = switch (_selectedLocation) {
        null => true,
        LocationFilter.nearby => group.isNearby,
        LocationFilter.city =>
          group.city.toLowerCase() == _cityName.toLowerCase(),
      };

      final matchesServices =
          _selectedServices.isEmpty ||
          _selectedServices.every(group.services.contains);

      final matchesAvailability =
          _selectedAvailability == null ||
          group.availability == _selectedAvailability;

      final matchesOrganization =
          _selectedOrganization == null ||
          group.organizationType == _selectedOrganization;

      return matchesQuery &&
          matchesLocation &&
          matchesServices &&
          matchesAvailability &&
          matchesOrganization;
    }).toList();
  }

  Future<void> _openFiltersSheet() async {
    final result = await showModalBottomSheet<_InstitutionFilterResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _InstitutionsFiltersSheet(
          selectedLocation: _selectedLocation,
          selectedAvailability: _selectedAvailability,
          selectedOrganization: _selectedOrganization,
          selectedServices: _selectedServices,
        );
      },
    );

    if (result == null || !mounted) return;
    setState(() {
      _selectedLocation = result.location;
      _selectedAvailability = result.availability;
      _selectedOrganization = result.organization;
      _selectedServices = result.services;
    });
  }

  String _availabilityLabel(AvailabilityFilter value) {
    switch (value) {
      case AvailabilityFilter.openNow:
        return 'Abierto ahora';
      case AvailabilityFilter.allDay:
        return '24/7';
      case AvailabilityFilter.limited:
        return 'Horario limitado';
    }
  }

  String _organizationLabel(OrganizationType value) {
    switch (value) {
      case OrganizationType.ngo:
        return 'ONG';
      case OrganizationType.government:
        return 'Gobierno';
      case OrganizationType.private:
        return 'Privado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _filteredGroups;
    final nearbyGroups = filteredGroups.where((g) => g.isNearby).toList();
    final globalGroups = filteredGroups.where((g) => !g.isNearby).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Grupos cercanos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Buscar grupo o ciudad',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Text('Cerca:'),
                  ),
                  if (nearbyGroups.isEmpty)
                    const _EmptySection(
                      message: 'Sin grupos cercanos con esos filtros',
                    )
                  else
                    ...nearbyGroups.map(
                      (group) => _GroupCard(
                        group: group,
                        availabilityLabel: _availabilityLabel(
                          group.availability,
                        ),
                        organizationLabel: _organizationLabel(
                          group.organizationType,
                        ),
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Text('Global:'),
                  ),
                  if (globalGroups.isEmpty)
                    const _EmptySection(
                      message: 'Sin grupos globales con esos filtros',
                    )
                  else
                    ...globalGroups.map(
                      (group) => _GroupCard(
                        group: group,
                        availabilityLabel: _availabilityLabel(
                          group.availability,
                        ),
                        organizationLabel: _organizationLabel(
                          group.organizationType,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          switch (i) {
            case 0:
              Navigator.pushNamed(context, '/collection');
              break;
            case 1:
              Navigator.pushNamed(context, '/capture');
              break;
            case 2:
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
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
      ),
    );
  }
}

class _InstitutionFilterResult {
  final LocationFilter? location;
  final AvailabilityFilter? availability;
  final OrganizationType? organization;
  final Set<String> services;

  const _InstitutionFilterResult({
    required this.location,
    required this.availability,
    required this.organization,
    required this.services,
  });
}

class _InstitutionsFiltersSheet extends StatefulWidget {
  final LocationFilter? selectedLocation;
  final AvailabilityFilter? selectedAvailability;
  final OrganizationType? selectedOrganization;
  final Set<String> selectedServices;

  const _InstitutionsFiltersSheet({
    required this.selectedLocation,
    required this.selectedAvailability,
    required this.selectedOrganization,
    required this.selectedServices,
  });

  @override
  State<_InstitutionsFiltersSheet> createState() =>
      _InstitutionsFiltersSheetState();
}

class _InstitutionsFiltersSheetState extends State<_InstitutionsFiltersSheet> {
  static const List<String> _serviceOptions = [
    'Rescate',
    'Adopción',
    'Refugio',
    'Veterinaria',
  ];

  LocationFilter? _location;
  AvailabilityFilter? _availability;
  OrganizationType? _organization;
  late Set<String> _services;

  @override
  void initState() {
    super.initState();
    _location = widget.selectedLocation;
    _availability = widget.selectedAvailability;
    _organization = widget.selectedOrganization;
    _services = {...widget.selectedServices};
  }

  String _locationLabel(LocationFilter value) {
    switch (value) {
      case LocationFilter.nearby:
        return 'Cercano a mí';
      case LocationFilter.city:
        return 'Por ciudad';
    }
  }

  String _availabilityLabel(AvailabilityFilter value) {
    switch (value) {
      case AvailabilityFilter.openNow:
        return 'Abierto ahora';
      case AvailabilityFilter.allDay:
        return '24/7';
      case AvailabilityFilter.limited:
        return 'Horario limitado';
    }
  }

  String _organizationLabel(OrganizationType value) {
    switch (value) {
      case OrganizationType.ngo:
        return 'ONG';
      case OrganizationType.government:
        return 'Gobierno';
      case OrganizationType.private:
        return 'Privado';
    }
  }

  void _clearAndApply() {
    Navigator.pop(
      context,
      const _InstitutionFilterResult(
        location: null,
        availability: null,
        organization: null,
        services: <String>{},
      ),
    );
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
                'Ubicación',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              ...LocationFilter.values.map(
                (location) => RadioListTile<LocationFilter>(
                  value: location,
                  groupValue: _location,
                  toggleable: true,
                  onChanged: (value) => setState(() => _location = value),
                  title: Text(_locationLabel(location)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tipo de servicio',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _serviceOptions.map((option) {
                  final selected = _services.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _services.add(option);
                        } else {
                          _services.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Disponibilidad',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              ...AvailabilityFilter.values.map(
                (availability) => RadioListTile<AvailabilityFilter>(
                  value: availability,
                  groupValue: _availability,
                  toggleable: true,
                  onChanged: (value) => setState(() => _availability = value),
                  title: Text(_availabilityLabel(availability)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tipo de organización',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              ...OrganizationType.values.map(
                (organization) => RadioListTile<OrganizationType>(
                  value: organization,
                  groupValue: _organization,
                  toggleable: true,
                  onChanged: (value) => setState(() => _organization = value),
                  title: Text(_organizationLabel(organization)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearAndApply,
                      child: const Text('Limpiar filtros'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          _InstitutionFilterResult(
                            location: _location,
                            availability: _availability,
                            organization: _organization,
                            services: {..._services},
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

class _GroupCard extends StatelessWidget {
  final RescueGroup group;
  final String availabilityLabel;
  final String organizationLabel;

  const _GroupCard({
    required this.group,
    required this.availabilityLabel,
    required this.organizationLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        leading: Icon(Icons.pets, color: Colors.blue.shade700, size: 44),
        title: Text(group.name),
        subtitle: Text(
          '${group.description}\n$availabilityLabel · $organizationLabel · ${group.city}',
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;

  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(message),
    );
  }
}
