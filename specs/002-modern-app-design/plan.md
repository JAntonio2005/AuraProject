# Implementation Plan: Modern App Visual Refresh

**Branch**: `002-modern-app-design` | **Date**: 2026-04-14 | **Spec**: `specs/002-modern-app-design/spec.md`
**Input**: Feature specification from `specs/002-modern-app-design/spec.md`

## Summary

Modernizar la experiencia visual de Aura con una navegacion principal consistente de cinco destinos (incluyendo Comunidad), estilos de UI coherentes entre pantallas clave y validacion incremental sin romper flujos existentes de autenticacion y navegacion. El enfoque tecnico prioriza cambios de bajo riesgo: consolidacion de `NavigationBar`, adopcion progresiva de tokens visuales y refinamiento por fases verificables.

## Technical Context

**Language/Version**: Dart 3.9.x / Flutter stable  
**Primary Dependencies**: flutter (Material 3), dio, camera, image_picker, flutter_secure_storage, provider, hive, flutter_riverpod  
**Storage**: Flutter Secure Storage (sesion/token), datos remotos via API; sin nueva persistencia para este feature  
**Testing**: flutter_test + validacion manual de navegacion/diseno  
**Target Platform**: Android/iOS y Windows desktop (desktop usado para validacion rapida)
**Project Type**: Mobile app por features (monorepo Flutter)  
**Performance Goals**: transiciones de navegacion fluidas y sin errores visuales bloqueantes en flujo principal  
**Constraints**: cambios incrementales, sin refactor funcional masivo, preservar rutas y flujos auth existentes  
**Scale/Scope**: 5 secciones principales (`collection`, `capture`, `community`, `history`, `profile`) y lineamientos de consistencia visual compartida

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Pre-Phase 0 (PASS):
- Build Health First: PASS. El plan exige mantener `flutter analyze` sin `error` y validar `flutter test` en cada fase.
- Single Source for Runtime Flows: PASS. Se define `NavigationBar` como componente unico de navegacion principal y se documenta contrato de rutas.
- Verifiable Incremental Delivery: PASS. Historias y validaciones independientes definidas por seccion y por pruebas manuales/automatizadas.
- Safe Error Handling: PASS. No cambia capa de errores de negocio; se preservan mensajes y comportamientos existentes.
- Simplicity Over Refactor Churn: PASS. Estrategia incremental con cambios acotados por pantalla.

Post-Phase 1 (PASS):
- Artefactos de diseno y decision creados: `research.md`, `data-model.md`, `contracts/ui-navigation-contract.md`, `quickstart.md`.
- Gates A/B/C trazables en plan y listos para ser ejecutados durante implementacion.

## Project Structure

### Documentation (this feature)

```text
specs/002-modern-app-design/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ui-navigation-contract.md
├── checklists/
│   └── requirements.md
└── tasks.md             # Se crea en /speckit.tasks
```

### Source Code (repository root)

```text
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── models/
    │   ├── routes/
    │   │   └── services/
    │   └── theme/
    ├── features/
    │   ├── collection/presentation/pages/
    │   ├── capture/presentation/pages/
    │   ├── community/presentation/pages/
    │   ├── history/presentation/pages/
    │   ├── profile/presentation/pages/
    │   └── auth/presentation/pages/
    └── widgets/

test/
└── widget_test.dart
```

**Structure Decision**: Se mantiene la arquitectura Flutter existente por features. La modernizacion visual se concentra en capas de presentacion y rutas, evitando cambios de dominio/servicios fuera de lo necesario para consistencia de navegacion.

## Complexity Tracking

No se detectan violaciones constitucionales que requieran excepcion en esta fase.
