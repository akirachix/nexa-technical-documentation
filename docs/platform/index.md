# Platform

The platform is everything the application runs on and behind: the perimeter, secrets, database, logs and backups.

| Component | Responsibilities | Details |
|---|---|---|
| DNS and DDoS protection | DDoS mitigation, rate limiting | [Security](security.md#perimeter) |
| WAF | Input and output sanitisation, bot blocking, rate limiting | [Security](security.md#perimeter) |
| API gateway | Schema and body-size validation, rate, abuse and OTP throttling, security headers | [Security](security.md#perimeter) |
| PostgreSQL (encrypted) | Accounts, organisations, fleet, shipments, cargo, matches, reservations, private costs, audit records | [Security](security.md#database), [Data model](../backend/data-model.md) |
| Secret manager (Vault) | Database credentials, routing and email credentials, application secrets | [Security](security.md#secrets-vault) |
| Audit and security logs | Authentication, OTP, authorization, verification, cargo and allocation events | [Security](security.md#logs-and-monitoring) |
| Encrypted backups (Supabase) | Restricted backup access, separate recovery access | [Deployment](deployment.md#backups-and-recovery) |

| Page | What it covers |
|---|---|
| [Configuration](configuration.md) | Configuration categories, secrets and environment differences |
| [Security](security.md) | Perimeter, secrets, database, logs, backups |
| [Testing](testing.md) | Platform-level tests |
| [Deployment](deployment.md) | Hosting facts, backups and production release controls |

Privacy, retention and compliance are in [Security](../security/privacy-and-retention.md).
