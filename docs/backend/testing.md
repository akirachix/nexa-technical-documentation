# Backend testing

## Running the tests

### Test framework

The backend test suite is written with **pytest** (confirm the exact framework and version in the backend repository). Tests live alongside the backend source in a `tests/` directory and are configured with `pytest.ini` or `pyproject.toml`.

### Test commands

From the backend repository root, with the virtual environment activated:

```bash
# Run the full backend suite
pytest

# Run with coverage report
pytest --cov=backend --cov-report=html

# Run only the security-focused tests
pytest -m security

# Run verification and upload tests
pytest tests/test_verification.py tests/test_uploads.py

# Run allocation concurrency tests
pytest tests/test_allocation.py -k concurrency
```

### Test results and coverage

No test results or coverage figures are included in the project material, so this documentation reports no pass/fail counts and no coverage percentage. Every test listed below is **pending evidence** until a test run is recorded here.

| Test group | Tests | Status | Evidence |
|---|---|---|---|
| Source code review | Authentication, authorization, business verification, cost handling, allocation logic | Pending | No review record in this repository |
| API security testing (OWASP Top 10) | Authentication, authorization, IDOR, cross-organisation access, invalid input, error handling, rate limiting | Pending | No results in this repository |
| Organisation isolation | Cross-organisation access to protected records | Pending | No results in this repository |
| Allocation concurrency | Simultaneous acceptance yields exactly one allocation | Pending | No results in this repository |
| External API failure | Missing/invalid routing input, auth failures, unavailable service | Pending | No results in this repository |
| Dependency scanning | Known vulnerabilities in third-party packages | Pending | No scan results in this repository |
| SAST | Static analysis of backend source | Pending | No results in this repository |
| DAST | Dynamic testing of the deployed test environment | Pending | No results in this repository |

Update this table when a test run is completed, and record the runner, environment, date and outcome in the team's test record.

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
