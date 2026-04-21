# Non-Regression Plan (T014)

## Scope
- Auth flow outcomes
- Main navigation routing behavior
- Shared visual style continuity
- Responsive readability in compact and wide layouts
- Collection-to-detail navigation continuity

## Baseline Commands
- `flutter analyze`
- `flutter test`

## Manual Non-Regression Paths
1. Auth path:
- login
- register
- guest entry (if available)

2. Navigation path:
- collection -> capture -> community -> history -> profile
- return transitions keep expected selected destination

3. Visual path:
- verify shared spacing/radius rhythm on all main screens
- verify loading/empty/error panels remain legible and actionable

4. Responsive path:
- compact width (<380)
- regular width
- wide width (>=900)

5. Collection continuity path:
- open breed detail from list item
- return keeps stable UI state without navigation break

## Exit Criteria
- No analyzer `error` diagnostics
- Affected tests pass
- No blocking regressions in auth/nav/style/responsive paths
