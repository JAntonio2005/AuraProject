# Consistency Notes

## Architecture Decisions Applied
- Kept `MaterialApp.routes` as primary route registry in `lib/main.dart`.
- Added complementary `onGenerateRoute: AppRouter.onGenerateRoute` fallback.
- Documented runtime API client ownership in `service-ownership.md`.
- Documented legacy files and criteria in `legacy-decision.md`.

## US1/US2/US3 Progress
- US1 (build health tasks): completed.
- US2 (service/routing consistency): completed.
- US3 implementation/code + automated checks: completed.
- US3 manual auth evidence: pending environment execution.
