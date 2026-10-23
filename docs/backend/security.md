# Backend security

This page lists the security requirements for the backend modules: authentication and OTP, authorization, shipment and fleet management, matching and first-accept allocation, audit logging and error handling. Related pages: [Business verification](verification.md) for uploads, [Platform security](../platform/security.md) for secrets, perimeter and database, and [AI security](../ai/security.md) for the Gemini integration.

## Authentication

| Requirement | Priority |
|---|---|
| Every Shipper and Fleet Manager authenticates before reaching protected functions or organisation data | High |
| Email and password login, plus a short-lived, single-use email OTP with attempt and resend limits | High |
| Passwords are stored as hashes (`users.password_hash`) using a modern password-hashing algorithm | High |
| Secure session handling, with sessions ended on logout or expiry | Medium |

## Authorization

Authorization is separate from authentication: it decides what an authenticated user may do.

| Requirement | Priority |
|---|---|
| Role-based checks (`shipper`, `fleet_manager`) plus organisation-level checks | High |
| Users act only within their role and see only their organisation's data, or data exposed through the shipment workflow | High |
| Object and ownership checks on individual records | High |
| Organisation data isolation: one organisation's data is never reachable by another | High |
| Private cost data (the cost columns of `companies`, `trucks.fuel_consumption_l_per_100km` and `trucks.maintenance_per_km`) is returned only to the owning company | High |
| Only `verified` companies may post or accept shipments | High |
| Contact details are released only after a valid reservation | High |

## Input validation and error handling

| Requirement | Priority |
|---|---|
| Server-side validation of shipment weight, proposed payment, route inputs, fleet capacity and cost settings. Invalid, missing, negative or out-of-range values are rejected. | High |
| Database constraints enforce basic rules, for example `weight_kg > 0`, `proposed_amount > 0` and latitude and longitude ranges. See [Data model](data-model.md). | High |
| The Shipper confirms a shipment before it is published, and unaccepted cargo types are rejected | High |
| Error responses contain no stack traces, database details, credentials or internal paths | Medium |
| Failures of external services return controlled errors | Medium |

## Allocation integrity

Only one fleet company can secure a shipment. Two mechanisms enforce this:

- The backend re-checks the shipment's state when a Fleet Manager accepts it.
- `reservations.shipment_id` is `UNIQUE`, so the database rejects a second reservation for the same shipment even if two acceptances arrive at the same moment.

A successful acceptance creates the `reservations` row, sets the shipment to `confirmed` and sets the other matches for that shipment to `closed`. A Fleet Manager who loses the race receives a conflict response.

## Logging and monitoring

| Requirement | Priority |
|---|---|
| Authentication events, verification results, shipment creation and material changes, fleet and cost-setting changes, acceptance outcomes and authorization failures are traceable | Medium |
| Logs exclude passwords, OTPs, tokens, API keys and unnecessary sensitive data | Medium |
| Audit logs have restricted access, integrity protection and retention controls | High |

The audit table and actions are described in [Backend](index.md#audit-events). The monitoring and alerting tools are not named in the project material.

## Integrations

| Integration | Requirement |
|---|---|
| Openrouteservice | The API key is in the Vault, fetched only by the backend, and never exposed to the PWA, source code or logs. Failures return controlled errors. Only origin and destination coordinates and routing parameters are shared. |
| Gemini API | See [AI security](../ai/security.md). |

## Threats and required controls

| Threat | Required control |
|---|---|
| Unauthorized access | Authentication, role-based access control, organisation-level authorization, server-side checks |
| Cross-organisation data disclosure | Organisation isolation and authorization testing |
| Account compromise | Secure session handling, safe account recovery, access monitoring |
| Malicious or invalid input | Server-side validation, accepted ranges, type checking, sanitisation |
| Exposure of private cost information | Organisation isolation, authorization, minimum necessary exposure |
| Double shipment allocation | Atomic allocation and concurrency testing |
| Incorrect shipment details | Required fields, range checks, Shipper confirmation before publication |
| External routing failure | Controlled errors, input validation, server-side key protection |
| Sensitive information in logs | A logging policy that excludes credentials, keys, tokens and unnecessary personal or commercial data |

## Implementation standards

Apply restrictive CORS rules, CSRF protection where cookie-based authentication is used, request throttling on authentication and OTP endpoints, a modern password-hashing algorithm, short-lived verification codes, pinned and scanned dependencies, parameterised database operations and context-aware output encoding. Keep configuration in the deployment environment and review it at every release.
