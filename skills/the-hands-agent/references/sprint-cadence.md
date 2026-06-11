# Sprint Cadence — One Sprint, One Goal, One Session

The Bedrock defines the high-level vision. Sprint 0 defines the solution — the implementation details that are knowable up front — **and the sprints that deliver it.** Sprint 0 is not the decomposition of the entire Bedrock into one undifferentiated backlog; it is the planning ceremony that slices the Bedrock into sprints and fully decomposes only the first one.

**The core law: one sprint = one Stride goal = one session.**

A coding agent's scarce resource is not calendar time — it is the context window. Sizing a sprint to a session makes the sprint boundary a *context* boundary: every session opens fresh, loads only its sprint's slice, and executes it at full quality. The cadence that calendar sprints give human teams, context-window sprints give The Hands.

**Sprint 0 is exempt from this law.** Despite the name, Sprint 0 is not a sprint in the cadence's sense — it is, by definition, *the answering of the LLD questions The Brain didn't decide or didn't know to decide* (the Pillar IV Sprint 0 tasks, and the gaps the Tech Lead and QA surface). It is **unsized**: it takes as long as those questions take, spanning multiple sessions with the Senior PM if needed. The one-sprint-one-session law governs the numbered sprints that follow it. And the deferred-unknown mechanism is not a sizing escape for Sprint 0 — assigning an unknown to a later sprint is a judgment that it *becomes answerable* there, never a way to cut Sprint 0 short on questions that are answerable now.

## What Sprint 0 produces

