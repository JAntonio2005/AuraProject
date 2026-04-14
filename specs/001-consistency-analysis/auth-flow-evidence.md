# Auth Flow Evidence (Manual)

## Scope
- Flow: `ForgotPassword -> NewPassword`
- Environment: pending manual execution against backend reachable from device
- Last review: 2026-04-14

## Case A: Success Response
- Status: Pending manual validation
- Steps:
  1. Open `ForgotPasswordPage`
  2. Submit valid email
  3. Open `NewPasswordPage`
  4. Submit valid code + new password
- Expected:
  - Success snackbar in both steps
  - Redirect to `/login` after password update
- Observed:
  - Pending

## Case B: Controlled Error Response
- Status: Pending manual validation
- Steps:
  1. Submit invalid/unknown email or trigger backend error in request reset
  2. Submit invalid/expired code in confirm reset
- Expected:
  - Error snackbar with mapped message (no crash)
- Observed:
  - Pending

## Notes
- Implemented backend calls via `AuthService.requestPasswordReset` and `AuthService.confirmPasswordReset`.
- Final manual execution should be done on device/emulator with backend connectivity.
- Blocking condition: no backend credentials/test mailbox were provided in this branch session, so evidence remains pending by policy (no fabricated observations).
