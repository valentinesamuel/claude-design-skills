# Design Pipeline

A six-specialist design organisation. Conversation is temporary; artifacts are
permanent. Every stage reconstructs its context from
`.claude/.artifacts/design/` and survives a complete context clear.

## Invocation

Skills are invoked manually, one stage at a time. Skill names are lowercase and
hyphenated — Claude Code requires this, so `/designReviewer` will not resolve.

```
/artifact-manager          stage 0   init, new feature, repair, status, archive
/senior-product-designer   stage 1   art direction, spec, prototype
/design-reviewer           stage 2   visual gate
/ux-reviewer               stage 3   usability gate
/frontend-architect        stage 4   architecture plan
/staff-ui-engineer         stage 5   implementation
/frontend-architect        stage 6   engineering validation
```

`/clear` between every stage. That is the point of the design — each specialist
reads only the artifacts its stage needs, so a clean context costs nothing and a
dirty one costs tokens and invites cross-contamination between roles.

Every skill checks the manifest first. Invoke the wrong one and it will tell you
which to run instead and stop, without doing partial work.

## Starting a project

```
/artifact-manager          → answer the project interview
/clear
/artifact-manager          → open your first feature
/clear
/senior-product-designer
```

## Where things live

```
.claude/
  CLAUDE.md
  skills/
    _shared/               pipeline contract + review protocol
    {six specialists}/     SKILL.md + references/ loaded on demand
  knowledge/               stack.md, craft.md — organisational standards
  scripts/                 validate-manifest.mjs, token-diff.mjs
  templates/design/        artifact templates
  .artifacts/design/       project state (generated)
    manifest.md            the state machine
    project-context.md     business truth
    art-direction.md       visual point of view — locked at stage 1
    product-architecture.md  navigation, IA, URL patterns, vocabulary
    design-system.md       token and component truth
    decisions.md           append-only institutional memory
    features/{slug}/       everything feature-scoped
    archive/               completed features
```

## The state machine

`manifest.md` holds a `PIPELINE STATE` block. `Next Skill` is the only field that
determines who may run. Verdicts route mechanically:

- **Approved** → advance a stage
- **Approved with required changes** → advance, changes tracked in the manifest and
  assigned to a stage that must clear them
- **Rejected** → return to the producing stage, iteration incremented

After `Max Iterations` (default 2), the pipeline blocks and writes
`escalation.md` for you to decide. Unbounded rejection loops are the main failure
mode of a gated pipeline, so the escalation is the designed exit rather than a
safety net.

## Mechanical gates

Three of the four gates are judgement. These two are not, and both are run at the end
of every stage:

```
node .claude/scripts/validate-manifest.mjs
node .claude/scripts/token-diff.mjs --prototype <feature>/prototype/theme.css
```

The first catches stale or inconsistent state — the failure that silently breaks every
later stage. The second catches hardcoded design values and tokens that never made it
from the approved prototype into production.

Stage 5 also writes tests (one Playwright test per acceptance criterion, plus unit
tests and axe), and stage 6 re-runs every command rather than trusting the report.
Absent evidence is treated as failed verification, because the pipeline cannot tell
them apart. Details in `skills/_shared/verification.md`.

## Design intent worth knowing

**The prototype is the reviewable artifact.** Stage 1 produces a working static
prototype, not just a specification. Without it, stages 2 and 3 review prose and
stage 5 invents the design — which is exactly how generated-looking UI reaches
production.

**The art direction is the anti-generic mechanism.** Interfaces read as AI-made
because they contain no evidence of a decision, not because they contain gradients.
`art-direction.md` forces specific committed values, and stages 2 and 6 check
conformance against them. A prohibition list alone only produces bland-safe work.

**Verdicts derive from severity counts, not from taste.** One Critical blocks; a
Major means approve-with-changes; neither means approve. A gate that never opens
transmits no information.

**Reviews are scoped after the first iteration.** A rejection sets
`Review Scope: delta` and a Changed Surfaces list, so the next review covers what
changed at full standard plus a regression pass — rather than re-reviewing everything
every time, which is what makes gated pipelines get abandoned.

**Coherence is a project-level artifact.** No gate looks across features, so
`product-architecture.md` holds the navigation model, object model, URL patterns and
controlled vocabulary, and every feature is checked against it. Ten individually
approved features otherwise produce three words for the same object.

**Settled decisions stay settled.** `decisions.md` and prior approvals cannot be
grounds for rejection — only for a Reopen Request that you adjudicate. This is what
makes the pipeline converge instead of re-arguing stage 1 forever.

**Write scope is absolute, and read scope is universal.** Only `staff-ui-engineer`
writes application code. The three interrogating roles — both reviewers and the
architect in validate mode — write nothing but their own report. They do not fix the
defects they find, however trivial, because the finding is the deliverable and a
silent fix bypasses the gate that was supposed to catch it.

**No skill assumes anything.** Every specialist verifies what it read back to you
and asks about every gap before producing its deliverable, in structured rounds,
with recommended options and a short description of each. Anything a specialist
would otherwise have to guess becomes a question instead.

Because a `/clear` destroys conversation, every answer is appended to
`features/{slug}/clarifications.md`. That file is what stops stage 4 from re-asking
what stage 1 already settled, and what lets a later stage tell a decision you made
from one a specialist invented. A skill waiting on you sets
`Status: awaiting-clarification` and stops.

## Stack

React 19 · Vite · TypeScript strict · Tailwind v4 · shadcn/ui retokenised.
Vitest, Playwright and axe-core for verification. Fixture-backed data layer with a
single switch at `src/api/`, so a real backend plugs in without a refactor —
`frontend-architect` writes `api-contract.md` at stage 4 as the document you hand to
whoever builds it. Details in `knowledge/stack.md`.

`.artifacts/` is committed; one in-flight feature per branch.
