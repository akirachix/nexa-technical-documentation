# Components and responsibilities

Components are grouped by the layers of the [secure architecture diagram](index.md#secure-architecture).

## Users

| Component | Responsibilities |
|---|---|
| Shipper (PWA) | Registers and submits the PACRA certificate, posts shipments, views shipment status and allocation, receives the fleet company's contact details after allocation. |
| Fleet Manager (PWA) | Manages trucks, availability and private cost settings, views eligible shipments and cost assessments, accepts or declines shipments, receives the shipper's contact details after allocation. |

## Perimeter

| Component | Responsibilities |
|---|---|
| DNS and DDoS protection | DDoS mitigation and rate limiting. |
| WAF | Input and output sanitisation, bot blocking and rate limiting. Labelled as provided by Vercel in the secure architecture diagram. |
| API gateway | Request schema and body-size validation, rate and abuse controls, login and OTP throttling, security headers. |

## Application (backend)

| Component | Responsibilities |
|---|---|
| Authentication and OTP | Email and password login, short-lived single-use email OTP, attempt and resend limits, session after OTP verification. |
| Authorization | Role enforcement, organisation scope, object and ownership checks. |
| Business verification | PACRA certificate validation using QR and OCR checks. Fails safely when information cannot be reliably processed. See [Business verification](../backend/verification.md). |
| Shipment management | Creates and validates shipments. The Shipper confirms before publication. |
| Cargo validation | Rejects cargo types that ZamLine does not accept. |
| Fleet management | Fleet records, truck capacity, body type and availability. |
| Fleet matching | Selects open shipments that an available truck can carry. |
| Cost estimation | Route distance and duration, private organisation-scoped cost inputs, comparison of the shipment's proposed payment with the estimated cost. See [AI Module](../ai/index.md). |
| First-accept allocation | Backend state check and an atomic guard against double allocation. |
| Contact handoff | Releases relevant contacts only after successful allocation. |

## Data and storage

| Component | Responsibilities |
|---|---|
| PostgreSQL (encrypted) | Accounts, organisations, fleet, shipments, cargo, matches, reservations, private costs and audit records. See [Data model](../backend/data-model.md). |
| Certificate storage | Holds PACRA certificate files separately from the database. The database stores a reference (`companies.certificate_file_url`). |
| Reference file storage | Holds the Markdown reference files used by cost estimation. |
| Gemini file registry | A local JSON configuration file on the application server that records each Gemini file reference and its upload timestamp. |
| Secret manager (Vault) | Database credentials, routing and email credentials, application secrets. |
| Audit and security logs | Authentication, OTP, authorization, verification, cargo and allocation events. Passwords, OTPs and API keys are excluded. |
| Encrypted backups | Backup storage on Supabase with restricted backup access and separate recovery access. |

## External services

| Service | Responsibilities |
|---|---|
| Openrouteservice | Route distance, duration and route details using the heavy-goods-vehicle profile. |
| Gemini API | Generates the cost-estimate explanation from structured context and the uploaded reference files. Content filtering applies. |
