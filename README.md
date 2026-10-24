# ZamLine Technical Documentation

The technical documentation for ZamLine, Team Nexa's freight coordination and decision-support platform for verified shippers and fleet companies in Zambia. It is a [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) site.

## Run locally

Requires Python 3.10 or newer.

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
mkdocs serve --dev-addr 127.0.0.1:8002
```

Open <http://127.0.0.1:8002>. Use any free port.

## Build and check

```bash
mkdocs build --strict      # writes the static site to site/
./scripts/check_docs.sh    # strict build, image references, placeholder text, secret patterns
```

Publish the contents of `site/` to any static web host. `site/` is generated and is ignored by Git. Building does not deploy anything.

## Structure

| Path | Contents |
|---|---|
| `docs/index.md` | Home |
| `docs/Get started/` | Problem, solution, users and workflow |
| `docs/architecture/` | Components, responsibilities, data flow, external services |
| `docs/backend/` | API design, data model, business verification, security, testing, deployment |
| `docs/ai/` | Cost estimation, reference data, security, evaluation, operations |
| `docs/frontend/` | The PWA: pages and workflows, security, testing, deployment |
| `docs/platform/` | Configuration, perimeter, secrets, backups, deployment |
| `docs/security/` | Security overview, privacy and retention |
| `docs/developer-guide/` | Where to change things, standards, testing overview, release checklist |
| `docs/reference/` | Glossary |
| `docs/assets/images/` | Application screenshots, architecture diagrams, logo |
| `docs/stylesheets/extra.css` | ZamLine brand styling |
| `mkdocs.yml` | Navigation and theme configuration |

## Navigation

The primary navigation is the tab bar at the top of the site. The left sidebar lists the pages of the current section, and the right sidebar lists the headings of the current page. Pages in a section are added in `mkdocs.yml` under that section's tab.

## Brand

Ice blue `#DAF0F7`, midnight navy `#030E1C`, cerulean `#00A9D6`. The header is light in light mode and navy in dark mode. The logo mark is `docs/assets/images/logo-mark.png`; the full logo is `logo.png`.

## Screenshots

Use real screenshots of the application. Remove credentials, one-time codes and real personal or business information before adding them to `docs/assets/images/`, and reference every image from a page (`check_docs.sh` reports unreferenced images).
