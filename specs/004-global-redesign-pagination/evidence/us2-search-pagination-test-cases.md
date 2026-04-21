# US2 Search + Pagination Test Cases

**Feature**: 004-global-redesign-pagination  
**Story**: US2 - Navegacion de Razas Escalable con Paginador  
**Task**: T030  
**Date**: 2026-04-21

## Casos

| ID | Escenario | Precondicion | Pasos | Resultado esperado |
|---|---|---|---|---|
| US2-SP-01 | Reset explicito al cambiar query | Estar en pagina > 1 con listado completo | Escribir una query distinta | La pagina vuelve explicitamente a 1 |
| US2-SP-02 | Recalculo de total de paginas | Listado completo cargado | Aplicar query con menos resultados | totalPages se recalcula al nuevo total filtrado |
| US2-SP-03 | Mantener pagina si query no cambia | Query establecida y pagina actual valida | Re-disparar filtro sin cambio de query | currentPage se mantiene y solo se revalida rango |
| US2-SP-04 | Query vacia restaura dataset | Query activa con pocos resultados | Limpiar query | Se restaura lista completa y pagina 1 |
| US2-SP-05 | Buscar y abrir detalle | Query activa y resultados paginados | Abrir una raza desde pagina filtrada | Detalle corresponde al item tocado |
| US2-SP-06 | Query sin resultados | Dataset cargado | Ingresar query inexistente | Estado vacio visible; sin crash; pagina estable |
| US2-SP-07 | Botones en borde tras filtro | Query deja una sola pagina | Verificar botones | Anterior y Siguiente en estado deshabilitado correcto |

## Criterio de salida

La coherencia busqueda-paginacion se valida cuando el reseteo a pagina 1 por cambio de query y el recorte de paginas validas se cumplen en todos los escenarios.
