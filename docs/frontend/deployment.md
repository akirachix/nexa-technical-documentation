# Frontend deployment

This page covers the frontend only. Backend deployment is documented separately in [Backend deployment](../backend/deployment.md).

## What is known

| Item | Detail |
|---|---|
| Client type | A Progressive Web App for Shippers and Fleet Managers |
| Entry path | HTTPS and TLS, then DNS and DDoS protection, the WAF and the API gateway. The secure architecture diagram labels the WAF as provided by Vercel. |
| Secrets | No secret may be placed in client-side configuration. |
| Configuration | Keep environment-specific settings, such as the API base URL, outside committed source code. |

## Release requirements

- Production builds succeed, and static assets load from the configured production domain.
- The API base URL differs per environment and points at the matching backend.
- The production domain and TLS certificate are configured before users are directed to the service.
- A release updates the service worker and cache version so users do not keep stale assets, and the release procedure includes cache invalidation and a rollback path.
- After release, a smoke test covers registration, verification, shipment publication, fleet matching, cost assessment, acceptance and contact handoff. See the [release checklist](../developer-guide/release-checklist.md).
