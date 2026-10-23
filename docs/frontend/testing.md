# Frontend testing

## Running the tests

The frontend's test framework, test locations and commands are not documented here, and no test results are available. Add them to this page together with the frontend's test configuration.

## Required tests

These tests come from ZamLine's security requirements.

| Test | What it checks |
|---|---|
| SAST | Static analysis of the frontend source where supported |
| Dependency scanning | Known vulnerabilities in third-party packages |
| DAST | Dynamic testing of the deployed test environment, including the PWA |
| Privacy review | Only necessary data is collected, and driver location is not collected |
| Source code review | Review of where authentication and role-based screens are handled |

## Recommended workflow tests

| Workflow | Expected result |
|---|---|
| Registration and login with OTP | A wrong or expired OTP is rejected, and attempt limits appear as an error |
| PACRA upload | An unsupported or oversized file shows a controlled error |
| Post a shipment (Shipper) | Required fields and ranges are enforced, and a confirmation step precedes publication |
| Fleet setup | Truck and cost settings are saved, and invalid values are rejected |
| Opportunities (Fleet Manager) | Only compatible open shipments are listed |
| Accept or decline | A second Fleet Manager sees a controlled failure if the load is already taken |
| Contact handoff | Contact details are absent before acceptance and present after |
| Errors | No internal details are displayed |
| Role separation | A Shipper cannot reach fleet screens, and the reverse. The backend must still enforce this. |

Include installability, service-worker update, offline behaviour and low-connectivity scenarios in the PWA regression suite. Test on current supported desktop and mobile browsers and at responsive viewport sizes, and record the run, environment and outcome in the team's test record.

For the full test ownership matrix, see [Testing overview](../developer-guide/testing-overview.md).
