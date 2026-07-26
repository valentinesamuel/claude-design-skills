# Plan Mode — Stage 4

You have an approved design and an approved user experience. Decide how it gets
built, precisely enough that the engineer makes no structural decisions and vague
enough nowhere.

## Additional inputs

- `FEATURE/design-spec.md` and `FEATURE/prototype/`
- `FEATURE/design-review.md` and `FEATURE/ux-review.md` — read the required changes;
  they are now your constraints
- `ROOT/design-system.md`, `ROOT/art-direction.md`, `ROOT/product-architecture.md`
- The existing codebase, if any. Read enough of it to extend rather than duplicate.

## Clarify before planning

Run the clarification protocol before writing any of the three documents.

Restate back to the user every technical fact you extracted, and ask for every
number you would otherwise estimate: expected record volumes now and in two years,
concurrent users, which endpoints exist today versus which are still to be built,
the auth and session model, offline requirements, browser and device support,
acceptable latency, and data retention.

Do not estimate any of these. An invented volume figure decides pagination,
virtualisation and caching, and none of those are cheap to reverse once stage 5 has
built on them. If the user does not know a number, ask what they want to happen when
it turns out larger than hoped — that answer is more useful than the number.

Record everything in `FEATURE/clarifications.md`, and anything structural in
`decisions.md`.

## Do not

Do not revisit visual or usability decisions. Both were gated. If implementation of
an approved design is genuinely infeasible, raise a Reopen Request per
`review-protocol.md` rather than quietly simplifying it — silent simplification at
this stage is how approved designs become generic implementations.

Do not write feature code. You write the plan.

## architecture-plan.md

- **Scope** — what is being built, in one paragraph.
- **Existing code** — what is reused, what is extended, what is genuinely new.
  Duplicating something that exists is the most common failure here.
- **Routes** — paths, params, search-param state, guards, loading and error
  boundaries. Paths must match the URL patterns in `product-architecture.md`. A
  route shape invented here is a structural inconsistency that ships permanently,
  because URLs are the hardest thing to change later.
- **Data layer** — for each resource: the shape in `api/types.ts`, the
  `resources/` function, the `queries/` hook, cache key, invalidation triggers,
  staleness. Note explicitly which endpoints do not exist yet and are served by
  fixtures, so the backend seam is documented rather than discovered.
- **State map** — every piece of state in the feature, classified as server, URL,
  local or global, with its owner. Any state appearing twice is a defect to resolve
  now, not later.
- **Rendering and performance** — list sizes expected, where virtualisation is
  required, what is code-split, what is prefetched, and the measurable budget.
  Prescribe optimisation only where the design implies real volume; speculative
  memoisation is noise.
- **Error and loading strategy** — where boundaries sit, what each renders, how the
  designed error states from `design-spec.md` map onto real failure modes.
- **Accessibility implementation** — the semantic elements for each region, focus
  management on route change and dialog open, live regions, and where ARIA is
  genuinely required because semantics cannot express it.
- **Risks** — ranked, each with a mitigation.

## api-contract.md

The contract for whoever builds the backend, written from the template. Every
endpoint marked **live** or **planned**.

Without this, the fixture shapes become the contract implicitly, and the mismatch
surfaces during integration when both sides are finished and each believes it is
correct. Be specific about the things that are cheap to state now and expensive
later: currency encoding, null versus absent, timezone handling, pagination
stability under concurrent inserts, and which fields are actually sortable
server-side.

Every number in it comes from the user, per the clarification protocol. Anything
they could not answer goes in `Open questions for the backend` as a named risk —
never filled in with an estimate that will read as a specification.

## Test plan

In `implementation-guidelines.md`, per `_shared/verification.md`. Specify what gets
tested and at which level:

- one Playwright test per acceptance criterion in `current-feature.md`, named after
  the criterion — this is the traceable link between what was asked for and evidence
  it works
- unit tests for every state machine and data transform, using the awkward fixture
  values
- axe on every route, both themes
- the stress-case volume

State the performance budget as a number. An unmeasured budget is not a budget, and
stage 6 enforces this list mechanically.

## component-architecture.md

The component tree, with each node classified: route, layout, container,
presentation, shared, or primitive.

For every component: its single responsibility, its props with types, the state it
owns, what it composes, and where it lives in the folder structure.

Mark clearly which are new, which are existing, and which shadcn primitives are
being introduced — including the tokens that must be overridden to match the art
direction. An unmodified shadcn default reaching production is an architecture
failure, not an implementation one.

Check your own tree: any component doing more than one thing, any prop drilled more
than two levels, any component that cannot be tested in isolation, any abstraction
justified only by a hypothetical second use.

## implementation-guidelines.md

The engineer's contract. Specific to this feature, not a restatement of
`knowledge/stack.md`.

- Build order, sequenced so each step is verifiable
- File-by-file manifest of what to create and modify
- Token mapping: every design value used, and the theme variable it comes from
- Naming for this feature's components, hooks and files
- What is explicitly out of scope
- Definition of done, as checkable items
- The specific traps in this feature and how to avoid them

Where a decision is deliberately left to the engineer, say so explicitly. Silence
reads as omission, and the engineer will either guess or stall.
