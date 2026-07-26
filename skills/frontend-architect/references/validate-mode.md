# Validate Mode — Stage 6

The implementation is delivered. Verify it matches the plan and meets engineering
standards. This is the last gate before the feature is complete.

## Additional inputs

- `.claude/skills/_shared/review-protocol.md` — severity, verdict, report shape
- `.claude/skills/_shared/verification.md` — the mechanical gate you now enforce
- `FEATURE/api-contract.md` — verify the data layer matches what was contracted
- `FEATURE/architecture-plan.md`, `FEATURE/component-architecture.md`,
  `FEATURE/implementation-guidelines.md` — the contract you wrote
- `FEATURE/implementation-report.md` and `FEATURE/implementation-plan.md`
- The delivered source code
- `FEATURE/prototype/` — for fidelity comparison
- `FEATURE/design-review.md`, `FEATURE/ux-review.md` — verify required changes landed

## Remit

Engineering quality and fidelity to the plan. Visual craft was gated at stage 2 and
usability at stage 3 — you do not re-open either. Fidelity of the built UI to the
approved prototype *is* yours, because deviation there means the approved design was
never delivered.

## You do not touch the code

Write access in this mode is `validation-report.md` and nothing else. Every defect
you find is written up, never fixed — see the absolute rules in `SKILL.md`.

Before recording any deviation from your plan as a defect, ask whether it was a
deliberate decision you were not told about. An engineer who improved on the plan
and simply failed to document it has made a documentation error, not an
architectural one, and the two carry very different severities.

## Procedure

1. **Plan conformance.** Walk `component-architecture.md` against the actual tree.
   Every deviation is a finding, but judge each on merit — an engineer who improved
   on the plan and documented why has done the right thing, and an undocumented
   deviation is the problem regardless of quality.

2. **Required changes.** Confirm every open required change from stages 2 and 3 was
   actioned. Any that was silently dropped is Critical: it means a gate was bypassed.

3. **Fidelity.** Compare the built UI to the prototype. Spacing, type, colour,
   radius, states, motion. Values that drifted from tokens to hardcoded numbers are
   Major at minimum.

4. **Code review.** Run the checklist below.

5. **Re-run every command yourself.** Per `_shared/verification.md`:

   ```
   npx tsc --noEmit
   npx eslint . --max-warnings 0
   npx vitest run
   npx playwright test
   node .claude/scripts/token-diff.mjs --prototype {FEATURE}/prototype/theme.css
   node .claude/scripts/validate-manifest.mjs
   ```

   Any failure is Critical. Evidence absent for a required item is also Critical —
   absent evidence and failed verification are indistinguishable to this pipeline, so
   they carry the same weight. A reported result that differs from your re-run is
   Critical and named explicitly in your report.

   Confirm one Playwright test exists per acceptance criterion. A criterion with no
   test is Critical: it means nothing verifies the thing the user actually asked for.

   Then open the result and use it. A review that only reads code misses every defect
   that appears at runtime, which is most of the interesting ones.

6. Assign severity and derive the verdict mechanically per `review-protocol.md`.

## Checklist

**API conformance** — the data layer matches `api-contract.md`: shapes, error
handling for every documented status, pagination semantics, and the fixture seam
still switchable in one place. A frontend that drifted from its own contract will
fail integration.

**Structure** — feature-organised, not type-organised. No component over ~200 lines
without justification. No god components. Nothing dumped in shared `components/`
that only one feature uses. Names state intent; no `utils`, `helpers`, `manager`.

**State** — one home per fact. No duplicated or derived-and-stored state. Server
state in TanStack Query, not `useEffect`. Filters, sort and pagination in the URL.
No unnecessary global state. No impossible state combinations that a discriminated
union would have prevented.

**Data** — components import only from `queries/`. No `fetch` in a component. Cache
keys and invalidation as planned. Fixture seam intact and switchable in one place.
Requests cancellable. No waterfalls that could be parallel.

**Types** — strict, no `any`, `unknown` narrowed at boundaries. Props explicit.
State modelled as unions. Types not silently widened to make an error go away.

**Design system** — no hardcoded colour, spacing, radius, font size or duration.
shadcn primitives retokenised to the art direction. No one-off styling that should
be a variant.

**Accessibility** — semantic HTML first. Focus visible on everything interactive.
Focus managed on route change and dialog open, and returned on close. Keyboard
completable. Labels associated. Live regions for async results. `prefers-reduced-motion`
respected. Contrast preserved in both themes.

**Performance** — long lists virtualised where the plan requires. No unnecessary
re-render cascades. Memoisation where measured, absent where speculative. Bundle
impact reasonable. Images sized and lazy where appropriate. No layout shift on load.

**Errors** — every failure path handled and rendered as the designed state. No
silent catch. No unhandled promise rejection. Boundaries where planned.

**Craft** — no dead code, no commented-out blocks, no leftover console statements,
no `TODO` without an owner. No nested ternaries in JSX. No copy-pasted blocks that
should be a component or a map.

**Over-engineering** — abstractions with one caller. Config objects for values that
never vary. Wrappers that only forward props. Generics with one instantiation. Reject
these as readily as duplication; unused flexibility is cost with no return.

## Scored dimensions

Plan Conformance · Visual Fidelity · Component Design · State Management ·
Data Layer · Type Safety · Accessibility · Performance · Error Handling ·
Maintainability · Design System Compliance · Code Quality

Plus Verification Evidence and API Conformance.

Overall out of 100, using the anchors in `review-protocol.md`.
