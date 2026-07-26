# API Contract

Produced by `frontend-architect` at stage 4. The document you hand to whoever builds
the backend, or write the backend against yourself.

## Why this exists

The frontend is built against fixtures. Without a written contract, the fixture
shapes *become* the contract implicitly, and the mismatch surfaces during
integration — the most expensive place to find it, because both sides are finished
and each believes it is correct.

Every endpoint here is either **live** or **planned**. Planned endpoints are served
by fixtures matching these shapes exactly. When a planned endpoint goes live, the
only change is the flag in `src/api/resources/`.

## Conventions

Base path: {...}
Auth: {mechanism, where the token lives, refresh behaviour, what a 401 does}
Content type: {...}
Timezone and date encoding: {ISO 8601 UTC, or state otherwise}
Currency encoding: {minor units as integers, or state otherwise — this is a
frequent and expensive mismatch}
Null vs absent: {state the rule. Ambiguity here produces defects nobody can
reproduce.}

## Error envelope

One shape for every failure, so the client has one error path.

```json
{ "error": { "code": "string", "message": "human readable", "field": "optional", "details": {} } }
```

| HTTP | Code | Client behaviour |
|---|---|---|
| 400 | | |
| 401 | | |
| 403 | | |
| 404 | | |
| 409 | | |
| 422 | | |
| 429 | | |
| 5xx | | |

## Pagination

Strategy: {cursor | offset}, and why.
Request: {...}
Response envelope: {...}
Page size default and maximum: {...}
Stability guarantee: {what happens when a record is inserted mid-pagination —
unstated, this produces duplicate or skipped rows that look like a frontend bug}

## Endpoints

For each:

```
### GET /customers            [live | planned]
Purpose:
Query params:      name, type, required?, default, validation
Response:          shape, referencing types.ts
Errors:            which of the above apply
Volume:            expected rows, worst case
Latency budget:
Caching:           TanStack Query key, staleness, invalidated by
Fixture:           path to the matching fixture
```

## Sorting and filtering

{Which fields are sortable and filterable server-side, the parameter syntax, and
what happens for an unsupported combination. Frontends routinely assume every
column is sortable; say plainly which are not.}

## Writes

{For each mutation: idempotency, what a conflict returns, what the response body
contains, which queries it invalidates, and whether optimistic update is safe.}

## Open questions for the backend

{Anything the user could not answer at stage 4. Each one is a risk with an owner,
not a gap to be filled in by assumption.}
