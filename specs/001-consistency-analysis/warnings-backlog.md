# Warnings Backlog

## Source
- Command: `flutter analyze`
- Snapshot: 2026-04-14
- Total issues: 15 (info; 0 warning, 0 error-level diagnostics)

## Backlog Items

1. `lib/src/core/routes/services/history_service.dart`
- Type: info
- Issue: `print` in production code (multiple lines)
- Suggested action: replace with structured logging/debugPrint guarded by build mode

2. `lib/src/features/capture/presentation/pages/capture_page.dart`
- Type: info
- Issue: unnecessary braces in string interpolation
- Suggested action: simplify interpolation expression

3. `lib/src/features/collection/presentation/pages/collection_page.dart`
- Type: info
- Issue: `BuildContext` across async gap
- Suggested action: add mounted checks around post-await UI interactions

4. `lib/src/features/institutions/presentation/pages/institutions_page.dart`
- Type: info
- Issue: deprecated `Radio` API (`groupValue`/`onChanged`) en multiples ubicaciones
- Suggested action: migrar a `RadioGroup` para eliminar deprecations y mantener compatibilidad futura

5. `lib/src/features/result/presentation/pages/breed_detail_page.dart`
- Type: info
- Issue: angle brackets in doc comment interpreted as HTML
- Suggested action: escape or rewrite doc comment text

6. `lib/src/features/result/presentation/pages/prediction_detail_page.dart`
- Type: info
- Issue: unnecessary `toList` in spread
- Suggested action: remove explicit `toList`

## Exit Criteria
- Keep 0 analyzer `error` diagnostics.
- Close backlog incrementally in next cleanup slice.
