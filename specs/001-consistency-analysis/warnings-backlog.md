# Warnings Backlog

## Source
- Command: `flutter analyze`
- Snapshot: 2026-04-08
- Total issues: 12 (warnings/info; 0 error-level diagnostics)

## Backlog Items

1. `lib/src/core/routes/services/auth_service.dart`
- Type: warning
- Issue: `_accessToken` unused field
- Suggested action: remove field or consume in session state logic

2. `lib/src/core/routes/services/auth_services_original.dart`
- Type: warning
- Issue: `_accessToken` unused field
- Suggested action: remove file or archive as legacy

3. `lib/src/core/routes/services/breeds_service.dart`
- Type: warning
- Issue: unused catch variable `e`
- Suggested action: remove variable or log mapped error

4. `lib/src/core/routes/services/history_service.dart`
- Type: info
- Issue: `print` in production code (multiple lines)
- Suggested action: replace with structured logging/debugPrint guarded by build mode

5. `lib/src/features/capture/presentation/pages/capture_page.dart`
- Type: info
- Issue: unnecessary braces in string interpolation
- Suggested action: simplify interpolation expression

6. `lib/src/features/collection/presentation/pages/collection_page.dart`
- Type: info
- Issue: `BuildContext` across async gap
- Suggested action: add mounted checks around post-await UI interactions

7. `lib/src/features/result/presentation/pages/breed_detail_page.dart`
- Type: info
- Issue: angle brackets in doc comment interpreted as HTML
- Suggested action: escape or rewrite doc comment text

8. `lib/src/features/result/presentation/pages/prediction_detail_page.dart`
- Type: info
- Issue: unnecessary `toList` in spread
- Suggested action: remove explicit `toList`

## Exit Criteria
- Keep 0 analyzer `error` diagnostics.
- Close backlog incrementally in next cleanup slice.
