import 'package:aura_pet/src/core/models/breed_summary.dart';
import 'package:aura_pet/src/features/collection/presentation/state/breeds_pagination_state.dart';

class CollectionPaginationController {
  BreedsPaginationState buildState({
    required int currentPage,
    required int pageSize,
    required int totalItems,
  }) {
    final safePageSize = pageSize <= 0 ? 1 : pageSize;
    final base = BreedsPaginationState(
      currentPage: currentPage < 1 ? 1 : currentPage,
      pageSize: safePageSize,
      totalItems: totalItems < 0 ? 0 : totalItems,
    );

    if (base.currentPage > base.totalPages) {
      return base.copyWith(currentPage: base.totalPages);
    }
    return base;
  }

  BreedsPaginationState onQueryChanged({
    required int pageSize,
    required int totalItems,
  }) {
    return buildState(
      currentPage: 1,
      pageSize: pageSize,
      totalItems: totalItems,
    );
  }

  List<BreedSummary> pageSlice({
    required List<BreedSummary> source,
    required BreedsPaginationState state,
  }) {
    if (source.isEmpty) return const [];
    final start = state.startIndex;
    final end = state.endExclusive;
    if (start >= source.length) return const [];
    return source.sublist(start, end);
  }
}
