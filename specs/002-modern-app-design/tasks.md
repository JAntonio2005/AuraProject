# Tasks: Modern App Visual Refresh

**Input**: Design documents from `specs/002-modern-app-design/`  
**Prerequisites**: `plan.md` (required), `spec.md` (required), `research.md`, `data-model.md`, `contracts/ui-navigation-contract.md`, `quickstart.md`

**Tests**: No se solicito crear nuevos tests automatizados; se incluyen tareas de validacion (`flutter analyze`, `flutter test`) y pruebas manuales UX definidas en quickstart.

**Organization**: Tasks grouped by user story so each story can be implemented and validated independently.

## Closure Status

- Estado unico de cierre: **PARCIAL (pendiente de cierre formal de SC-002 y SC-003 por muestra insuficiente)**.
- Cierre tecnico: implementacion y validaciones tecnicas completadas.
- Cierre de metricas UX: pendiente de corrida con muestra valida (n>=5, objetivo n=10).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: User story reference (`US1`, `US2`, `US3`)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Preparar baseline de diseno y evidencia para medir la mejora visual.

- [X] T001 Crear baseline visual con capturas y notas en `specs/002-modern-app-design/ui-baseline.md`.
- [X] T002 Verificar quickstart actual y registrar brechas iniciales en `specs/002-modern-app-design/quickstart-review.md` (sin actualizar `quickstart.md` en esta fase).
- [X] T003 [P] Registrar checklist de evaluacion visual interna en `specs/002-modern-app-design/ux-evaluation-sheet.md`.
- [X] T034 [P] Definir protocolo de medicion para SC-002 y SC-003 en `specs/002-modern-app-design/measurement-protocol.md` con tamano de muestra, instrumento, formula, umbral y criterio de aprobacion/rechazo.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Definir cimientos de navegacion y estilo para evitar duplicacion entre pantallas.

**CRITICAL**: Ninguna historia de usuario inicia hasta completar esta fase.

- [X] T004 Crear tokens visuales centralizados en `lib/src/core/theme/design_tokens.dart`.
- [X] T005 Crear modelo compartido de destino de navegacion en `lib/src/core/models/navigation_destination.dart`.
- [X] T006 Crear barra de navegacion reutilizable en `lib/src/widgets/app_navigation_bar.dart`.
- [X] T007 Definir lista canonica de destinos y rutas en `lib/src/core/routes/app_destinations.dart`.
- [X] T008 Alinear registro de rutas principales con destinos canonicos en `lib/main.dart`.

**Checkpoint**: Fundacion lista; historias de usuario pueden avanzar.

---

## Phase 3: User Story 1 - Navegacion moderna y clara (Priority: P1) 🎯 MVP

**Goal**: Navegacion principal unificada, moderna y consistente en todas las secciones.

**Independent Test**: Navegar entre Razas, Camara, Comunidad, Historial y Perfil con estado activo correcto y sin rutas rotas.

### Implementation for User Story 1

- [X] T009 [P] [US1] Reemplazar navegacion local por componente compartido en `lib/src/features/collection/presentation/pages/collection_page.dart`.
- [X] T010 [P] [US1] Reemplazar navegacion local por componente compartido en `lib/src/features/capture/presentation/pages/capture_page.dart`.
- [X] T011 [P] [US1] Reemplazar navegacion local por componente compartido en `lib/src/features/history/presentation/pages/history_page.dart`.
- [X] T012 [P] [US1] Reemplazar navegacion local por componente compartido en `lib/src/features/profile/presentation/pages/profile_page.dart`.
- [X] T013 [P] [US1] Integrar componente compartido en `lib/src/features/community/presentation/pages/community_page.dart`.
- [X] T014 [US1] Validar indices, labels cortos y selected state de 5 destinos en `lib/src/widgets/app_navigation_bar.dart`.
- [X] T015 [US1] Documentar resultado de walkthrough de navegacion principal en `specs/002-modern-app-design/nav-validation.md`.

**Checkpoint**: US1 funcional y validable de forma independiente.

