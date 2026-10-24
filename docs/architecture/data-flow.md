# Data flow and external services

## Main flows

| Flow | Path |
|---|---|
| Request | PWA → HTTPS/TLS → DNS and DDoS protection → WAF → API gateway → backend module → PostgreSQL |
| Verification | A Shipper or Fleet Manager uploads a PACRA certificate → business verification (QR and OCR) → `verification_status` on `companies`. Every attempt is written to `audit_logs`. |
| Cost estimate | Backend → routing service (distance, duration) and Gemini API (reference files and journey details) → cost fields on `shipment_matches` |
| Allocation | Acceptance → backend state check → atomic guard → `reservations` row → shipment `confirmed` → other matches for the shipment `closed` |
| Contact handoff | After allocation only: the Shipper sees the accepting company's permitted contacts, and `contact_viewed` is logged. |
| Reference file refresh | The backend checks the Gemini file reference, re-uploads the Markdown original if it has expired, and updates the local registry. See [Gemini file expiry and refresh](../ai/operations.md#gemini-file-expiry-and-refresh). |

## External services

| Service | Purpose | Data shared | Credential handling |
|---|---|---|---|
| Openrouteservice | Distance and duration for the route | Origin and destination coordinates and routing parameters | API key in the Vault, fetched only by the backend, never exposed to the PWA, source code or logs |
| Gemini API | Cost estimate and explanation | Structured context only, with content filtering | API key held as a server-side secret |
| Supabase | Encrypted backups | Backup copies of application data | Restricted backup access and separate recovery access |
| Email provider | Delivery of OTP emails | Recipient address and one-time code | Credentials in the Vault. The provider is not named in the project material. |

