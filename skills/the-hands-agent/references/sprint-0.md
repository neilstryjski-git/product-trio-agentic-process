# Sprint 0 — Foundational Context Phase

Sprint 0 is mandatory and initiates automatically after the Pillars are read. It runs as a **Three Amigos session** (see [`personas.md`](personas.md)) with the Senior PM present.

Sprint 0 is, by definition, **the answering of the LLD questions The Brain didn't decide or didn't know to decide** — the Pillar IV Sprint 0 tasks (known unknowns) and the gaps the Tech Lead and QA surface (unknown unknowns). It answers what is answerable at setup time **and plans the sprints that deliver the rest** — it does not decompose the entire Bedrock into one backlog. The sprint model (one sprint = one Stride goal = one session, the sprint plan, boundary ceremonies) is defined in [`sprint-cadence.md`](sprint-cadence.md); **Sprint 0 itself is exempt from that sizing law** — it is unsized and runs as long as its questions take.

## Initialization Protocol

On every session start, before any action:

### Step 1 — Load the in-scope Pillar set

A Bedrock is **one or more four-Pillar sets**. Read only the set in scope for the work at hand.

```
# Single-set project (the default) — four Pillars, flat:
productdocuments/
├── Pillar I: The Charter
├── Pillar II: The Specs
├── Pillar III: The Quality Gate
└── Pillar IV: The Ledger

# Multi-set project — the primary (original) set stays flat at root; each
# ADDITIONAL set is a meaningfully-named subfolder (never version numbers),
# added only when the project grows past one set. Work declares a named set,
# or defaults to the root/primary set:
productdocuments/
├── Pillar I … IV         ← the primary/default set (read when none is named)
├── voc_mt_ia/            ← an additional named set (four Pillars)
└── rider_portal/         ← another named set
```

Read the **in-scope set's four Pillars in full**; do not pull other sets into context (a set whose Charter is marked `ARCHIVED` is never read in). If `productdocuments/` is missing, or the in-scope set's Pillars are absent: stop and notify the Senior PM. **Do not proceed.**

### Step 2 — Declare Stride Status

Check whether Stride is available. Log the declaration in the `qa_log.md` header (see [`qa-protocol.md`](qa-protocol.md)):

```
QA Mode: [Stride Active | Stride Unavailable]
Initialized: YYYY-MM-DD
```

When Stride is the governed execution layer (the Product Trio default per Option A — see [`stride-integration.md`](stride-integration.md)), the task lifecycle, code review (`stride:task-reviewer`), and Bedrock-to-task decomposition all route through it.

### Step 3 — Initiate Sprint 0, or enter the next sprint

- If Sprint 0 has **not** been completed for the in-scope set: Sprint 0 begins automatically upon completing the Pillar read. See §Objectives below.
- If Sprint 0 is complete and a `sprint_plan.md` exists: **the session is the next sprint.** Enter its boundary ceremony per [`sprint-cadence.md`](sprint-cadence.md) — unless the Senior PM's opening direction is something else (a defect, an amendment, a question), which is a managed exception.

### Step 4 — Resume or Create Logs

- If `log_of_changes.md` exists → read the last entry and resume.
- If not → create it with the standardized header documented in [`personas.md`](personas.md) (Tech Lead owns the dev log).
- If `sprint_plan.md` exists → read it, including the previous sprint's Handoff (TPM owns the sprint plan — see [`sprint-cadence.md`](sprint-cadence.md)).

---

## Objectives

1. Read the in-scope set's four Pillars in full.
2. Execute all Sprint 0 Tasks assigned in Pillar IV — these are PM-defined, Brain-identified LLD unknowns. Answer the ones that are answerable at setup time.
3. Proactively identify additional gaps the Tech Lead or QA Engineer surface that the Brain could not anticipate.
4. Resolve each item collaboratively, **assign it to the sprint where it becomes answerable** (recorded in `sprint_plan.md`), or escalate to the Amendment Protocol.
5. Define the sprint plan and decompose **the first sprint only** — one sprint = one Stride goal = one session; later goals are created sparse with their deferred unknowns and task stubs (see [`sprint-cadence.md`](sprint-cadence.md)).
6. Receive explicit Senior PM confirmation — which ratifies the sprint plan — before transitioning to implementation.

## HLD Gap Protocol

When any persona identifies a gap, ambiguity, or inconsistency during Sprint 0:

```
⚠️ HLD Gap Identified
Persona: [TPM / Tech Lead / QA Engineer]
Location: [Pillar X, Section Y]
Gap: [Description]
Impact: [What cannot proceed without resolution]
Options: (a) [Option A]  (b) [Option B]  (c) Escalate to Brain
```

The Senior PM may resolve the gap in the moment, **assign it to the sprint where it becomes answerable** (it becomes a Deferred Unknown on that sprint in `sprint_plan.md`, worked at that sprint's boundary ceremony), defer it, or skip it entirely — **HLD gaps may be skipped at the PM's direction.** Skipped gaps are noted in `log_of_changes.md` with the PM's rationale.

If a gap is complex enough to affect the Charter or Problem Statement, the TPM must flag it as an Amendment candidate:

```
Speaking as TPM: This gap touches the Charter / Problem Statement.
I recommend we consider a Pillar V Amendment rather than resolving this inline.
Senior PM, do you want to invoke the Amendment Protocol or proceed as-is?
```

See [`amendment-protocol.md`](amendment-protocol.md). The PM decides. The AI suggests; it does not block.

## Sprint 0 Complete

Sprint 0 closes when the Senior PM explicitly confirms: **"Sprint 0 complete."** Only then does The Hands enter Solo Execution Mode (see [`personas.md`](personas.md)).

That confirmation also **ratifies the sprint plan**: every subsequent session enters its sprint's boundary ceremony autonomously, with no per-sprint PM gate. The PM re-enters the loop only through UAT between sprints or a Charter-touching escalation (see [`sprint-cadence.md`](sprint-cadence.md)).
