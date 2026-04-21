# Implementation Plan: Global Redesign and Breeds Pagination

**Branch**: `004-global-redesign-pagination` | **Date**: 2026-04-21 | **Spec**: `specs/004-global-redesign-pagination/spec.md`
**Input**: Feature specification from `/specs/004-global-redesign-pagination/spec.md`

## Summary

Extender el lenguaje visual ya aplicado en colección al resto de pantallas principales y robustecer colección con paginación de catálogo, manteniendo búsqueda/filtro y priorizando una disposición de elementos clara. La implementación seguirá un enfoque incremental: 1) reglas visuales compartidas y layout unificado, 2) paginación de razas con estado consistente, 3) validación de continuidad funcional y visual con trazabilidad de evidencia.

## Technical Context

**Language/Version**: Dart 3.9.x / Flutter stable  
**Primary Dependencies**: flutter (Material 3), dio, camera, image_picker, flutter_secure_storage, provider, hive, flutter_riverpod  
**Storage**: Secure storage para sesión/token + consumo API existente para catálogo de razas (sin nueva persistencia obligatoria en esta fase)  
**Testing**: flutter_test + flutter analyze + walkthrough manual por pantallas y escenarios de paginación  
**Target Platform**: Android/iOS + Windows desktop para validación rápida de UI
**Project Type**: Aplicación móvil Flutter por módulos  
**Performance Goals**: navegación percibida fluida y cambios de página en colección sin bloqueos visuales ni inconsistencias de estado  
**Constraints**: cero regresiones bloqueantes en auth/nav; mantener simplicidad de cambios; reutilizar componentes compartidos; adaptabilidad en anchos compactos y amplios  
**Scale/Scope**: pantallas principales (auth, home, collection, community, capture, history, profile) + estados de vista + paginación de colección

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Pre-Phase 0 (PASS):
- Build Health First: PASS. El plan exige `flutter analyze` sin errores y respeta dependencias ya declaradas.
- Single Source for Runtime Flows: PASS. Navegación/rutas y servicios existentes se mantienen como fuente principal.
- Verifiable Incremental Delivery: PASS. Cada historia define validación independiente y evidencia requerida.
- Safe Error Handling: PASS. Estados loading/empty/error se normalizan con mensajes recuperables.
- Simplicity Over Refactor Churn: PASS. Cambios acotados a presentación, composición y estado de paginación.

Post-Phase 1 design (PASS):
- Artefactos de diseño completados: `research.md`, `data-model.md`, `contracts/ui-consistency-and-pagination-contract.md`, `quickstart.md`.
- Gates A/B/C quedan trazables para ejecución en implementación y cierre de tareas.

## Project Structure

### Documentation (this feature)

```text
specs/004-global-redesign-pagination/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ui-consistency-and-pagination-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── models/
    │   ├── routes/
    │   └── theme/
    ├── features/
    │   ├── auth/presentation/pages/
    │   ├── home/presentation/pages/
    │   ├── collection/presentation/pages/
    │   ├── community/presentation/pages/
    │   ├── capture/presentation/pages/
    │   ├── history/presentation/pages/
    │   └── profile/presentation/pages/
    └── widgets/

test/
└── widget_test.dart
```

**Structure Decision**: Se conserva la estructura Flutter por features. El alcance se implementa en presentación y widgets compartidos, evitando cambios estructurales mayores en capas de dominio/servicios.

## Complexity Tracking

No se identifican violaciones constitucionales que requieran excepción en esta fase.
