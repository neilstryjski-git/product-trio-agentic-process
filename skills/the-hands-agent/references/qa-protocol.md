# QA Protocol — `qa_log.md` (QA Engineer owned)

Internal to The Hands. Not a Brain deliverable unless an audit is requested.

**Code review note.** When Stride is present (the Product Trio default per Option A — see [`stride-integration.md`](stride-integration.md)), code review against the task's acceptance criteria is handled by `stride:task-reviewer`. This QA protocol covers Pillar III BDD validation and implementation-specific test gates — *not* low-level diff review. The QA Engineer does not run a parallel review.

## Header

```
# QA Log: [Project Name]
Created: YYYY-MM-DD | Last Updated: YYYY-MM-DD
QA Mode: [Stride Active | Stride Unavailable]
```

## When Stride is Active — Lean Mode

BDD scenarios from Pillar III live on the Stride ticket as acceptance criteria. The QA Engineer populates tickets before implementation begins. `qa_log.md` captures only what Stride does not:

```
## [YYYY-MM-DD] — [Flag Type: Pre-Stride Defect / Three Amigos Flag / Pillar III Delta]
Feature: [Name]
Description: [Detail]
Status: [Open / Resolved / Escalated]
```

## When Stride is Unavailable — Full Mode

`qa_log.md` becomes the complete acceptance record:

```
## [YYYY-MM-DD] — QA Gate: [Feature Name]
BDD Scenarios:
  Given [...] When [...] Then [...] → [PASS / FAIL]
Additional Tests: [Any implementation-specific tests not in Pillar III]
Defects:
  - [Severity: High / Med / Low] [Description] [Status]
Sign-Off: [Approved / Blocked]
```

## When to trigger QA Gate (Mode 3)

The QA Gate (see [`personas.md`](personas.md)) is invoked when:

- A feature or task is complete and ready for validation against Pillar III.
- The Tech Lead has finished implementation and `log_of_changes.md` is up to date.
- (Stride active) `stride:task-reviewer` has approved the diff — QA Gate validates the Pillar III BDD scenarios on top of code-level approval.

QA Gate produces a sign-off line in `qa_log.md`. A blocked sign-off returns the task to implementation with defect notes.

## Build Verification Gate (deployable / buildable surfaces)

**"Done" requires a *verified build*, not merely green types or passing unit tests.** Before any task that touches a buildable or deployable surface is signed off, The Hands must:

1. **Run the project's *real* build** — the exact command the deploy pipeline runs, not just `tsc` or the unit suite — and confirm it exits clean.
2. **Verify the *produced artifact*** — that the expected output exists, is non-empty, and the surface actually loads/serves (e.g. the SPA bundle is present and the route returns `200`), not merely that the pipeline *reported* success.

Why this is a hard gate, not a nicety: a passing type-check or unit suite is **necessary but not sufficient**. Transpile-only bundlers (Vite/esbuild, SWC) emit a working-looking bundle *without* type-checking, so a separate type gate can fail while the app still "builds"; and deploy pipelines can report **success on a partial or empty artifact** (a broken sub-build whose failure is masked while static assets still copy). Either path ships a green-looking deploy that is actually down.

For any surface with an **automated deploy** (push-to-deploy), a **pre-merge CI build gate is mandatory**: run the full build — *including* the type-check — on every PR and block merge on failure. A breaking change must be caught before it can reach the deploy branch; never let the deploy itself be the first place the build runs.

*Origin:* a single missing import passed locally at runtime, failed `tsc`, and shipped an **empty production bundle as a "successful" deploy** — a total outage. The deployable artifact was never built/verified before merge, and the pipeline reported success on the empty output.
