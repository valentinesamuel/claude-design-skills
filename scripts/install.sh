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
  curl -fsSL ${BASE_URL}/scripts/install.sh | bash -s -- [project-path] [options]
  bash install.sh [project-path] [options]

Installs the six-specialist design pipeline (art direction, prototype,
design review, UX review, frontend architecture, implementation) into a
project's .claude/ directory. Always installed in full — no selection.

On top of the core pipeline, two optional packs are offered interactively:
  Roles       individual subagents (.claude/agents/) — e.g. ui-designer,
              frontend-developer, code-reviewer, qa-expert.
  Industries  vertical command packs (.claude/commands/) — e.g. health,
              which adds 13 domain-expert consultants (clinical, HMO,
              nursing, pharmacy, lab, compliance, revenue-cycle, etc.)

Options:
  --roles <list>       comma-separated role keys, or "all" or "none".
                        Skips the interactive roles menu.
  --industries <list>  comma-separated industry keys, or "all" or "none".
                        Skips the interactive industries menu.
  -h, --help           show this help text.

If project-path is omitted, you will be prompted.
USAGE
}

# ── argument parsing ──────────────────────────────────────────────────────────
PROJECT_PATH=""
ROLES_FLAG=""
INDUSTRIES_FLAG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage; exit 0
      ;;
    --roles)
      ROLES_FLAG="${2:-}"; shift 2
      ;;
    --roles=*)
      ROLES_FLAG="${1#*=}"; shift
      ;;
    --industries)
      INDUSTRIES_FLAG="${2:-}"; shift 2
      ;;
    --industries=*)
      INDUSTRIES_FLAG="${1#*=}"; shift
      ;;
    *)
      if [[ -z "${PROJECT_PATH}" ]]; then
        PROJECT_PATH="$1"
      fi
      shift
      ;;
  esac
done

# ── dependency check ──────────────────────────────────────────────────────────
if ! command -v curl &>/dev/null; then
  echo "  Error: curl is required but not installed." >&2
  exit 1
fi

# ── resolve project path ──────────────────────────────────────────────────────
if [[ -z "${PROJECT_PATH}" ]]; then
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

# ── roles: optional individual agents ─────────────────────────────────────────
ROLE_KEYS=(accessibility-tester architect-reviewer code-reviewer compliance-auditor \
           debugger frontend-developer fullstack-developer javascript-pro \
           performance-engineer qa-expert react-specialist typescript-pro ui-designer)
ROLE_LABELS=(
  "Accessibility Tester   (WCAG compliance, assistive tech support)"
  "Architect Reviewer     (system design, scalability, tech choices)"
  "Code Reviewer          (quality, security, maintainability review)"
  "Compliance Auditor     (regulatory controls, audit prep)"
  "Debugger               (root cause diagnosis, failure analysis)"
  "Frontend Developer     (React/Vue/Angular application development)"
  "Fullstack Developer    (end-to-end feature development)"
  "JavaScript Pro         (advanced JS patterns, performance)"
  "Performance Engineer   (profiling, optimization, load behaviour)"
  "QA Expert              (test strategy, coverage, automation)"
  "React Specialist       (React 18+ architecture and optimization)"
  "TypeScript Pro         (advanced types, generics, type safety)"
  "UI Designer            (visual design, design systems, interaction)"
)
declare -a ROLE_SELECTED
for i in "${!ROLE_KEYS[@]}"; do ROLE_SELECTED[$i]=0; done

print_role_menu() {
  hdr "Select roles  (toggle number, Enter to confirm)"
  echo ""
  for i in "${!ROLE_KEYS[@]}"; do
    if [[ "${ROLE_SELECTED[$i]}" -eq 1 ]]; then
      echo -e "  ${GREEN}[x]${RESET} $((i+1)). ${ROLE_LABELS[$i]}"
    else
      echo  "  [ ] $((i+1)). ${ROLE_LABELS[$i]}"
    fi
  done
  echo ""
  echo "  Enter numbers to toggle (e.g. 1 3), or press Enter to confirm:"
}

if [[ -n "${ROLES_FLAG}" ]]; then
  if [[ "${ROLES_FLAG}" == "all" ]]; then
    for i in "${!ROLE_KEYS[@]}"; do ROLE_SELECTED[$i]=1; done
  elif [[ "${ROLES_FLAG}" != "none" ]]; then
    IFS=',' read -ra _wanted <<< "${ROLES_FLAG}"
    for w in "${_wanted[@]}"; do
      for i in "${!ROLE_KEYS[@]}"; do
        [[ "${ROLE_KEYS[$i]}" == "${w}" ]] && ROLE_SELECTED[$i]=1
      done
    done
  fi
