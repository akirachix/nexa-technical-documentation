# Platform deployment

Component-specific deployment is documented separately: [Backend](../backend/deployment.md), [Frontend](../frontend/deployment.md) and [AI operations](../ai/operations.md). This page covers what they share.

## Shared infrastructure

| Item | Detail |
|---|---|
| Backups | Encrypted backups on Supabase, with separate recovery access |
| Secrets | Vault |
| External services | Openrouteservice and the Gemini API |
| Configuration | See [Configuration](configuration.md) |

## Backups and recovery

Maintain encrypted backups with restricted backup access and separate recovery permissions. Set backup frequency and retention according to the operational recovery objectives. Test restoration before a production release and after material infrastructure changes.

## Production release controls

- Configure the production domain and TLS certificate before directing users to the service.
- Use a repeatable deployment pipeline with a documented rollback path.
- Configure health checks, structured logs and monitoring for the application and its dependencies.
- Keep production secrets in the secret manager, and make sure they are not printed during deployment.
- Do not scale the backend to several instances until the Gemini file registry is moved off the local server file. 

