---
description: Run the mandatory Sprint 0 foundational-context phase — read the in-scope set's Pillars, declare Stride status, run the Three Amigos session over the Brain-identified LLD unknowns and any gaps the Tech Lead/QA surface, decompose the Bedrock into Stride tasks (or a written list when Stride is absent), and hold at the Senior PM sign-off gate before any implementation begins.
---

# /sprint-0 — Foundational Context Phase

You are running the Product Trio `/sprint-0` command. Sprint 0 is **mandatory** and runs as a **Three Amigos session** (Mode 1 🟡 — see [`skills/the-hands-agent/references/personas.md`](../skills/the-hands-agent/references/personas.md)) with the Senior PM present. It ends only at an explicit PM sign-off. No implementation happens before that gate.

The canonical sequence lives in [`skills/the-hands-agent/references/sprint-0.md`](../skills/the-hands-agent/references/sprint-0.md). Read it if it is not loaded. Stride routing lives in [`stride-integration.md`](../skills/the-hands-agent/references/stride-integration.md); Pillar immutability in [`macd-protocol.md`](../skills/the-hands-agent/references/macd-protocol.md). This command drives that sequence — it does not restate the detail.

## Step 1 — Load the in-scope Pillar set

A Bedrock is **one or more four-Pillar sets**. The **primary (or only) set** sits flat at the root of `productdocuments/`; each **additional** set lives in a meaningfully-named subfolder (`productdocuments/<set>/`) — subfolders appear only when a project actually grows past one set (a project that may never have a second set keeps it flat). Identify the in-scope set — a named subfolder, or the **root/primary set by default** when none is named — and read **that set's four Pillars in full** (Pillar I Charter, II Specs, III Quality Gate, IV Ledger). Do **not** read other sets into scope (a set with an `ARCHIVED` Charter status is never read in).

If `productdocuments/` is missing, or the in-scope set has no Pillars: **stop** and notify the Senior PM. Do not proceed, do not create logs, do not invent a Bedrock. (See the same guard in `sprint-0.md` Step 1 and in `productdocuments/README.md`.)

## Step 2 — Declare Stride status

Check whether Stride is invokable (the `stride:*` skills/agents — `stride:stride-workflow`, `stride:task-decomposer`, etc.). Declare the mode in the `qa_log.md` header (see [`qa-protocol.md`](../skills/the-hands-agent/references/qa-protocol.md)):

```
QA Mode: [Stride Active | Stride Unavailable]
Initialized: YYYY-MM-DD
```

Stride Active is the Product Trio default (Option A). Stride Unavailable is a real, supported operating mode — see "Graceful fallback" in [`stride-integration.md`](../skills/the-hands-agent/references/stride-integration.md). Everything below has both paths.

## Step 3 — Run the Three Amigos session

Open Mode 1 with all three personas labelled (`Speaking as TPM:` / `Speaking as Tech Lead:` / `Speaking as QA Engineer:`). Work the Objectives from `sprint-0.md`:

1. Confirm the in-scope set's four Pillars were read.
2. Execute the Sprint 0 tasks assigned in **Pillar IV** — the PM-defined, Brain-identified LLD unknowns.
3. Proactively surface additional gaps the Tech Lead or QA Engineer find that the Brain could not anticipate.

For each gap, ambiguity, or inconsistency, raise the **HLD Gap Protocol** block from `sprint-0.md`:

```
⚠️ HLD Gap Identified
Persona: [TPM / Tech Lead / QA Engineer]
Location: [Pillar X, Section Y]
Gap: [Description]
Impact: [What cannot proceed without resolution]
Options: (a) [...]  (b) [...]  (c) Escalate to Brain
```

The Senior PM resolves, defers, or **skips** each gap — skipped gaps are logged in `log_of_changes.md` with the PM's rationale (Skipped HLD Gaps format in `personas.md`). If a gap touches the Charter or Problem Statement, the TPM flags it as an **Amendment candidate** and offers `/amendment` — the AI suggests, it does not block. The PM decides.

## Step 4 — Decompose the Bedrock into work

Turn the resolved Pillar items into enriched, executable work. The TPM owns the decomposition.

**Stride Active:** decompose via `stride:stride-workflow` → `stride:task-decomposer`, and enrich each task with `stride:task-enricher` so every task carries `key_files`, `acceptance_criteria`, `verification_steps`, and `pitfalls` drawn from the Bedrock. Record Sprint 0 resolutions in `log_of_changes.md` with the **Stride Active** format (Stride Ticket + one-line resolution).

**Stride Unavailable:** produce the same enrichment shape as a written task list in `log_of_changes.md` (or a project-local TODO), so a later `stride` install lifts it onto a board with minimal translation. Record resolutions with the **Stride Unavailable** format (Decision + Personas Present + PM Sign-Off).

Do **not** carry Stride task IDs back into the Bedrock files — `productdocuments/` references intent, not task numbers (forbidden pattern in `stride-integration.md`).

## Step 5 — Senior PM sign-off gate

Sprint 0 does **not** close on the agent's judgment. Prompt the Senior PM:

> Senior PM — Sprint 0 review complete. Pillars read, Sprint 0 LLD unknowns worked, gaps resolved/deferred/skipped, and work decomposed. Reply **"Sprint 0 complete"** to authorize the transition to Solo Execution Mode, or raise remaining items.

Only on the explicit confirmation **"Sprint 0 complete"** does The Hands enter Solo Execution Mode (Mode 2 🟢). Until then, remain in the Three Amigos session — no implementation.

## Forbidden shortcuts

- **Never** proceed past Step 1 with a missing or empty `productdocuments/`.
- **Never** edit a Pillar to "resolve" a gap inline — gaps that touch the Bedrock go through `/amendment`, never a direct edit (the Bedrock hook will block it anyway).
- **Never** declare Sprint 0 complete on your own. The sign-off is the Senior PM's, verbatim.
- **Never** run a parallel persona code review when Stride is present — review is `stride:task-reviewer`'s job (see `stride-integration.md`).
