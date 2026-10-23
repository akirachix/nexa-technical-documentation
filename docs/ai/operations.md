# Deployment and operations

## Components

| Component | Responsibility |
|---|---|
| `manifest.json` | Lists the reference files used by the backend upload workflow |
| Reference-file upload workflow | Uploads the reference files to the Gemini Files API and maintains usable file references |
| Gemini API key | Retrieved by the backend from the Vault or secret manager |
| Reference documents | Curated Markdown files produced by the [reference-data notebook](reference-data.md) |

## Operating the reference files

1. Run the notebook when source documents change, and review `quality_report.csv`.
2. Place the resulting Markdown files and `manifest.json` in server-side storage with access restricted to authorised services.
3. The backend checks file references before use and refreshes expired Gemini file references.
4. Keep API keys and file-registry details out of client responses and application logs.
5. Keep the manifest and source documents under version control or controlled release storage so updates are traceable.

## Gemini file expiry and refresh

Files uploaded through the Gemini Files API are not stored permanently, so the backend manages their availability.

**Storage**

- Original Markdown files stay in persistent server-side storage.
- The Gemini file reference and upload timestamp for each file are kept in a local JSON configuration file on the application server.

**Before each use**

1. The backend checks whether the file's uploaded reference is still valid.
2. If it has expired or is no longer available, the backend re-uploads the original Markdown file.
3. After every successful upload, the backend replaces the stored reference and upload timestamp.
4. Later Gemini requests use the new reference.

## Production operations

- Protect shared reference-file storage with least-privilege access.
- Make refresh operations safe to retry, and prevent concurrent refreshes from creating a conflicting registry.
- Deploy reference updates through a controlled release so active estimates use a consistent reference set.
- Monitor provider failures, expired file references, upload failures and estimate completion errors.
- Return a controlled failure when required reference files cannot be loaded. Do not present an incomplete estimate as successful.
