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
