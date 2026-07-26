# Verification Contract

Shared by `frontend-architect` (both modes) and `staff-ui-engineer`. Defines the
mechanical checks that must pass before a feature can be approved.

## Why this exists

Three of this pipeline's four gates are judgement. Judgement misses the class of
defect that only appears at runtime, and it cannot honestly assert that contrast
ratios pass, that no console error fires, or that a bundle stayed within budget.

Every claim below is checkable by a command. A claim without command output behind
it is an opinion, and stage 6 treats it as one.

## Stack

- **Vitest** + **React Testing Library** — unit and component
- **Playwright** — end-to-end flows
- **axe-core** via `@axe-core/playwright` — automated accessibility
- `tsc --noEmit` and ESLint — types and lint

Chosen because Vitest shares Vite's config and transform pipeline, so there is no
second build to maintain. If the project deviates, record it as a decision.

Automated accessibility checking finds roughly a third of real barriers. It does not
replace the keyboard and screen-reader review at stages 2, 3 and 6 — it removes the
mechanical third so human attention goes to the rest.

## What gets tested

`frontend-architect` specifies this at stage 4, in `implementation-guidelines.md`.
Not everything is worth a test, and a plan that demands coverage everywhere produces
tests written to satisfy a number.

Required:

- **Every state machine** — anything with more than two states, unit tested across
  all of them, including the impossible-state cases the union prevents.
- **Every data transform** — formatters, parsers, derived calculations. Unit tested
  with the awkward inputs from the fixtures: nulls, long strings, negative amounts.
- **Every acceptance criterion in `current-feature.md`** — one Playwright test each,
  named after the criterion. This is the direct link between what the user asked for
  and evidence it works.
- **Every form** — validation timing, error display, keyboard completion, submit
  state, double-submit prevention.
- **Accessibility** — axe on every route, in both themes.
- **The stress case** — the largest fixture volume the plan anticipates.

Not required: presentational components with no logic, wrappers, or anything whose
test would only assert that the markup is the markup.

## Commands

The engineer runs these and pastes real output into
`implementation-report.md`. The architect re-runs them at stage 6.

```
npx tsc --noEmit
npx eslint . --max-warnings 0
npx vitest run
npx playwright test
node .claude/scripts/token-diff.mjs
node .claude/scripts/validate-manifest.mjs
```

## Evidence format

In `implementation-report.md`, under `## Verification`:

```
### Commands
npx tsc --noEmit                → pass, 0 errors
npx eslint . --max-warnings 0   → pass, 0 warnings
npx vitest run                  → 47 passed, 0 failed
npx playwright test             → 12 passed, 0 failed
node .claude/scripts/token-diff.mjs → pass, 0 hardcoded values

### Acceptance criteria
AC1 "find a customer by partial name" → e2e/customers.spec.ts:14 → passing
AC2 ...

### Accessibility
axe on /customers        → 0 violations (light), 0 violations (dark)
axe on /customers/:id    → 0 violations (light), 0 violations (dark)

### Budget
Route bundle: 84kb gzip (budget 120kb)

### Manual
Keyboard walkthrough: {what you did, what you found}
360px: {result}
Stress fixture (50k rows): {result}
```

Paste the real output. Do not summarise a failing run as passing, and do not report
a command you did not run — stage 6 re-runs all of them, so a fabricated result is
both detected and disqualifying.

## Enforcement at stage 6

`frontend-architect` in validate mode re-runs every command. Then:

- Any command fails → **Critical**, verdict REJECTED.
- Evidence absent for a required item → **Critical**. Not "unverified" — absent
  evidence and failed verification are treated identically, because the pipeline
  cannot distinguish them.
- Reported result differs from the re-run → **Critical**, and note it explicitly in
  the report.
- An acceptance criterion with no test → **Critical**.
- `token-diff` reports hardcoded values → **Major** at minimum.

If the environment genuinely cannot run a command, say which and why in the report.
An honest gap is a Major finding and a known risk. A silent gap is a Critical one.
