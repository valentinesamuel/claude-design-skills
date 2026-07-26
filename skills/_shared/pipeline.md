# Pipeline Contract

Shared by all six specialists. Defines paths, stages, the preflight gate, state
schema, routing and write scopes. Read this only after the preflight gate in your
own SKILL.md has confirmed you are the current owner.

## Paths

- `ROOT` = `.claude/.artifacts/design/`
- `FEATURE` = `ROOT + features/{Feature Slug}/`

Project-level artifacts persist across every feature and live directly in `ROOT`:
`manifest.md`, `project-context.md`, `art-direction.md`,
`product-architecture.md`, `design-system.md`, `decisions.md`.

Everything else is feature-scoped and lives in `FEATURE`.

## Stage table

| Stage | Skill | Mode | Produces |
|---|---|---|---|
| 0 | `artifact-manager` | init / feature / repair / status / archive / audit | repository structure, project-level artifacts |
| 1 | `senior-product-designer` | design | `design-analysis.md`, `design-spec.md`, `prototype/`, `handoff.md`, updates `art-direction.md`, `product-architecture.md` + `design-system.md` |
| 2 | `design-reviewer` | review | `design-review.md` + verdict |
| 3 | `ux-reviewer` | review | `ux-review.md` + verdict |
| 4 | `frontend-architect` | plan | `architecture-plan.md`, `component-architecture.md`, `implementation-guidelines.md`, `api-contract.md` |
| 5 | `staff-ui-engineer` | implement | `implementation-plan.md`, application code, `implementation-report.md` |
| 6 | `frontend-architect` | validate | `validation-report.md` + engineering verdict |

Stage 6 approval completes the feature. `artifact-manager` then archives it and
resets the manifest for the next feature.

`frontend-architect` runs twice. Its mode is read from the manifest `Mode` field,
never inferred: stage 4 is `plan`, stage 6 is `validate`. If `Mode` is absent or
disagrees with `Stage`, stop and report the inconsistency rather than guessing.

## Preflight gate

Every specialist runs this before reading any other file, before any tool call,
and before producing any output.

1. Read `ROOT/manifest.md`. Read nothing else yet.
2. If it is missing, stop and output exactly:
   `No pipeline found at .claude/.artifacts/design/. Run /artifact-manager to initialise.`
3. Parse `Next Skill`, `Stage`, `Mode`, `Status`, `Feature`, `Iteration`.
4. If `Status: blocked`, stop even if you are the owner. Report the blocking
   reason and the path to `FEATURE/escalation.md`. A human decides.
5. If `Next Skill` is not your own skill name, stop. Output:
   - current `Feature`, `Stage`, `Status`
   - one sentence on why you are not the owner
   - `Run /{Next Skill}`
   Do not read further artifacts. Do not perform partial work. Do not offer to
   proceed anyway. Do not ask permission to override. Exiting is the correct result.
6. You are the owner. Load only the files listed in your stage's Inputs.

The gate exists so that a stage cannot run on unapproved inputs. Refusing to run
out of sequence is a feature, not an obstacle.

## Manifest state schema

The `PIPELINE STATE` block is the only part any skill must parse. Keys are fixed;
never rename or reorder them.

```
Feature: Customer search and filtering
Feature Slug: customer-search
Stage: 2
Owner: design-reviewer
Next Skill: design-reviewer
Mode: review
Status: awaiting-review
Iteration: 1
Max Iterations: 2
Open Required Changes: 0
Last Decision: D-014
Updated: 2026-07-26T14:02Z
```

`Status` is one of: `not-started`, `in-progress`, `awaiting-clarification`,
`awaiting-review`, `changes-required`, `blocked`, `complete`.

`awaiting-clarification` means the owner has asked the user questions and stopped.
Ownership does not change; the same skill resumes once answered. Any specialist may
enter this state at any point, and must rather than assume — see
`clarification-protocol.md`.

## Verdict routing

Reviewer stages (2, 3, 6) end in exactly one verdict. Routing is mechanical.

**APPROVED** — advance. `Stage += 1`; set `Owner`, `Next Skill` and `Mode` from the
stage table; `Status: in-progress`; `Iteration: 0`.

**APPROVED WITH REQUIRED CHANGES** — advance as above, and append each required
change to the manifest's Open Required Changes table, assigned to the stage that
must action it. Increment `Open Required Changes` by the number added.

**REJECTED** — return. Set `Stage` to the producing stage and `Next Skill` to that
stage's skill; `Status: changes-required`; `Iteration += 1`.

Producing stages must clear every open required change assigned to them before
handing off, and must state in their handoff how each was addressed.

## Loop termination

If a REJECTED verdict would push `Iteration` above `Max Iterations` (default 2),
do not reject again. Instead set `Status: blocked`, `Next Skill: none`, and write
`FEATURE/escalation.md` containing:

- the specific disagreement, stated in one paragraph
- the reviewer's position and what standard it rests on
- the producer's position and why it was chosen
- two or three options with honest trade-offs
- a recommendation, and what would change it

Then stop and put the decision to the human. Unbounded rejection loops burn
budget and converge on nothing; escalation is the designed exit.

## Deterministic checks

Two checks are scripts rather than instructions, because they are mechanical and a
model following them carefully will still occasionally not:

```
node .claude/scripts/validate-manifest.mjs
node .claude/scripts/token-diff.mjs --prototype {FEATURE}/prototype/theme.css
```

