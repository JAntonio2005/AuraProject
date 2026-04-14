# Legacy Decision Log

## Criteria Applied
- If a file is not in the active runtime path, either:
  - retire it, or
  - keep it temporarily as legacy with explicit documentation.

## Decision by File

### Kept as Legacy (Documented)
- `lib/src/core/network/api_client.dart`
  - Reason: referenced by legacy repository/DI files, not by main active UI route-services flow.
- `lib/src/features/auth/data/auth_repository.dart`
  - Reason: old repository layer tied to legacy network client.
- `lib/src/features/capture/data/ai_repository.dart`
  - Reason: old repository layer tied to legacy network client.
- `lib/src/core/di/providers.dart`
  - Reason: Riverpod DI layer is not wired into `main.dart` app runtime.

### Active (Not Legacy)
- `lib/src/core/routes/services/api_client.dart`
- `lib/src/core/routes/services/auth_service.dart`
- `lib/src/core/routes/services/predict_service.dart`
- `lib/src/core/routes/services/history_service.dart`
- `lib/src/core/routes/services/breeds_service.dart`

## Next Action
- In a dedicated cleanup slice, remove or archive legacy network/DI files after confirming no runtime references remain.
