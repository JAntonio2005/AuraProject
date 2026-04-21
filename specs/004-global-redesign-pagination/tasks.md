# Tasks: Global Redesign and Breeds Pagination

**Input**: Design documents from `/specs/004-global-redesign-pagination/`  
**Prerequisites**: `plan.md` (required), `spec.md` (required), `research.md`, `data-model.md`, `contracts/ui-consistency-and-pagination-contract.md`, `quickstart.md`

**Tests**: Se incluyen tareas de validación visual/funcional y no-regresión porque el alcance del feature exige verificación explícita de continuidad.

**Organization**: Tasks are grouped by user story and, dentro de cada historia, por pantalla o módulo visual.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Puede ejecutarse en paralelo (archivos distintos, sin dependencia de tareas incompletas)
- **[Story]**: Referencia de historia (`US1`, `US2`, `US3`) solo en fases de historias
- Cada tarea incluye ruta de archivo exacta

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Definir base documental y matriz de alcance visual antes de tocar módulos.

- [ ] T001 Consolidar inventario de pantallas y estados visuales en `specs/004-global-redesign-pagination/evidence/screen-scope-matrix.md`
- [ ] T002 Definir checklist operativo de consistencia por pantalla en `specs/004-global-redesign-pagination/evidence/visual-consistency-checklist.md`
- [ ] T003 [P] Crear matriz de escenarios de paginación y búsqueda en `specs/004-global-redesign-pagination/evidence/pagination-scenarios-matrix.md`
- [ ] T004 [P] Registrar baseline visual y funcional previo al cambio en `specs/004-global-redesign-pagination/evidence/baseline-before-redesign.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Base global de estilos/componentes compartidos y reglas de layout.

**⚠️ CRITICAL**: Ninguna tarea de historias inicia hasta completar esta fase.

### Componentes compartidos y diseño visual global

- [x] T005 Refinar tokens visuales globales para consistencia de spacing/rhythm en `lib/src/core/theme/design_tokens.dart`
- [x] T006 [P] Ajustar tema global para jerarquía y superficies consistentes en `lib/src/core/theme/app_theme.dart`
- [x] T007 [P] Estandarizar paneles de estado (`loading/empty/error`) para todos los módulos en `lib/src/widgets/state_panels.dart`
- [x] T008 [P] Normalizar comportamiento visual de barra de navegación compartida en `lib/src/widgets/app_navigation_bar.dart`

### Layout/shared rules

- [x] T009 Definir utilidades de layout reutilizables para pantallas principales en `lib/src/widgets/layout/app_screen_scaffold.dart`
- [x] T010 [P] Definir contrato de composición visual por pantalla en `specs/004-global-redesign-pagination/contracts/ui-consistency-and-pagination-contract.md`

### Paginación compartida (sin backend)

- [x] T011 Crear estado de paginación de colección en `lib/src/features/collection/presentation/state/breeds_pagination_state.dart`
- [x] T012 Crear componente visual de controles de paginación en `lib/src/features/collection/presentation/widgets/breeds_paginator.dart`

### Búsqueda + paginación coherente

- [x] T013 Integrar reglas de coherencia query->page en `lib/src/features/collection/presentation/controllers/collection_pagination_controller.dart`

### Pruebas base / no-regresión de infraestructura

- [x] T014 [P] Documentar plan de no-regresión global (auth/nav/styles/responsive) en `specs/004-global-redesign-pagination/evidence/non-regression-plan.md`

**Checkpoint**: Base global lista; historias habilitadas.

---

## Phase 3: User Story 1 - Experiencia Visual Consistente Global (Priority: P1) 🎯 MVP

**Goal**: Unificar diseño visual y layout en todas las pantallas principales usando base compartida.

**Independent Test**: Recorrer auth/home/collection/community/capture/history/profile y verificar estructura visual homogénea y estados consistentes.

### Tests for User Story 1 (visual + funcional)

- [x] T015 [P] [US1] Crear checklist de validación visual por pantalla en `specs/004-global-redesign-pagination/evidence/us1-visual-walkthrough.md`
- [x] T016 [P] [US1] Crear matriz de validación de estados (`normal/loading/empty/error`) en `specs/004-global-redesign-pagination/evidence/us1-state-coverage.md`

### Módulo Auth (diseño visual + layout)

- [ ] T017 [P] [US1] Alinear layout y jerarquía visual de login a patrón global en `lib/src/features/auth/presentation/pages/login_page.dart`
- [ ] T018 [P] [US1] Alinear layout y jerarquía visual de registro a patrón global en `lib/src/features/auth/presentation/pages/register_page.dart`

### Módulo Home (diseño visual + layout)

- [ ] T021 [US1] Alinear composición visual y zona de acción principal en `lib/src/features/home/presentation/pages/home_page.dart`

### Módulo Collection (solo consistencia visual en esta historia)

- [ ] T022 [US1] Reforzar composición visual base de colección sin alterar lógica de datos en `lib/src/features/collection/presentation/pages/collection_page.dart`

### Módulo Community (diseño visual + layout)

- [ ] T023 [US1] Alinear composición visual de comunidad con patrón global en `lib/src/features/community/presentation/pages/community_page.dart`

### Módulo Capture (diseño visual + layout)

- [ ] T024 [US1] Alinear composición visual de captura con patrón global en `lib/src/features/capture/presentation/pages/capture_page.dart`

### Módulo History (diseño visual + layout)

- [ ] T025 [US1] Alinear composición visual de historial con patrón global en `lib/src/features/history/presentation/pages/history_page.dart`

### Módulo Profile (diseño visual + layout)

- [ ] T026 [US1] Alinear composición visual de perfil con patrón global en `lib/src/features/profile/presentation/pages/profile_page.dart`

### Validación US1

- [x] T027 [US1] Ejecutar walkthrough visual completo y registrar resultado en `specs/004-global-redesign-pagination/evidence/us1-visual-walkthrough.md`
- [x] T028 [US1] Consolidar evidencia de consistencia por pantalla en `specs/004-global-redesign-pagination/evidence/us1-consistency-snapshot.md`

**Checkpoint**: US1 funcional de forma independiente.

---

## Phase 4: User Story 2 - Navegación de Razas Escalable con Paginador (Priority: P2)

**Goal**: Implementar paginación en colección con coherencia de búsqueda/filtro sin cambios de backend.

**Independent Test**: Navegar páginas en colección con y sin búsqueda activa, incluyendo bordes (primera/última/resultado vacío).

### Tests for User Story 2 (funcional + no-regresión lógica)

- [x] T029 [P] [US2] Definir casos de prueba funcional de paginación en `specs/004-global-redesign-pagination/evidence/us2-pagination-test-cases.md`
- [x] T030 [P] [US2] Definir casos de prueba de búsqueda+paginación en `specs/004-global-redesign-pagination/evidence/us2-search-pagination-test-cases.md`

### Módulo Collection - Paginación

- [x] T031 [US2] Integrar estado de paginación en flujo de listado de razas en `lib/src/features/collection/presentation/pages/collection_page.dart`
- [x] T032 [US2] Integrar controles de paginación (prev/next/indicador de página) en `lib/src/features/collection/presentation/pages/collection_page.dart`
- [x] T033 [P] [US2] Ajustar widget de paginador para estados de borde en `lib/src/features/collection/presentation/widgets/breeds_paginator.dart`

### Módulo Collection - Búsqueda y filtros

- [x] T034 [US2] Conectar búsqueda activa con recálculo de páginas válidas en `lib/src/features/collection/presentation/controllers/collection_pagination_controller.dart`
- [x] T035 [US2] Resetear página a primer bloque válido al cambiar query/filtro en `lib/src/features/collection/presentation/pages/collection_page.dart`
- [x] T036 [P] [US2] Preservar apertura de detalle desde resultados paginados en `lib/src/features/collection/presentation/pages/collection_page.dart`

### Módulo Collection - Layout orientado a claridad

- [x] T037 [US2] Reordenar secciones de colección para jerarquía (contexto, búsqueda, lista, paginador) en `lib/src/features/collection/presentation/pages/collection_page.dart`
- [x] T038 [US2] Optimizar legibilidad de bloques de contenido por página en `lib/src/features/collection/presentation/pages/collection_page.dart`

### Validación US2

- [x] T039 [US2] Ejecutar validación funcional de paginación y documentar resultados en `specs/004-global-redesign-pagination/evidence/us2-pagination-validation.md`
- [x] T040 [US2] Ejecutar validación de búsqueda+paginación y documentar resultados en `specs/004-global-redesign-pagination/evidence/us2-search-pagination-validation.md`

**Checkpoint**: US2 funcional de forma independiente.

---

## Phase 5: User Story 3 - Disposición de Elementos Orientada a Usabilidad (Priority: P3)

**Goal**: Mejorar distribución de elementos por módulo con foco en legibilidad y acción principal, manteniendo responsividad.

**Independent Test**: Validar tareas clave en anchos compactos y amplios sin pérdida de legibilidad ni ruptura de navegación/estilos.

### Tests for User Story 3 (visual + responsividad)

- [x] T041 [P] [US3] Definir matriz de validación responsive por pantalla en `specs/004-global-redesign-pagination/evidence/us3-responsive-test-matrix.md`
- [x] T042 [P] [US3] Definir checklist de legibilidad y prominencia de acción en `specs/004-global-redesign-pagination/evidence/us3-layout-usability-checklist.md`

### Ajustes de layout por módulo visual (sin alterar lógica de negocio)

- [x] T043 [P] [US3] Ajustar distribución final de elementos en auth (login) en `lib/src/features/auth/presentation/pages/login_page.dart`
- [x] T044 [P] [US3] Ajustar distribución final de elementos en auth (register) en `lib/src/features/auth/presentation/pages/register_page.dart`
- [x] T045 [P] [US3] Ajustar distribución final de elementos en home en `lib/src/features/home/presentation/pages/home_page.dart`
- [x] T046 [P] [US3] Ajustar distribución final de elementos en colección en `lib/src/features/collection/presentation/pages/collection_page.dart`
- [x] T047 [P] [US3] Ajustar distribución final de elementos en comunidad en `lib/src/features/community/presentation/pages/community_page.dart`
- [x] T048 [P] [US3] Ajustar distribución final de elementos en captura en `lib/src/features/capture/presentation/pages/capture_page.dart`
- [x] T049 [P] [US3] Ajustar distribución final de elementos en historial en `lib/src/features/history/presentation/pages/history_page.dart`
- [x] T050 [P] [US3] Ajustar distribución final de elementos en perfil en `lib/src/features/profile/presentation/pages/profile_page.dart`

### No-regresión UX transversal

- [x] T051 [US3] Validar que navegación principal no se rompe tras ajustes de layout en `specs/004-global-redesign-pagination/evidence/us3-navigation-non-regression.md`
- [x] T052 [US3] Validar que estilos compartidos y responsividad se mantienen en `specs/004-global-redesign-pagination/evidence/us3-style-responsive-non-regression.md`

### Validación US3

- [x] T053 [US3] Consolidar evidencia de usabilidad visual por pantalla en `specs/004-global-redesign-pagination/evidence/us3-layout-usability-validation.md`

**Checkpoint**: US3 funcional de forma independiente.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Cierre técnico, validación integral y trazabilidad final.

- [x] T054 [P] Ejecutar `flutter analyze` y registrar salida en `specs/004-global-redesign-pagination/evidence/analyze-final.md`
- [x] T055 [P] Ejecutar `flutter test` y registrar salida en `specs/004-global-redesign-pagination/evidence/test-final.md`
- [x] T056 Ejecutar validación manual completa de quickstart en `specs/004-global-redesign-pagination/evidence/quickstart-validation.md`
- [x] T057 Consolidar matriz requirement->task->evidence en `specs/004-global-redesign-pagination/evidence/traceability-matrix.md`
- [x] T058 Consolidar reporte final de no-regresión (auth/nav/styles/responsive/collection) en `specs/004-global-redesign-pagination/evidence/non-regression-final.md`
- [x] T059 Actualizar snapshot final y criterios de cierre en `specs/004-global-redesign-pagination/evidence/final-closure.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: sin dependencias.
- **Phase 2 (Foundational)**: depende de completar Phase 1; bloquea historias.
- **Phase 3 (US1)**: depende de completar Phase 2.
- **Phase 4 (US2)**: depende de Phase 2 y de consistencia visual base de colección (T022).
- **Phase 5 (US3)**: depende de Phase 2 y se recomienda después de US1+US2 para estabilizar layout final.
- **Phase 6 (Polish)**: depende de completar las historias objetivo.

