# Data Model: Global Redesign and Breeds Pagination

## Entity: ScreenLayoutProfile
- Purpose: Defines the reusable visual composition pattern for a screen.
- Fields:
  - `screenId` (string)
  - `layoutVariant` (enum): `compact` | `regular` | `wide`
  - `hasContextHeader` (bool)
  - `hasPrimaryActionZone` (bool)
  - `statePanelStyle` (string)
- Validation rules:
  - Every main screen must have one active profile per breakpoint variant.
  - `hasPrimaryActionZone` must be true for task-driven screens.

## Entity: BreedsPaginationState
- Purpose: Represents paginated navigation status in collection.
- Fields:
  - `currentPage` (int)
  - `pageSize` (int)
  - `totalItems` (int)
  - `totalPages` (int)
  - `hasNextPage` (bool)
  - `hasPreviousPage` (bool)
- Validation rules:
  - `currentPage >= 1`
  - `totalPages >= 1` when `totalItems > 0`
  - `currentPage <= totalPages`

## Entity: BreedsQueryContext
- Purpose: Captures active filtering/search criteria that pagination depends on.
- Fields:
  - `queryText` (string)
  - `activeFilters` (map<string, string>)
  - `sortMode` (string)
- Validation rules:
  - Query updates must re-evaluate page validity.
  - Invalid page after query change must fallback to first valid page.

## Entity: PaginationInteractionEvent
- Purpose: Represents user actions on paginator controls.
- Fields:
  - `eventType` (enum): `next` | `previous` | `jump`
  - `originPage` (int)
  - `targetPage` (int)
  - `isAccepted` (bool)
- Validation rules:
  - `targetPage` must be within `[1, totalPages]`.
  - Rejected events must not mutate visible item slice.

## Relationships
- `ScreenLayoutProfile` is applied across main feature pages.
- `BreedsPaginationState` depends on the active `BreedsQueryContext`.
- `PaginationInteractionEvent` transitions `BreedsPaginationState`.

## State Transitions
- Pagination flow: `idle -> page-change-requested -> page-updated`.
- Query update flow: `query-updated -> page-revalidated -> list-rendered`.
