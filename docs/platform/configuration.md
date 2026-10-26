# Configuration

## Configuration categories

Configuration values differ between environments. Never place real values in documentation or source control.

| Category | Secret | Notes |
|---|---|---|
| Database connection | Yes | Held in the secret manager |
| Routing service key | Yes | Never exposed to the PWA, source code or logs |
| Gemini API key | Yes | A server-side secret |
| Email (OTP) credentials | Yes | Held in the secret manager |
| Application secrets, for example token signing | Yes | Held in the secret manager |
| Public configuration, for example the API base URL | No | Set per environment outside committed source |

## Environment variables

The exact environment variable names should be confirmed against the backend and frontend repositories. The table below lists the canonical names used in this documentation; confirm them before deployment.

| Variable | Required | Secret | Example value | Purpose |
|---|---|---|---|---|
| `DATABASE_URL` | Yes | Yes | `postgresql+psycopg2://zamline:password@host:5432/zamline` | PostgreSQL connection string |
| `GEMINI_API_KEY` | Yes | Yes | server-side secret | Gemini API key |
| `ORS_API_KEY` or `OPENROUTESERVICE_API_KEY` | Yes | Yes | server-side secret | Openrouteservice API key |
| `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS` | Yes | Yes | mail provider settings | OTP email delivery |
| `SECRET_KEY` or `JWT_SECRET` | Yes | Yes | server-side secret | Session and token signing |
| `API_BASE_URL` | No | No | `https://api.zamline.example.com` | Public backend base URL |
| `CORS_ORIGINS` | No | No | `https://app.zamline.example.com` | Allowed frontend origins |
| `ENVIRONMENT` | No | No | `development` or `production` | Deployment environment |
| `LOG_LEVEL` | No | No | `info` | Application log level |

## Development and production

The two environments should differ as follows.

| Aspect | Requirement |
|---|---|
| Databases | Development and production should use separate databases. |
| API URLs | Each environment should point the frontend at its own backend. |
| Secrets | Must always come from the secret manager or protected deployment configuration, never source code or client configuration. |
| Debug configuration | Debugging should be off in production, and production errors must never expose internals. |
| CORS | Allowed origins should match the production domain. |

## External services

| Service | Used for | Credential | Failure handling |
|---|---|---|---|
| Openrouteservice | Route distance and duration | API key | Request returns a controlled error; no provider credentials exposed |
| Gemini API | Cost estimate and explanation | API key | `estimated_total_cost` is null; controlled message to the Fleet Manager |
| Email provider (not named) | OTP delivery | Email credentials | OTP delivery failure returns a controlled error at login or resend |
| Supabase | Encrypted backups | Backup and separate recovery access | Restoration tested before production and after material infrastructure changes |

Details of data shared with each service are in [Data flow and external services](../architecture/data-flow.md#external-services).

## Verifying external services

| Service | How to verify it is working |
|---|---|
| Openrouteservice | Call a route with known origin and destination coordinates and confirm distance and duration are returned |
| Gemini API | Request a cost estimate for a known shipment and truck and confirm `estimated_total_cost`, `ai_explanation` and margin are populated |
| Email provider | Register a new user and confirm the OTP email arrives |
| Supabase | Restore a backup into a clean environment and confirm application and audit records are recoverable |
