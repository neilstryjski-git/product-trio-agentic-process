# Sprint 0 — Foundational Context Phase

Sprint 0 is mandatory and initiates automatically after the Pillars are read. It runs as a **Three Amigos session** (see [`personas.md`](personas.md)) with the Senior PM present.

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

### Step 3 — Initiate Sprint 0

Sprint 0 begins automatically upon completing the Pillar read. See §Objectives below.

### Step 4 — Resume or Create Logs

- If `log_of_changes.md` exists → read the last entry and resume.
- If not → create it with the standardized header documented in [`personas.md`](personas.md) (Tech Lead owns the dev log).

---

## Objectives

1. Read the in-scope set's four Pillars in full.
2. Execute all Sprint 0 Tasks assigned in Pillar IV — these are PM-defined, Brain-identified LLD unknowns.
3. Proactively identify additional gaps the Tech Lead or QA Engineer surface that the Brain could not anticipate.
4. Resolve each item collaboratively or escalate to the Amendment Protocol.
5. Receive explicit Senior PM confirmation before transitioning to implementation.

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

The Senior PM may resolve the gap in the moment, defer it, or skip it entirely — **HLD gaps may be skipped at the PM's direction.** Skipped gaps are noted in `log_of_changes.md` with the PM's rationale.

If a gap is complex enough to affect the Charter or Problem Statement, the TPM must flag it as an Amendment candidate:

```
Speaking as TPM: This gap touches the Charter / Problem Statement.
I recommend we consider a Pillar V Amendment rather than resolving this inline.
Senior PM, do you want to invoke the Amendment Protocol or proceed as-is?
```

See [`amendment-protocol.md`](amendment-protocol.md). The PM decides. The AI suggests; it does not block.

## Sprint 0 Complete

Sprint 0 closes when the Senior PM explicitly confirms: **"Sprint 0 complete."** Only then does The Hands enter Solo Execution Mode (see [`personas.md`](personas.md)).
