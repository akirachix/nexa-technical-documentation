# AI testing and evaluation

## State of the evidence

No evaluation dataset, metrics, baseline or results for the cost estimate are included in the project material, so this documentation states no accuracy figures. Do not describe the estimate as accurate or reliable without evaluation results. Until such results exist, treat estimates as indicative decision support.

An evaluation of the cost estimate would need an evaluation dataset of journeys with known costs, metrics and a baseline to compare against, results by journey type, and known failure cases. Add the artefacts and their results here when they exist.

## Required tests

These tests come from ZamLine's security requirements.

| Test | What it checks |
|---|---|
| Cost-calculation verification | Deterministic cost results match independently calculated expected values |
| External API failure | The system handles unavailable services, authentication failures and invalid input |
| Source code review | Review of the cost-handling logic |

## Recommended behaviour tests

| Behaviour | Expected result |
|---|---|
| AI call fails | `estimated_total_cost` is null, no stale value is displayed, and the request reports failure |
| Margin arithmetic | `estimated_margin` equals `proposed_amount` minus `estimated_total_cost` |
| File expiry | An expired Gemini reference triggers a re-upload and updates the registry |
| Failed re-upload | The failure is reported and the invalid reference is not used |
| Concurrent re-upload | Refresh operations are coordinated so concurrent requests keep a valid registry and never expose conflicting references |

## Reference-data quality checks

The reference-data notebook has built-in checks. They validate the preparation of the data, not the quality of the estimates.

| Check | How it works |
|---|---|
| Missing or duplicate sources | Missing PDFs are reported, and duplicate files are skipped using SHA-256 hashes |
| Text extraction | OCR is used only for pages with fewer than 200 characters, and accepted at a mean confidence of 60 or above |
| No lost numbers | Numbers are counted before and after cleaning, and any loss is recorded in `quality_report.csv` |
| Dataset validation | Size, missing values and duplicate rows are recorded in `structured_validation.csv` |
| Spot check | A cleaned document is reviewed, with DOC018 used by default |

See also [Backend testing](../backend/testing.md) and [Frontend testing](../frontend/testing.md).
