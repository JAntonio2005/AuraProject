# US2 Collection Manual Scenarios

Feature: 004-global-redesign-pagination  
Story: US2 - Collection pagination and search coherence  
Date: 2026-04-21

## Preparacion

1. Ejecutar la app y abrir collection.
2. Confirmar que hay datos cargados en el listado de razas.
3. Si no hay datos, repetir con conectividad habilitada.

## Escenarios manuales ejecutables

| ID | Escenario | Pasos | Resultado esperado |
|---|---|---|---|
| COL-US2-M01 | Paginador visible con datos | Abrir collection con datos disponibles | Se muestra paginador con pagina X de Y y rango inicio-fin de total |
| COL-US2-M02 | Borde primera pagina | En pagina 1 observar controles | Anterior deshabilitado, Siguiente habilitado si hay mas paginas |
| COL-US2-M03 | Avance de pagina | Pulsar Siguiente una vez | Cambia a pagina 2 y se actualiza el rango mostrado |
| COL-US2-M04 | Retroceso de pagina | Desde pagina > 1 pulsar Anterior | Regresa a pagina previa y actualiza rango |
| COL-US2-M05 | Borde ultima pagina | Navegar hasta ultima pagina | Siguiente deshabilitado |
| COL-US2-M06 | Detalle desde pagina intermedia | En pagina 2 o superior abrir una raza | Navega a detalle correcto de la raza seleccionada |
| COL-US2-M07 | Busqueda con reseteo explicito | Estar en pagina > 1 y escribir una query distinta | La pagina vuelve a 1 y totalPages se recalcula |
| COL-US2-M08 | Busqueda sin cambios de query | Reejecutar busqueda con el mismo texto | Mantiene pagina actual valida, sin reinicio innecesario |
| COL-US2-M09 | Limpiar query | Con query activa, borrar todo el texto | Vuelve al dataset completo y pagina 1 |
| COL-US2-M10 | Query sin resultados | Ingresar texto sin coincidencias | Se muestra estado vacio, sin error y sin ruptura de layout |

## Resultado de ejecucion recomendada

Registrar para cada escenario: PASS o FAIL, observacion y evidencia visual (captura).
