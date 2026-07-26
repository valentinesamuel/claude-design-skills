# Visual Review Checklist

Work through these against the rendered prototype. Every finding needs a location
and a required fix. Skip nothing, but do not manufacture findings — a review that
reports problems in every category is as uninformative as one that reports none.

## Art direction conformance

The direction is a list of commitments. Check each literally:

- Are the specified typefaces in use, at the specified weights?
- Do the type sizes match the emitted scale, or has drift crept in?
- Does density match the stated control and row heights, on every screen?
- Is the palette the specified accent plus neutrals, with no unearned hues?
- Does the radius scale match, and is its character consistent?
- Is the committed elevation strategy used, rather than borders and shadows both?
- Does the signature element exist and carry the weight it was meant to?
- Are any of the explicit rejections present anyway?

Reversion to a default on a committed axis is a Major finding. Reversion across
several axes is Critical — it means the direction was decorative.

## Hierarchy

Where does the eye go first, second, third? Is that the order the user's task
needs? Is the primary action unmistakable within a second? Are destructive actions
present but subordinate? If everything has equal weight, the layout never decided
what matters.

## Typography

Scale adherence. Weight count in actual use — more than three signals drift. Line
height by role. Line length for prose. Tracking at large sizes. Tabular figures and
decimal alignment in numeric columns. Heading rhythm consistent across screens.
Hierarchy legible in greyscale.

## Spacing and density

Every value from the scale — hunt for the one-off. Related items closer than
unrelated ones, obvious at a squint. Section gaps clearly larger than intra-section
gaps. Density consistent across every screen. Padding that varies with content
rather than being uniform by habit.

## Alignment

Shared baselines and edges. Icons optically centred against their labels rather
than mathematically centred. Table columns aligned by data type. Form labels and
controls on a consistent axis. Almost-aligned is worse than deliberately offset.

## Colour

Accent reserved for action, status and focus. Semantic colour paired with a second
channel. Neutral ramp used by role rather than picked ad hoc. Contrast measured,
not eyeballed: 4.5:1 body, 3:1 large text and UI boundaries. Muted text checked
specifically — it is the most common failure. Greyscale test: does the interface
still work?

## Components

Does each component earn its existence? Are records in a table rather than cards?
Any component invented where a system one would serve? Any system component used
outside its purpose? Do variants come from the system rather than one-off styling?
Does every interactive element have hover, focus-visible, active and disabled?

## Tables

Header state visible when sorted. Alignment by type. Sticky header. Predictable
truncation with the full value retrievable. Selection and bulk action treatment.
Row height matching the density target. Behaviour at one row and at hundreds.

## State coverage

Empty state explains the screen's purpose and offers the filling action. Loading
uses skeletons matching final layout, with no shift on load. Error states name what
happened and the recovery, in the interface's voice, without blame. Partial state
handles long strings, missing fields, extreme values.

Judge these at full standard. A defaulted empty state after a polished happy path
is the clearest evidence of unfinished work.

## Responsiveness

360px, tablet, laptop, wide. Does the layout adapt or merely shrink? Do tables
become usable rather than horizontally scrolling by accident? Do touch targets
reach 44px where touch is supported? Does anything overflow, clip or collapse?

## Accessibility in your remit

Contrast ratios measured. Focus-visible present, designed, and consistent on every
interactive element — its absence is Critical. Target sizes. Colour never the sole
carrier of meaning. Text still legible at 200% zoom.

## Data authenticity

Realistic names, companies, amounts, dates, IDs, consistent with each other and
with the domain. Domain vocabulary used correctly. Awkward cases present. No Lorem
ipsum, no John Doe, no invented metrics, no chart that only goes up.

## Generated-look tells

Run the tells list in
`.claude/skills/senior-product-designer/references/anti-ai-playbook.md`. Report matches as
findings with locations rather than as a general impression — "this feels
AI-generated" is not actionable, and the producer cannot iterate on it.

## Professionalism

Would an experienced designer believe a team made this? Would it embarrass the
company in front of a customer? Is every visible choice defensible?
