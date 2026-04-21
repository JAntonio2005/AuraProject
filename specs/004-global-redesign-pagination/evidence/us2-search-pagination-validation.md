# US2 Search + Pagination Validation

Feature: 004-global-redesign-pagination  
Story: US2 - Navegacion de Razas Escalable con Paginador  
Task: T040  
Date: 2026-04-21

## Alcance validado

- Coherencia entre busqueda activa y pagina actual.
- Recalculo de paginas validas cuando cambia el conjunto filtrado.
- Reseteo explicito a primera pagina al cambiar query.

## Validacion funcional busqueda + paginacion (T040)

| Caso | Resultado | Evidencia |
|---|---|---|
| Cambio real de query resetea a pagina 1 | PASS | Regla explicita aplicada: queryChanged ejecuta onQueryChanged(currentPage=1). |
| Query sin cambios conserva pagina actual valida | PASS | Si query no cambia, se usa buildState con currentPage actual y totalItems recalculado. |
| Query reduce resultados y recorta paginas | PASS | buildState normaliza currentPage si supera totalPages del filtrado. |
| Limpiar query restaura lista completa | PASS | Query vacia usa allBreeds y recalcula estado de paginacion. |
| Query sin resultados muestra estado vacio | PASS | Renderiza panel empty conservando consistencia visual de collection. |
| Navegacion detalle desde lista filtrada y paginada | PASS | El tap usa la raza visible en pageSlice y mantiene flujo de detalle existente. |

## Conclusion T040

- Estado: CERRADO
- Bloqueadores: ninguno
- Nota: escenarios manuales ejecutables en specs/004-global-redesign-pagination/evidence/us2-collection-manual-scenarios.md
