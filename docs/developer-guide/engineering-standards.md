# Engineering standards

These standards guide implementation, testing, deployment and day-to-day operation of ZamLine.

## Security and access

- Authenticate users before granting access to protected functions or organisation data.
- Enforce role-based and organisation-level authorization on the server for every protected resource.
- Validate request bodies, query parameters, uploaded files and business rules at the API boundary.
- Store database credentials, external API keys and application secrets in the deployment secret store, and never expose them to the PWA or logs.
- Return controlled errors without stack traces, SQL details, filesystem paths or secret values.
- Keep audit events useful for investigation while excluding passwords, OTP values, session tokens, API keys and unnecessary personal data.

## Freight workflow integrity

- Re-check shipment eligibility when a Fleet Manager accepts an opportunity.
- Process acceptance as a single-winner operation so a shipment cannot be allocated to multiple fleet companies.
- Keep private fleet operating-cost settings within the owning organisation's access boundary.
- Release contact information only within the permitted post-allocation workflow.
- Present route and cost outputs as decision-support estimates, not guaranteed quotes.

## Business verification and uploads

- Enforce supported file types and the 10 MB upload-size limit on the server.
- Process PACRA certificates in a controlled workflow, and restrict access to authorized verification operations.
- Apply QR and OCR consistency rules, and fail safely when required information cannot be processed reliably.
- Do not trust a client-provided filename or MIME type as the only basis for accepting an upload.

## AI and cost estimation

- Validate inputs before requesting an estimate.
- Keep organisation-private operating costs out of responses to other organisations.
- Handle provider errors with a controlled response, and never present a failed or incomplete result as a successful estimate.
- Use deterministic test cases to verify arithmetic independently of generated explanations.
- Keep reference-data provenance and model version information available for operational traceability.
