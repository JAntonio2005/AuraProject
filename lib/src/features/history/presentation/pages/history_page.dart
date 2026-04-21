import 'package:flutter/material.dart';
import 'package:aura_pet/src/widgets/app_background.dart';
import 'package:aura_pet/src/core/routes/services/history_service.dart';
import 'package:aura_pet/src/core/models/prediction_history_item.dart';
import 'package:aura_pet/src/core/theme/design_tokens.dart';
import 'package:aura_pet/src/widgets/app_navigation_bar.dart';
import 'package:aura_pet/src/widgets/state_panels.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/history';
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _historyService = HistoryService();

  // Estado para predicciones
  bool _loadingPred = true;
  String? _errorPred;
  List<PredictionHistoryItem> _predItems = [];

  // Estado para búsquedas
  bool _loadingSearch = true;
  String? _errorSearch;
  List<PredictionHistoryItem> _searchItems = [];

  @override
  void initState() {
    super.initState();
    _loadPredictionHistory();
    _loadSearchHistory();
  }

  Future<void> _loadPredictionHistory() async {
    setState(() {
      _loadingPred = true;
      _errorPred = null;
    });

    try {
      final items = await _historyService.getMyPredictionHistory();
      setState(() {
        _predItems = items;
        _loadingPred = false;
      });
    } catch (_) {
      setState(() {
        _errorPred = 'No se pudo cargar tu historial de predicciones.';
        _loadingPred = false;
      });
    }
  }

  Future<void> _loadSearchHistory() async {
    setState(() {
      _loadingSearch = true;
      _errorSearch = null;
    });

    try {
      final items = await _historyService.getMySearchHistory();
      setState(() {
        _searchItems = items;
        _loadingSearch = false;
      });
    } catch (_) {
      setState(() {
        _errorSearch = 'No se pudo cargar tu historial de búsquedas.';
        _loadingSearch = false;
      });
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final d = dt; // lo usamos tal cual viene del backend

    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy $hh:$mi';
  }

  Widget _buildHistoryList({
    required bool loading,
    required String? error,
    required List<PredictionHistoryItem> items,
    required VoidCallback onRetry,
    required String emptyMessage,
  }) {
    if (loading) {
      return StatePanels.loading();
    } else if (error != null) {
      return StatePanels.error(
        context: context,
        message: error,
        onRetry: onRetry,
      );
    } else if (items.isEmpty) {
      return StatePanels.empty(context: context, message: emptyMessage);
    } else {
      final width = MediaQuery.sizeOf(context).width;
      final listPadding = width < 380 ? 8.0 : 12.0;
      return ListView.separated(
        padding: EdgeInsets.all(listPadding),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final it = items[i];

          final subtitleParts = <String>[];
          if (it.createdAt != null) {
            subtitleParts.add(_formatDate(it.createdAt));
          }
          if (it.confidence != null) {
            subtitleParts.add(
              'Confidencia ${it.confidence!.toStringAsFixed(1)}%',
            );
          }
          final subtitle = subtitleParts.join(' • ');

          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.pets)),
            title: Text(it.title),
            subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Aquí luego puedes navegar a un detalle de predicción/búsqueda
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Detalle de historial pendiente')),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 380;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Historial'),
          bottom: TabBar(
            labelStyle: TextStyle(
              fontSize: isCompact ? 12 : 14,
              fontWeight: FontWeight.w700,
            ),
            tabs: [
              Tab(text: 'Predicciones', icon: Icon(Icons.analytics_outlined)),
              Tab(text: 'Búsquedas', icon: Icon(Icons.search)),
            ],
          ),
        ),
        body: AppBackground(
          opacity: DesignTokens.surfaceOpacityLow,
          child: SafeArea(
            child: TabBarView(
              children: [
                // Historial de predicciones
                _buildHistoryList(
                  loading: _loadingPred,
                  error: _errorPred,
                  items: _predItems,
                  onRetry: _loadPredictionHistory,
                  emptyMessage: 'Aún no hay predicciones registradas.',
                ),
                // Historial de búsquedas
                _buildHistoryList(
                  loading: _loadingSearch,
                  error: _errorSearch,
                  items: _searchItems,
                  onRetry: _loadSearchHistory,
                  emptyMessage: 'Aún no hay búsquedas registradas.',
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppNavigationBar(currentIndex: 3),
      ),
    );
  }
}
