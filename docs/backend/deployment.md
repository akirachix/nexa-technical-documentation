# Backend deployment

This page covers the backend only. Frontend deployment is documented separately in [Frontend deployment](../frontend/deployment.md), and AI reference-file operations in [AI operations](../ai/operations.md).

## Hosting and configuration

| Item | Description |
|---|---|
| Hosting | Heroku hosts the ZamLine backend application. |
| Database | PostgreSQL. Database encryption is required. |
| Secrets | Database, routing, email and application secrets are retrieved from Vault. Secrets must not be stored in source code or client configuration. |
| Transport security | HTTPS and TLS protect all traffic to the backend API. |
| Backups | Backups are encrypted, access is restricted, and recovery access is separate. See [Platform deployment](../platform/deployment.md#backups-and-recovery). |

## Release requirements

Before a backend release:

1. Apply database migrations against the release database, with a recovery plan.
2. Confirm production secrets are injected from the secret manager or protected deployment configuration, and are not printed during deployment.
3. Verify HTTPS, CORS and allowed origins, cookie and session settings, error handling, health checks and audit events for the production domain.
4. Run the smoke test described in the [release checklist](../developer-guide/release-checklist.md).

Development and production must differ in database, API URLs, secrets and debug configuration. Production errors must never expose internals.

