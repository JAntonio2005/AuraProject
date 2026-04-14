# T047 Evidence - Analyze Final

## Command
`flutter analyze`

## Latest Run
- Date: 2026-04-14
- Summary: `13 issues found` (all `info`, no `error`, no `warning`)
- Exit code: `1` (configured analyzer treats infos as non-zero)

## Gate A Interpretation
- Gate A criterion is `0 analyzer errors`.
- Non-zero exit code in this run is due to info-level diagnostics policy, not analyzer errors.
- Therefore: Gate A = PASS by criterion, with informational diagnostics pending cleanup.

## Evidence (Esperado | Observado | Criterio | Resultado)

| Esperado | Observado | Criterio | Resultado |
|---|---|---|---|
| Gate A sin errores de analyzer | Analyzer errors: 0; warnings: 0; info: 13; exit code: 1 | La constitucion exige cero `error` | Cumple |
| Registro de salida de comando para trazabilidad | Se registro resumen y tipo de diagnosticos | Debe quedar evidencia verificable del comando ejecutado | Cumple |

## Notable Non-Blocking Infos
- avoid_print in history_service.dart
- deprecated_member_use in institutions_page.dart
- unintended_html_in_doc_comment in breed_detail_page.dart
- unnecessary_to_list_in_spreads in prediction_detail_page.dart
