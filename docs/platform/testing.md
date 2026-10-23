# Platform testing

## Required tests

| Test | What it checks |
|---|---|
| DAST | Dynamic testing of the deployed test environment, including perimeter behaviour |
| Backup restoration | Application and audit records can be recovered. Tested before production. |
| Dependency scanning | Known vulnerabilities in packages, then a rescan after fixes |
| Source code review | Secret handling: no secrets in source, application files or client configuration |

## Recommended behaviour tests

| Behaviour | Expected result |
|---|---|
| Rate limiting and OTP throttling | Excess requests are rejected at the gateway |
| Oversized body or invalid schema | Rejected at the gateway |
| Secret scan | No credentials or keys in the repository or build output |
| Log hygiene | No passwords, OTPs, tokens or keys in logs |
| Restore drill | The database is restored from a backup into a clean environment |
| Separate recovery access | Backup access and recovery access are distinct |
