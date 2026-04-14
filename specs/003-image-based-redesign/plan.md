# Implementation Plan: Image-Based Global Redesign

**Branch**: `003-image-based-redesign` | **Date**: 2026-04-14 | **Spec**: `specs/003-image-based-redesign/spec.md`
**Input**: Feature specification from `specs/003-image-based-redesign/spec.md`

## Summary

Aplicar un rediseño visual global inspirado en imagen de referencia, con despliegue en dos fases: MVP (autenticacion, home, coleccion, comunidad y navegacion principal) y post-MVP (capture, historial, perfil y estados secundarios). El enfoque preserva comportamiento funcional existente, explicita fuera-de-alcance y valida resultados con criterios medibles de consistencia, claridad y usabilidad.

## Technical Context

**Language/Version**: Dart 3.9.x / Flutter stable  
**Primary Dependencies**: flutter (Material 3), dio, camera, image_picker, flutter_secure_storage, provider, flutter_riverpod, hive  
**Storage**: Flutter Secure Storage + Hive + consumo API existente (sin nueva persistencia para este feature)  
**Testing**: flutter_test, flutter analyze, validacion manual UX con guias por fase  
**Target Platform**: Android/iOS + Windows desktop para validacion funcional y visual
**Project Type**: Aplicacion Flutter multi-feature  
**Performance Goals**: preservar fluidez perceptible de interacciones del flujo principal y cero regresiones bloqueantes de UX funcional  
**Constraints**: no modificar logica de negocio, no reestructuracion arquitectonica mayor, despliegue incremental por fases, estados visuales consistentes (normal/carga/vacio/error)  
**Scale/Scope**: Fase 1 (5 areas clave) + Fase 2 (resto de modulos en alcance activo) con cobertura objetivo del 100% de pantallas del proyecto

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Pre-Phase 0 (PASS):
- Build Health First: PASS. El plan exige mantener `flutter analyze` con cero `error` y registrar dependencias ya presentes en `pubspec.yaml`.
- Single Source for Runtime Flows: PASS. Se mantiene navegacion/autenticacion existentes como fuente primaria, con cambios enfocados a presentacion.
- Verifiable Incremental Delivery: PASS. Historias y fases tienen validacion independiente y criterios medibles.
- Safe Error Handling: PASS. No se altera manejo funcional de errores; se estandariza presentacion visual de estados de error.
- Simplicity Over Refactor Churn: PASS. Alcance acotado a UI/UX visual incremental, sin refactor masivo.

Post-Phase 1 Design (PASS):
- Artefactos de diseno completados: `research.md`, `data-model.md`, `contracts/ui-redesign-contract.md`, `quickstart.md`.
- Gates A/B/C trazables en el plan y en quickstart para ejecucion durante implementacion.
- Fuera de alcance declarado explicitamente y mantenido en todos los artefactos para control de desvio.

## Project Structure

### Documentation (this feature)

```text
specs/003-image-based-redesign/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ui-redesign-contract.md
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
    │   ├── di/
    │   ├── network/
    │   ├── routes/
    │   └── theme/
    ├── features/
    │   ├── auth/
    │   ├── collection/
    │   ├── community/
    │   ├── capture/
    │   ├── history/
    │   └── profile/
    └── widgets/

assets/
├── icons/
└── images/

test/
└── widget_test.dart
```

**Structure Decision**: Se mantiene la arquitectura Flutter actual por features. El rediseño se ejecuta en capas de presentacion y lineamientos visuales compartidos para minimizar riesgo de regresion funcional.

## Operational Scope Creep Control

Objetivo: prevenir desvio de alcance durante implementacion y validacion, manteniendo alineacion estricta con `spec.md` (inventario cerrado vinculante, fases y out-of-scope).

### Desvio aceptable (ACCEPT)

- Ajustes de presentacion visual dentro del inventario vinculante del spec.
- Ajustes para mantener consistencia entre estados `normal/loading/empty/error` en pantallas en alcance.
- Correcciones menores de copy visual necesarias para legibilidad o jerarquia sin alterar comportamiento funcional.

### Desvio no aceptable (REJECT)

- Solicitudes que introduzcan nueva funcionalidad de producto.
- Cambios en logica de negocio, contratos funcionales o flujo de navegacion base.
- Cambios de infraestructura, scripts o arquitectura fuera de lo declarado en alcance.
- Inclusion de pantallas/modulos no listados en el inventario vinculante sin actualizacion previa del spec.

### Regla operativa de decision

1. Toda solicitud nueva se clasifica como `ACCEPT` o `REJECT` contra el inventario vinculante y out-of-scope del spec.
2. Si la solicitud es `REJECT`, no se implementa en esta fase y se registra como pendiente externa.
3. Si la solicitud requiere ampliar alcance, se debe actualizar primero `spec.md`, luego re-sincronizar `plan.md` y `tasks.md` antes de ejecutar cambios.

### Evidencia requerida por fase

- Registro de solicitudes evaluadas con decision `ACCEPT/REJECT` y justificacion.
- Trazabilidad explicita entre criterios PAC/SC y entregables de fase.
- Confirmacion final de que no hubo desvio fuera del inventario vinculante al cierre de cada fase.

## Complexity Tracking

No se detectan violaciones constitucionales que requieran excepcion en esta fase.
