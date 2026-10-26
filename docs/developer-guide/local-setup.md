# Local setup

This page documents how to set up the ZamLine backend and frontend on a local development machine, including the required software, repository links, environment variables, database setup and the commands that run each application.

## Repository links

The backend and frontend repositories are maintained separately from this documentation repository. Obtain their URLs from the team before cloning:

- Backend API (FastAPI, Python): not recorded in this documentation — request the repository URL from the team
- Frontend PWA: not recorded in this documentation — request the repository URL from the team
- This documentation: https://github.com/Team-Nexa/nexa-technical-documentation

## Required software

| Tool | Version | Purpose |
|---|---|---|
| git | any recent | Clone repositories |
| Python | 3.10 or newer | Backend application and migrations |
| Node.js | LTS | Frontend PWA build and dev server |
| npm | bundled with Node.js | Frontend dependencies |
| PostgreSQL | 15 or newer | Local development database |
| psql | bundled with PostgreSQL | Inspect and seed the local database |

Python is already required to build and preview this documentation (see [Building this documentation](#building-this-documentation)).

## Backend setup

### 1. Clone and install

```bash
git clone <backend-repository-url>
cd zamline-backend
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
pip install -r requirements-dev.txt   # test tooling, if present
```

### 2. Environment variables

Copy the example file provided by the backend repository and fill in the values from Vault or your local secret store. Never commit real values.

| Variable | Required | Example value | Purpose |
|---|---|---|---|
| `DATABASE_URL` | Yes | `postgresql+psycopg2://zamline:password@localhost:5432/zamline_dev` | Connection to the local PostgreSQL database |
| `GEMINI_API_KEY` | Yes | server-side secret | Gemini API for cost explanations |
| `ORS_API_KEY` | Yes | server-side secret | Openrouteservice routing key |
| `SMTP_HOST` / `SMTP_PORT` / `SMTP_USER` / `SMTP_PASS` | Yes | mail provider settings | OTP email delivery |
| `SECRET_KEY` | Yes | server-side secret | Session and token signing |
| `API_BASE_URL` | No | `http://localhost:8000` | Public backend URL |
| `CORS_ORIGINS` | No | `http://localhost:5173` | Allowed frontend origins |
| `ENVIRONMENT` | No | `development` | Deployment environment |

### 3. Database setup

1. Start PostgreSQL locally and create a development database:

   ```bash
   createdb zamline_dev
   ```

2. Run the backend migrations against the local database. Confirm the exact migration command in the backend repository; for Alembic-based projects it is typically:

   ```bash
   alembic upgrade head
   ```

3. The migrations create the seven tables described in [Data model](../backend/data-model.md): `companies`, `users`, `trucks`, `shipments`, `shipment_matches`, `reservations` and `audit_logs`.

### 4. Run the backend

Confirm the application entry point in the backend repository. A typical FastAPI run is:

```bash
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

The API is then available at `http://localhost:8000`, and the interactive OpenAPI documentation (for verifying the endpoints documented in [Backend API reference](../backend/index.md#api-reference)) is at `http://localhost:8000/docs`.

## Frontend setup

### 1. Clone and install

```bash
git clone <frontend-repository-url>
cd zamline-frontend
npm install
```

### 2. Environment variables

Create a local environment file from the repository's example and point it at your local backend:

```bash
cp .env.example .env.local
```

Set at least:

| Variable | Purpose | Example |
|---|---|---|
| `VITE_API_BASE_URL` | Backend API base URL | `http://localhost:8000` |

Variable names may differ in the frontend repository — confirm them there.

### 3. Run the frontend

```bash
npm run dev       # local development server
npm run build     # production build
npm run preview   # preview the production build locally
```

The PWA is then available on the port printed by the dev server (commonly `http://localhost:5173`).

## Verifying the local setup

| Check | How to verify |
|---|---|
| Backend reaches the database | `GET /health` (or the backend's health endpoint) returns a successful response |
| Backend reaches Openrouteservice | A route request returns distance and duration without a credential error |
| Backend reaches Gemini | A cost-estimate request returns an `ai_explanation`, or a controlled failure when the key is missing |
| Frontend reaches the backend | Registration and login complete end to end against `http://localhost:8000` |
| Database tables exist | `psql -d zamline_dev -c "\dt"` lists the seven ZamLine tables |

## Database setup reminders

- Use a separate local database from production and staging.
- Run migrations before starting the backend, and re-run them after any model change.
- Never seed production data into a local database without removing personal and commercial data first.

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
