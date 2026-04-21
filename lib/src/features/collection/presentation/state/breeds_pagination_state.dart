class BreedsPaginationState {
  final int currentPage;
  final int pageSize;
  final int totalItems;

  const BreedsPaginationState({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
  });

  int get totalPages {
    if (totalItems <= 0) return 1;
    final pages = (totalItems / pageSize).ceil();
    return pages < 1 ? 1 : pages;
  }

  bool get hasPreviousPage => currentPage > 1;

  bool get hasNextPage => currentPage < totalPages;

  int get startIndex => (currentPage - 1) * pageSize;

  int get endExclusive {
    final end = startIndex + pageSize;
    return end > totalItems ? totalItems : end;
  }

  BreedsPaginationState copyWith({
    int? currentPage,
    int? pageSize,
    int? totalItems,
  }) {
    return BreedsPaginationState(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}
