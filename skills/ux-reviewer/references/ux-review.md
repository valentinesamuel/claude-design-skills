# UX Review Checklist

Judge the rendered prototype and the specified flows. Every finding needs a
location, a consequence for the user, and a required change.

## Task flow

What is the goal, where does the user start, and how many actions reach the end?
Which action could be removed, inferred, defaulted or deferred? Is the next step
obvious at every point without reading instructions? Where would a user abandon?
Does the flow assume knowledge the user does not have at that moment?

Count interaction cost honestly: clicks, keystrokes, context switches, scroll
distance, and screens traversed. Efficiency claims need numbers.

## Personas

Weight these by who actually uses the product.

- **First-time** — can they tell what the screen is for in five seconds? Do they
  know the next step? Is anything overwhelming?
- **Returning** — can they build muscle memory? Is anything positionally unstable?
- **Power** — keyboard shortcuts, bulk actions, no forced confirmations on routine
  work, no mouse dependency for repeated tasks.
- **Interrupted** — can they leave and return without losing state or place? Is
  work preserved? Is context recoverable from the URL?
- **Assistive technology** — is the task completable by keyboard alone, and with a
  screen reader? Is focus order logical? Are states announced?
- **Mobile** — reachable targets, thumb zones, forms completable, safe areas.

## Cognitive load

Too many simultaneous choices. Information the user must remember between screens.
Competing primary actions. Poor grouping forcing a visual search. Long forms that
could be staged or shortened. Labels that require internal system knowledge.

Recognition over recall, always. If the user must remember a value from a previous
screen, that is a design failure, not a user failure.

## Mental models

Does the terminology match the user's language rather than the system's? Do objects
behave consistently across screens? Do actions do what their names imply? Does the
structure match how users think about their work, or how the data happens to be
stored?

## Navigation

Can the user always tell where they are and how to get back? Is browser back
respected? Is state in the URL so a view can be shared or bookmarked? Is context
preserved through a drill-down and return — filters, scroll position, selection?
Losing filters on back navigation is a Critical finding in a data tool.

## Forms

For every field: why does it exist, can it be removed, inferred, defaulted or
auto-filled? Is validation timed helpfully — on blur rather than per keystroke, and
never only on submit? Does an error message say how to fix rather than what is
wrong? Can data be pasted? Is the whole form completable by keyboard? Is focus
moved to the first error? Is submission state unambiguous, and double submission
prevented?

## Error prevention and recovery

Prefer constraint over correction. Are dangerous actions distinguishable from
routine ones? Is destructive work undoable rather than confirmed — undo beats a
dialog almost always? Are confirmations reserved for the genuinely irreversible?
Are there dead ends where the only option is to start over? Is partial work
preserved on failure?

Confirmation fatigue is a real defect: dialogs on reversible actions train users to
dismiss the ones that matter.

## Feedback

Does every action produce a visible response within 100ms? Are long operations
given progress rather than an indeterminate spinner? Is background work visible?
Is saved state unambiguous — no hidden autosave the user cannot trust? Do success
messages use the same verb as the action?

## Discoverability

Are primary actions visible without exploration? Are advanced actions findable
without being in the way? Is anything important available only on hover, only via
right-click, or only via an unlabelled icon? Are shortcuts discoverable rather than
secret?

## Edge cases

No data, one item, thousands of items. Slow network, failed request, expired
session. Permission changes mid-task. Duplicate submission. Concurrent edit by
another user. Timeout. Very long strings. Missing optional data.

An interface reviewed only against the populated happy path has not been reviewed.

## Internationalisation

Long translations breaking layout. RTL. Date, time, number and currency formats.
Name and address shapes that assume one country. Sorting that assumes ASCII.

## Performance perception

Skeletons over spinners. Optimistic updates where safe. Prefetch on intent.
Immediate feedback on interaction regardless of backend latency. No layout shift as
data arrives. An interface can be fast and feel slow.

## Trust and emotion

Is language clear rather than alarming? Are permissions and data use explained
where requested? Are consequential actions clearly labelled? Would a user feel in
control, or watched, guessed-at, or scolded?

Users should feel confident, in control and successful — never confused, anxious,
or punished for a reasonable mistake.

## UX tells

A wizard where one page would do. Modals stacked on modals. Nested navigation
requiring memory of the path. Hidden save. Ambiguous button labels. Unexpected
navigation. Context lost on return. Tiny targets. Destructive action with no undo.