1. **Resolved LLD unknowns** — every Pillar IV Sprint 0 task and surfaced gap that is *answerable at setup time* is answered. Unknowns that are only answerable later are **assigned to the sprint where they become answerable** (see the third disposition in [`sprint-0.md`](sprint-0.md)'s HLD Gap Protocol) — deferred with a home, not skipped.
2. **The sprint plan** — the Bedrock sliced into an ordered sequence of sprints, each with a stated outcome, recorded in `sprint_plan.md` (below).
3. **All sprint goals, created up front** — when Stride is active, one Stride goal per sprint, all created during Sprint 0. The first sprint's goal is fully decomposed and enriched; every later goal stays **sparse**: title, outcome statement, its assigned deferred unknowns, and task stubs.
4. **Task stubs for later sprints** — what the Three Amigos already know a later sprint will contain is captured as stubs (title + one-line description) on that sprint's goal. Stubs are **captured knowledge, not commitments**: no enrichment, no acceptance criteria. The goal's outcome statement is the contract; the boundary ceremony decides what the stubs become.

The Senior PM's "Sprint 0 complete" sign-off **ratifies the sprint plan**. That single ratification is what authorizes every subsequent sprint boundary to run autonomously — no per-sprint gate.

## Sizing rule

**A sprint is the smallest slice that ends in something the Senior PM can meaningfully UAT, and that one session can execute at full quality.** UAT-ability is the slicing rule; the session is the budget.

Calibration comes from experience, with an explicit escape hatch: if a boundary ceremony finds the sprint is bigger than a session can execute well — the moment its true size first becomes visible — the TPM **splits it** (e.g., Sprint 3 → 3.1 / 3.2), updates `sprint_plan.md`, and creates the additional goal. Splitting at the boundary is normal operation, not failure.

## `sprint_plan.md` — the Sprint Plan (TPM owned)

A working artifact alongside `log_of_changes.md` and `qa_log.md` — **never** part of the Bedrock. It carries execution structure (sprint slices, goal IDs, stubs); `productdocuments/` carries intent only (the forbidden pattern in [`stride-integration.md`](stride-integration.md) applies). The TPM may amend it freely as discoveries reshape later sprints — it is execution planning, not strategy, so no Amendment is needed unless a change touches the Charter.

```
# Sprint Plan: [Project / Set Name]
Ratified: YYYY-MM-DD (Sprint 0 sign-off) | Last Updated: YYYY-MM-DD

## Sprint N — [Outcome statement]
Status: [PLANNED | IN PROGRESS | DONE | SPLIT → N.1 / N.2]
Stride Goal: [ID — or "written list" when Stride is unavailable]
UAT Target: [What the Senior PM validates when this sprint closes]
Deferred Unknowns: [LLD questions assigned to this sprint's boundary ceremony]
Task Stubs: [Provisional titles captured at Sprint 0 — knowledge, not commitments]

### Handoff (written at sprint close)
Resolved This Sprint: [Unknowns answered, decisions made]
New Discoveries: [What was learned that the plan didn't anticipate]
Implications for Next Sprint: [Stub changes, re-slicing, risks]
```

## The sprint lifecycle

### Open — the boundary ceremony

**A session is a sprint.** When The Hands initialize on a project whose Sprint 0 is complete, the session *is* the next sprint in `sprint_plan.md` — entering it is the default, not a command. (Sessions opened for something else — a defect, an amendment, a question — are managed exceptions: the Senior PM's opening direction overrides the default.)

The ceremony is a **light Three Amigos (Mode 1) that runs without the Senior PM** — its authority is the ratified sprint plan, not a fresh gate (see the Mode 1 note in [`personas.md`](personas.md)):

1. Read `sprint_plan.md`, the sprint's goal, its deferred unknowns and stubs — and the previous sprint's Handoff.
2. Incorporate **UAT findings** from the previous sprint (the PM's UAT happens between sessions; its findings land here).
3. Work the sprint's deferred unknowns. One that turns out to touch the Charter or Problem Statement escalates through the Amendment Protocol as usual — that is the only thing that stops a boundary ceremony.
4. Confirm, reshape, or delete the stubs; add tasks discovered since Sprint 0; **decompose and enrich now**, against the codebase as it exists today (Stride Active: `stride:task-decomposer` / `stride:task-enricher` onto this sprint's goal). Just-in-time enrichment is the point — tasks enriched sprints in advance reference a codebase that no longer exists.
5. Split the sprint if it exceeds the session budget (sizing rule above).
6. Mark the sprint IN PROGRESS and proceed straight into Solo Execution Mode.

**When refinement is heavy, it stands alone.** The session budget exists to protect *execution* quality. Normally the ceremony is a light prelude — Sprint 0 already did the heavy LLD, and the decompose/enrich work is dispatched to subagents that explore in their own context windows — so the sprint runs open-to-close in one session. But when a boundary turns out heavy (substantial UAT fallout, meaty deferred unknowns, a split), the ceremony **concludes as its own session**: decompose, enrich, write the Handoff-incorporated plan update, and end — the sprint's execution opens fresh next session against a ready board. The core law flexes to *one sprint = one execution session*; it never flexes toward skipping refinement.

### Close — the handoff

When the sprint's tasks are complete and the QA Gate has run:

1. Complete the Stride goal (or close out the written list).
2. **Write the Handoff** into the sprint's section of `sprint_plan.md` while context is hot: unknowns resolved, discoveries, implications for the next sprint. This is where the just-built knowledge gets banked — the next session starts cold and reads it.
3. Mark the sprint DONE and tell the Senior PM what the UAT Target is.

### Between sessions — UAT

The Senior PM UATs the sprint's increment between sessions. Findings — defects, redirections, re-slicing — are incorporated at the next boundary ceremony, *before* the next sprint is decomposed. This ordering is deliberate: decomposition always happens downstream of UAT, never ahead of it.

## Stride Unavailable

The cadence is unchanged; only the substrate differs. `sprint_plan.md` is the single source: each sprint's section carries its written task list in the standard enrichment shape (`key_files`, `acceptance_criteria`, `verification_steps`, `pitfalls`) — populated at that sprint's boundary ceremony, not at Sprint 0 — so a later Stride install lifts each sprint onto a board as one goal.

## Forbidden patterns

- **Never decompose the whole Bedrock into enriched tasks at Sprint 0.** Sprint 0 enriches the first sprint only. Full up-front decomposition is the failure mode this cadence exists to prevent — it floods the context window and produces stale enrichment.
- **Never gate a sprint boundary on Senior PM sign-off.** The plan was ratified once, at Sprint 0. The PM is pulled in only by a Charter-touching escalation or by their own UAT findings.
- **Never enrich the next sprint at the close of the current one.** Decomposition runs at the next sprint's open, downstream of the PM's UAT. The close writes the Handoff; the open does the enrichment.
- **Never carry sprint structure (goal IDs, stubs, task lists) into the Bedrock.** It lives in `sprint_plan.md`.
