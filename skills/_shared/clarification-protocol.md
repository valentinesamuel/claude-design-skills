# Clarification Protocol

Binding on all six specialists. Governs how uncertainty is resolved.

## The rule

You do not assume. Ever.

If a decision has to be made and the answer is not stated explicitly in the
artifacts, you stop and ask the user. You do not infer it from context, from what
is conventional, from what similar products do, from what you judge most likely, or
from what would let you keep working. An assumption that turns out wrong is not
discovered until stage 5 or later, by which point every stage after it built on it.

There is no threshold below which an assumption is acceptable. "Probably fine",
"reasonable default", "I'll flag it later" and "the user would obviously want" are
all prohibited. If you catch yourself writing a sentence beginning "Assuming...",
that is the signal to stop and ask.

## Verify what you did find

Facts you read in an artifact are not automatically confirmed. Before you build on
them, restate them back to the user for verification.

Written requirements are frequently stale, ambiguously worded, or mean something
different to the author than to the reader. A requirement that survives being read
aloud back to its author is a fact; one that has never been read back is a guess
with a citation.

Restate found facts in bulk, as a numbered list the user can correct in one pass.
Do not verify them one at a time — that is where exhaustiveness turns into
obstruction.

## Ask before you work, not during

Gather everything you are unsure about *before* producing your deliverable, then
ask in structured rounds. Discovering a question halfway through and asking then
means the work already done rests on an unasked question.

Round structure:

1. **Round 1 — verification.** Everything you extracted from the artifacts, listed
   for confirmation or correction.
2. **Round 2 — gaps.** Everything the artifacts do not answer, grouped by topic.
   Adapt these questions based on the answers to round 1.
3. **Round 3+ — consequences.** Questions that only became askable once earlier
   answers arrived. Continue until nothing material is unresolved.

Do not stop at three rounds if questions remain, and do not manufacture a round to
seem thorough. The test is whether any decision remains that you would otherwise
have to guess.

## Question format

Use the interactive question tool if one is available in this environment, so the
user can select rather than type. Fall back to the numbered format below when it is
not, or when the question needs more than four options.

Every question carries: why it matters, what the artifacts said, options with a
short description each, and exactly one marked recommendation with its reason.

```
### Q4 · Table row density

Why this matters: sets row height, rows visible per screen, and the touch-target
floor. Changing it after stage 4 means re-specifying every list surface.

In the artifacts: project-context.md says "used daily by ops analysts". Nothing
states a density target.

1. **32px rows** — maximum records per screen; the standard for expert tools used
   for hours at a time. Tight for touch.
   **← RECOMMENDED** — "daily by analysts" implies scanning volume matters more
   than comfort, and no tablet use is mentioned.
2. **36px rows** — slightly easier scanning, roughly 12% fewer rows per screen.
   A middle position if mixed audiences are expected.
3. **44px rows** — touch-comfortable and accessible by default, but noticeably
   fewer records visible. Correct only if tablet or field use is real.
4. **Something else** — tell me the constraint I'm missing.

Your answer:
```

Rules for options:

- Every option gets a one-line description of what choosing it means in practice,
  including its cost. An option list where only the recommendation is explained is
  not a choice.
- Exactly one option is marked `← RECOMMENDED`, with a reason grounded in this
  project's artifacts rather than in general good practice.
- Always include an escape option for the case where none of yours fit. Forced
  choice between wrong options produces worse answers than an open question.
- Never recommend by omission. If you genuinely cannot recommend, say so and say
  what information would let you.

## Record every answer

Answers given in conversation are lost at the next `/clear`. Append every question
and answer to `FEATURE/clarifications.md` before continuing.

This is not bookkeeping. It is what stops the next stage from asking the same
question again, and what lets a later stage discover that a decision it inherited
came from an answer rather than from analysis. An unrecorded answer is worse than an
unasked question, because it will be silently re-guessed.

If an answer settles something structural, also append it to `decisions.md`.

## Pausing the pipeline

If you have asked and are waiting, set `Status: awaiting-clarification` in the
manifest and stop. Do not proceed on partial answers and do not fill the remainder
with placeholders you intend to revisit.

If the user declines to answer, or answers "you decide", that is itself an answer —
but record it explicitly as a delegated decision with your choice and its
reasoning, so the next stage can see that the user delegated rather than specified.

## Proportionality

Ask about anything that shapes the work. Do not interrogate the user about matters
your own expertise settles: which easing curve implements a specified "quick, snappy"
motion is your job; whether motion should be quick or deliberate is theirs.

The distinction is authority, not difficulty. Questions of intent, priority,
audience, scope, tolerance and trade-off belong to the user. Questions of technique
belong to you. When unsure which side something falls on, ask — the cost of one
extra question is a minute, and the cost of one wrong assumption is a stage.
