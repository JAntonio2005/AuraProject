# Implementation Plan: Flutter Project Consistency Hardening

**Branch**: `001-consistency-analysis` | **Date**: 2026-04-08 | **Spec**: `specs/001-consistency-analysis/spec.md`
**Input**: Feature specification from `specs/001-consistency-analysis/spec.md`

## Summary

Estabilizar el proyecto Flutter para desarrollo continuo mediante tres entregas incrementales:
1. Salud de analyzer/build sin errores de compilacion.
2. Consistencia de arquitectura en servicios HTTP y navegacion.
3. Cierre funcional del flujo de recuperacion de contrasena con evidencia de pruebas.

## Technical Context

**Language/Version**: Dart 3.9.x / Flutter stable  
**Primary Dependencies**: flutter, dio, camera, image_picker, flutter_secure_storage, provider, hive, flutter_riverpod  
**Storage**: Flutter Secure Storage (token), Hive disponible para persistencia local  
**Testing**: flutter_test  
**Target Platform**: Android/iOS (desktop/web generados pero no foco principal)  
**Project Type**: Mobile app monoproyecto por features  
**Performance Goals**: analyzer con 0 errores `error`; flujos auth/capture/history sin crash por red  
**Constraints**: cambios minimos, sin refactor masivo, compatibilidad con rutas actuales  
**Scale/Scope**: modulos `auth`, `capture`, `collection`, `history`, `profile`, `result`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Pre-Phase 0 (PASS):
- Build Health First: PASS (objetivo explicitado en FR-002, SC-001).
- Single Source for Runtime Flows: PASS (US2 y tareas T011-T014 lo cubren).
- Verifiable Incremental Delivery: PASS (cada historia tiene prueba independiente).
- Safe Error Handling: PASS (FR-006 + US3).
- Simplicity Over Refactor Churn: PASS (alcance incremental sin reestructura masiva).

Post-Phase 1 (PASS):
- Artefactos de investigacion y diseno creados (`research.md`, `data-model.md`, `contracts/`, `quickstart.md`).
- Gates A/B/C trazables a tareas en `tasks.md`.

## Project Structure

### Documentation (this feature)

```text
specs/001-consistency-analysis/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── api-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── di/
    │   ├── models/
    │   ├── network/
    │   ├── routes/
    │   │   ├── app_router.dart
    │   │   └── services/
    │   └── theme/
    ├── features/
    │   ├── auth/
    │   ├── capture/
    │   ├── collection/
    │   ├── history/
    │   ├── home/
    │   ├── profile/
    │   └── result/
    └── widgets/

test/
└── widget_test.dart
```

**Structure Decision**: Se mantiene estructura actual por features; se consolida ownership de red/rutas con cambios acotados y documentados.

## Complexity Tracking

No hay violaciones constitucionales que requieran excepcion en esta fase.
