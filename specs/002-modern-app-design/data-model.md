# Data Model: Modern App Visual Refresh

## Entity: NavigationDestination
- Purpose: Represents one primary app section in global navigation.
- Fields:
  - `key` (string): stable identifier (`breeds`, `camera`, `community`, `history`, `profile`)
  - `label` (string): user-facing name
  - `activeIcon` (icon ref): selected-state icon
  - `inactiveIcon` (icon ref): default-state icon
  - `routeName` (string): app route target
  - `position` (int): fixed index in navigation order
- Validation:
  - `position` must be unique and contiguous.
  - `label` should be short and readable in narrow layouts.

## Entity: VisualStyleToken
- Purpose: Central reusable visual constants for coherence.
- Fields:
  - `spacingScale` (map): e.g., 4/8/12/16/24
  - `radiusScale` (map): e.g., 8/12/16/20
  - `elevationScale` (map): semantic levels for cards/buttons
  - `surfaceOpacity` (map): background/surface alpha guidance
  - `motionDuration` (map): standard animation durations
- Validation:
  - Token names must be semantic (`spacingMedium`) rather than screen-specific.
  - Tokens should be reused by at least two screens before adding new ones.

## Entity: CommunityContentBlock
- Purpose: Represents one content card in Community screen.
- Fields:
  - `id` (string)
  - `title` (string)
  - `subtitle` (string)
  - `icon` (icon ref)
  - `actionType` (enum): `navigate` | `external` | `placeholder`
  - `actionTarget` (string): route/url/action identifier
- Validation:
  - `title` and `subtitle` must be non-empty.
  - `actionType` and `actionTarget` must be consistent.

## Relationships
- `NavigationDestination` drives route transitions across main feature pages.
- `VisualStyleToken` is consumed by pages/components to maintain UI consistency.
- `CommunityContentBlock` is rendered inside Community feature and can later bind to API data.
