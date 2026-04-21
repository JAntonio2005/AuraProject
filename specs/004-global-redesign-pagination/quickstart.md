# Quickstart: Global Redesign and Breeds Pagination

## 1. Preparation
1. Switch to branch `004-global-redesign-pagination`.
2. Ensure dependencies are installed:

```bash
flutter pub get
```

## 2. Baseline Validation
1. Run analyzer:

```bash
flutter analyze
```

2. Run tests:

```bash
flutter test
```

Expected baseline:
- zero analyzer `error` diagnostics
- test suite passes for affected areas

## 3. Visual Consistency Validation Flow
1. Launch app:

```bash
flutter run -d windows
```

2. Walkthrough main screens:
- login/register
- home
- collection
- community
- capture
- history
- profile

3. Verify per screen:
- context header clarity
- primary action prominence
- coherent spacing/rhythm
- loading/empty/error consistency

## 4. Collection Pagination Validation Flow
1. Open collection and verify paginator visibility.
2. Navigate next/previous pages and confirm page indicator updates.
3. Apply search/filter and verify pagination works on filtered results.
4. Validate boundary behavior:
- first page (no previous)
- last page (no next)
- empty result after query change

## 5. Non-Regression Checks
- Auth flow still reaches expected destinations.
- Main navigation keeps working among all primary sections.
- Breed detail opening from collection remains functional.

## 6. Evidence to Capture
- Visual consistency notes by screen.
- Pagination scenario matrix (normal + boundary cases).
- Analyzer/test output summaries.
- Requirement-task-evidence mapping artifact for closure.
