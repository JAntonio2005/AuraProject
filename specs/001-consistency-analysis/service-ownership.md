# Service Ownership Decision

## Decision Summary
- Active runtime API client: `lib/src/core/routes/services/api_client.dart`
- Primary consumers in active app flows:
  - `lib/src/core/routes/services/auth_service.dart`
  - `lib/src/core/routes/services/predict_service.dart`
  - `lib/src/core/routes/services/history_service.dart`
  - `lib/src/core/routes/services/breeds_service.dart`
  - `lib/src/features/profile/presentation/pages/profile_page.dart`
- Navigation ownership:
  - Primary: `MaterialApp.routes` in `lib/main.dart`
  - Complementary fallback: `AppRouter.onGenerateRoute` in `lib/src/core/routes/app_router.dart`

## Files Migrated/Aligned in This Task
- `lib/main.dart`
  - Added `onGenerateRoute: AppRouter.onGenerateRoute` while preserving `routes` as primary registry.
- Service imports in active route-services layer were verified to already use local `api_client.dart`.

## Legacy Files Identified
- `lib/src/core/network/api_client.dart`
- `lib/src/features/auth/data/auth_repository.dart` (depends on core/network path)
- `lib/src/features/capture/data/ai_repository.dart` (depends on core/network path)
- `lib/src/core/di/providers.dart` (Riverpod path targeting core/network)

## Rationale
- Keeping a single active API client path reduces ambiguity and regression risk.
- Existing route-services already use `core/routes/services/api_client.dart`; minimizing refactor preserves behavior.
