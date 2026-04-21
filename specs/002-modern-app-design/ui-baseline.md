# UI Baseline (T001)

## Fecha
- 2026-04-14

## Alcance baseline
- Pantallas principales evaluadas:
  - collection
  - capture
  - history
  - profile
  - community

## Hallazgos baseline
- Navegacion inferior ya usa estilo moderno en varias pantallas, pero duplicada por pantalla.
- Espaciados y radios repetidos como literales en multiples vistas.
- Estados loading/error/empty no estaban completamente estandarizados en componentes compartidos.

## Criterio de mejora esperado
- Unificar navegacion en componente reutilizable.
- Introducir tokens visuales compartidos para consistencia.
- Registrar evidencia de validaciones responsive, auth/nav y metricas UX.
