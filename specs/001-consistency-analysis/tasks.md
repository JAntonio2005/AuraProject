# Tasks: Flutter Project Consistency Hardening

**Input**: Design documents from `specs/001-consistency-analysis/`  
**Prerequisites**: `plan.md` and `spec.md` present (done)  
**Tests**: Include smoke tests because they are required by spec

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: User story reference (`US1`, `US2`, `US3`)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Baseline and tooling consistency.

- [X] T001 [P] Capturar baseline de issues con `flutter analyze` y guardar resumen en `specs/001-consistency-analysis/analyze-baseline.md`.
- [X] T002 [P] Capturar baseline de pruebas con `flutter test` y registrar resultado en `specs/001-consistency-analysis/test-baseline.md`.
- [X] T003 Verificar dependencias en `pubspec.yaml` para imports activos y ejecutar `flutter pub get`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Correcciones estructurales mínimas para permitir implementación segura.

- [X] T004 Resolver imports no usados/duplicados en `lib/main.dart` y `lib/src/features/collection/presentation/pages/collection_page.dart`.
- [X] T005 Corregir warning de acceso inválido tipo colección en `lib/src/core/routes/services/history_service.dart`.
- [X] T006 [P] Actualizar usos deprecados (`withOpacity`) en `lib/src/widgets/slow_bg.dart`.
- [X] T007 Ejecutar `flutter analyze` como gate intermedio y confirmar 0 errores de severidad `error`.

**Checkpoint**: Build health establecida (analyzer sin errores de compilación).

---

## Phase 3: User Story 1 - Analyzer Build Health (Priority: P1) 🎯 MVP

**Goal**: Proyecto sin errores de análisis de compilación.

**Independent Test**: `flutter analyze` retorna sin errores `error`.

### Implementation for User Story 1

- [X] T008 [US1] Revisar y limpiar campos no usados en `lib/src/features/capture/presentation/pages/capture_page.dart`.
- [X] T009 [US1] Eliminar casts innecesarios en `lib/src/features/result/presentation/pages/breed_detail_page.dart`.
- [X] T010 [US1] Re-ejecutar `flutter analyze` como gate final y documentar conteo final de issues en `specs/001-consistency-analysis/analyze-final.md` comparado contra baseline.

**Checkpoint**: Analyzer estable para iteración continua.

---

## Phase 4: User Story 2 - Servicio y Ruteo Consistentes (Priority: P2)

**Goal**: Definir una capa de servicio y navegación coherente.

**Independent Test**: Imports y flujo de navegación principal sin referencias ambiguas.

### Implementation for User Story 2

- [X] T011 [US2] Inventariar uso de `ApiClient` en `lib/src/core/network/api_client.dart` y `lib/src/core/routes/services/api_client.dart`.
- [X] T012 [US2] Definir capa oficial de ApiClient y ajustar imports en servicios (`auth_service.dart`, `predict_service.dart`, `history_service.dart`, `breeds_service.dart`), dejando decision documentada en `specs/001-consistency-analysis/service-ownership.md` con: cliente activo, archivos migrados y archivos legacy.
- [X] T013 [US2] Alinear estrategia de rutas entre `lib/main.dart` y `lib/src/core/routes/app_router.dart`, preservando `MaterialApp.routes` como fuente principal y documentando uso complementario de `onGenerateRoute` si aplica.
- [X] T014 [US2] Aplicar criterio explícito a código legacy en `lib/src/core/di/providers.dart` y/o `lib/src/core/network/`: retirar si no tiene referencias activas o documentar estado `legacy` en `specs/001-consistency-analysis/legacy-decision.md` con motivo técnico.

**Checkpoint**: Arquitectura consistente y documentada para red/ruteo.

---

## Phase 5: User Story 3 - Flujos Auth Pendientes Cerrados (Priority: P3)

**Goal**: Recuperación de contraseña funcional contra backend.

**Independent Test**: Flujo `ForgotPassword -> NewPassword -> Login` con éxito y manejo de error.

### Tests for User Story 3

- [X] T015 [P] [US3] Agregar smoke test de arranque en `test/widget_test.dart` (reemplazar placeholder).
- [X] T016 [P] [US3] Agregar test mínimo de navegación auth (home a login/register) en `test/widget_test.dart` o archivo dedicado.

### Implementation for User Story 3

- [X] T017 [US3] Implementar llamada real de request reset en `lib/src/features/auth/presentation/pages/forgot_password_page.dart` usando servicio existente.
- [X] T018 [US3] Implementar confirmación real de nueva contraseña en `lib/src/features/auth/presentation/pages/new_password_page.dart`.
- [X] T019 [US3] Unificar mensajes y manejo de errores HTTP en páginas de auth (`login_page.dart`, `register_page.dart`, `forgot_password_page.dart`, `new_password_page.dart`).
- [ ] T020 [US3] Ejecutar validación manual y registrar evidencia de `ForgotPassword -> NewPassword` en éxito y error en `specs/001-consistency-analysis/auth-flow-evidence.md`.
- [X] T021 [US3] Ejecutar validación final: `flutter test` y `flutter analyze`.

**Checkpoint**: Funcionalidad auth completa y validada.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T022 [P] Actualizar notas de consistencia en `specs/001-consistency-analysis/` con decisiones finales de arquitectura.
- [X] T023 Revisar lista de warnings restantes y abrir backlog técnico explícito en `specs/001-consistency-analysis/warnings-backlog.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1**: sin dependencias.
- **Phase 2**: depende de Phase 1.
- **Phase 3 (US1)**: depende de Phase 2.
- **Phase 4 (US2)**: depende de Phase 3.
- **Phase 5 (US3)**: depende de Phase 3; puede iniciar en paralelo parcial con Phase 4 si no hay conflictos de archivos.
- **Phase 6**: depende de completar US2 y US3.

### Parallel Opportunities

- T001 y T002.
- T006 con T004/T005 (archivos diferentes).
- T015 y T016.

## Implementation Strategy

### MVP First

1. Completar Phase 1 y Phase 2.
2. Completar US1 (Phase 3) y validar analyzer.
3. Detener y validar estabilidad base.

### Incremental Delivery

1. US1: salud técnica.
2. US2: consistencia arquitectura.
3. US3: cierre funcional auth.

## Notes

- Las tareas apuntan a rutas reales del repositorio Flutter actual.
- Si una tarea implica refactor mayor, dividirla en sub-tareas antes de implementar.
