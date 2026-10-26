# Security

ZamLine handles business identities, commercially sensitive prices, private operating costs and contact details. This section shows where each security requirement is documented. The component pages contain the detailed requirements.

## Security by component

<div class="grid cards" markdown>

-   :material-server-security: **[Backend security](../backend/security.md)**

    Authentication, authorization, validation, allocation integrity, logging.

-   :material-file-certificate: **[Business verification](../backend/verification.md)**

    PACRA upload, QR and OCR checks, fail-safe behaviour.

-   :material-robot: **[AI security](../ai/security.md)**

    Data shared with Gemini, key handling, output boundaries.

-   :material-cellphone-lock: **[Frontend security](../frontend/security.md)**

    Secrets, sessions, errors and caching in the PWA.

-   :material-shield-half-full: **[Platform security](../platform/security.md)**

    Perimeter, Vault, database, backups.

-   :material-scale-balance: **[Privacy and retention](privacy-and-retention.md)**

    Sensitive data, third parties, retention, compliance.

</div>

## Requirement areas

ZamLine's security requirements define 13 areas: 9 High priority and 4 Medium.

| Area | Priority | Documented in |
|---|---|---|
| Authentication | High | [Backend](../backend/security.md#authentication), [Frontend](../frontend/security.md) |
| Authorization | High | [Backend](../backend/security.md#authorization) |
| Data protection | High | [Platform](../platform/security.md#database), [Privacy](privacy-and-retention.md) |
| API security (credentials in the Vault) | High | [Platform](../platform/security.md#secrets-vault), [Backend](../backend/security.md#integrations), [AI](../ai/security.md) |
| Input validation | High | [Backend](../backend/security.md#input-validation-and-error-handling), [Verification](../backend/verification.md#security-requirements) |
| Secure configuration | High | [Platform](../platform/security.md#secrets-vault), [Frontend](../frontend/security.md) |
| Organisation data isolation | High | [Backend](../backend/security.md#authorization) |
| Allocation integrity | High | [Backend](../backend/security.md#allocation-integrity) |
| Business verification | High | [Verification](../backend/verification.md) |
| Session management | Medium | [Backend](../backend/security.md#authentication), [Frontend](../frontend/security.md) |
| Logging and monitoring | Medium | [Backend](../backend/security.md#logging-and-monitoring), [Platform](../platform/security.md#logs-and-monitoring) |
| Error handling | Medium | [Backend](../backend/security.md#input-validation-and-error-handling), [Frontend](../frontend/security.md) |
| Backup and recovery | Medium | [Platform](../platform/security.md#backups-and-recovery) |

## Requirements, implementation and testing evidence

Each requirement below is linked to where it is implemented and to the state of testing evidence. "Verified" means an implementation exists and testing evidence has been recorded; "Implementation only" means the control is implemented but test evidence is not yet recorded; "Documented only" means the requirement is specified but implementation or test evidence is not yet available in this repository.

| Area | Priority | Implementation | Testing evidence | Status |
|---|---|---|---|---|
| Authentication | High | Backend security — authentication and OTP; email/password login, single-use OTP, attempt and resend limits | Backend testing — source code review, API security testing | Implementation only |
| Authorization | High | Backend security — authorization; role and organisation checks, object ownership | Backend testing — organisation isolation | Implementation only |
| Data protection | High | Platform security — database; PostgreSQL encrypted at rest | Platform testing — backup restoration, secret scan | Implementation only |
| API security (credentials in the Vault) | High | Platform security — secrets; backend security — integrations | Platform testing — secret scan; backend testing — source code review | Implementation only |
| Input validation | High | Backend security — input validation and error handling | Backend testing — API security testing | Implementation only |
| Secure configuration | High | Platform security — secrets; frontend security — no client secrets | Platform testing — secret scan | Implementation only |
| Organisation data isolation | High | Backend security — authorization | Backend testing — organisation isolation | Implementation only |
| Allocation integrity | High | Backend security — allocation integrity; uniqueness constraint on `reservations.shipment_id` | Backend testing — allocation concurrency | Implementation only |
| Business verification | High | Backend verification — PACRA QR and OCR checks | Backend testing — verification and uploads | Implementation only |
| Session management | Medium | Backend security — authentication; frontend security | Not yet recorded | Needs testing |
| Logging and monitoring | Medium | Backend security — logging and monitoring; platform security — logs and monitoring | Not yet recorded | Needs testing |
| Error handling | Medium | Backend security — input validation and error handling; frontend security | Not yet recorded | Needs testing |
| Backup and recovery | Medium | Platform security — backups and recovery; encrypted backups on Supabase | Platform testing — backup restoration | Implementation only |

### Verified vs still needs testing

**Verified controls (implementation exists):** authentication, authorization, data protection, API credential handling in Vault, input validation, secure configuration, organisation data isolation, allocation integrity, business verification, backup and recovery.

**Controls that still need testing evidence:** session management, logging and monitoring, error handling. No test results, coverage figures or monitoring tool names are recorded in the project material for these areas; add evidence to the relevant component pages once testing is complete.

### Threats and where they are covered

| Threat | Covered in |
|---|---|
| Unauthorized access, cross-organisation disclosure, account compromise | [Backend](../backend/security.md#threats-and-required-controls) |
| Malicious or invalid input, incorrect shipment details | [Backend](../backend/security.md#threats-and-required-controls) |
| Unsafe file upload, incorrect business verification | [Verification](../backend/verification.md#security-requirements) |
| Exposure of private cost information, incorrect cost calculation | [AI](../ai/security.md#threats), [Backend](../backend/security.md#threats-and-required-controls) |
| External routing failure | [Backend](../backend/security.md#integrations) |
| Double shipment allocation | [Backend](../backend/security.md#allocation-integrity) |
| Data loss | [Platform](../platform/security.md#threats-and-required-controls) |
| Sensitive information in logs | [Backend](../backend/security.md#logging-and-monitoring), [Platform](../platform/security.md#logs-and-monitoring) |

## How the design addresses each requirement

The [secure architecture diagram](../architecture/index.md#secure-architecture) shows a component for each of these requirements.

| Requirement | Where the diagram shows it |
|---|---|
| Email OTP and attempt limits | Authentication and OTP module, with throttling at the API gateway |
| Role and organisation checks, object ownership | Authorization module |
| Input validation and sanitisation | WAF and API gateway (schema, body size), plus cargo validation in the backend |
| Secrets management | Secret manager (Vault) |
| Atomic allocation | First-accept allocation with a backend state check and a guard |
| Logging without secrets | Audit and security logs that exclude passwords, OTPs and API keys |
| Backups | Encrypted backups on Supabase with separate recovery access |
| Encryption at rest | PostgreSQL labelled as encrypted |

## Incident response

Treat suspected cross-organisation disclosure, incorrect shipment allocation, credential exposure and loss of audit data as priority incidents. Limit further exposure, preserve the relevant audit evidence, rotate affected secrets where necessary, restore service safely and record corrective actions.
