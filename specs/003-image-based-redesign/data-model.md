# Data Model: Image-Based Global Redesign

## Entity: RedesignPhase
- Purpose: Representa un bloque de entrega con alcance y criterios de salida.
- Fields:
  - `id` (string): `phase-1-mvp` | `phase-2-post-mvp`
  - `name` (string)
  - `inScopeScreens` (list<ScreenSurface>)
  - `outOfScopeItems` (list<string>)
  - `acceptanceCriteria` (list<AcceptanceMetric>)
  - `status` (enum): `planned` | `in-progress` | `validated` | `closed`
- Validation rules:
  - Debe tener al menos un criterio medible de salida.
  - `inScopeScreens` no puede solaparse ambiguamente entre fases.
  - `outOfScopeItems` debe estar explicitado en ambas fases para prevenir desvio.

## Entity: ScreenSurface
- Purpose: Superficie de interfaz que debe adoptar el lenguaje visual objetivo.
- Fields:
  - `id` (string)
  - `module` (string): auth, home, collection, community, camera, history, profile, secondary
  - `screenName` (string)
  - `phaseOwner` (RedesignPhase.id)
  - `priority` (enum): `critical` | `important` | `extended`
  - `supportedBreakpoints` (list<string>): small, medium, large
  - `viewStates` (list<ViewState>)
- Validation rules:
  - Cada pantalla debe pertenecer a una fase.
  - Cada pantalla debe declarar al menos estado `normal`.
  - Pantallas en MVP deben cubrir el flujo principal end-to-end.

## Entity: VisualPattern
- Purpose: Patron reusable de presentacion que define identidad visual.
- Fields:
  - `id` (string)
  - `category` (enum): `layout`, `hierarchy`, `component-style`, `emphasis`, `motion`
  - `description` (string)
  - `applicability` (list<ScreenSurface.id>)
  - `doRules` (list<string>)
  - `dontRules` (list<string>)
- Validation rules:
  - Debe poder aplicarse en al menos dos pantallas para considerarse patron.
  - Debe incluir criterio de consistencia observable.

## Entity: ViewState
- Purpose: Estado de presentacion de una pantalla.
- Fields:
  - `state` (enum): `normal` | `loading` | `empty` | `error`
  - `messageClarityLevel` (enum): `high` | `medium` | `low`
  - `primaryActionVisible` (boolean)
  - `fallbackVisualPatternId` (optional string)
- Validation rules:
  - `error` y `empty` deben exponer accion recuperable cuando aplique.
  - `loading` no debe ocultar por completo contexto critico de pantalla.

## Entity: AcceptanceMetric
- Purpose: Criterio medible y agnostico de tecnologia para validar fase o alcance global.
- Fields:
  - `id` (string)
  - `scope` (enum): `phase-1` | `phase-2` | `global`
  - `metricName` (string)
  - `targetThreshold` (string)
  - `measurementMethod` (string)
  - `evidenceArtifact` (string)
- Validation rules:
  - Cada metrica debe tener umbral cuantificable.
  - El metodo de medicion debe ser reproducible entre evaluaciones.

## Relationships
- `RedesignPhase` 1..n `ScreenSurface`
- `ScreenSurface` n..n `VisualPattern`
- `ScreenSurface` 1..n `ViewState`
- `RedesignPhase` 1..n `AcceptanceMetric`

## State Transitions
- `RedesignPhase.status`: `planned -> in-progress -> validated -> closed`
- `ScreenSurface` readiness (derived): `not-started -> visually-updated -> functionally-checked -> phase-validated`
