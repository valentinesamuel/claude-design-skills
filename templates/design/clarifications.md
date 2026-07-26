# Clarifications

Append-only record of every question asked of the user and every answer given,
for this feature. Written by whichever specialist asked.

This file exists because answers given in conversation are destroyed by the next
`/clear`. Without it, each stage re-asks what the previous stage already resolved,
and a decision that came from the user becomes indistinguishable from one a
specialist invented.

Before asking anything, read this file. If the question has already been answered,
it is answered.

Record the answer as given. If the user delegated the choice, record that
explicitly, along with the choice made and why — a delegated decision and a
specified one carry different weight later.

---

## C-001
Asked by: {skill} (stage {n})
Date: {YYYY-MM-DD}
Question: {as put to the user}
Options offered: {list, with which was recommended}
Answer: {as given}
Type: {specified | corrected | delegated | declined}
Consequence: {what this now determines}
Decision ID: {if it also went to decisions.md, otherwise none}
