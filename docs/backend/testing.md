# Backend testing

## Running the tests

The test framework, test locations and the command to run the suite are not documented here, and no test results or coverage figures are available. Add them to this page together with the backend's test configuration.

## Required tests

These tests come from ZamLine's security requirements.

| Test | What it checks |
|---|---|
| Source code review | Authentication, authorization, business verification, cost handling and allocation logic |
| API security testing | OWASP Top 10 themes: authentication, authorization, IDOR and cross-organisation access, invalid input, error handling, rate limiting |
| Organisation isolation | Users from different organisations cannot reach each other's protected records |
| Allocation concurrency | Simultaneous acceptance by several Fleet Managers yields exactly one allocation |
| External API failure | Missing or invalid routing input, API authentication failures, unavailable service |
| Dependency scanning | Known vulnerabilities in third-party packages. Fix, replace or remove, then rescan. |
| SAST | Static analysis of the backend source where supported |
| DAST | Dynamic testing of the deployed test environment |

## Verification and uploads

| Test | Expected result |
|---|---|
| Unsupported, corrupted, oversized or malformed certificate | Fails safely with no crash, returns a controlled error and logs the attempt |
| QR present but OCR mismatch | Status is `resubmit` or `rejected`, never `verified` |

## Recommended behaviour tests

These behaviours follow from the data model and business rules and are worth covering with named tests.

| Behaviour | Expected result |
|---|---|
| Compatibility filter | A truck matches when its `body_type` equals the shipment's `required_body_type`, its `capacity_kg` covers `weight_kg`, and it is `available` |
| Verification gate | Only `verified` companies can post or accept |
| One reservation per shipment | A second acceptance fails on the `reservations.shipment_id` uniqueness |
| Match closure | After acceptance, the other matches for the shipment become `closed` |
| Contact visibility | Contact details are hidden before reservation and visible after, and `contact_viewed` is logged |
| Private cost fields | Never returned to another organisation |
| Data model constraints | Positive weight and amount, coordinate ranges, unique plate number and registration number |
| Error responses | No stack traces, database details, credentials or internal paths |

Cost and AI tests are in [AI testing and evaluation](../ai/testing.md). For the full test ownership matrix, see [Testing overview](../developer-guide/testing-overview.md).
