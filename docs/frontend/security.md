# Frontend security

## Requirements that affect the PWA

| Requirement | Detail |
|---|---|
| Secrets never reach the client | External API credentials, database credentials and API keys stay out of source code, application files and client-side configuration. |
| Transport | Users reach the system over HTTPS and TLS. |
| Authentication | Email and password plus an email OTP. The PWA is where users enter them. |
| Server-side validation | Validation is required on the server for all listed fields. Client-side checks are not a substitute. |
| Errors | No stack traces, database details, credentials or internal paths are shown to users. |
| Role and organisation visibility | Users see only the screens and data that their role and organisation allow. Enforcement is in the backend, so hiding a screen is not a control. |
| Uploads | PACRA certificates are validated for type and size on the server. |
| Security headers | Apply HTTPS, a restrictive Content Security Policy and standard browser security headers at the web-serving layer and the API gateway. |
| Privacy | Driver location is not collected, and data is minimised to what the MVP needs. |

## Threats and required controls

| Threat | Required control |
|---|---|
| Malicious or invalid input | Server-side validation, accepted ranges, sanitisation (WAF and gateway) |
| Account compromise | Secure session handling, OTP, access monitoring |
| Exposure of private cost information | Backend organisation isolation. Never trust client-side filtering. |

## Implementation standards

- Render user-supplied text as text, and encode output for its context to reduce cross-site scripting risk.
- Apply a restrictive Content Security Policy and standard security headers at the web-serving layer.
- Keep authentication material out of URLs, analytics events and application logs. Use the application's configured secure session mechanism and invalidate sessions on logout or expiry.
- Configure service-worker caching so that authenticated responses and private organisation data are not stored in a shared or public cache.
- Treat browser-side validation as a usability aid, and enforce business rules and authorization in the backend.
- Keep the interface responsive and accessible, including visible focus states and readable colours in light and dark modes.
