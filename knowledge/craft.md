# Craft Standards

Organisational standard. Read by `senior-product-designer`, `design-reviewer` and
`staff-ui-engineer`. Concrete defaults so that "polished" is a checkable claim
rather than a matter of taste.

## Typography

Type carries more of the personality of an interface than colour does, and it is
where default-tooling character is most visible.

- Two faces, three at most: a display face used with restraint, a body/UI face,
  and optionally a mono or tabular face for data. One face for everything reads as
  unconsidered; four reads as undisciplined.
- Set a scale from a ratio and hold it. 1.2 for dense product UI, 1.25 for
  standard, 1.333 where the display face needs room. Emit the actual numbers into
  the design system; do not describe the scale in t-shirt sizes.
- Weights: no more than three in use. Distinguish hierarchy with weight and size
  before reaching for colour, and never with colour alone.
- Line height: 1.4–1.5 for body, 1.15–1.25 for headings, 1.3 for dense table
  cells. Tight headings and loose body is a signature of considered typesetting.
- Line length 45–75 characters for prose. Enforce it with `max-w-*`, not by hope.
- Letter spacing: negative for large display sizes, zero for body, slightly
  positive for small caps and uppercase labels. Uniform tracking across all sizes
  is a tell.
- Numbers in tables use tabular figures and right alignment. Currency aligns on
  the decimal.
- System font stacks are a legitimate choice for internal tooling, but only as a
  stated decision, never as a default nobody made.

## Spacing and density

- One scale, geometric, based on 4px. Every spacing value in the product comes
  from it. A single `19px` proves the scale is decorative.
- Commit to a density target and record it: control height, table row height, and
  section rhythm. Enterprise data tools want 32–36px rows; consumer surfaces want
  44–48px. Mixed densities inside one screen read as unfinished.
- Space belongs to relationships, not to elements. Related items sit closer than
  unrelated ones, and that difference should be obvious at a squint. Uniform gaps
  everywhere destroy grouping and are the most common AI spacing pattern.
- Vertical rhythm: section spacing should be visibly larger than intra-section
  spacing — roughly double. Ambiguity here is what makes a page feel soupy.
- Generous padding is not the same as clarity. Whitespace that does not encode a
  relationship is just low information density.

## Colour

- Neutrals do the work. Most surfaces are neutral; colour appears where it carries
  meaning.
- One accent hue. Every additional hue must be earned by a semantic role: success,
  warning, danger, info. Decorative colour is the fastest way to look generated.
- Build a full neutral ramp (typically 11 steps) and use it deliberately: surface,
  raised surface, border, muted text, body text, strong text. Picking greys
  ad-hoc produces the muddy, slightly-off look that is hard to name but easy to see.
- Contrast: 4.5:1 body text, 3:1 large text and UI boundaries, as a floor rather
  than a target. Muted text at 3.2:1 is a failure regardless of how good it looks.
- Semantic colour must never be the only channel. Pair with icon, label or shape
  so the interface survives colour blindness and greyscale printing.
- Dark mode is designed, not inverted. Elevation in dark mode comes from surface
  lightness and borders, not from shadows, which mostly disappear.

## Elevation

Pick one dominant strategy per product and hold it: borders, or shadows. Dense
professional tooling almost always wants hairline borders. Consumer surfaces can
carry soft shadows. Using both everywhere is why interfaces look busy.

Shadows, if used: two or three tokens maximum, all sharing a light direction and
tinted with the surface hue rather than pure black.

## Motion

Motion explains change. It has three legitimate jobs: showing where something came
from, holding continuity between states, and confirming an action landed.

- Durations: 120–160ms for state changes, 200–260ms for entrances and layout
  shifts, up to 400ms only for large surfaces. Anything slower feels sluggish;
  anything uniformly 300ms feels defaulted.
- Easing: decelerate on entrance, accelerate on exit, standard ease for state
  change. Never linear except for continuous indicators.
- Animate `transform` and `opacity`. Animating layout properties causes jank.
- Motion must be interruptible. An animation that queues behind another feels broken.
- `prefers-reduced-motion` collapses duration to zero and preserves the end state.
  Never remove the state change itself.
- Scattered micro-animations add up to noise. One well-orchestrated moment beats
  ten independent effects.

## Interaction states

Every interactive element implements: default, hover, focus-visible, active,
disabled, and where applicable loading, selected and error. A missing hover state
is minor; a missing focus-visible state is a Critical accessibility finding.

Focus rings are designed. A 2px offset ring in the accent hue, consistent across
every control, is the mark of a real design system. The browser default ring, or
its removal, are both tells.

## States that carry the product

These are where professional software distinguishes itself, and where generated
UI is thinnest. Every screen needs all four designed, not defaulted:

- **Empty** — explains what the screen is for and offers the action that fills it.
  Never a bare centred illustration.
- **Loading** — skeletons matching the eventual layout, so nothing shifts. Spinners
  only for actions under a second where layout is unknown.
- **Error** — states what happened, in the interface's voice, and the recovery
  action. Never blames the user, never says "something went wrong".
- **Partial / too much** — long names, missing fields, 100k rows, one row. Design
  for these explicitly; they are the normal case in production.

## Tables

Professional tools live in tables. A table replaced by cards is almost always a
downgrade in scannability.

Required: sortable headers with visible state, alignment by data type, sticky
header, keyboard row navigation, selection with a bulk action bar, a designed
empty state, skeleton loading, and column content that truncates predictably with
the full value available. Virtualise past a few hundred rows.

## Copy

Words are design material. Active voice, sentence case, no filler. Label controls
with what happens: "Save changes", not "Submit". An action keeps its name through
the whole flow — a "Publish" button produces a "Published" confirmation. Name
things as the user recognises them, never as the system is built.
