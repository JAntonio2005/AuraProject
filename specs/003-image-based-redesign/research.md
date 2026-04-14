# Research: Image-Based Global Redesign

## Decision 1: Rollout Strategy by Phase
- Decision: Ejecutar el rediseño en dos fases con validacion independiente: MVP y post-MVP.
- Rationale: Reduce riesgo de regresion y permite confirmar la direccion visual antes del despliegue global.
- Alternatives considered:
  - Big-bang global: descartado por alto riesgo de ruptura y baja capacidad de aislamiento de fallos.
  - Rediseño por modulo sin fases formales: descartado por falta de criterio de salida objetivo.

## Decision 2: Reference-Driven Visual Language (Not Pixel Copy)
- Decision: Tratar la imagen de referencia como guia de lenguaje visual (jerarquia, ritmo, estilo), no como copia exacta.
- Rationale: Permite consistencia transversal y adaptacion a distintos contenidos/pantallas sin deuda de rigidez.
- Alternatives considered:
  - Copia pixel-perfect de cada vista: descartada por baja adaptabilidad y alto costo de mantenimiento.
  - Ajustes cosmeticos aislados: descartados por no resolver consistencia global.

## Decision 3: Technology-Agnostic Measurement Model
- Decision: Medir resultados con indicadores de percepcion y tareas de usuario (claridad, completitud sin ayuda, coherencia) en lugar de metricas acopladas a framework.
- Rationale: Mantiene validez de aceptacion aunque cambien componentes, estilos o implementacion interna.
- Alternatives considered:
  - Validar solo por checklist de componentes: descartado por no reflejar experiencia real del usuario.
  - Validar solo por aprobacion subjetiva interna: descartado por baja reproducibilidad.

## Decision 4: Out-of-Scope Enforcement
- Decision: Mantener fuera de alcance cualquier cambio de logica de negocio, infraestructura, arquitectura o nuevas funcionalidades de producto.
- Rationale: Evita deriva de alcance y protege la entrega incremental centrada en experiencia visual.
- Alternatives considered:
  - Mezclar rediseño con refactor funcional: descartado por riesgo y dificultad de atribucion de defectos.

## Decision 5: Consistent View-State Design
- Decision: Incluir estados normal, carga, vacio y error dentro del alcance visual, con prioridad MVP en pantallas base y extension completa en post-MVP.
- Rationale: La consistencia no se logra solo en estados felices; los estados transitorios definen gran parte de la experiencia.
- Alternatives considered:
  - Diferir estados no normales para una fase posterior indefinida: descartado por inconsistencia visible.

## Decision 6: Validation Sampling Protocol
- Decision: Usar una muestra minima definida de usuarios evaluadores por fase y tareas criticas predefinidas para medir PAC/SC.
- Rationale: Proporciona evidencia comparable entre fases y evita interpretaciones ad hoc.
- Alternatives considered:
  - Pruebas informales sin protocolo: descartadas por baja trazabilidad.
