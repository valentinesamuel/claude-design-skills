# Pipeline Manifest

Read first by every specialist. Updated last by every specialist.

## PIPELINE STATE

```
Feature: none
Feature Slug: none
Stage: 0
Owner: artifact-manager
Next Skill: artifact-manager
Mode: init
Status: not-started
Iteration: 0
Max Iterations: 2
Open Required Changes: 0
Last Decision: none
Updated: never
Review Scope: full
```

`Status` values: `not-started` · `in-progress` · `awaiting-clarification` ·
`awaiting-review` · `changes-required` · `blocked` · `complete`

`awaiting-clarification` means the current owner asked the user something and
stopped. Ownership is unchanged; the same skill resumes when answered.

## Stage map

| Stage | Skill | Mode |
|---|---|---|
| 0 | artifact-manager | init / feature / repair / status / archive / audit |
| 1 | senior-product-designer | design |
| 2 | design-reviewer | review |
| 3 | ux-reviewer | review |
| 4 | frontend-architect | plan |
| 5 | staff-ui-engineer | implement |
| 6 | frontend-architect | validate |

## Artifact index

| Artifact | Stage | Status | Updated |
|---|---|---|---|
| project-context.md | 0 | — | — |
| product-architecture.md | 1 | — | — |
| art-direction.md | 1 | — | — |
| design-system.md | 1 | — | — |
| current-feature.md | 0 | — | — |
| clarifications.md | any | — | — |
| design-analysis.md | 1 | — | — |
| design-spec.md | 1 | — | — |
| prototype/ | 1 | — | — |
| handoff.md | 1 | — | — |
| design-review.md | 2 | — | — |
| ux-review.md | 3 | — | — |
| architecture-plan.md | 4 | — | — |
| component-architecture.md | 4 | — | — |
| implementation-guidelines.md | 4 | — | — |
| api-contract.md | 4 | — | — |
| implementation-plan.md | 5 | — | — |
| implementation-report.md | 5 | — | — |
| validation-report.md | 6 | — | — |

## Open Required Changes

Added by reviewers on APPROVED WITH REQUIRED CHANGES. Cleared by the assigned
stage. A stage may not hand off with unactioned changes assigned to it.

| # | Change | Raised by | Assigned to | Status |
|---|---|---|---|---|

## Changed Surfaces

Written by a producing stage after a REJECTED verdict, to scope the next review.
Cleared when `Review Scope` returns to `full`.

| Surface | What changed | Finding it addresses |
|---|---|---|

## Gate history

| Stage | Skill | Iteration | Verdict | Date |
|---|---|---|---|---|
