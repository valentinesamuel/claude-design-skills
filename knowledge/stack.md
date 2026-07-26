# Stack Conventions

Organisational standard, not project history. Read by `frontend-architect` and
`staff-ui-engineer`. A project may override any of it in `project-context.md`,
but the override must be recorded as a decision.

## Base

React 19 · Vite · TypeScript (strict) · Tailwind v4 · shadcn/ui

## Tailwind v4

CSS-first configuration. There is no `tailwind.config.js`.

- `src/styles/theme.css` holds `@import "tailwindcss";` followed by a single
  `@theme` block. This file is the machine-readable form of `art-direction.md`
  and `design-system.md`, and it is the only place raw values are declared.
- Colours in OKLCH. It keeps perceived lightness consistent across hues, which is
  what makes a neutral ramp read as deliberate rather than muddy.
- Dark mode via `@custom-variant dark`.
- Custom utilities via `@utility`, not by hand-writing CSS classes.
- shadcn/ui expects its tokens as CSS variables on `:root` and `.dark`, mapped
  into Tailwind with `@theme inline`. Keep shadcn's variable names intact and set
  their values from the art direction.

Verify current Tailwind v4 and shadcn/ui syntax against the official docs before
relying on the details above — this file is written from knowledge current to
mid-2026 and both projects move quickly.

## shadcn/ui

shadcn is a starting point that is copied into the repo, not a dependency to
defer to. Its default theme is one of the most recognisable AI-app signatures in
existence, so:

- Every component that ships must have its tokens replaced by art-direction
  values. Default radius, default neutral ramp and default focus ring are all
  tells.
- Delete variants the product does not use rather than carrying them.
- Keep the Radix primitive underneath. Re-implementing accessible menus, dialogs
  and comboboxes by hand is where accessibility regressions come from.
- `components/ui/` holds shadcn primitives. Product components compose them and
  live elsewhere. Never scatter product logic into `components/ui/`.

## Backend seam

The prototype and the first implementation run against fixtures. Real endpoints
arrive later. The seam must be a single, obvious place — not a refactor.

```
src/api/
  types.ts          # domain types, hand-written, the contract
  client.ts         # fetch wrapper: base URL, auth, error normalisation
  fixtures/         # realistic seed data, same shape as types.ts
  resources/        # one file per resource: customers.ts, orders.ts
  queries/          # TanStack Query hooks — the only thing components import
```

- `resources/*.ts` exports functions that either hit `client.ts` or return
  fixtures, switched by one env flag (`VITE_USE_FIXTURES`). Swapping to the real
  backend changes the flag and the resource bodies. Nothing else.
- Components never call `fetch` and never import from `resources/` or
  `fixtures/`. They import hooks from `queries/`.
- Fixtures must be realistic in shape *and* in distribution: real-looking names,
  plausible skew, some long strings, some nulls, some rows that break layouts.
  Fixtures that are all tidy hide the bugs the design has to survive.

## State

- Server state: TanStack Query. Never `useEffect` + `useState` for fetching.
- URL state: filters, sort, pagination, active tab, opened record. If a user
  would reasonably bookmark or share it, it belongs in the URL.
- Local state: `useState` inside the component that owns it.
- Derived state: computed at render. Never stored.
- Global client state: only for genuinely cross-cutting concerns (theme, session,
  toasts). Reach for Zustand or Context. Not Redux by default.

Duplicated state is the defect to hunt for. One fact, one home.

## Libraries

- Routing: TanStack Router (type-safe params, first-class search-param state) or
  React Router. Choose once per project and record it.
- Forms: React Hook Form + Zod. One schema drives validation and types.
- Tables: TanStack Table, headless, styled by our own components.
- Charts: pick one and only one. Recharts for standard cases, visx or D3 when the
  chart is a designed artifact rather than a default.
- Icons: one set, one weight, one size scale. Mixing icon sets is instantly visible.
- Dates: `date-fns` with explicit locale and timezone handling. Never ad-hoc formatting.

## Folder structure

Organise by feature, not by file type.

```
src/
  features/
    customers/
      components/
      hooks/
      routes/
  components/ui/       # shadcn primitives
  components/          # shared product components
  api/
  lib/
  styles/
```

A shared `components/` directory that accumulates everything is the thing this
structure exists to prevent. Something moves to `components/` when a second
feature actually uses it, not in anticipation.

## Naming

Names state intent. Banned as file or module names: `utils`, `helpers`, `misc`,
`common`, `data`, `stuff`, `manager`, `handler`. `formatCurrency.ts` and
`useCustomerFilters.ts` say what they are; `utils.ts` becomes a landfill.

## TypeScript

- `strict: true`. No `any`. `unknown` at boundaries, narrowed immediately.
- Domain types hand-written in `api/types.ts`. Generate from a schema only once a
  real schema exists.
- Discriminated unions for states. A component with `isLoading`, `isError` and
  `data` all independently optional has four impossible states; a union has none.
- Props typed explicitly. No `React.FC`.

## Testing

Vitest + React Testing Library for unit and component, Playwright for end-to-end,
`@axe-core/playwright` for automated accessibility. Vitest shares Vite's config and
transform pipeline, so there is no second build to maintain.

What gets tested, and the evidence format stage 6 enforces, is in
`.claude/skills/_shared/verification.md`.

Test the behaviour a user depends on, not the implementation. A test asserting that a
component renders a div is a maintenance cost with no informational value; a test
asserting that filtering by partial name returns the right rows is the acceptance
criterion made executable.

Fixtures are shared between the app and the tests. One source of realistic data means
tests exercise the same awkward values the UI has to survive.

## Version control

- `.claude/.artifacts/` is committed, prototypes included. It is the institutional
  memory, and memory that exists on one machine is not memory.
- One in-flight feature per branch. The manifest is single-writer state.
- Decision IDs are feature-scoped (`D-{slug}-{n}`) so concurrent branches never
  collide and merges never require renumbering.
- `node_modules`, `dist`, `coverage`, `playwright-report` and `.env*` are ignored.
- Run `node .claude/scripts/validate-manifest.mjs` after any merge that touched
  `.artifacts/`.

## Quality floor

Non-negotiable, never announced as an achievement:

- Responsive to 360px.
- Visible keyboard focus on every interactive element.
- `prefers-reduced-motion` respected.
- Semantic HTML before ARIA. ARIA only where semantics cannot express it.
- No console errors or warnings.
- No layout shift on data load.
