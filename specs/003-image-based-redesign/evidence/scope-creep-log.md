# T051 Evidence - Scope Creep Log (ACCEPT/REJECT)

## Decision Rules Reference
- Source: plan.md -> Operational Scope Creep Control
- Inventory reference: spec.md -> Closed Scope Inventory (Binding)

## Reviewed Requests

| Date | Request | Decision | Rationale |
|---|---|---|---|
| 2026-04-14 | Unify module naming to `capture` with visible label `Cámara` in docs | ACCEPT | In-scope documentation consistency; no functional change |
| 2026-04-14 | Expand US1 independent test text to include forgot/new password | ACCEPT | Aligns with binding post-MVP inventory in spec |
| 2026-04-14 | Any additional screen not in binding inventory | REJECT (default) | Requires spec update before implementation |

## Evidence (Esperado | Observado | Criterio | Resultado)

| Esperado | Observado | Criterio | Resultado |
|---|---|---|---|
| Registro de decisiones ACCEPT/REJECT durante ejecucion | Se documentaron solicitudes, decision y rationale | Debe existir trazabilidad operativa para evitar scope creep | Cumple |
| Regla de rechazo para alcance no vinculante | Se explicita REJECT por defecto para pantallas fuera de inventario | Debe proteger el alcance cerrado del feature | Cumple |
