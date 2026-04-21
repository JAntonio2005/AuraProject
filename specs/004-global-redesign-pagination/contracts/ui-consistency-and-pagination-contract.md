# Contract: UI Consistency and Breeds Pagination

## 1. Scope
This contract defines mandatory behavior for:
- visual consistency across main screens
- breeds list pagination behavior in collection

## 2. Visual Consistency Contract
- Main screens must preserve a consistent structure:
  - context header
  - main content region
  - clearly distinguishable primary action
  - coherent state feedback (loading/empty/error)
- Navigation patterns and hierarchy must remain stable across modules.
- Compact and wide layouts must keep readability and tap/action accessibility.

### 2.1 Composition Profile (Reusable)
- Every main screen must apply the same composition order:
  1. context header
  2. explanatory/support text (optional)
  3. primary action zone
  4. secondary content blocks
  5. feedback states shell when applicable
- Spacing rhythm must follow shared design tokens.
- State panels must render in a constrained container for visual consistency.

## 3. Breeds Pagination Contract
- Collection must expose explicit pagination controls.
- Current page must always be visible.
- Previous/next controls must reflect valid navigation bounds.
- Pagination must run over the active filtered/search result set.
- Filter/query changes must invalidate out-of-range pages and recover to a valid page.

## 4. Interaction Contract
- Pagination interaction must not break the selected query context.
- No visual jump should remove orientation (user always knows page and result block).
- Pagination controls must remain operable in compact and wide widths.

## 5. Validation Checklist
- Analyzer gate: zero `error` diagnostics.
- Test gate: affected tests pass.
- Manual walkthrough:
  - cross-screen visual consistency
  - collection pagination with and without active query/filter
  - boundary scenarios (first/last page, zero results after query change)

## 6. Non-Regression Conditions
- Existing auth and navigation flows keep expected outcomes.
- Existing breed detail opening flow remains functional from paginated list items.
- Responsive readability remains acceptable in compact and wide widths.
