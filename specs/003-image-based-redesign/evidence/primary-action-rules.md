# T023 Evidence - Primary Action Rules

## Rule Set (US2)

1. Every screen declares one visible primary action above or immediately before the main CTA.
2. Primary CTA uses FilledButton styling and keeps full-width affordance on compact layouts.
3. Secondary actions remain visually subordinated using TextButton/OutlinedButton patterns.
4. Header -> context copy -> primary action flow is preserved in all updated screens.
5. State panels (`loading`, `empty`, `error`) must include explicit recovery guidance.

## Screen Mapping

- login_page: `Accion principal` label + primary `Continuar`
- register_page: `Accion principal` label + primary `Continuar`
- home_page: `Accion principal` label + primary `Iniciar sesion`
- collection_page: `Accion principal: buscar una raza` + search submission CTA
- community_page: hero CTA + actionable block list
- capture_page: `Accion principal: tomar foto para escanear` + shutter CTA
- history_page: tab hierarchy + standardized state actions
- profile_page: `Accion principal` section for account context and actions

## Evidence (Esperado | Observado | Criterio | Resultado)

| Esperado | Observado | Criterio | Resultado |
|---|---|---|---|
| Reglas unificadas de jerarquia y CTA | Se definio set de 5 reglas y mapeo por pantalla | Debe existir una guia verificable para US2 | Cumple |
| Accion principal identificable por pantalla | Todas las pantallas objetivo de T024-T031 incorporan marcador/estructura de accion principal | Debe reducir ambiguedad de accion principal | Cumple |
