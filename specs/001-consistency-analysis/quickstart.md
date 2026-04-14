# Quickstart: Execute Consistency Hardening Plan

## 1) Prepare environment
```bash
flutter pub get
```

## 2) Baseline validation
```bash
flutter analyze
flutter test
```

Save baseline outputs in:
- `specs/001-consistency-analysis/analyze-baseline.md`

## 3) Implement by priority
1. US1 Build Health (T001-T010)
2. US2 Service/Route Consistency (T011-T014)
3. US3 Auth Reset Completion (T015-T020)

## 4) Verify acceptance criteria
```bash
flutter analyze
flutter test
```

Manual verification required for SC-003:
- Forgot password success case
- Forgot password error case
- New password success and error handling

Document manual evidence in:
- `specs/001-consistency-analysis/auth-flow-evidence.md`

## 5) Final artifacts to produce
- `specs/001-consistency-analysis/analyze-final.md`
- `specs/001-consistency-analysis/legacy-decision.md`
- `specs/001-consistency-analysis/warnings-backlog.md`
