# Platform security

## Perimeter

| Layer | Protections |
|---|---|
| DNS and DDoS protection | DDoS mitigation, rate limiting |
| WAF | Input and output sanitisation, bot blocking, rate limiting |
| API gateway | Schema and body-size validation, rate, abuse and OTP throttling, security headers |

## Secrets (Vault)

| Requirement | Priority |
|---|---|
| Database credentials, routing and email credentials and application secrets live in a Vault or secret manager | High |
| They are fetched only by authorised backend services, and never appear in source code, application files or client-side configuration | High |
| They are never logged | High |
| Secrets are rotated on a defined schedule and immediately after suspected exposure, and old values are revoked after a successful rollout | Medium |

## Database

| Requirement | Priority |
|---|---|
| PostgreSQL is encrypted at rest, and data is protected in transit | High |
| Access is limited to authorised services with protected credentials | High |
| Private cost data is protected by organisation-level access control | High |
| Backups are secured | Medium |

## Logs and monitoring

Audit and security logs record authentication, OTP, authorization, verification, cargo and allocation events, and exclude passwords, OTPs and keys. Audit logs require restricted access and integrity protection. Monitoring should alert on repeated authentication failures, authorization denials, verification anomalies, provider failures, allocation conflicts and unusual error rates. The monitoring and alerting tools are not named in the project material.

## Backups and recovery

Application and audit records are backed up according to the chosen hosting and database environment, and recovery is tested before production. The secure architecture diagram shows encrypted backups on Supabase with restricted backup access and separate recovery access.

## Threats and required controls

| Threat | Required control |
|---|---|
| Data loss | Backup, recovery and restoration testing |
| Unauthorized access to infrastructure | Restricted administration, secret management, access controls |
| Denial of service and abuse | Perimeter rate limiting and DDoS mitigation |
| Sensitive information in logs | A logging policy that excludes credentials and unnecessary data |

## Controls at a glance

| Control | Security purpose |
|---|---|
| DNS and DDoS protection, WAF, API gateway | Perimeter protection, request filtering and abuse controls |
| Vault or secret manager | Restricted storage and retrieval of application secrets |
| Encryption at rest | Protects stored application data |
| Backups with tested recovery | Recovery from data loss |
