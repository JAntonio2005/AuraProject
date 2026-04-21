# Tasks: Image-Based Global Redesign

**Input**: Design documents from `/specs/003-image-based-redesign/`
**Prerequisites**: `plan.md` (required), `spec.md` (required), `research.md`, `data-model.md`, `contracts/ui-redesign-contract.md`, `quickstart.md`

**Tests**: No se requieren nuevas pruebas automatizadas por TDD en esta feature. Se incluyen tareas de validacion manual y ejecucion de `flutter analyze`/`flutter test` como verificacion de no regresion.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Preparar artefactos de control de alcance por fases y evidencia medible.

- [x] T001 Crear inventario vinculante por fase en specs/003-image-based-redesign/evidence/screen-inventory.md (Trace: FR-007, FR-011, SC-001, SC-003)
- [x] T002 Definir protocolo de medicion y muestreo en specs/003-image-based-redesign/evidence/measurement-protocol.md (Trace: FR-012, SC-002, SC-004)
- [x] T003 [P] Mapear referencia visual a patrones observables en specs/003-image-based-redesign/evidence/reference-mapping.md (Trace: FR-001, FR-002, SC-001)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Base visual compartida que bloquea la implementacion de todas las historias.

**CRITICAL**: No user story work can begin until this phase is complete.

- [x] T004 Actualizar tokens visuales globales en lib/src/core/theme/design_tokens.dart (Trace: FR-001, FR-004, SC-001)
- [x] T005 [P] Unificar tema global para superficies, tipografia y contraste en lib/src/core/theme/app_theme.dart (Trace: FR-002, FR-004, SC-001)
- [x] T006 [P] Estandarizar paneles/estados normal-loading-empty-error en lib/src/widgets/state_panels.dart (Trace: FR-006, SC-003, SC-006)
- [x] T007 [P] Estandarizar estilo de navegacion principal en lib/src/widgets/app_navigation_bar.dart (Trace: FR-002, FR-005, SC-006)
- [x] T008 Alinear metadatos de destinos en lib/src/core/routes/app_destinations.dart (Trace: FR-002, FR-005, SC-006)
- [x] T009 Crear matriz de cobertura visual por fase en specs/003-image-based-redesign/evidence/phase-coverage-matrix.md (Trace: FR-009, FR-011, SC-001, SC-003)

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Identidad visual consistente en toda la app (Priority: P1) 🎯 MVP

**Goal**: Aplicar el lenguaje visual inspirado en la imagen de referencia primero en MVP y luego en el resto de pantallas para cerrar consistencia global.

**Independent Test**: Recorrer MVP (login/registro, home, coleccion, comunidad) y luego post-MVP (Cámara `capture`, historial, perfil, recuperacion y nueva contrasena) verificando continuidad visual y ausencia de quiebres de estilo.

### Implementation for User Story 1

- [x] T010 [P] [US1] Redisenar identidad visual de login en lib/src/features/auth/presentation/pages/login_page.dart (Trace: FR-001, FR-007, SC-001)
- [x] T011 [P] [US1] Redisenar identidad visual de registro en lib/src/features/auth/presentation/pages/register_page.dart (Trace: FR-001, FR-007, SC-001)
- [x] T012 [P] [US1] Redisenar identidad visual de home en lib/src/features/home/presentation/pages/home_page.dart (Trace: FR-001, FR-007, SC-001)
- [x] T013 [P] [US1] Redisenar identidad visual de coleccion en lib/src/features/collection/presentation/pages/collection_page.dart (Trace: FR-001, FR-007, SC-001)
- [x] T014 [P] [US1] Redisenar identidad visual de comunidad en lib/src/features/community/presentation/pages/community_page.dart (Trace: FR-001, FR-007, SC-001)
- [x] T015 [US1] Verificar continuidad visual de navegacion MVP en lib/src/widgets/app_navigation_bar.dart (Trace: FR-002, FR-005, SC-006)
- [x] T016 [US1] Registrar evidencia PAC fase 1 en specs/003-image-based-redesign/evidence/phase-1-acceptance.md (Trace: FR-009, SC-001, SC-002)
- [x] T017 [P] [US1] Redisenar identidad visual de capture en lib/src/features/capture/presentation/pages/capture_page.dart (Trace: FR-001, FR-007, SC-003)
- [x] T018 [P] [US1] Redisenar identidad visual de historial en lib/src/features/history/presentation/pages/history_page.dart (Trace: FR-001, FR-007, SC-003)
- [x] T019 [P] [US1] Redisenar identidad visual de perfil en lib/src/features/profile/presentation/pages/profile_page.dart (Trace: FR-001, FR-007, SC-003)
- [x] T020 [P] [US1] Redisenar identidad visual de recuperacion en lib/src/features/auth/presentation/pages/forgot_password_page.dart (Trace: FR-001, FR-007, SC-003)
- [x] T021 [P] [US1] Redisenar identidad visual de nueva contrasena en lib/src/features/auth/presentation/pages/new_password_page.dart (Trace: FR-001, FR-007, SC-003)
- [x] T022 [US1] Registrar evidencia PAC fase 2 y cobertura 100% en specs/003-image-based-redesign/evidence/phase-2-acceptance.md (Trace: FR-009, FR-011, SC-003, SC-006)

