# Contract: UI Navigation and Visual Consistency

## Scope
Defines expected UI behavior for modernized main navigation and Community section.

## Navigation Contract
- Component: Global bottom `NavigationBar`.
- Destinations (fixed order):
  1. Razas (`/collection`)
  2. Camara (`/capture`)
  3. Comunidad (`/community`)
  4. Historial (`/history`)
  5. Perfil (`/profile`)
- Behavioral rules:
  - Exactly one destination is active at any time.
  - Selecting destination `i` routes to its section without creating conflicting stacks.
  - Active/inactive icon states are visually distinct.
  - Labels remain visible and readable on target form factors.

## Visual Consistency Contract
- Shared style requirements across main sections:
  - Consistent spacing rhythm for screen paddings and section gaps.
  - Consistent radius/elevation treatment for cards and surfaces.
  - Consistent heading/subheading hierarchy and action prominence.
- Error/loading states:
  - Must show clear feedback and preserve visual language consistency.

## Community Screen Contract
- Screen title: `Comunidad`.
- Must render a hero-intro section and at least three structured content blocks.
- Content block minimum fields:
  - icon
  - title
  - subtitle
  - actionable affordance (tap target)

## Validation Checklist
- `flutter analyze` has zero `error` diagnostics.
- `flutter test` passes.
- Manual walkthrough confirms all five destinations and visual consistency criteria.

## Implementation Confirmation (T028)
- Date: 2026-04-14
- Main navigation component: `lib/src/widgets/app_navigation_bar.dart`
- Canonical destinations: `lib/src/core/routes/app_destinations.dart`
- Main integrated screens:
  - `collection_page.dart`
  - `capture_page.dart`
  - `community_page.dart`
  - `history_page.dart`
  - `profile_page.dart`