### User Story Dependencies

- **US1 (P1)**: inicia tras Foundational; no depende de otras historias.
- **US2 (P2)**: inicia tras Foundational; requiere base visual de colección (T022) para evitar retrabajo.
- **US3 (P3)**: inicia tras Foundational; depende de que US1/US2 estén funcionales para validar no-regresión integral.

### Task-Level Critical Dependencies

- T011 depende de T005 y T006.
- T012 depende de T011.
- T013 depende de T011 y T012.
- T022 depende de T005, T006, T009.
- T031 depende de T011, T012, T013, T022.
- T032 depende de T012 y T031.
- T034 depende de T013 y T031.
- T035 depende de T034.
- T037 depende de T031 y T032.
- T046 depende de T037 y T038.
- T051 y T052 dependen de T043-T050.
- T054-T059 dependen de T027, T040, T053.

### Parallel Opportunities

- Setup paralelizable: T003, T004.
- Foundational paralelizable: T006, T007, T008, T010, T014.
- US1 paralelizable por pantalla: T017, T018, T021, T023, T024, T025, T026.
- US2 paralelizable: T029, T030, T033, T036.
- US3 paralelizable por módulo: T043-T050.
- Cierre paralelizable: T054, T055.

---

## Parallel Example: User Story 1

```bash
# Ajustes por módulo/pantalla en paralelo
T017 login_page.dart
T018 register_page.dart
T021 home_page.dart
T023 community_page.dart
T024 capture_page.dart
T025 history_page.dart
T026 profile_page.dart
```

