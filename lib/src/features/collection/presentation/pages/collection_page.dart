import 'package:flutter/material.dart';

import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/core/routes/services/breeds_service.dart';
import 'package:aura_pet/src/core/models/breed_summary.dart';
import 'package:aura_pet/src/features/result/presentation/pages/breed_detail_page.dart';
import 'package:aura_pet/src/core/routes/services/history_service.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/features/collection/presentation/controllers/collection_pagination_controller.dart';
import 'package:aura_pet/src/features/collection/presentation/state/breeds_pagination_state.dart';
import 'package:aura_pet/src/features/collection/presentation/widgets/breeds_paginator.dart';
import 'package:aura_pet/src/widgets/app_navigation_bar.dart';
import 'package:aura_pet/src/widgets/state_panels.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  static const int _pageSize = 12;

  final _breedsService = BreedsService();
  final _searchCtrl = TextEditingController();
  final _historyService = HistoryService();
  final _paginationController = CollectionPaginationController();

  List<BreedSummary> _allBreeds = [];
  List<BreedSummary> _filteredBreeds = [];
  BreedsPaginationState _paginationState = const BreedsPaginationState(
    currentPage: 1,
    pageSize: _pageSize,
    totalItems: 0,
  );
  String _lastAppliedQuery = '';
  bool _loading = true;
  String? _error;

  final List<Color> _cardPalette = const [
    Color(0xFF8A83D6),
    Color(0xFFF78B47),
    Color(0xFF6E55D8),
    Color(0xFF6F88CC),
    Color(0xFFF2A31B),
  ];

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
        _lastAppliedQuery = '';
        _paginationState = _paginationController.onQueryChanged(
          pageSize: _pageSize,
          totalItems: breeds.length,
        );
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
    final filtered = query.isEmpty
        ? _allBreeds
        : _allBreeds.where((b) {
            final name = b.name.toLowerCase();
            final slug = b.slug.toLowerCase();
            final label = b.label.toLowerCase();
            return name.contains(query) ||
                slug.contains(query) ||
                label.contains(query);
          }).toList();
    final queryChanged = query != _lastAppliedQuery;

    setState(() {
      _filteredBreeds = filtered;
      // Regla US2 explicita: cualquier cambio real de query reinicia paginacion.
      _paginationState = queryChanged
          ? _paginationController.onQueryChanged(
              pageSize: _paginationState.pageSize,
              totalItems: filtered.length,
            )
          : _paginationController.buildState(
              currentPage: _paginationState.currentPage,
              pageSize: _paginationState.pageSize,
              totalItems: filtered.length,
            );
      _lastAppliedQuery = query;
    });
  }

  void _goToPreviousPage() {
    if (!_paginationState.hasPreviousPage) return;
    setState(() {
      _paginationState = _paginationController.buildState(
        currentPage: _paginationState.currentPage - 1,
        pageSize: _paginationState.pageSize,
        totalItems: _filteredBreeds.length,
      );
    });
  }

  void _goToNextPage() {
    if (!_paginationState.hasNextPage) return;
    setState(() {
      _paginationState = _paginationController.buildState(
        currentPage: _paginationState.currentPage + 1,
        pageSize: _paginationState.pageSize,
        totalItems: _filteredBreeds.length,
      );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < DesignTokens.compactWidth;
    final isWide = width >= DesignTokens.wideWidth;
    final listMaxWidth = isWide ? 980.0 : 760.0;
    final horizontalPadding = isCompact
        ? DesignTokens.space12
        : DesignTokens.space16;
    final gridCount = width >= 980 ? 4 : (width >= 700 ? 3 : 2);
    final gridAspect = isCompact ? 0.82 : 0.9;

    Widget body;
    if (_loading) {
      body = StatePanels.loading();
    } else if (_error != null) {
      body = StatePanels.error(
        context: context,
        message: _error!,
        onRetry: _loadBreeds,
      );
    } else {
      final recentBreeds = _filteredBreeds.take(6).toList();
      final pageBreeds = _paginationController.pageSlice(
        source: _filteredBreeds,
        state: _paginationState,
      );

      body = SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: listMaxWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                DesignTokens.space12,
                DesignTokens.space12,
                DesignTokens.space12,
                DesignTokens.space16,
              ),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFEAD8CC),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: const Icon(Icons.pets, color: Color(0xFF7A5D4F)),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.space12),
                    Text(
                      'Nicole',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3E2D25),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.space12),
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8CC300),
                    borderRadius: BorderRadius.circular(DesignTokens.radius16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.family_restroom, color: Colors.white),
                      const SizedBox(width: DesignTokens.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'En familia',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.space4),
                            Text(
                              'Descubre juntos nuevas razas y sus cuidados.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.92),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.space12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Accion principal: buscar una raza',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.space8),
                TextField(
                  controller: _searchCtrl,
                  onSubmitted: _onSearchSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Buscar raza',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => _onSearchSubmitted(_searchCtrl.text),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radius16,
                      ),
                    ),
                    filled: true,
                  ),
                ),
                const SizedBox(height: DesignTokens.space8),
                Text(
                  _filteredBreeds.isEmpty
                      ? '0 resultados disponibles'
                      : '${_paginationState.startIndex + 1}-${_paginationState.endExclusive} de ${_filteredBreeds.length} resultados',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: DesignTokens.space16),
                Text(
                  'Reciente',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3E2D25),
                  ),
                ),
                const SizedBox(height: DesignTokens.space12),
                SizedBox(
                  height: isCompact ? 160 : 172,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentBreeds.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: DesignTokens.space12),
                    itemBuilder: (context, index) {
                      final breed = recentBreeds[index];
                      final color = _cardPalette[index % _cardPalette.length];
                      return _RecentBreedCard(
                        breed: breed,
                        color: color,
                        onTap: () => _onTapBreed(breed),
                      );
                    },
                  ),
                ),
                const SizedBox(height: DesignTokens.space20),
                Text(
                  'Explorar razas',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3E2D25),
                  ),
                ),
                const SizedBox(height: DesignTokens.space12),
                if (_filteredBreeds.isEmpty)
                  StatePanels.empty(
                    context: context,
                    message:
                        'Sin resultados. No encontramos razas para tu busqueda actual. Intenta otro termino.',
                  )
                else ...[
                  Container(
                    padding: EdgeInsets.all(horizontalPadding),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radius16,
                      ),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageBreeds.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        mainAxisSpacing: DesignTokens.space12,
                        crossAxisSpacing: DesignTokens.space12,
                        childAspectRatio: gridAspect,
                      ),
                      itemBuilder: (context, index) {
                        final breed = pageBreeds[index];
                        final color =
                            _cardPalette[(index + 1) % _cardPalette.length];
                        return _ExploreBreedCard(
                          breed: breed,
                          color: color,
                          onTap: () => _onTapBreed(breed),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space16),
                  BreedsPaginator(
                    currentPage: _paginationState.currentPage,
                    totalPages: _paginationState.totalPages,
                    totalItems: _filteredBreeds.length,
                    startItem: _filteredBreeds.isEmpty
                        ? 0
                        : _paginationState.startIndex + 1,
                    endItem: _paginationState.endExclusive,
                    onPrevious: _paginationState.hasPreviousPage
                        ? _goToPreviousPage
                        : null,
                    onNext: _paginationState.hasNextPage ? _goToNextPage : null,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE6),
      body: AppBackground(opacity: 0.04, child: body),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 0),
    );
  }
}

class _RecentBreedCard extends StatelessWidget {
  final BreedSummary breed;
  final Color color;
  final VoidCallback onTap;

  const _RecentBreedCard({
    required this.breed,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radius16),
      child: Container(
        width: 292,
        padding: const EdgeInsets.all(DesignTokens.space12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(DesignTokens.radius16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6,
              width: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: DesignTokens.space12),
            Text(
              'Guía reciente',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: DesignTokens.space4),
            Text(
              breed.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.pets, color: Colors.white),
                const SizedBox(width: DesignTokens.space8),
                Expanded(
                  child: Text(
                    breed.label.isNotEmpty ? breed.label : 'Raza destacada',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreBreedCard extends StatelessWidget {
  final BreedSummary breed;
  final Color color;
  final VoidCallback onTap;

  const _ExploreBreedCard({
    required this.breed,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radius16),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.space12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(DesignTokens.radius16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.space8,
                vertical: DesignTokens.space4,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Raza',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            Text(
              breed.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: DesignTokens.space4),
            Text(
              breed.description?.isNotEmpty == true
                  ? breed.description!
                  : 'Conoce más sobre esta raza.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
