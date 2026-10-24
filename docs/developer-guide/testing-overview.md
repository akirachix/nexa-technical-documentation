# Testing overview

Each required test has an owning component. Details are on the component pages: [Backend](../backend/testing.md), [AI](../ai/testing.md), [Frontend](../frontend/testing.md) and [Platform](../platform/testing.md).

| Test | Backend | AI | Frontend | Platform |
|---|---|---|---|---|
| Source code review | Yes | Cost handling | Authentication screens | Secret handling |
| Dependency scanning | Yes | | Yes | Yes |
| SAST | Yes | | Yes | |
| DAST | Yes | | Yes | Yes |
| API security testing (OWASP themes) | Yes | | | |
| Organisation isolation | Yes | | | |
| File upload | Yes (verification) | | Error display | |
| Allocation concurrency | Yes | | | |
| Cost-calculation verification | | Yes | | |
| External API failure | Yes | Yes | | |
| Privacy review | | | Yes | |
| Backup restoration | | | | Yes |

