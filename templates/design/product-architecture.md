# Product Architecture

Project-level and structural, the counterpart to `art-direction.md`. Authored by
`senior-product-designer` during the first feature, then extended and conformed to.

## Why this exists

The pipeline gates one feature at a time. Every feature can pass all four gates and
the product can still be incoherent, because no gate looks across features.

That incoherence is what makes software feel assembled rather than designed: three
words for the same object, four navigation patterns, a URL scheme that changes shape
per section. Visual consistency cannot rescue structural inconsistency — it makes it
more conspicuous.

Every feature checks itself against this document. Changing it is a decision, not
an edit.

## Navigation model

{The single navigation pattern: sidebar, top nav, command-driven, or a stated
combination. What lives at the top level and why. Where secondary navigation
appears. What is reachable in one action from anywhere.}

Rule for adding a top-level destination: {state it, so the fifth feature cannot
quietly add a sixth nav item.}

## Information architecture

{The object model as the user understands it — the real entities, their
relationships, and which are containers. This is what the URL structure and
navigation both derive from, so it comes first.}

| Object | Contains | Reached from | Primary view |
|---|---|---|---|

## URL structure

{Patterns, not an exhaustive list. Collection, detail, nested detail, modal-over-
context, filtered state. `frontend-architect` conforms routes to these at stage 4.}

| Pattern | Shape | Example |
|---|---|---|
| Collection | | |
| Detail | | |
| Filtered collection | | |
| Nested resource | | |

State that belongs in the URL by default: {...}

## Terminology

The controlled vocabulary. One term per concept, used in every label, message, empty
state and error, across every feature. Include the rejected synonyms explicitly —
that is what makes this checkable rather than aspirational.

| Use | Never | Means |
|---|---|---|

## Shared surfaces

{Surfaces every feature touches, and the rules for touching them: global search,
notifications, user menu, breadcrumbs, page header, toasts, command palette. Who
may add to them and under what conditions.}

## Cross-feature patterns

{Decided once, reused everywhere: how detail views open, how destructive actions
are confirmed, where bulk actions live, how filters persist, how errors surface,
how long-running work reports progress.}

| Pattern | Decision | Decision ID |
|---|---|---|

## Change log

| Date | Change | Feature | Decision ID |
|---|---|---|---|
