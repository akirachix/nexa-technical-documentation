set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
note() { printf '%s\n' "$*"; }

note "1/4  Strict MkDocs build"
python -m mkdocs build --strict --site-dir "$(mktemp -d)" >/dev/null 2>"${TMPDIR:-/tmp}/zl_build.log" || {
  cat "${TMPDIR:-/tmp}/zl_build.log"; fail=1; }

note "2/4  Images: every file in docs/assets/images is referenced, every reference exists"
python - <<'PY' || fail=1
import re, sys, pathlib
root = pathlib.Path("docs"); img = root / "assets" / "images"
text = "\n".join(p.read_text(encoding="utf-8") for p in root.rglob("*.md"))
text += "\n" + pathlib.Path("mkdocs.yml").read_text(encoding="utf-8")
text += "\n" + (root / "stylesheets" / "extra.css").read_text(encoding="utf-8")
bad = False
# Source artwork kept for regenerating logo-mark.png and favicon.png
source_artwork = {"logo.png"}
for f in sorted(img.iterdir()):
    if f.name not in text and f.name not in source_artwork:
        print("  unreferenced image:", f.name); bad = True
for m in sorted(set(re.findall(r"assets/images/([\w.\-]+)", text))):
    if not (img / m).exists():
        print("  missing image:", m); bad = True
sys.exit(1 if bad else 0)
PY

note "3/4  Placeholder and review-label text must not be published"
if grep -rniE "PLACE THE PHOTO|\[PLACEHOLDER|YOUR LOGO|TODO|TBD|See the component runbook|pill (spec|nyd)" docs --include=*.md; then
  fail=1
fi

note "4/4  Possible secrets in pages (long tokens, key assignments)"
if grep -rnE "(AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_\-]{30,}|sk-[A-Za-z0-9]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|(password|secret|api[_-]?key|token)[\"' ]*[:=][\"' ]*[A-Za-z0-9/+_\-]{16,})" docs --include=*.md; then
  fail=1
fi

if [ "$fail" -eq 0 ]; then note "All documentation checks passed."; else note "Documentation checks failed."; exit 1; fi
