# Aura Project Constitution

## Core Principles

### I. Build Health First
- Every feature branch MUST keep the project free of analyzer `error` diagnostics.
- Any dependency introduced in code MUST be declared in `pubspec.yaml`.

### II. Single Source for Runtime Flows
- Core runtime flows (navigation, auth token usage, API client access) MUST have one documented primary source.
- Parallel/legacy code MAY exist temporarily only if explicitly marked and tracked in feature docs.

### III. Verifiable Incremental Delivery
- Every user story MUST include an independent validation path (command, test, or manual scenario).
- Placeholder tests are not acceptable as completion evidence.

### IV. Safe Error Handling
- User-facing network failures MUST provide recoverable, understandable messages.
- Silent failures are not allowed in user-critical flows (auth, predict, history, profile).

### V. Simplicity Over Refactor Churn
- Prefer minimal, targeted edits over broad structural rewrites.
- Large refactors require explicit justification in the plan and a rollback strategy.

## Quality Gates

- Gate A: `flutter analyze` shows zero `error` entries.
- Gate B: `flutter test` passes for all affected tests.
- Gate C: Tasks and requirements mapping is explicit; unresolved warnings are documented in backlog.

## Development Workflow

- Specs, plan, and tasks MUST be updated before major implementation phases.
- Each completed phase should leave observable evidence in feature docs (baseline, final reports, or validation notes).
- Breaking decisions (routing/auth/service ownership) MUST be documented in the feature folder.

## Governance

This constitution governs planning and implementation quality for the repository. Any exception MUST be documented in the current feature plan with rationale and impact.

**Version**: 1.0.0 | **Ratified**: 2026-04-08 | **Last Amended**: 2026-04-08