---

## Phase 4: User Story 2 - Pantallas con estilo visual cohesivo (Priority: P2)

**Goal**: Coherencia visual moderna en pantallas principales con tokenizacion reutilizable.

**Independent Test**: Comparar visualmente pantallas principales y confirmar consistencia de spacing, radios, jerarquia y estados.

### Implementation for User Story 2

- [X] T016 [P] [US2] Aplicar `design_tokens.dart` a espaciados/radios en `lib/src/features/collection/presentation/pages/collection_page.dart`.
- [X] T017 [P] [US2] Aplicar `design_tokens.dart` a espaciados/radios en `lib/src/features/capture/presentation/pages/capture_page.dart`.
- [X] T018 [P] [US2] Aplicar `design_tokens.dart` a espaciados/radios en `lib/src/features/history/presentation/pages/history_page.dart`.
- [X] T019 [P] [US2] Aplicar `design_tokens.dart` a espaciados/radios en `lib/src/features/profile/presentation/pages/profile_page.dart`.
- [X] T020 [P] [US2] Aplicar `design_tokens.dart` y patrones de tarjetas en `lib/src/features/community/presentation/pages/community_page.dart`.
- [X] T021 [US2] Ajustar tema global para reforzar jerarquia visual moderna en `lib/src/core/theme/app_theme.dart`.
- [X] T022 [US2] Estandarizar estilos de estados (loading/error/empty) en `lib/src/widgets/state_panels.dart` y adoptar en `lib/src/features/history/presentation/pages/history_page.dart`.
- [X] T023 [US2] Registrar comparativo visual antes/despues en `specs/002-modern-app-design/visual-consistency-report.md`.

**Checkpoint**: US2 funcional y validable de forma independiente.

---

## Phase 5: User Story 3 - Seccion Comunidad con valor visible (Priority: P3)

**Goal**: Pantalla Comunidad util, moderna y accionable dentro del flujo principal.

**Independent Test**: Entrar a Comunidad y verificar hero, bloques de contenido y navegacion ida/vuelta consistente.

### Implementation for User Story 3

- [X] T024 [P] [US3] Crear entidad de bloque de comunidad en `lib/src/features/community/domain/community_content_block.dart`.
- [X] T025 [P] [US3] Crear datasource inicial de bloques en `lib/src/features/community/data/community_blocks_seed.dart`.
- [X] T026 [US3] Refactorizar render de comunidad con entidad/datasource en `lib/src/features/community/presentation/pages/community_page.dart`.
- [X] T027 [US3] Implementar acciones placeholder consistentes para bloques en `lib/src/features/community/presentation/pages/community_page.dart`.
- [X] T028 [US3] Confirmar contrato de navegacion/comunidad actualizado en `specs/002-modern-app-design/contracts/ui-navigation-contract.md`.
- [X] T029 [US3] Documentar evidencia manual de experiencia Comunidad en `specs/002-modern-app-design/community-validation.md`.

**Checkpoint**: US3 funcional y validable de forma independiente.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T030 [P] Ejecutar `flutter analyze` y registrar resultado en `specs/002-modern-app-design/analyze-final.md`.
- [X] T031 [P] Ejecutar `flutter test` y registrar resultado en `specs/002-modern-app-design/test-final.md`.
- [X] T035 Ejecutar protocolo de medicion de SC-002 y SC-003 y registrar resultados en `specs/002-modern-app-design/measurement-results.md`.
- [X] T036 Ejecutar validacion responsive en movil, escritorio y ancho reducido (incluyendo navegacion principal) y registrar observaciones en `specs/002-modern-app-design/responsive-validation.md`.
- [X] T037 Consolidar evidencia verificable (capturas/notas) de validacion responsive en `specs/002-modern-app-design/responsive-validation.md`.
- [X] T038 Ejecutar regresion explicita de autenticacion y navegacion (login, register e invitado/guest) y registrar resultado en `specs/002-modern-app-design/auth-nav-regression.md`.
- [X] T039 Consolidar evidencia verificable de regresion auth/nav en `specs/002-modern-app-design/auth-nav-regression.md`.
- [X] T040 [P] Crear o actualizar `specs/002-modern-app-design/warnings-backlog.md` con issues no resueltos detectados en validacion final, cumpliendo Gate C de la constitucion.
- [X] T032 Consolidar evidencia final de navegacion/diseno moderno en `specs/002-modern-app-design/final-ux-summary.md`.
- [X] T033 Actualizar lineamientos finales de uso del sistema visual en `specs/002-modern-app-design/quickstart.md` con base en hallazgos de T035-T039.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: sin dependencias.
- **Phase 2 (Foundational)**: depende de Phase 1.
- **Phase 3 (US1)**: depende de Phase 2.
- **Phase 4 (US2)**: depende de Phase 2 y puede ejecutarse tras US1 base de navegacion.
- **Phase 5 (US3)**: depende de Phase 3 para experiencia navegable completa.
- **Phase 6 (Polish)**: depende de completar US1, US2 y US3.

