# US2 Pagination Functional Test Cases

**Feature**: 004-global-redesign-pagination  
**Story**: US2 - Navegacion de Razas Escalable con Paginador  
**Task**: T029  
**Date**: 2026-04-21

## Casos

| ID | Escenario | Precondicion | Pasos | Resultado esperado |
|---|---|---|---|---|
| US2-PAG-01 | Primera pagina inicial | Collection cargada con resultados > pageSize | Abrir collection | Se muestra pagina 1 y control indica pagina actual correctamente |
| US2-PAG-02 | Navegar siguiente pagina | En pagina 1 con hasNextPage true | Tocar Siguiente | Se muestran items de la pagina 2 y actualiza indicador |
| US2-PAG-03 | Navegar pagina anterior | En pagina > 1 | Tocar Anterior | Vuelve a pagina previa con items correspondientes |
| US2-PAG-04 | Borde inferior | En pagina 1 | Verificar boton Anterior | Boton Anterior deshabilitado |
| US2-PAG-05 | Borde superior | En ultima pagina | Verificar boton Siguiente | Boton Siguiente deshabilitado |
| US2-PAG-06 | Conteo de rango | Cualquier pagina con resultados | Observar leyenda de rango | Muestra inicio-fin y total de resultados coherente |
| US2-PAG-07 | Seleccion de raza paginada | En pagina distinta de 1 | Abrir detalle de una raza | Navega a detalle correcto de la raza tocada |
| US2-PAG-08 | Sin resultados | Query sin coincidencias | Ejecutar busqueda | Se muestra estado vacio sin romper layout ni paginador activo |

## Criterio de salida

US2 paginacion funcional se considera valida cuando todos los casos anteriores pasan sin regresion de navegacion ni errores de UI.