else
  while true; do
    clear 2>/dev/null || true
    hdr "Distinguished Design Pipeline Setup"
    echo -e "  Target: ${BOLD}${PROJECT_PATH}${RESET}"
    print_role_menu
    read -rp "  > " input </dev/tty
    [[ -z "${input}" ]] && break
    for token in ${input}; do
      if [[ "${token}" =~ ^[0-9]+$ ]] && (( token >= 1 && token <= ${#ROLE_KEYS[@]} )); then
        idx=$((token - 1))
        ROLE_SELECTED[$idx]=$(( 1 - ROLE_SELECTED[$idx] ))
      fi
    done
  done
fi

hdr "Installing selected roles"
roles_installed=()
any_role=0
for i in "${!ROLE_KEYS[@]}"; do
  [[ "${ROLE_SELECTED[$i]}" -eq 0 ]] && continue
  any_role=1
  role="${ROLE_KEYS[$i]}"
  if fetch_file "agents/${role}.md" "${DEST}/agents/${role}.md"; then
    (( file_count++ )) || true
    roles_installed+=("${role}")
  fi
done
[[ "${any_role}" -eq 0 ]] && echo "  (none selected)"

# ── industries: optional vertical command packs ───────────────────────────────
INDUSTRY_KEYS=(health)
INDUSTRY_LABELS=(
  "Health   (clinical, nursing, pharmacy, lab, HMO/claims, hospital ops, compliance — 13 domain experts)"
)
declare -a IND_SELECTED
for i in "${!INDUSTRY_KEYS[@]}"; do IND_SELECTED[$i]=0; done

print_industry_menu() {
  hdr "Select industries  (toggle number, Enter to confirm)"
  echo ""
  for i in "${!INDUSTRY_KEYS[@]}"; do
    if [[ "${IND_SELECTED[$i]}" -eq 1 ]]; then
      echo -e "  ${GREEN}[x]${RESET} $((i+1)). ${INDUSTRY_LABELS[$i]}"
    else
      echo  "  [ ] $((i+1)). ${INDUSTRY_LABELS[$i]}"
    fi
  done
  echo ""
  echo "  Enter numbers to toggle (e.g. 1), or press Enter to confirm:"
}

if [[ -n "${INDUSTRIES_FLAG}" ]]; then
  if [[ "${INDUSTRIES_FLAG}" == "all" ]]; then
    for i in "${!INDUSTRY_KEYS[@]}"; do IND_SELECTED[$i]=1; done
  elif [[ "${INDUSTRIES_FLAG}" != "none" ]]; then
    IFS=',' read -ra _wanted <<< "${INDUSTRIES_FLAG}"
    for w in "${_wanted[@]}"; do
      for i in "${!INDUSTRY_KEYS[@]}"; do
        [[ "${INDUSTRY_KEYS[$i]}" == "${w}" ]] && IND_SELECTED[$i]=1
      done
    done
  fi
else
  while true; do
    clear 2>/dev/null || true
    hdr "Distinguished Design Pipeline Setup"
    echo -e "  Target: ${BOLD}${PROJECT_PATH}${RESET}"
    print_industry_menu
    read -rp "  > " input </dev/tty
    [[ -z "${input}" ]] && break
    for token in ${input}; do
      if [[ "${token}" =~ ^[0-9]+$ ]] && (( token >= 1 && token <= ${#INDUSTRY_KEYS[@]} )); then
        idx=$((token - 1))
        IND_SELECTED[$idx]=$(( 1 - IND_SELECTED[$idx] ))
      fi
    done
  done
fi

# Command files installed per industry (bash 3.2-compatible — no associative arrays)
INDUSTRY_COMMANDS_health="clinical-advisor devops-reliability health-data-standards \
  healthcare-pm healthcare-ux-designer hmo-expert hospital-ops-expert lab-scientist \
  nursing-expert pharmacist-agent qa-lead regulatory-compliance revenue-cycle-expert"

hdr "Installing selected industry packs"
industries_installed=()
any_industry=0
for i in "${!INDUSTRY_KEYS[@]}"; do
  [[ "${IND_SELECTED[$i]}" -eq 0 ]] && continue
  any_industry=1
  industry="${INDUSTRY_KEYS[$i]}"
  varname="INDUSTRY_COMMANDS_${industry}"
  for cmd in ${!varname}; do
    if fetch_file "industries/${industry}/commands/${cmd}.md" "${DEST}/commands/${cmd}.md"; then
      (( file_count++ )) || true
    fi
  done
  industries_installed+=("${industry}")
done
[[ "${any_industry}" -eq 0 ]] && echo "  (none selected)"

# 7. Manifest
{
  echo "installed_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "source=remote:${BASE_URL}"
  echo "files=${file_count}"
  echo "roles=${roles_installed[*]+"${roles_installed[*]}"}"
  echo "industries=${industries_installed[*]+"${industries_installed[*]}"}"
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
