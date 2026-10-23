# Backend

The ZamLine backend is the trusted service layer between the Progressive Web App, PostgreSQL, business-verification processing, the routing service and AI cost estimation. It owns authentication, authorization, validation, data integrity and audit events. The browser is never the authority for permissions or cost privacy.

| Page | What it covers |
|---|---|
| [Data model](data-model.md) | Tables, columns, constraints and relationships |
| [Business verification](verification.md) | PACRA certificate upload, QR and OCR checks, verification outcomes |
| [Security](security.md) | Authentication, authorization, validation, allocation integrity, logging |
| [Testing](testing.md) | Required and recommended backend tests |
| [Deployment](deployment.md) | Hosting and release requirements |

## Technology

| Item | Detail |
|---|---|
| Framework | FastAPI (Python) |
| Database | PostgreSQL, encrypted |
| Authentication | Email and password with a short-lived, single-use email OTP |
| Hosting | Heroku (see [Deployment](deployment.md)) |
| External services | Openrouteservice for routes, Gemini API for cost explanations |

## Service responsibilities

| Service area | Responsibilities | Primary data |
|---|---|---|
| Authentication and OTP | Registration, login, verification codes, session lifecycle and logout | `users`, audit events |
| Companies and verification | Company profiles, PACRA certificate processing, verification status | `companies`, protected files |
| Fleet and trucks | Fleet setup, truck capacity, body type, availability and private operating costs | `companies`, `trucks` |
| Shipments | Create, publish, update and track cargo opportunities | `shipments` |
| Routing and assessment | Route distance and duration, operating-cost assessment, estimate explanation | `shipment_matches` |
| Matching | Filter open shipments against available compatible trucks | `shipments`, `trucks`, `shipment_matches` |
| Reservations and allocation | Accept or decline compatible shipments and enforce one winning allocation | `reservations`, `shipment_matches` |
| Contact handoff | Release permitted business contact details after allocation | `companies`, `reservations`, `audit_logs` |
| Audit logging | Record security-relevant and business-critical actions | `audit_logs` |

## API design

The API is organised around the resource families below. All protected operations require authentication and server-side authorization. Route paths, HTTP methods and payload schemas are not listed in this documentation; the table describes the operations each family is designed to support.

| Resource family | Typical operations | Authorization rule |
|---|---|---|
| Authentication | Register, log in, verify OTP, resend OTP, log out, retrieve the current account | Public only where needed for account creation and authentication. OTP endpoints are rate-limited. |
| Companies | Read and update the own business profile, submit or retrieve verification status | Company owner or authorized member. Certificate access is restricted. |
| Fleet and trucks | List, create, update and deactivate trucks, maintain operating-cost settings | Fleet Manager within the owning company |
| Shipments | Create, publish, list eligible shipments, retrieve details, update or cancel permitted states | The Shipper owns mutations. Fleet Managers see eligible published opportunities. |
| Matches and assessments | Retrieve compatible shipments, request or retrieve route and cost assessment | Fleet Managers see only permitted estimate fields. Private inputs stay organisation-scoped. |
| Reservations | Accept or decline a shipment, retrieve reservation and allocation state | Eligible Fleet Manager. Acceptance is atomic and single-winner. |
| Contact handoff | Retrieve counterparty business contact details after allocation | Only the parties entitled under the successful reservation |
| Audit events | Record and inspect audit data | Writes from trusted services. Reads restricted to authorized operators. |

## Business rules

- Only verified businesses take part in protected shipper and fleet workflows.
- Only published, open shipments are considered for matching.
- Only available trucks that meet the shipment's requirements are eligible.
- Private company operating-cost settings and private truck cost fields are visible only to the owning fleet company and the backend's assessment logic.
- A Shipper's proposed payment is commercially sensitive data.
- Accepting a shipment is transactional: it cannot be allocated to more than one Fleet Manager.
- Contact handoff follows a successful reservation and is audit logged.
- Invalid weights, negative payments, impossible capacity values and invalid route inputs are rejected on the server.

## Response and error conventions

Successful responses return structured JSON. Validation errors identify the invalid field without echoing sensitive input. Authorization failures do not reveal whether another organisation's private record exists. A state conflict, such as a shipment that was already allocated, returns a conflict response so the frontend can refresh its state. Failures of the routing service or the AI call return controlled errors without provider credentials, stack traces or internal details.

Responses should carry a request or correlation identifier for tracing. Logs must exclude passwords, OTP values, access tokens, API keys and unnecessary personal or commercial data.

## Audit events

The audit trail covers authentication events, verification attempts and outcomes, shipment publication and material changes, shipment views where required, fleet changes, cost-assessment requests, allocation outcomes, contact handoff and authorization failures. Each event records a timestamp, the actor and organisation where applicable, an action type, a reference to the target record, the outcome and a minimal details object. The table is described in [Data model](data-model.md#audit_logs).
