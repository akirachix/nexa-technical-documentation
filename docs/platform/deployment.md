# Platform deployment

Component-specific deployment is documented separately: [Backend](../backend/deployment.md), [Frontend](../frontend/deployment.md) and [AI operations](../ai/operations.md). This page covers what they share, plus the shared deployment procedure.

## Shared infrastructure

| Item | Detail |
|---|---|
| Backups | Encrypted backups on Supabase, with separate recovery access |
| Secrets | Vault |
| External services | Openrouteservice and the Gemini API |
| Configuration | See [Configuration](configuration.md) |

## Deployment procedure

Follow these steps for each release:

1. **Confirm test evidence.** Review the [release checklist](../developer-guide/release-checklist.md) and the test results recorded for backend, AI, frontend and platform testing. All required tests must have been executed and findings resolved or triaged.
2. **Prepare the release package.** Build the backend and frontend from the same commit. Do not deploy uncommitted changes.
3. **Inject secrets.** Provide production secrets from Vault or protected deployment configuration. Do not print secrets during deployment and do not store them in source code.
4. **Run database migrations.** Apply migrations against the release database before starting the new version:
   ```bash
   # Backend migration command — confirm the exact command in the backend repository
   alembic upgrade head
   ```
   Keep a recovery plan: a recent backup and the ability to roll back the migration if it fails.
5. **Deploy the backend.** Roll out the new backend version with health checks enabled. Confirm HTTPS, CORS, allowed origins, cookie and session settings, error handling and audit events for the production domain.
6. **Deploy the frontend.** Publish the production build to the configured domain. Update the service worker and cache version and invalidate stale caches.
7. **Verify external services.** Confirm Openrouteservice returns route data and the Gemini API returns cost estimates using production credentials.
8. **Run the smoke test.** Complete the shipment lifecycle: registration, verification, shipment publication, fleet matching, cost assessment, acceptance and contact handoff.
9. **Confirm release readiness.** Check every item on the [release checklist](../developer-guide/release-checklist.md) before directing users to the service.

## Database migrations

- Migrations create and alter the seven tables described in [Data model](../backend/data-model.md): `companies`, `users`, `trucks`, `shipments`, `shipment_matches`, `reservations` and `audit_logs`.
- Run migrations against the release database with a recovery plan.
- Do not run migrations against production without a recent, tested backup.
- Confirm new columns (for example `shipment_matches.decided_at`) against the migrations before relying on them.

## Backups and recovery

Maintain encrypted backups with restricted backup access and separate recovery permissions. Set backup frequency and retention according to the operational recovery objectives. Test restoration before a production release and after material infrastructure changes.

## Production release controls

- Configure the production domain and TLS certificate before directing users to the service.
- Use a repeatable deployment pipeline with a documented rollback path.
- Configure health checks, structured logs and monitoring for the application and its dependencies.
- Keep production secrets in the secret manager, and make sure they are not printed during deployment.
- Do not scale the backend to several instances until the Gemini file registry is moved off the local server file.

## Release readiness checklist

Use the [release checklist](../developer-guide/release-checklist.md) as the final gate before a production release of the web application, API, database and AI cost-estimation service. It covers application readiness, security and privacy, data and recovery, AI and external services, and deployment and observability.
