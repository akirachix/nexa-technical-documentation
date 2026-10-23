# Developer guide

This guide helps a developer find where to make a change and how to keep the documentation in step with it.

| Page | What it covers |
|---|---|
| [Testing overview](testing-overview.md) | Which component owns which required test |
| [Engineering standards](engineering-standards.md) | Rules for security, workflow integrity, uploads and AI |
| [Release checklist](release-checklist.md) | The final gate before a production release |

## Local setup

Setup instructions for the backend and the frontend are not documented here, because neither repository was available when this documentation was prepared. That includes prerequisites, installation, environment configuration, local services such as PostgreSQL and the secret manager, database setup and migrations, and the commands that run each application. Add them to the [Backend](../backend/deployment.md) and [Frontend](../frontend/index.md#technology) pages once they are confirmed.

Two procedures are documented and runnable:

- Generating the cost-estimation reference files: see [Running the notebook](../ai/reference-data.md#running-the-notebook).
- Building and previewing this documentation: see [Building this documentation](#building-this-documentation).

## Where to make changes

| Change | Start from |
|---|---|
| A table or column | [Data model](../backend/data-model.md). Update the migrations and that page together. |
| Compatibility or matching rules | The fleet matching module, described in [Components and responsibilities](../architecture/components.md) |
| Cost estimate behaviour | [AI Module](../ai/index.md), and the reference files via the [notebook](../ai/reference-data.md) |
| Acceptance behaviour | First-accept allocation and the `reservations` constraints in [Backend security](../backend/security.md#allocation-integrity) |
| Access rules | The authorization module and [Backend security](../backend/security.md#authorization) |
| A screen | [Pages and workflows](../frontend/workflows.md) |

## Debugging

- **AI provider failure.** Keep `estimated_total_cost` null and return a controlled message that the estimate could not be completed.
- **Failed Gemini file re-upload.** Return a controlled error, log the operational event without credentials, and allow a safe retry. See [Gemini file expiry and refresh](../ai/operations.md#gemini-file-expiry-and-refresh).
- **Verification returns `resubmit` or `rejected`.** Read `companies.verification_failure_reason` and the `verification_attempted` entry in `audit_logs.details`, which hold the QR and OCR results.

## Documentation conventions

| Rule | Reason |
|---|---|
| Update the documentation in the same change as the functionality | Prevents drift |
| Keep the documentation aligned with the implemented product and the approved requirements | Keeps guidance consistent |
| Never put real secrets, tokens, credentials or personal data in pages or screenshots | Security |
| Use real screenshots of the application, with private data removed | Keeps pages accurate |
| State plainly when a page does not cover a detail | Readers can tell what is verified |

## Building this documentation

Requires Python 3.10 or newer. From the repository root:

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
mkdocs serve --dev-addr 127.0.0.1:8002   # preview; choose any free port
mkdocs build --strict                    # fails on warnings, broken links or missing pages
./scripts/check_docs.sh                  # strict build plus image, placeholder and secret checks
```

The static site is written to `site/`. Publish the contents of that directory to any static host.