**Checkpoint**: User Story 1 delivers continuidad visual MVP + post-MVP con evidencia de fase.

---

## Phase 4: User Story 2 - Lectura y accion claras en cada pantalla (Priority: P2)

**Goal**: Garantizar jerarquia visual clara y reconocimiento rapido de la accion principal en todas las pantallas en alcance.

**Independent Test**: Ejecutar tareas por pantalla y medir tiempo de identificacion de accion principal con muestra de usuarios evaluadores.

### Implementation for User Story 2

- [x] T023 [P] [US2] Definir reglas de jerarquia y accion principal en specs/003-image-based-redesign/evidence/primary-action-rules.md (Trace: FR-003, FR-004, SC-002)
- [x] T024 [US2] Ajustar jerarquia/CTA de login en lib/src/features/auth/presentation/pages/login_page.dart (Trace: FR-003, FR-004, SC-002)
- [x] T025 [P] [US2] Ajustar jerarquia/CTA de registro en lib/src/features/auth/presentation/pages/register_page.dart (Trace: FR-003, FR-004, SC-002)
- [x] T026 [P] [US2] Ajustar jerarquia/CTA de home en lib/src/features/home/presentation/pages/home_page.dart (Trace: FR-003, FR-004, SC-002)
- [x] T027 [P] [US2] Ajustar jerarquia/CTA de coleccion en lib/src/features/collection/presentation/pages/collection_page.dart (Trace: FR-003, FR-004, SC-002)
- [x] T028 [P] [US2] Ajustar jerarquia/CTA de comunidad en lib/src/features/community/presentation/pages/community_page.dart (Trace: FR-003, FR-004, SC-004)
- [x] T029 [P] [US2] Ajustar jerarquia/CTA de capture en lib/src/features/capture/presentation/pages/capture_page.dart (Trace: FR-003, FR-004, SC-004)
- [x] T030 [P] [US2] Ajustar jerarquia/CTA de historial en lib/src/features/history/presentation/pages/history_page.dart (Trace: FR-003, FR-004, SC-004)
- [x] T031 [P] [US2] Ajustar jerarquia/CTA de perfil en lib/src/features/profile/presentation/pages/profile_page.dart (Trace: FR-003, FR-004, SC-004)
- [x] T032 [US2] Estandarizar mensajes/acciones de estado vacio-error en lib/src/widgets/state_panels.dart (Trace: FR-006, FR-004, SC-006)
- [x] T033 [US2] Registrar mediciones de identificacion de accion principal en specs/003-image-based-redesign/evidence/us2-action-discovery-results.md (Trace: FR-012, SC-002, SC-004)

**Checkpoint**: User Story 2 delivers claridad de accion medible y consistente en todo el alcance.

---

## Phase 5: User Story 3 - Adaptacion visual entre dispositivos (Priority: P3)

