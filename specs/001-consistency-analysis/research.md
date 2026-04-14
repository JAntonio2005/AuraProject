# Research: Flutter Project Consistency Hardening

## Decision 1: Keep `MaterialApp.routes` as primary navigation source
- Decision: Preserve `MaterialApp.routes` in `lib/main.dart` as primary route registry.
- Rationale: Current app already relies on named routes across multiple features; minimizing risk aligns with constitution simplicity principle.
- Alternatives considered:
  - Full migration to `onGenerateRoute`: rejected due to higher migration risk and low immediate value.
  - Third-party router (go_router/auto_route): rejected for scope expansion.

## Decision 2: Consolidate runtime HTTP usage around a single active ApiClient path
- Decision: Use one documented runtime API client path and mark/remove parallel legacy paths.
- Rationale: Duplicate service layers (`core/network` vs `core/routes/services`) create ambiguity and regressions.
- Alternatives considered:
  - Keep both permanently: rejected due to maintenance overhead.
  - Rewrite all services from scratch: rejected due to refactor churn.

## Decision 3: Implement real forgot/reset password flow in existing auth pages
- Decision: Replace TODO/mock delays in forgot/new password pages with real backend calls.
- Rationale: Directly satisfies FR-005 and SC-003 with user-visible value.
- Alternatives considered:
  - Keep mock flow: rejected because it fails acceptance criteria.
  - Build a brand-new auth module: rejected due to scope.

## Decision 4: Verification strategy
- Decision: Validate with `flutter analyze`, `flutter test`, and manual evidence for success/error auth reset scenarios.
- Rationale: Covers technical and behavioral acceptance criteria.
- Alternatives considered:
  - Manual-only validation: rejected because it weakens repeatability.
  - Tests-only validation: rejected because backend environment behaviors still require manual evidence.