`validate-manifest` verifies state-key completeness, stage/owner/mode consistency,
status legality, iteration bounds, required-change count drift, artifact presence and
emptiness for every passed stage, unfilled placeholders, and decision-ID sequence.
Run it at the end of every stage, before handing off. A non-zero exit means the
handoff is not complete.

`token-diff` finds hardcoded design values in application source and tokens present
in the approved prototype but missing from production. Stage 5 runs it before
reporting; stage 6 re-runs it.

## Review scope

`Review Scope` is `full` or `delta`.

First review of a feature is always `full`. After a REJECTED verdict, the producing
stage sets `Review Scope: delta` and lists what it changed in the manifest's Changed
Surfaces table. The reviewer then covers the changed surfaces in full, plus a
regression pass over what did not change — checking specifically that a fix did not
break something previously approved.

Without this, every iteration re-reviews everything, which is the cost that makes
gated pipelines get abandoned around the fourth feature. A delta review is not a
lighter standard; it is the same standard applied where the work happened.

Reviewers state their scope in the report. A delta review that finds a Critical
issue in an unchanged surface escalates to `full` for the next iteration.

## Repository and concurrency

The artifact repository is committed. It is the institutional memory, and a
`.artifacts/` directory that exists only on one machine is not memory. Commit
everything under `ROOT`, including prototypes — a reviewer needs to be able to open
what was approved three features ago.

The manifest holds exactly one in-flight feature. It is single-writer state.

- One feature per branch. Two features in flight on one branch corrupts the manifest.
- Decision IDs are feature-scoped — `D-{feature-slug}-{n}`, sequential within the
  feature. This is deliberate: globally sequential IDs conflict on every merge of two
  concurrent branches, and renumbering to resolve the conflict would break every
  reference pointing at them.
- On merge, `decisions.md` conflicts are resolved by keeping both blocks. No
  renumbering is ever needed, because the feature slug disambiguates.
- After merging, run `validate-manifest.mjs`. If the merged manifest describes a
  feature that is no longer in flight, run `/artifact-manager` in repair mode.

## Write scopes

Write scope is absolute. Read is universal; write is exclusive.

A specialist writes only the files listed against its name below, plus the manifest,
the decision log and its feature's clarifications log. Everything else in the
repository and in the application is read-only to it, without exception.

There is no such thing as a small, obvious, helpful or trivial edit outside your
scope. A reviewer that fixes the bug it found has destroyed the record of the
defect, bypassed the gate that was supposed to catch it, and left the producer
unaware that anything was wrong. A one-line fix costs more than the finding it
replaced, because the finding is the deliverable.

This holds even when:

- the fix is a single character, or plainly correct
- you are certain the producer would agree
- fixing it is faster than describing it
- the user asks you to fix it while you are in a reviewing role — in that case,
  say which skill owns the change and stop
- you are mid-iteration on the same feature and the file is open
- the defect is blocking your own ability to complete your review

If something outside your scope must change, you describe it: a finding with a
location and a required fix, a decision entry, or a required change assigned to the
owning stage. Then you stop.

Interrogating roles — `design-reviewer`, `ux-reviewer` and `frontend-architect` in
validate mode — write nothing but their own report. No application code, no
prototype edits, no specification edits, no design-system edits, no test files, no
configuration, no formatting, no import reordering. Nothing.

| Skill | May write |
|---|---|
| `artifact-manager` | repository structure, project-level artifacts, archives |
| `senior-product-designer` | `design-analysis.md`, `design-spec.md`, `prototype/`, `handoff.md`, `art-direction.md`, `design-system.md` |
| `design-reviewer` | `design-review.md` |
| `ux-reviewer` | `ux-review.md` |
| `frontend-architect` | `architecture-plan.md`, `component-architecture.md`, `implementation-guidelines.md`, `validation-report.md` |
| `staff-ui-engineer` | `implementation-plan.md`, `implementation-report.md`, application source code |

Every specialist may also append to `ROOT/decisions.md` and `FEATURE/clarifications.md`. Both are append-only.

Everyone may read anything. Nobody edits another specialist's documents — a
disagreement is recorded as a finding or a decision, never as a silent edit.

Only `staff-ui-engineer` writes application source code. Reviewers and architects
describe changes; they do not make them.

## Shutdown procedure

Before finishing, in this order:

1. Write your own artifacts.
2. Append any significant decision to `ROOT/decisions.md` and note the new ID.
3. Update the `PIPELINE STATE` block and the artifact index in `ROOT/manifest.md`.
4. Print a two-line handoff: what you produced, and `Run /{next skill}`.

If you cannot complete step 3, say so explicitly. A stale manifest silently
breaks every later stage, so it is the one failure that must never be quiet.

## Decision log entry

Append-only. Never edit or delete an existing entry.

```
## D-customer-search-3 — Server-side pagination for the customer table
Author: frontend-architect (stage 4)
Date: 2026-07-26
Context: 5.2M customer records; the design shows an unbounded scrolling table.
Decision: Cursor pagination at 50 rows, virtualised viewport.
Reasoning: Offset pagination degrades past ~100k rows on the source query.
Alternatives: Offset pagination (simpler, degrades); full client load (impossible).
Trade-offs: Cursor pagination forfeits jump-to-page. Accepted.
Next Owner: staff-ui-engineer
```
