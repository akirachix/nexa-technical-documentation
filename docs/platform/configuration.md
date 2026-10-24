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

The names of the individual environment variables are not documented here. Add them, with the required and optional ones separated, once they are confirmed against the backend and frontend configuration.

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

| Service | Used for | Credential |
|---|---|---|
| Openrouteservice | Route distance and duration | API key |
| Gemini API | Cost estimate and explanation | API key |
| Email provider (not named) | OTP delivery | Email credentials |
| Supabase | Encrypted backups | Backup and separate recovery access |

Details of data shared with each service are in [Data flow and external services](../architecture/data-flow.md#external-services).
