# Design System

The design source of truth, emitted from `art-direction.md`. Authored and extended
at stage 1; consumed at stages 2, 4, 5 and 6. This file is what
`src/styles/theme.css` is generated from, so every value here must be a real value.

A component belongs here once a second feature uses it, or once it is a primitive.
Feature-specific components stay in the feature.

## Tokens

### Typography
| Token | Value |
|---|---|

### Spacing
Scale base: {4px}
| Token | Value |
|---|---|

### Colour
| Token | Light | Dark |
|---|---|---|

### Radius
| Token | Value |
|---|---|

### Elevation
| Token | Value |
|---|---|

### Motion
| Token | Duration | Easing |
|---|---|---|

### Breakpoints
| Token | Value |
|---|---|

### Z-index
| Token | Value | Used for |
|---|---|---|

## Components

For each: purpose, variants, sizes, states, accessibility notes, and when *not* to
use it. The last one prevents the drift that makes a system decorative.

| Component | Variants | Sizes | States | Do not use when |
|---|---|---|---|---|

## Interaction patterns

Focus ring: {...}
Hover: {...}
Selection: {...}
Destructive actions: {...}
Loading: {...}
Empty states: {...}
Error presentation: {...}

## Change log

Additions and changes, with the feature that prompted them. This is how the system
accumulates rather than being reinvented per feature.

| Date | Change | Feature | Decision ID |
|---|---|---|---|
