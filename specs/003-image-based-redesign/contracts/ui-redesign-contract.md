# UI Redesign Contract: Image-Based Global Redesign

## 1. Purpose
Definir el contrato de entrega y validacion del rediseño visual global para asegurar consistencia, claridad de accion y adaptacion entre tamanos de pantalla sin alterar comportamiento funcional existente.

## 2. Scope Contract

### 2.1 MVP (Phase 1)
- In scope:
  - Inicio de sesion y registro
  - Home principal
  - Coleccion
  - Comunidad
  - Navegacion principal entre estas pantallas
- Required outcome:
  - Continuidad visual verificable en recorrido central de onboarding/descubrimiento.

### 2.2 Post-MVP (Phase 2)
- In scope:
  - Camara
  - Historial
  - Perfil
  - Pantallas secundarias y estados asociados pendientes (carga, vacio, error)
- Required outcome:
  - Cobertura de consistencia visual en 100% de pantallas en alcance total.

### 2.3 Explicit Out of Scope
- Cambios de logica de negocio o comportamiento funcional de flujos actuales.
- Nuevas funcionalidades de producto no vinculadas a consistencia visual.
- Cambios de infraestructura, pipelines o scripts de automatizacion.
- Migraciones arquitectonicas o reorganizacion estructural mayor.
- Rebranding integral (naming/estrategia de marca).

## 3. Functional Invariants
- Los flujos existentes deben conservar resultados esperados de autenticacion, navegacion, consulta, captura y perfil.
- La accion principal de cada pantalla debe ser identificable sin exploracion completa.
- Los estados visuales `normal/loading/empty/error` deben tener lineamientos coherentes de jerarquia y comunicacion.

## 4. Measurement Contract (Technology-Agnostic)

### 4.1 Phase 1 Minimum Pass Criteria
- 100% de pantallas MVP reflejan el lenguaje visual acordado.
- >= 90% de usuarios evaluadores identifica accion principal en <= 5 segundos.
- >= 90% de tareas criticas MVP se completan sin asistencia.
- 0 regresiones funcionales bloqueantes en flujo MVP.

### 4.2 Phase 2 Minimum Pass Criteria
- 100% de pantallas restantes en alcance adoptan continuidad visual con MVP.
- >= 85% de usuarios evaluadores califican consistencia global >= 4/5.
- >= 95% de tareas criticas end-to-end se completan sin asistencia.
- 100% de estados relevantes (normal/loading/empty/error) tienen presentacion consistente y clara.

## 5. Validation Evidence Requirements
- Matriz por pantalla con estado de adopcion visual por fase.
- Registro de evaluacion de usuarios y tiempos de identificacion de accion principal.
- Registro de tareas criticas por fase con resultado (sin ayuda / con ayuda / fallo).
- Evidencia de no regresion funcional en flujos clave.

## 6. Change Control
- Cualquier solicitud que afecte fuera de alcance requiere addendum en spec/plan antes de ejecutarse.
- Si una pantalla no puede cumplir el patron visual completo en la fase asignada, se debe documentar degradacion controlada y criterio de cierre temporal.
