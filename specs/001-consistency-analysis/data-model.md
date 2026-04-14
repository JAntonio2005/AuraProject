# Data Model: Flutter Project Consistency Hardening

## Entity: AuthSession
- Description: Represents authenticated user session state in client runtime.
- Fields:
  - `accessToken` (String, required)
  - `tokenType` (String, optional)
  - `isAuthenticated` (bool, derived)
- Validation Rules:
  - `accessToken` must be non-empty to consider session valid.
- State Transitions:
  - `unauthenticated -> authenticated` after successful login.
  - `authenticated -> unauthenticated` after logout or token invalidation.

## Entity: PasswordResetRequest
- Description: Payload to request reset flow.
- Fields:
  - `email` (String, required)
- Validation Rules:
  - Email must match app validation regex and be non-empty.

## Entity: PasswordResetConfirm
- Description: Payload to confirm new password.
- Fields:
  - `code` (String, required)
  - `newPassword` (String, required)
- Validation Rules:
  - `code` minimum length as enforced by UI.
  - `newPassword` minimum length 6.

## Entity: PredictResponse
- Description: AI prediction response consumed by capture/result flows.
- Fields:
  - `logId` (int, required)
  - `top1` (PredictionItem, required)
  - `top5` (List<PredictionItem>, required)

## Entity: PredictionHistoryItem
- Description: Unified model for prediction/search history rendering.
- Fields:
  - `id` (String, required)
  - `title` (String, required)
  - `imageName` (String, optional)
  - `confidence` (double, optional)
  - `createdAt` (DateTime, optional)

## Entity: BreedSummary
- Description: Breed catalog item used in collection/search/detail.
- Fields:
  - `id` (int, required)
  - `name` (String, required)
  - `slug` (String, required)
  - `label` (String, required)
  - `description` (String, optional)
  - `imageUrl` (String, optional)
