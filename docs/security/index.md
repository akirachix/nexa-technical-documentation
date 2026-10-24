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

## Threats and where they are covered

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
