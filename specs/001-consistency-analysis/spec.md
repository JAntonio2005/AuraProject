# Feature Specification: Flutter Project Consistency Hardening

**Feature Branch**: `001-consistency-analysis`  
**Created**: 2026-04-08  
**Status**: Draft  
**Input**: User description: "Run a project analysis for consistency and make artifacts executable"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Analyzer Build Health (Priority: P1)

Como desarrollador, quiero que el proyecto pase análisis estático sin errores de compilación para poder iterar sin bloquearme por dependencias o referencias rotas.

**Why this priority**: Sin salud básica de build/analyzer, cualquier cambio de funcionalidad se vuelve riesgoso y lento.

**Independent Test**: Ejecutar `flutter analyze` y verificar que no existan entradas de severidad `error`.

**Acceptance Scenarios**:

1. **Given** el repositorio en la rama de feature, **When** ejecuto `flutter analyze`, **Then** no aparecen errores de compilación por paquetes faltantes o símbolos indefinidos.
2. **Given** una instalación limpia, **When** ejecuto `flutter pub get` y después `flutter analyze`, **Then** el proyecto resuelve dependencias y queda listo para desarrollo.

---

### User Story 2 - Servicio y Ruteo Consistentes (Priority: P2)

Como desarrollador, quiero una arquitectura consistente entre cliente HTTP, rutas y capas de servicio para reducir duplicidad y evitar flujos ambiguos.

**Why this priority**: La app tiene capas paralelas (`core/network` y `core/routes/services`) y rutas duplicadas; sin consolidación, aumenta el riesgo de regresiones.

**Independent Test**: Verificar imports activos y navegación principal (`Home -> Login/Register -> Collection -> Capture/History/Profile`) sin referencias huérfanas.

**Acceptance Scenarios**:

1. **Given** los servicios de red actuales, **When** reviso imports y uso real desde pantallas, **Then** existe una única ruta recomendada para acceso HTTP y autenticación.
2. **Given** la configuración de navegación, **When** inspecciono el arranque de `MaterialApp`, **Then** el esquema de rutas documentado coincide con el código ejecutado.

---

### User Story 3 - Flujos Auth Pendientes Cerrados (Priority: P3)

Como usuario, quiero recuperar y actualizar contraseña en un flujo real de backend para no depender de simulaciones.

**Why this priority**: El flujo principal de auth existe, pero recuperación de contraseña conserva TODOs y comportamiento mock.

**Independent Test**: Ejecutar flujo `ForgotPassword -> NewPassword` con llamadas reales y manejo de errores HTTP.

**Acceptance Scenarios**:

1. **Given** un correo válido, **When** envío recuperación de contraseña, **Then** la app invoca endpoint real y muestra resultado exitoso o error mapeado.
2. **Given** un código de verificación y nueva contraseña, **When** confirmo el cambio, **Then** la app actualiza credenciales y redirige a login.

### Edge Cases

- Imagen demasiado pesada en captura: la app debe bloquear envío y mostrar mensaje claro.
- Token expirado (401) en perfil/historial: la app debe mostrar estado de sesión inválida sin crash.
- Endpoint no disponible por red: la app debe mostrar mensaje recuperable y opción de reintento.
- Argumentos de navegación ausentes en detalle de predicción/raza: la pantalla debe usar fallback seguro.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema MUST mantener dependencias declaradas para todos los paquetes usados por código activo (`pubspec.yaml` consistente con imports).
- **FR-002**: El sistema MUST ejecutar `flutter analyze` sin errores de compilación (`error`) en la rama de feature.
- **FR-003**: El sistema MUST eliminar o consolidar referencias duplicadas de servicios/rutas para dejar una arquitectura navegable y documentada.
- **FR-004**: El sistema MUST conservar `MaterialApp.routes` como fuente principal de navegación para pantallas de producto; cualquier `onGenerateRoute` existente debe ser complementario y no contradictorio.
- **FR-005**: El sistema MUST implementar recuperación y confirmación de contraseña con llamadas reales de backend en lugar de demoras simuladas.
- **FR-006**: El sistema MUST mapear errores de red comunes (401, timeouts, conexión) con mensajes de usuario claros.
- **FR-007**: El sistema MUST mantener al menos un test automatizado no-placeholder que valide arranque o navegación base.

### Key Entities *(include if feature involves data)*

- **AuthSession**: token de acceso persistido en storage seguro y usado por interceptores HTTP.
- **PredictResponse**: resultado de IA con `logId`, `top1` y `top5`.
- **PredictionHistoryItem**: registro de historial (id, título, confianza, fecha).
- **BreedSummary**: entidad de catálogo de razas para colección y búsqueda.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `flutter analyze` reporta 0 errores de severidad `error`.
- **SC-002**: Tomando como baseline inicial 21 issues de analyzer (capturados al inicio de la feature), el estado final MUST ser <= 4 issues sin corregir, y cada issue restante MUST quedar documentado en backlog técnico con justificación.
- **SC-003**: Flujo `ForgotPassword -> NewPassword` MUST validarse manualmente en dos casos documentados: (a) respuesta exitosa de backend y (b) respuesta de error controlada, ambos con evidencia de resultado esperado y observado.
- **SC-004**: Existe al menos 1 test de smoke real ejecutable en `flutter test` (sin placeholder trivial).

## Assumptions

- El backend de Aura expone endpoints de auth, predict, history y breeds accesibles en ambiente de prueba.
- El alcance actual prioriza estabilidad técnica y consistencia sobre rediseño visual.
- No se introduce cambio de framework de estado (se respeta implementación existente y se consolida gradualmente).
- Los cambios se aplican sin reestructurar de cero la app ni renombrar masivamente carpetas.