### User Story Dependencies

- **US1 (P1)**: base del MVP; no depende de otras historias.
- **US2 (P2)**: depende de la fundacion y se apoya en la navegacion unificada de US1.
- **US3 (P3)**: depende de navegacion moderna para experiencia completa y de consistencia visual minima.

### Parallel Opportunities

- Setup paralelo: T001, T002, T003, T034.
- Fundacional paralelo: T004, T005, T007.
- US1 paralelo: T009, T010, T011, T012, T013.
- US2 paralelo: T016, T017, T018, T019, T020.
- US3 paralelo: T024, T025.
- Validacion final paralelo: T030, T031, T040.

---

## Parallel Example: User Story 1

```bash
# Estos cambios pueden ejecutarse en paralelo (archivos independientes):
T009 collection_page.dart
T010 capture_page.dart
T011 history_page.dart
T012 profile_page.dart
T013 community_page.dart
```

## Parallel Example: User Story 2

```bash
# Aplicacion de tokens por pantalla en paralelo:
T016 collection_page.dart
T017 capture_page.dart
T018 history_page.dart
T019 profile_page.dart
T020 community_page.dart
```

## Parallel Example: User Story 3

```bash
# Modelo y seed inicial en paralelo:
T024 community_content_block.dart
T025 community_blocks_seed.dart
```

---

## Implementation Strategy

### MVP First (US1 only)

1. Completar Setup y Foundational.
2. Completar US1 (navegacion moderna unificada).
3. Validar rapidamente navegacion manual + analyzer/test.
4. Entregar MVP navegable.

### Incremental Delivery

1. US1: navegacion moderna y clara.
2. US2: coherencia visual transversal.
3. US3: valor visible de Comunidad.
4. Polish: evidencia final y cierre tecnico.

### Risk Control

1. Mantener cambios funcionales acotados a presentacion y rutas canonicas.
2. Verificar `flutter analyze` y `flutter test` al cierre de cada fase principal.
3. Registrar evidencia manual para criterios de exito de UX.

---

## Traceability (FR/SC/Gates)

### Functional Requirements Coverage

- **FR-006** (funcional en movil/escritorio y ancho reducido): T036, T037
- **FR-007** (preservar flujos auth y navegacion): T038, T039

### Success Criteria Coverage

- **SC-002** (90% identifica seccion en <5s): T034 (definicion de medicion), T035 (ejecucion y resultados)
- **SC-003** (85% califica modernidad >= 4/5): T034 (definicion de medicion), T035 (ejecucion y resultados)

**Estado actual de SC**
- SC-002: NO CONCLUYENTE (muestra insuficiente en `measurement-results.md`).
- SC-003: NO CONCLUYENTE (muestra insuficiente en `measurement-results.md`).

### Constitution Gates Coverage

- **Gate A** (`flutter analyze` sin `error`): T030
- **Gate B** (`flutter test` pasa): T031
- **Gate C** (mapeo explicito + backlog warnings no resueltos): T040
