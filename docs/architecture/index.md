# Architecture

ZamLine is a Progressive Web App (PWA) in front of a backend API. The backend is organised into modules (authentication, business verification, shipments, fleet management, fleet matching, cost estimation, allocation and contact handoff) and stores its data in PostgreSQL. Two external services support cost estimation: a routing service for distance and duration, and the Gemini API for the cost explanation.

| Page | What it covers |
|---|---|
| This page | The two architecture diagrams and the decisions that shape the design |
| [Components and responsibilities](components.md) | What each component does, layer by layer |
| [Data flow and external services](data-flow.md) | How requests, verification, cost estimates and allocation move through the system |

## System architecture

The diagram below shows the application modules and how the two user roles reach them through the PWA. Each module reads and writes application data through the backend API. The Cost Estimation module calls the routing service and the Gemini Files API, and uses Markdown reference files for background.

![System architecture diagram showing Shipper and Fleet Manager PWAs, the backend modules, the API, the PostgreSQL database, the routing service and the Gemini Files API](../assets/images/architecture-diagram.png)

## Secure architecture

The second diagram groups the same system into five layers: users and devices, perimeter security, the application layer, the data layer and external services. Traffic enters over HTTPS and passes DNS and DDoS protection, a web application firewall (WAF) and an API gateway before it reaches the backend. The diagram labels the WAF as provided by Vercel and the encrypted backup storage as Supabase.

![Secure architecture diagram with users, perimeter security, application layer, data layer and external services](../assets/images/secure-architecture-diagram.png)

## Architectural decisions

| Decision | Description |
|---|---|
| Progressive Web App | One PWA serves both Shippers and Fleet Managers. |
| Layered security perimeter | DNS and DDoS protection, a WAF and an API gateway filter traffic before it reaches the backend. |
| Backend as the authority | The backend enforces authentication, authorization, validation and audit logging. The browser is never trusted for permissions or cost privacy. |
| Secret management | Credentials and application secrets are held in a secret manager (Vault), not in source code or client configuration. |
| Single-winner allocation | A uniqueness constraint on `reservations.shipment_id` and an atomic backend check prevent a shipment from being allocated twice. |
| Private fleet cost data | Fleet cost settings are scoped to the organisation that owns them. |
| Delayed contact handoff | Contact details are released only after a valid reservation. |
| Reference files for cost estimation | Markdown reference files are uploaded to the Gemini Files API. Because uploaded files expire, the backend keeps the originals and re-uploads them when needed. See [AI operations](../ai/operations.md). |
