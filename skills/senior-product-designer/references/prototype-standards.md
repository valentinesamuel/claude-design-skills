# Prototype Standards

Read at stage 1 step 4. The prototype is the reviewable artifact and the contract
the implementation is measured against.

## What it is

A self-contained static prototype at `FEATURE/prototype/`. It exists so that
stages 2 and 3 review something real, and so that stage 5 reproduces a design
rather than interpreting prose.

It is not the implementation. It is deliberately throwaway, and it must not be
copied into the application — stage 5 rebuilds it properly against the approved
architecture. Its job is to be *seen*.

## Form

Single `index.html` per screen, plus a shared `theme.css`. Tailwind via CDN is
acceptable here; this file never ships. No build step, no framework, no data
fetching — the reviewer must be able to open it directly.

Multiple screens get multiple files plus a plain index listing them. Interaction
that matters to a review — opening a panel, sorting a column, switching a tab,
toggling a state — is wired with minimal vanilla JS. Interaction that does not
affect the review is not.

## Token discipline

`theme.css` declares every value from `art-direction.md` as a custom property, and
the markup uses only those. No raw hex, no arbitrary pixel values, no
`text-[13px]`. This file is the draft of the real theme layer, so getting it right
here means stage 5 inherits it rather than re-deriving it.

## Required coverage

Every prototype must show, not merely describe:

- The default populated state, with realistic data at realistic volume
- The empty state
- The loading state, with skeletons matching the final layout
- An error state
- The stress case: longest plausible strings, missing values, a row that wraps
- Every interactive state on at least one instance of each component, including
  focus-visible
- The narrowest supported viewport, at 360px

Static screenshots of the happy path only are the most common reason a design
review approves work that then fails in production.

## Data

Realistic and internally consistent. Names, companies, dates, amounts and IDs that
plausibly co-occur in this domain. Include the awkward cases: the customer with a
62-character legal name, the record missing a region, the amount that is negative.

Never Lorem ipsum. Never John Doe. Never a chart that only goes up.

If the domain has real vocabulary, use it exactly. Wrong domain language reads as
outsider work faster than any visual mistake.

## Annotation

A short `prototype/NOTES.md` listing what is real, what is faked, what is
deliberately out of scope, and which screens correspond to which section of
`design-spec.md`. This is what prevents a reviewer from raising findings against
scaffolding.
