# Review Protocol

Shared by `design-reviewer`, `ux-reviewer` and `frontend-architect` in validate mode.
Defines severity, scoring, verdict derivation and report shape, so that three
reviewers with different remits produce comparable, actionable output.

## Severity definitions

Severity is about consequence, not about how strongly you feel.

**Critical** — ships a defect a user or the business would feel. The task cannot be
completed, data can be lost or corrupted, an accessibility barrier excludes users,
a WCAG AA contrast or keyboard requirement fails, the interface breaks at a
supported viewport, or the work contradicts an approved artifact from an earlier
stage. Any Critical finding blocks.

**Major** — real quality loss that does not block task completion. Inconsistent
type or spacing against the design system, a workflow with removable friction, a
missing loading or empty state, an unhandled error path, a component that will not
survive long strings or long lists.

**Minor** — craft and polish. Optical alignment, easing choices, copy tone,
naming, a marginally better label.

## Verdict derivation

Verdict is derived mechanically from severity counts. It is not a judgement call
and it is not derived from the scores.

- One or more Critical → **REJECTED**
- Zero Critical, one or more Major → **APPROVED WITH REQUIRED CHANGES**
- Zero Critical, zero Major → **APPROVED**

Do not withhold approval because the work is merely good rather than
extraordinary. If you believe something is genuinely wrong, your obligation is to
name it as a Critical or Major finding with a location and a fix. Unfalsifiable
dissatisfaction is not a finding, and "approval is rare" is not a standard — a
gate that never opens transmits no information.

Equally, do not soften a Critical to keep the pipeline moving. The severity ladder
is the only place your judgement operates, so use it honestly.

## Score anchors

Scores are diagnostic, not a gate. Score each dimension against these anchors so
numbers mean the same thing across reviews and across features.

- **9–10** — would ship as-is at Linear or Stripe. Deliberate, consistent, defensible.
- **7–8** — competent and consistent, but no evidence of craft decisions.
- **5–6** — works; visible inconsistency or default-tooling character.
- **3–4** — visible amateur tells; a designer would notice within seconds.
- **1–2** — broken, or absent.

Report the dimensions your own SKILL.md lists, plus an overall. If a dimension
does not apply to this feature, mark it `n/a` rather than inventing a number.

## Finding format

Every finding is one block. No finding without a location and a fix — an
unactionable finding wastes the producer's next iteration.

```
[Critical] Filter panel traps keyboard focus
Location: prototype/index.html, filter drawer; design-spec.md §4.2
Observed: Tab cycles inside the drawer with no escape; Esc is not handled.
Consequence: Keyboard and screen reader users cannot return to the table.
Required: Focus trap must release on Esc and on close; return focus to the trigger.
```

## Scope discipline

Review only your remit. Overlap between reviewers produces contradictory verdicts
and duplicated cost.

- `design-reviewer` — visual craft, hierarchy, type, spacing, colour, component
  quality, design-system and art-direction conformance.
- `ux-reviewer` — task flows, cognitive load, discoverability, error prevention and
  recovery, efficiency, edge cases, trust.
- `frontend-architect` (validate) — code structure, state, performance,
  maintainability, and fidelity of implementation to the approved plan.

Accessibility is shared but split: `design-reviewer` owns contrast, focus-state
visibility and touch-target sizing; `ux-reviewer` owns focus order, screen-reader
task completion and motion sensitivity; `frontend-architect` owns semantics, ARIA
correctness and keyboard implementation.

If you find something serious outside your remit, record it under
`Cross-Cutting Notes`. It does not affect your verdict and does not block.

## No re-litigation

Decisions recorded in `decisions.md` and artifacts approved at earlier stages are
settled. You may not reject work for a decision that a prior gate approved.

If you believe a settled decision is genuinely wrong, do not reject. Write it as a
`Reopen Request` in your report naming the decision ID and the new information
that was not available when it was made. The human decides whether to reopen.

This rule is what makes the pipeline converge. Without it, every stage re-argues
stage 1 and nothing ships.

## Review scope

Read `Review Scope` from the manifest.

`full` — everything in your remit.

`delta` — the surfaces listed in the manifest's Changed Surfaces table, reviewed at
full standard, plus a regression pass over unchanged surfaces looking specifically
for breakage introduced by the fixes. State both parts in your report.

If a delta review turns up a Critical issue in an unchanged surface, record it, and
note that the next iteration should return to `full`.

Re-reviewing unchanged, previously-approved surfaces in full on every iteration is
not thoroughness — it is the cost that makes people stop running the pipeline.

## Report skeleton

```
# {Design | UX | Engineering} Review — {Feature}
Reviewer: {skill} · Stage {n} · Iteration {n} · Scope: {full | delta} · {date}
Reviewed: {exact artifacts and files, with the prototype path}

## Verdict
{REJECTED | APPROVED WITH REQUIRED CHANGES | APPROVED}
One paragraph: the single most important thing to understand about this work.

## Scores
{dimension}: {n}/10 — {one clause of justification}
...
Overall: {n}/100

## Critical
## Major
## Minor
## Strengths
Name what is genuinely good and why, specifically. This calibrates the producer
for the next iteration as much as the criticism does.

## Cross-Cutting Notes
## Reopen Requests
## Required Changes for Next Stage
Only for APPROVED WITH REQUIRED CHANGES. Each item, with its assigned stage,
copied into the manifest's Open Required Changes table.
```

## Conduct

Be direct, specific and unsparing about the work. Do not perform harshness as a
proxy for rigour — theatrical severity is noise, and it degrades the signal your
verdict is supposed to carry. The most useful reviewer is the one whose approvals
and rejections both mean something.
