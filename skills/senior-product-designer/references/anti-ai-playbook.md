# Anti-Generated-Look Playbook

Read during stage 1 self-critique, before handoff. Also used by `design-reviewer`.

Prohibitions come second here. The positive commitments are what actually work,
because you cannot avoid your way into good design.

## Positive commitments

**Commit to a density and hold it.** Pick row height and control height, then use
them everywhere. Mixed density inside one screen is the most reliable tell that no
single person designed it.

**Make space encode relationships.** Related things closer, unrelated things
farther, section gaps roughly double intra-section gaps. Uniform gaps everywhere is
the signature spacing pattern of generated UI, and it destroys grouping.

**Earn every hue.** One accent. Additional hues only for semantic roles. If a
colour is present for interest, remove it.

**Use a real type scale with a real ratio,** and distinguish hierarchy with weight
and size before colour. Uniform tracking across every size is a tell.

**Prefer the information-dense form.** Records go in tables, not cards. Cards exist
when grouping genuinely aids comprehension, not as a default container.

**Design the four hard states** — empty, loading, error, partial — as carefully as
the happy path. This is where generated work is thinnest and where reviewers look
first.

**Let asymmetry happen.** Real layouts have a dominant region and subordinate ones.
Equal-weight grids of equal-size boxes are a layout that avoided deciding what
matters.

**Write real copy.** Specific, active, in the interface's voice. Generic microcopy
makes a good design feel templated.

**Use realistic data with realistic distribution** — plausible names, some very
long, some nulls, some rows that stress the layout. Tidy uniform sample data hides
every bug the design has to survive.

## Tells to check for

Structural:

- Uniform padding on every container regardless of content
- Everything centred, including things with no reason to be
- A 4-across row of stat tiles above a chart
- Equal visual weight across all regions
- Cards nested inside cards
- Generic hero band on an internal tool
- Low information density presented as breathing room

Visual:

- Untouched shadcn/ui tokens: default radius, default ring, default neutral ramp
- Gradients on primary actions
- Glassmorphism, unless the product genuinely sits over content
- Shadows on everything, or shadows plus borders everywhere
- `rounded-2xl` on every surface
- Oversized icons; icons from more than one set or weight
- Pastel semantic colours that fail contrast
- Decorative illustrations with no informational role
- Emoji as interface iconography

Content:

- Lorem ipsum, John Doe, Acme Corp, example.com
- Fabricated metrics that would not exist in this product
- Charts with smooth invented upward trends
- Percentage deltas on every tile
- Trailing exclamation marks in empty states

Interaction:

- Missing focus-visible states, or removed browser defaults with no replacement
- Hover-only affordances
- Every transition at 300ms ease
- Animation on elements that do not change meaning
- Confirmation dialogs on reversible actions and none on destructive ones

## The honest test

Ask what you would have produced for a generic brief in this category. Compare it
to what you actually built. If the answer is "roughly this", the direction was
never committed to, and no amount of removing gradients will fix it.

Then: would this survive review at Linear or Stripe — not because it is beautiful,
but because every choice in it is defensible?