**Goal**: Mantener legibilidad y usabilidad del nuevo lenguaje visual en tamanos small, medium y large.

**Independent Test**: Validar cada pantalla en tres tamanos de referencia y comprobar que no hay superposiciones ni perdida de accionabilidad.

### Implementation for User Story 3

- [x] T034 [P] [US3] Definir matriz de breakpoints y criterios visuales en specs/003-image-based-redesign/evidence/responsive-breakpoint-matrix.md (Trace: FR-008, SC-003)
- [x] T035 [P] [US3] Ajustar responsive de login en lib/src/features/auth/presentation/pages/login_page.dart (Trace: FR-008, SC-001)
- [x] T036 [P] [US3] Ajustar responsive de registro en lib/src/features/auth/presentation/pages/register_page.dart (Trace: FR-008, SC-001)
- [x] T037 [P] [US3] Ajustar responsive de home en lib/src/features/home/presentation/pages/home_page.dart (Trace: FR-008, SC-001)
- [x] T038 [P] [US3] Ajustar responsive de coleccion en lib/src/features/collection/presentation/pages/collection_page.dart (Trace: FR-008, SC-003)
- [x] T039 [P] [US3] Ajustar responsive de comunidad en lib/src/features/community/presentation/pages/community_page.dart (Trace: FR-008, SC-003)
- [x] T040 [P] [US3] Ajustar responsive de capture en lib/src/features/capture/presentation/pages/capture_page.dart (Trace: FR-008, SC-003)
- [x] T041 [P] [US3] Ajustar responsive de historial en lib/src/features/history/presentation/pages/history_page.dart (Trace: FR-008, SC-003)
- [x] T042 [P] [US3] Ajustar responsive de perfil en lib/src/features/profile/presentation/pages/profile_page.dart (Trace: FR-008, SC-003)
- [x] T043 [P] [US3] Ajustar responsive de recuperacion en lib/src/features/auth/presentation/pages/forgot_password_page.dart (Trace: FR-008, SC-003)
- [x] T044 [P] [US3] Ajustar responsive de nueva contrasena en lib/src/features/auth/presentation/pages/new_password_page.dart (Trace: FR-008, SC-003)
- [x] T045 [US3] Ajustar navegacion principal para tap targets por tamano en lib/src/widgets/app_navigation_bar.dart (Trace: FR-008, FR-002, SC-006)
- [x] T046 [US3] Registrar validacion responsive por fase en specs/003-image-based-redesign/evidence/us3-responsive-validation.md (Trace: FR-012, SC-003, SC-004)

**Checkpoint**: User Story 3 delivers adaptacion visual validada en small/medium/large.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Cierre de calidad, trazabilidad PAC/SC y evidencia final.

- [x] T047 [P] Ejecutar flutter analyze y registrar resultado en specs/003-image-based-redesign/evidence/analyze-final.md (Trace: FR-005, SC-006)
- [x] T048 [P] Ejecutar flutter test y registrar resultado en specs/003-image-based-redesign/evidence/test-final.md (Trace: FR-005, SC-006)
- [x] T049 Consolidar matriz FR/SC/PAC por fase en specs/003-image-based-redesign/evidence/traceability-matrix.md (Trace: FR-009, FR-011, SC-001, SC-006)
- [x] T050 Consolidar reporte final de cierre por fase en specs/003-image-based-redesign/evidence/final-phase-closure.md (cierre documental final del feature) (Trace: FR-009, SC-001, SC-003, SC-006)
- [x] T051 Registrar control operativo de desvio ACCEPT/REJECT en specs/003-image-based-redesign/evidence/scope-creep-log.md (Trace: FR-010, FR-011)
- [x] T052 Actualizar resultados de validacion en specs/003-image-based-redesign/quickstart.md (Trace: FR-009, SC-001, SC-006)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies - can start immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1 completion - blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2 completion.
- **Phase 4 (US2)**: Depends on Phase 2 completion (recommended after MVP baseline from US1 to reduce rework).
- **Phase 5 (US3)**: Depends on Phase 2 completion (recommended after core screen updates from US1).
- **Phase 6 (Polish)**: Depends on completion of desired user stories.

