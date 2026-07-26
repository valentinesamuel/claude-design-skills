# Authoring the Art Direction

Read at stage 1 when `art-direction.md` is unfilled. This document is the product's
visual point of view, locked once and then conformed to. It is the reason the
product will not look generated.

## Why this exists

Interfaces read as AI-made not because they contain gradients, but because they
contain no evidence of a decision. Every axis is left at a safe default, so the
result is competent, hue-less and interchangeable with every other generated app.
A prohibition list cannot fix that — avoiding clichés produces bland-safe work,
which is the same failure wearing quieter clothes.

The fix is commitment. Pick specific values for specific reasons rooted in this
product's subject, audience and job, write them down, and hold them everywhere.
Consistency executed at high fidelity is what reads as a design team.

## Ground it in the subject

Before choosing anything, you must have in one sentence each: what this product is,
who uses it and how often, and the single job of its primary surface.

If `project-context.md` does not pin these down, you ask the user. You do not pin
them yourself. Every value in this document is derived from those three answers, so
inventing them means inventing the entire visual direction on the user's behalf and
then locking it as though they had chosen it.

Distinctiveness comes from the subject's own world — its vocabulary, its
artifacts, the rhythm of the work it supports. A tool used for eight hours a day by
experts wants density, keyboard-first interaction and quiet chrome. A tool used
monthly by occasional users wants guidance and larger targets. These lead to
genuinely different products, and the art direction is where that difference gets
decided rather than drifted into.

## Calibration: what defaults look like right now

Generated design currently clusters into three looks. All three are legitimate for
some briefs and all three appear regardless of brief, which is what makes them
defaults rather than choices:

1. Warm cream background near `#F4F1EA`, high-contrast serif display, terracotta
   accent near `#D97757`.
2. Near-black background with a single acid-green or vermilion accent.
3. Broadsheet layout, hairline rules, zero radius, dense newspaper columns.

For product UI specifically, add: shadcn/ui defaults untouched; a 4-across row of
stat cards above a chart; `rounded-2xl` everywhere; uniform `p-6`; violet-to-blue
gradients on primary buttons; a sidebar of icon-plus-label items with no visual
hierarchy between sections.

If `project-context.md` specifies a direction, follow it exactly — the brief always
wins, including when it asks for one of these. Where it leaves an axis free, do
not spend that freedom on a default.

## Required contents

Fill every section with values, not adjectives. Each choice gets a one-line reason
tied to this product.

**Position** — one paragraph. What this product should feel like to use, and what
it should explicitly not feel like. Name the feeling and the anti-feeling.

**Typefaces** — display, body/UI, and data face if needed. Actual family names,
actual weights in use, and why this pairing suits this subject rather than any
subject. Note the licensing and loading strategy.

**Type scale** — the ratio, and the emitted values from smallest to largest, each
with its line height, weight and tracking. Real numbers.

**Density** — the target, stated as control height, table row height, intra-section
spacing and section spacing. This single decision does more to characterise a
product than colour does.

**Palette** — the accent hue in OKLCH, the neutral ramp in full, the semantic
roles, and what each surface level is. State whether neutrals are warm, cool or
true, and why.

**Shape** — the radius scale and its character. A product can be sharp, softly
rounded, or mixed with intent — sharp containers with rounded controls, for
instance. Pick one and hold it.

**Elevation** — borders or shadows as the dominant strategy, per `craft.md`, and
the tokens for it.

**Motion signature** — the durations, the easing curves, and the one orchestrated
moment this product is remembered by, if any.

**Signature element** — the single thing a user would describe if asked what this
product looks like. Spend your boldness here and keep everything around it quiet.
A product with no signature element is forgettable; one with five is noisy.

**References** — two or three named products, and for each, precisely what is being
borrowed. "Linear" is not a reference. "Linear's approach to keyboard-first
navigation and its restraint in using colour only for status" is.

**Explicit rejections** — what this product deliberately will not do, so reviewers
can check it.

## Review before you build

Before writing any prototype code, review the direction you just wrote. Work
through what you would produce for a generic brief in this category. If any part of
your direction matches that generic output, revise it, and record what you changed
and why.

Then take one aesthetic risk you can justify in one sentence. Not taking a risk is
itself a risk — it is how work ends up defensible and forgettable. But spend it in
one place only.

## Chanel's test

Before handing off, look at the whole thing and remove one thing. There is almost
always one accessory too many.
