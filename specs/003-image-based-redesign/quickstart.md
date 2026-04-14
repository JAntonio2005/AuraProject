# Quickstart: Image-Based Global Redesign

## 1. Preconditions
1. Confirm branch is `003-image-based-redesign`.
2. Install/update dependencies:

```bash
flutter pub get
```

3. Confirm planning artifacts exist in `specs/003-image-based-redesign/`:
- `plan.md`
- `research.md`
- `data-model.md`
- `contracts/ui-redesign-contract.md`
- `quickstart.md`

## 2. Baseline Quality Gates (Before Implementation)
1. Run analyzer:

```bash
flutter analyze
```

2. Run tests:

```bash
flutter test
```

Expected baseline:
- Zero analyzer `error` diagnostics.
- Existing affected tests passing.

## 3. Phase 1 (MVP) Validation Workflow
1. Validate in-scope screens:
- Login/Register
- Home
- Collection
- Community
- Main navigation among them

2. Execute manual UX checks:
- Confirm visual continuity between each screen transition.
- Confirm primary action is recognizable within 5 seconds.
- Confirm hierarchy (header/content/actions) is clear.

3. Execute regression checks:
- Authentication flow still works end-to-end.
- Navigation does not break existing route outcomes.

4. Record measurable outcomes:
- `% users identifying primary action <= 5s`
- `% critical MVP tasks completed without assistance`
- `# of blocking functional regressions`

## 4. Phase 2 (Post-MVP) Validation Workflow
1. Validate extended scope screens:
- Camera
- History
- Profile
- Remaining secondary screens and view states

2. Verify state consistency in each modernized screen:
- `normal`
- `loading`
- `empty`
- `error`

3. Record measurable outcomes:
- `% global visual consistency rating >= 4/5`
- `% end-to-end critical tasks completed without assistance`
- `% relevant view states with consistent communication`

## 5. Evidence and Traceability
For each phase, keep the following evidence:
- Screen coverage matrix (in-scope, validated, pending)
- User evaluation sheet and aggregated metrics
- Functional regression notes (if any)
- Decision notes for deferred/non-compliant items

## 6. Completion Criteria
- Phase 1 closes only when all MVP criteria (PAC-001..PAC-004) are met.
- Phase 2 closes only when global criteria (PAC-005..PAC-008) are met.
- Any unmet criterion must remain open with explicit action owner and target phase.

## 7. Current Execution Snapshot (2026-04-14)
- `flutter analyze`: 0 errors, 0 warnings, 13 info diagnostics.
- `flutter test`: all tests passed.
- Setup and Foundational evidence artifacts created under `evidence/`.
- US1 screen implementation and phase evidence recorded.
- Remaining closure depends on SC-002/SC-004 measurement evidence and responsive/state validation artifacts.

## 8. Evidence (Esperado | Observado | Criterio | Resultado)

| Esperado | Observado | Criterio | Resultado |
|---|---|---|---|
| Snapshot de ejecucion actualizado con estado real | Se registraron resultados actuales de analyze/test y avance por fase | Debe reflejar estado verificable y accionable para siguiente iteracion | Cumple |
| Trazabilidad de pendientes de cierre | Se declara dependencia de SC-002/SC-004 y validacion responsive/estados | Debe evitar cierre prematuro de fase | Cumple |
