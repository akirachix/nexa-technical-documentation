# Privacy and retention


## Privacy

ZamLine collects only what the MVP needs: user names, business emails and contacts, account data, and verification documents that may contain details of company representatives. Driver-location data is deliberately not collected.

| Area | Requirement |
|---|---|
| Purpose | Data is used to create accounts, verify businesses, run shipment and fleet workflows, support communication between matched organisations and protect the platform. |
| Data minimisation | Collect only what the current MVP needs. |
| Storage | Personal, business and commercial data sit in the authorised ZamLine database with access controls. Secrets are kept in the Vault, never with normal application data. |
| Access | Access is limited by role and organisation. A Fleet Manager never sees another fleet company's private operating costs. A Shipper never receives a Fleet Manager's private cost calculations. |
| Retention | Periods are set per data category before production. See [Data retention](#data-retention). |
| Deletion | Authorised deletion or anonymisation within 30 days of a verified request, keeping records that must be retained by law or operations. |

## Sensitive data

| Data type | Sensitivity | Protection required |
|---|---|---|
| Credentials and session tokens | High | Secure handling with email OTP two-factor authentication, protected storage, restricted access, never logged in plaintext |
| PACRA certificates | High | Secure upload, file validation, restricted access, protected storage, controlled processing |
| Private fleet cost settings | High | Organisation-level access control, encryption in transit, protected storage |
| Proposed shipment payment | High | Role and organisation authorization, protected transmission and storage |
| Audit logs | High | Restricted access, integrity protection, retention controls, no passwords, tokens or API keys |
| Shipment and cargo information | Medium | Access control, validation, protected transmission and storage |
| Fleet and truck information | Medium | Organisation-level access control, protected storage |
| Business contact information | Medium | Restricted access, minimisation, protected storage |
| Route distance and duration | Medium | Controlled application access, integrity validation |
| Cost-prediction inputs and outputs | Medium | Access control, integrity protection, model-version traceability |

## Third-party services

| Service | Purpose | Data shared | Requirement |
|---|---|---|---|
| Openrouteservice Directions API | Route distance and duration using the HGV routing profile | Origin and destination coordinates and routing parameters | API key in the Vault, retrieved by the backend, never exposed to the PWA, source code or logs |
| Hosting or cloud provider | Hosts the application and, depending on the final infrastructure, the database | Application and database data | Access controls, secret management, encryption, backups, restricted administration |
| PostgreSQL hosting service | Persistent storage | Account, company, shipment, fleet, cost, allocation and audit data | Access limited to authorised services, protected credentials, secured backups |
| Gemini API | AI cost estimate | Structured context only, with content filtering | The API key is protected as a server-side secret; only the minimum context required for estimation is shared. |

## Data retention

Retention is set per data category, not as one period for everything.

| Data category | Retention period | After that |
|---|---|---|
| User account and profile data | While the account is active, then 30 days after termination | Permanently deleted or anonymised unless the law requires retention |
| Business profile and verification data | While the business account is active, then 30 days after termination | Deleted, except records under a legal retention requirement |
| Completed load and delivery records | 6 years after the transaction is completed | Deleted or permanently anonymised |
| Login and security audit logs | 12 months | Automatically deleted |
| OTP and 2FA codes | Until used or expired, at most 5 minutes | Automatically invalidated and deleted |
| Deletion requests | 30-day grace period after the request is verified | Personal data permanently erased, except legally retained records |

## Compliance

- **Zambia Data Protection Act, 2021:** covers personal data such as account and business-contact information. Collect only what a defined purpose needs, protect it, and keep identifiable data no longer than necessary.
- **Zambia Electronic Communications and Transactions Act, 2021:** where the law requires an electronic record to be kept, it must stay accessible, accurately represent the original and keep origin, destination, date and time information where required.
- **OWASP guidance:** informs design, implementation and testing of the web application and API.

ZamLine’s implementation and operational processes must follow applicable legal obligations and the privacy controls on this page.

