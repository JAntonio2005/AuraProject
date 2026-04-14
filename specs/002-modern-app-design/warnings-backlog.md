# Warnings Backlog (T040, Gate C)

## Snapshot
- Fecha: 2026-04-14
- Fuente: `flutter analyze`
- Severidad pendiente: 13 `info` (0 `warning`, 0 `error`)

## Items pendientes
1. `lib/src/core/routes/services/history_service.dart`
- Tipo: info
- Regla: `avoid_print`
- Conteo: 5
- Accion sugerida: reemplazar `print` por logging controlado (`debugPrint`/logger).

2. `lib/src/features/institutions/presentation/pages/institutions_page.dart`
- Tipo: info
- Regla: `deprecated_member_use` (`groupValue`/`onChanged` de Radio)
- Conteo: 6
- Accion sugerida: migrar a `RadioGroup`.

3. `lib/src/features/result/presentation/pages/breed_detail_page.dart`
- Tipo: info
- Regla: `unintended_html_in_doc_comment`
- Conteo: 1
- Accion sugerida: ajustar comentario con escapes/texto plano.

4. `lib/src/features/result/presentation/pages/prediction_detail_page.dart`
- Tipo: info
- Regla: `unnecessary_to_list_in_spreads`
- Conteo: 1
- Accion sugerida: eliminar `toList()` innecesario.

## Estado Gate C
- PASS: backlog explicitado y trazado en artefacto del feature.

## Nota de cierre
- Este backlog cumple Gate C para cierre tecnico.
- El cierre global del feature permanece PARCIAL por pendientes de medicion UX (SC-002/SC-003) y evidencia adicional en T037/T039.
