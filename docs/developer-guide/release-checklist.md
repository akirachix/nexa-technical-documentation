# Release checklist

Use this checklist as the final gate before a production release of the web application, API, database and AI cost-estimation service. Deployment procedures are documented separately for the [backend](../backend/deployment.md), the [frontend](../frontend/deployment.md) and the [AI reference files](../ai/operations.md).

## Application readiness

- [x] Shipper and Fleet Manager registration, login and email OTP flows work end to end.
- [x] PACRA certificate upload, QR and OCR processing, verification result and resubmission paths behave safely.
- [x] Shippers can create and manage shipments, and Fleet Managers can configure trucks and availability.
- [x] Compatible shipment results respect fleet capacity, shipment status and organisation boundaries.
- [x] Route distance and duration use the configured heavy-goods-vehicle routing profile.
- [x] The cost assessment presents its assumptions and explanation clearly.
- [x] Concurrent acceptance requests result in one allocation only.
- [x] Contact details are revealed only after the permitted reservation state.
- [x] Layouts, keyboard navigation, focus states and form error messages are usable on supported screen sizes.

## Security and privacy

- [x] HTTPS is enforced, and production secrets are injected from a secret manager or protected deployment configuration.
- [x] No credentials, OTP values, tokens, private cost data or certificate contents appear in logs.
- [x ] Role authorization and organisation isolation are tested for every protected resource family, including object-level authorization and IDOR scenarios.
- [x] Upload validation rejects unsupported, malformed and oversized files.
- [x] Rate limiting and safe error handling cover authentication, OTP and sensitive API routes.
- [x] Dependency scanning and source security checks have been reviewed, and findings resolved or triaged.
- [x] Audit events cover authentication, verification, shipment changes, fleet changes, cost assessment, allocation and authorization failures.
- [x] Retention and deletion jobs follow the approved category-specific schedule and legal holds.

## Data and recovery

- [x] Database migrations complete successfully against the release database, with a recovery plan.
- [x] A recent backup exists, and a restore has been exercised in a controlled environment.
- [x] Database credentials have least-privilege access.
- [x] Audit and business records remain consistent after a restart or a failed external request.

## AI and external services

- [x] Routing provider credentials are server-side only.
- [x ] Gemini credentials are server-side only, and requests contain only the data required for estimation.
- [x] Provider timeouts, invalid responses and rate limits produce controlled fallback behaviour.
- [x] Cost outputs are checked against known deterministic scenarios, and historical references are labelled by period.
- [x] Model and provider version and assessment metadata are retained for operational traceability.

## Deployment and observability

- [x] The production build succeeds, and static assets load from the configured domain.
- [x] CORS, allowed origins, cookie and session settings and security headers match the production domain.
- [x] Health checks, error monitoring and alert ownership are configured.
- [x] Database and application logs are accessible to authorized operators only.
- [x] Rollback and incident-response contacts are documented.
- [x] A smoke test passes for the complete shipment lifecycle: registration, verification, shipment publication, fleet matching, cost assessment, acceptance and contact handoff.
