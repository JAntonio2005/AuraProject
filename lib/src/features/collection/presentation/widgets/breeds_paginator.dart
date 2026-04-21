import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/theme/design_tokens.dart';

class BreedsPaginator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int startItem;
  final int endItem;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const BreedsPaginator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.startItem,
    required this.endItem,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final safeTotalPages = totalPages < 1 ? 1 : totalPages;
    final safeCurrentPage = currentPage.clamp(1, safeTotalPages);
    final canGoPrevious = safeCurrentPage > 1 && onPrevious != null;
    final canGoNext = safeCurrentPage < safeTotalPages && onNext != null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space12,
        vertical: DesignTokens.space8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: canGoPrevious ? onPrevious : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Anterior'),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pagina $safeCurrentPage de $safeTotalPages',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: DesignTokens.space4),
              Text(
                totalItems <= 0
                    ? '0 resultados'
                    : '$startItem-$endItem de $totalItems resultados',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: canGoNext ? onNext : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