## Parallel Example: User Story 2

```bash
# Casos de validación y componentes auxiliares en paralelo
T029 us2-pagination-test-cases.md
T030 us2-search-pagination-test-cases.md
T033 breeds_paginator.dart
T036 collection_page.dart (detalle desde paginado)
```

## Parallel Example: User Story 3

```bash
# Ajustes de layout final por pantalla en paralelo
T043 login_page.dart
T045 home_page.dart
T046 collection_page.dart
T047 community_page.dart
T048 capture_page.dart
T049 history_page.dart
T050 profile_page.dart
```

---

## Implementation Strategy

### MVP First (US1)

1. Completar Setup (Phase 1).
2. Completar Foundational (Phase 2).
3. Completar US1 (Phase 3).
4. Validar US1 con T027-T028 antes de mover paginación.

### Incremental Delivery

1. US1: consistencia visual global por módulos.
2. US2: paginación + búsqueda coherente en colección sin backend.
3. US3: layout/usabilidad + no-regresión responsive.
4. Polish: analyze/test/trazabilidad/cierre.

### Guardrails de Alcance

1. Mantener lógica existente siempre que sea posible.
2. Evitar cambios backend mientras no estén justificados por `spec.md`.
3. Priorizar componentes compartidos antes de ajustes por pantalla.
4. No cerrar tareas sin evidencia visual y funcional asociada.
