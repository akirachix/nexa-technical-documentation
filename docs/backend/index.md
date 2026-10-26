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

The API is organised around the resource families below. All protected operations require authentication and server-side authorization. Exact route paths, HTTP methods and payload schemas should be confirmed against the backend's OpenAPI schema (`/docs` or `/openapi.json` when the backend is running); the table describes the operations each family is designed to support, and the [API reference](#api-reference) lists the documented endpoint contract.

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

## API reference

All paths are relative to the backend base URL. Request and response bodies are JSON. Datetimes use ISO 8601 (`YYYY-MM-DDThh:mm:ssZ`). IDs are UUIDs.

### Authentication

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/auth/register` | POST | None | Register a new user and company |
| `/auth/login` | POST | None | Email and password login, issues a session |
| `/auth/otp/verify` | POST | None | Verify the one-time code sent by email |
| `/auth/otp/resend` | POST | None | Resend the OTP (rate-limited) |
| `/auth/logout` | POST | Session | End the current session |
| `/auth/me` | GET | Session | Retrieve the current account |

**Example: register request**

```json
POST /auth/register
{
  "email": "owner@logistics.zm",
  "password": "StrongPassw0rd!",
  "first_name": "Jane",
  "last_name": "Banda",
  "role": "shipper",
  "company": {
    "business_name": "Jane Logistics Ltd",
    "registration_number": "123456789",
    "company_email": "owner@logistics.zm",
    "phone_number": "+260971234567",
    "company_type": "shipper"
  }
}
```

**Example: register response (201)**

```json
{
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "owner@logistics.zm",
  "role": "shipper",
  "company_id": "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
  "verification_status": "pending"
}
```

### Companies

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/companies/me` | GET | Session | Read the caller's business profile |
| `/companies/me` | PATCH | Session | Update the caller's business profile |
| `/companies/me/verification` | GET | Session | Retrieve verification status |
| `/companies/me/certificate` | POST | Session | Upload a PACRA certificate (max 10 MB) |

### Fleet and trucks

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/fleet/trucks` | GET | Session | List the company's trucks |
| `/fleet/trucks` | POST | Session | Create a truck |
| `/fleet/trucks/{truck_id}` | PATCH | Session | Update a truck owned by the company |
| `/fleet/trucks/{truck_id}` | DELETE | Session | Deactivate a truck |
| `/fleet/cost-settings` | GET | Session | Read private cost settings |
| `/fleet/cost-settings` | PATCH | Session | Update private cost settings |

### Shipments

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/shipments` | POST | Session | Create a shipment (Shipper only) |
| `/shipments` | GET | Session | List shipments visible to the caller |
| `/shipments/{shipment_id}` | GET | Session | Retrieve shipment details |
| `/shipments/{shipment_id}` | PATCH | Session | Update a shipment the caller owns |
| `/shipments/{shipment_id}/publish` | POST | Session | Publish a draft shipment |
| `/shipments/{shipment_id}/cancel` | POST | Session | Cancel a shipment in a permitted state |

**Example: create shipment request**

```json
POST /shipments
{
  "origin_address": "Lusaka, Zambia",
  "origin_latitude": -15.4167,
  "origin_longitude": 28.2833,
  "destination_address": "Ndola, Zambia",
  "destination_latitude": -12.9833,
  "destination_longitude": 28.6333,
  "cargo_type": "maize",
  "weight_kg": 12000,
  "required_body_type": "flatbed",
  "pickup_time": "2026-11-05T06:00:00Z",
  "proposed_amount": 45000.00,
  "special_requirements": "Covered load"
}
```

**Example: create shipment response (201)**

```json
{
  "shipment_id": "550e8400-e29b-41d4-a716-446655440001",
  "status": "open",
  "published_at": "2026-10-26T08:00:00Z"
}
```

### Matches and assessments

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/shipments/{shipment_id}/matches` | GET | Session | Retrieve compatible matches for a shipment |
| `/matches/{match_id}/assess` | POST | Session | Request route and cost assessment |
| `/matches/{match_id}` | GET | Session | Retrieve a match with its cost estimate |

**Example: assessment response (200)**

```json
{
  "match_id": "550e8400-e29b-41d4-a716-446655440002",
  "distance_km": 330.5,
  "duration": 390,
  "fuel_cost": 620.00,
  "driver_cost": 180.00,
  "toll_cost": 90.00,
  "maintenance_cost": 110.00,
  "other_cost": 40.00,
  "estimated_total_cost": 1040.00,
  "proposed_amount": 45000.00,
  "estimated_margin": 43960.00,
  "outcome": "profit",
  "ai_explanation": "The route is 330.5 km...",
  "manager_decision": "pending"
}
```

### Reservations

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/reservations` | POST | Session | Accept a match and secure a shipment |
| `/reservations/{reservation_id}` | GET | Session | Retrieve reservation and allocation state |
| `/reservations/{reservation_id}/decline` | POST | Session | Decline a match |
| `/reservations/{reservation_id}/cancel` | POST | Session | Cancel an accepted reservation |

**Example: accept response (201)**

```json
{
  "reservation_id": "550e8400-e29b-41d4-a716-446655440003",
  "shipment_id": "550e8400-e29b-41d4-a716-446655440001",
  "status": "accepted",
  "reserved_at": "2026-10-26T09:15:00Z"
}
```

A second acceptance for the same shipment returns `409 Conflict`, because `reservations.shipment_id` is unique and the backend re-checks shipment state before allocating.

### Contact handoff

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/reservations/{reservation_id}/contacts` | GET | Session | Retrieve counterparty contact details after allocation |

### Audit events

| Endpoint | Method | Auth | Description |
|---|---|---|---|
| `/audit` | GET | Operator session | Inspect audit events (restricted) |

## Authentication requirements

- Protected endpoints require a valid session established through `/auth/login` or OTP verification.
- The session token is never returned to the browser as bearer data usable outside the PWA; session handling follows [Backend security](../backend/security.md#authentication).
- OTP and login endpoints are rate-limited at the API gateway.

## Common error responses

| Status | Meaning | Example body |
|---|---|---|
| `400 Bad Request` | Invalid or missing input | `{"error": "weight_kg must be greater than 0"}` |
| `401 Unauthorized` | Missing or invalid session | `{"error": "Authentication required"}` |
| `403 Forbidden` | Authenticated but not permitted | `{"error": "Not permitted to view this organisation's data"}` |
| `404 Not Found` | Record does not exist or is hidden | `{"error": "Shipment not found"}` |
| `409 Conflict` | State conflict, e.g. already allocated | `{"error": "Shipment already allocated to another fleet company"}` |
| `429 Too Many Requests` | Rate limit exceeded | `{"error": "Too many attempts. Try again later"}` |
| `500 Internal Server Error` | Unexpected server failure | `{"error": "Unable to complete the request. Try again later"}` |

Error responses never include stack traces, database details, credentials or internal paths. Failures of the routing service or Gemini return controlled errors without provider credentials.

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
