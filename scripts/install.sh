#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/valentinesamuel/claude-design-skills/main"

# ── colours ──────────────────────────────────────────────────────────────────
BOLD="\033[1m"; GREEN="\033[0;32m"; CYAN="\033[0;36m"; YELLOW="\033[0;33m"; RESET="\033[0m"
ok()   { echo -e "  ${GREEN}✓${RESET} $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $*" >&2; }
hdr()  { echo -e "\n${BOLD}${CYAN}$*${RESET}"; }

# ── usage ─────────────────────────────────────────────────────────────────────
usage() {
  cat <<USAGE
Usage:
  curl -fsSL ${BASE_URL}/scripts/install.sh | bash -s -- [project-path]
  bash install.sh [project-path]

Installs the six-specialist design pipeline (art direction, prototype,
design review, UX review, frontend architecture, implementation) into a
project's .claude/ directory.

If project-path is omitted, you will be prompted.
USAGE
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage; exit 0
fi

# ── dependency check ──────────────────────────────────────────────────────────
if ! command -v curl &>/dev/null; then
  echo "  Error: curl is required but not installed." >&2
  exit 1
fi

# ── resolve project path ──────────────────────────────────────────────────────
if [[ $# -ge 1 ]]; then
  PROJECT_PATH="$1"
else
  echo ""
  read -rp "  Project path: " PROJECT_PATH </dev/tty
fi

PROJECT_PATH="${PROJECT_PATH/#\~/$HOME}"

if [[ ! -d "${PROJECT_PATH}" ]]; then
  echo "  Error: directory does not exist: ${PROJECT_PATH}" >&2
  exit 1
fi

DEST="${PROJECT_PATH}/.claude"

# ── fetch helper ──────────────────────────────────────────────────────────────
# fetch_file <relative-path> <dest-file>
fetch_file() {
  local rel="$1"
  local dest="$2"
  local url="${BASE_URL}/${rel}"
  local label
  if [[ "$(basename "${dest}")" == "SKILL.md" ]]; then
    label="$(basename "$(dirname "${dest}")")/SKILL.md"
  else
    label="${rel}"
  fi
  mkdir -p "$(dirname "${dest}")"
  if ! curl -fsSL -o "${dest}" "${url}" 2>/dev/null; then
    warn "Could not fetch ${rel} — skipping"
    return 1
  fi
  ok "${label}"
  return 0
}

file_count=0
fetch() {
  fetch_file "$1" "${DEST}/$1" && (( file_count++ )) || true
}

hdr "Distinguished Design Pipeline Setup"
echo -e "  Target: ${BOLD}${PROJECT_PATH}${RESET}"

# 1. Root
hdr "Installing CLAUDE.md"
fetch "CLAUDE.md"

# 2. Knowledge
hdr "Installing knowledge base"
fetch "knowledge/craft.md"
fetch "knowledge/stack.md"

# 3. Scripts
hdr "Installing gate scripts"
fetch "scripts/validate-manifest.mjs"
fetch "scripts/token-diff.mjs"

# 4. Templates
hdr "Installing artifact templates"
for t in api-contract art-direction clarifications current-feature decisions \
         design-system manifest product-architecture project-context; do
  fetch "templates/design/${t}.md"
done

# 5. Shared pipeline contract
hdr "Installing shared pipeline contract"
fetch "skills/_shared/clarification-protocol.md"
fetch "skills/_shared/pipeline.md"
fetch "skills/_shared/review-protocol.md"
fetch "skills/_shared/verification.md"

# 6. The six specialists
hdr "Installing specialist skills"
fetch "skills/artifact-manager/SKILL.md"

fetch "skills/senior-product-designer/SKILL.md"
fetch "skills/senior-product-designer/references/anti-ai-playbook.md"
fetch "skills/senior-product-designer/references/art-direction.md"
fetch "skills/senior-product-designer/references/prototype-standards.md"

fetch "skills/design-reviewer/SKILL.md"
fetch "skills/design-reviewer/references/visual-review.md"

fetch "skills/ux-reviewer/SKILL.md"
fetch "skills/ux-reviewer/references/ux-review.md"

fetch "skills/frontend-architect/SKILL.md"
fetch "skills/frontend-architect/references/plan-mode.md"
fetch "skills/frontend-architect/references/validate-mode.md"

fetch "skills/staff-ui-engineer/SKILL.md"
fetch "skills/staff-ui-engineer/references/implementation.md"

# 7. Manifest
{
  echo "installed_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "source=remote:${BASE_URL}"
  echo "files=${file_count}"
} > "${DEST}/_setup-manifest.txt"

# ── summary ───────────────────────────────────────────────────────────────────
hdr "Done"
echo ""
echo -e "  ${BOLD}Design pipeline${RESET} → ${PROJECT_PATH}/.claude/   (${file_count} files)"
echo ""
echo -e "  ${BOLD}Workflow:${RESET}"
echo "  1. /artifact-manager        stage 0   init, new feature, repair, status"
echo "  2. /clear"
echo "  3. /senior-product-designer stage 1   art direction, spec, prototype"
echo "  4. /clear between every stage — see .claude/CLAUDE.md"
echo ""
