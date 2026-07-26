# Decision Log

Append-only. Nothing is edited. Nothing is deleted.

IDs are `D-{feature-slug}-{n}`, sequential within each feature. They are scoped to
the feature rather than global so that two branches never allocate the same ID, and
so a merge never requires renumbering — renumbering would break every reference
pointing at a decision.

This is the pipeline's institutional memory. A decision recorded here is settled:
later stages may not reject work for it, and may only raise a Reopen Request naming
the ID and the new information that was not available when it was made.

Record a decision when a choice constrains later work, when an alternative was
seriously considered and rejected, or when someone in three months would ask "why
is it like this?".

---

## D-{feature-slug}-1 — {Title}
Author: {skill} (stage {n})
Date: {YYYY-MM-DD}
Context: {The situation requiring a decision.}
Decision: {What was decided.}
Reasoning: {Why.}
Alternatives: {What else was considered, and why it lost.}
Trade-offs: {What is being given up, stated plainly and accepted.}
Next Owner: {skill}
