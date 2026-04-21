# Quickstart: Modern App Visual Refresh

## 1. Checkout and Environment
1. Switch to branch `002-modern-app-design`.
2. Install dependencies:

```bash
flutter pub get
```

## 2. Static Validation
1. Run analyzer:

```bash
flutter analyze
```

2. Run tests:

```bash
flutter test
```

Expected: zero analyzer `error` diagnostics and all tests passing.

## 3. Manual UX Validation Flow
1. Launch app:

```bash
flutter run -d windows
```

2. Validate global navigation:
- Open each section: Razas, Camara, Comunidad, Historial, Perfil.
- Confirm selected state is visible and labels are readable.
- Confirm transitions do not break current auth/session flow.

3. Validate visual consistency:
- Compare typography hierarchy and spacing across all main sections.
- Confirm cards/buttons/radius patterns appear coherent.
- Confirm no clipping or overflow at narrow window width.

## 4. Community Baseline Validation
- Enter Comunidad and verify content cards render with expected titles and icons.
- Verify navigation back-and-forth keeps active tab state coherent.

## 5. Evidence Capture
- Capture before/after screenshots for each main section.
- Record analyzer/test outputs in feature docs if changed.

## 6. UX Metrics Execution
1. Run protocol in `measurement-protocol.md`.
2. Register outcomes in `measurement-results.md`.
3. Interpret status using pass/fail/no-conclusive criteria from protocol.

## 7. Responsive and Auth/Nav Regression
1. Document responsive checks in `responsive-validation.md`.
2. Document auth/nav regression checks in `auth-nav-regression.md`.

## 8. Analyzer Backlog (Gate C)
1. If `flutter analyze` returns unresolved issues, update `warnings-backlog.md`.
2. Keep `analyze-final.md`, `test-final.md`, and `final-ux-summary.md` aligned.
