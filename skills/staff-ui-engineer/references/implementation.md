# Implementation Standards

Read at stage 5 step 4. These are the details that separate an implementation a
designer accepts from one they send back.

## Fidelity

The prototype is the contract. Where your output differs, your output is wrong
unless you declare the difference and justify it.

Match: every spacing value, type size, weight, line height and tracking, colour,
radius, border width, shadow, icon size, and transition duration and easing. Match
the layout at every specified breakpoint. Match the density target exactly — a row
height off by 4px reads as a different product.

Never eyeball a value that the token layer already declares.

## Tokens

Every value comes from the theme layer. If a needed value has no token, do not
inline it: add the token, note it in your report, and flag it for
`design-system.md`. An inline value is a token the next engineer will not find.

Banned in feature code: hex colours, arbitrary pixel spacing, `text-[13px]`,
one-off durations, magic z-index numbers.

## Component completeness

Every interactive component implements default, hover, focus-visible, active and
disabled, plus loading, selected and error where applicable. Focus-visible is not
optional and never removed without a designed replacement.

Every list or table implements the populated, empty, loading and error states, and
survives the stress case: very long strings, missing fields, one row, hundreds of rows.

Every form implements labels associated with controls, validation at the specified
timing, error messages that state the fix, focus moved to the first error on submit
failure, paste support, full keyboard completion, unambiguous submission state, and
double-submit prevention.

## Tables

Sortable headers with visible sort state. Alignment by data type, tabular figures
for numbers, decimal alignment for currency. Sticky header. Keyboard row
navigation. Selection with a bulk action bar. Predictable truncation with the full
value available. Virtualisation where the plan requires it. Row height from the
density token.

## Motion

Durations and easings from tokens, per the spec. Animate `transform` and `opacity`
only. Animations interruptible. `prefers-reduced-motion` collapses duration while
preserving the end state — never remove the state change itself.

If the spec does not specify motion for something, it does not animate.

## Accessibility

Semantic elements before ARIA; ARIA only where semantics cannot express the state.
One `h1` per screen with a sensible heading order. Every control has an accessible
name. Focus visible, managed on route change and dialog open, and returned to the
trigger on close. Async results announced via a live region. Keyboard reaches and
operates everything. Contrast preserved in both themes. Targets at least 44px where
touch is supported. Usable at 200% zoom.

## Code

Small focused files. One responsibility per component. Composition over
configuration. Props typed explicitly. No `any`. State at the narrowest scope that
serves it. Server state through `queries/` hooks only.

Avoid: components over ~200 lines, nested ternaries in JSX, repeated blocks that
should be a map or a component, wrapper divs with no purpose, `useEffect` where a
derived value or a query would do, memoisation without a measured reason,
abstractions with one caller.

Leave nothing behind: no dead code, no commented-out blocks, no console statements,
no unowned `TODO`.

## Self-review before reporting

- Does this match the prototype at every breakpoint, including 360px?
- Would the designer notice any difference?
- Does every interactive element have a visible focus state?
- Are all four states present on every list and every screen?
- Is there a single hardcoded value that should be a token?
- Does it hold up with the stress-case data rather than the tidy data?
- Is anything here something I would need to explain to the next engineer?

Any "no" is work remaining, not a note for the report.
