# API Contract (Client Expectations)

This document defines client-side request/response expectations used by Aura Flutter app.

## Authentication

### POST `/auth/login`
- Request:
  - Content-Type: `application/x-www-form-urlencoded`
  - Fields: `username`, `password`
- Success (200):
  - `access_token` (string)
  - `token_type` (string)
- Error:
  - 400/401 invalid credentials

### POST `/auth/register`
- Request JSON:
  - `email` (string)
  - `password` (string)
  - `full_name` (string)
- Success:
  - 200/201 with created payload or confirmation
- Error:
  - 409 already exists

### POST `/auth/password/reset/request`
- Request JSON:
  - `email` (string)
- Success:
  - 200/202 accepted
- Error:
  - 400 invalid email
  - 404 unknown account (optional behavior)

### POST `/auth/password/reset/confirm`
- Request JSON:
  - `code` (string)
  - `newPassword` (string)
- Success:
  - 200 password updated
- Error:
  - 400 invalid code / weak password
  - 410 expired code

## Profile

### GET `/auth/me`
- Auth: Bearer token required
- Success:
  - `email` (string)
  - `full_name` (string)
- Error:
  - 401 unauthorized/session expired

## AI Predict

### POST `/predict` or `/ai/detect` (active endpoint decided in US2)
- Auth: Bearer token required
- Request:
  - multipart/form-data with `file`
- Success:
  - `log_id` (int)
  - `top1` (object)
  - `top5` (array)
- Error:
  - 401 unauthorized
  - 413 image too large

## History

### GET `/history/predictions`
- Auth: Bearer token required
- Success:
  - List of prediction history entries OR `{ "results": [...] }`

### GET `/history/searches`
- Auth: Bearer token required
- Success:
  - List of search history entries OR `{ "results": [...] }`

### POST `/history/searches`
- Auth: Bearer token required
- Request JSON:
  - `query` (string, optional)
  - `breed_label` (string, optional)
- Rule:
  - At least one of `query` or `breed_label` must be present
