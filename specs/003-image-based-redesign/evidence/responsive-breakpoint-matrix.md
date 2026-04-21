# T034 Evidence - Responsive Breakpoint Matrix

## Breakpoint Definitions

- small: width < 380
- medium: 380 <= width < 900
- large: width >= 900

## Criteria by Breakpoint

| Criterio | small | medium | large |
|---|---|---|---|
| Max-width containment | Required | Required | Required |
| Primary CTA height adaptation | 46 px min | 48-52 px | 52 px |
| Horizontal padding adaptation | 12-16 px | 16-24 px | 24 px |
| Navigation tap targets | >=72 px nav height | >=80 px nav height | >=80 px nav height |
| Content readability | No clipping | Stable hierarchy | Stable hierarchy + expanded width |

## Screen Targets

- login_page
- register_page
- home_page
- collection_page
- community_page
- capture_page
- history_page
- profile_page
- forgot_password_page
- new_password_page

## Evidence (Esperado | Observado | Criterio | Resultado)

| Esperado | Observado | Criterio | Resultado |
|---|---|---|---|
| Matriz de breakpoints y criterios visuales definida | Se documentaron rangos small/medium/large y criterios de adaptacion | Debe guiar validacion consistente para US3 | Cumple |
| Cobertura de pantallas en alcance US3 | Se listaron las 10 pantallas objetivo de T035-T044 | Debe asegurar trazabilidad de ajustes responsive | Cumple |