### User Story Dependencies

- **US1 (P1)**: Can start after Foundational; no dependency on US2/US3.
- **US2 (P2)**: Can start after Foundational; validates best when US1 visual baseline is in place.
- **US3 (P3)**: Can start after Foundational; validates best when US1 updates are applied.

### Within Each User Story

- Baseline shared styles first (Phase 2)
- Screen-level implementation next
- Phase evidence and acceptance validation last

### Parallel Opportunities

- Setup in parallel: `T003` with `T001`/`T002`
- Foundational in parallel: `T005`, `T006`, `T007` after `T004`
- US1 MVP screens in parallel: `T010`..`T014`
- US1 post-MVP screens in parallel: `T017`..`T019`
- US2 screen refinements in parallel: `T025`..`T031`
- US3 responsive refinements in parallel: `T035`..`T044`
- Validation commands in parallel where feasible: `T047` and `T048`

---

## Parallel Example: User Story 1

```bash
# MVP screen updates in parallel:
Task T010 - lib/src/features/auth/presentation/pages/login_page.dart
Task T011 - lib/src/features/auth/presentation/pages/register_page.dart
Task T012 - lib/src/features/home/presentation/pages/home_page.dart
Task T013 - lib/src/features/collection/presentation/pages/collection_page.dart
Task T014 - lib/src/features/community/presentation/pages/community_page.dart

# Post-MVP screen updates in parallel:
Task T017 - lib/src/features/capture/presentation/pages/capture_page.dart
Task T018 - lib/src/features/history/presentation/pages/history_page.dart
Task T019 - lib/src/features/profile/presentation/pages/profile_page.dart
```

---

## Parallel Example: User Story 2

```bash
# Hierarchy/CTA refinement by module in parallel:
Task T026 - lib/src/features/home/presentation/pages/home_page.dart
Task T027 - lib/src/features/collection/presentation/pages/collection_page.dart
Task T028 - lib/src/features/community/presentation/pages/community_page.dart
Task T029 - lib/src/features/capture/presentation/pages/capture_page.dart
Task T030 - lib/src/features/history/presentation/pages/history_page.dart
Task T031 - lib/src/features/profile/presentation/pages/profile_page.dart
```

---

## Parallel Example: User Story 3

```bash
# Responsive adjustments in parallel after breakpoint matrix:
Task T038 - lib/src/features/collection/presentation/pages/collection_page.dart
Task T039 - lib/src/features/community/presentation/pages/community_page.dart
Task T040 - lib/src/features/capture/presentation/pages/capture_page.dart
Task T041 - lib/src/features/history/presentation/pages/history_page.dart
Task T042 - lib/src/features/profile/presentation/pages/profile_page.dart
```

---

## Implementation Strategy

### MVP First (Phase 1 + Phase 2 + US1 MVP slice)

1. Complete Setup (Phase 1)
2. Complete Foundational (Phase 2)
3. Complete US1 MVP tasks (`T010`..`T016`)
4. Validate PAC phase 1 before continuing

### Incremental Delivery

1. Deliver MVP consistency baseline (US1 MVP)
2. Extend consistency to remaining modules (US1 post-MVP)
3. Improve hierarchy and action clarity (US2)
4. Finalize responsive adaptation (US3)
5. Close evidence and quality gates (Phase 6)

### Parallel Team Strategy

1. Team aligns on Foundational tasks
2. Split by modules per story:
   - Dev A: Auth + Home
   - Dev B: Collection + Community
   - Dev C: Capture + History + Profile
3. Consolidate evidence owner for PAC/SC closure docs

---

## Notes

- `[P]` tasks = different files, minimal cross-dependency risk.
- `[US1]/[US2]/[US3]` labels map traceability to spec user stories.
- Cada tarea incluye trazabilidad explicita FR/SC en su descripcion.
- Granularidad 1:1 aplicada por pantalla/archivo real para tareas de implementacion.
- Mantener fuera de alcance: sin cambios de logica de negocio, infraestructura o scripts.
