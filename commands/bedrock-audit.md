---
description: Audit the Bedrock — report every Pillar file in productdocuments/ as [COMMITTED] or [UNDER AUDIT], flag drift (uncommitted working-tree changes to a ratified Pillar), and report the state of any Bedrock unlock marker. A read-only report; it never edits a Pillar.
---

# /bedrock-audit — Pillar State & Drift Report

You are running the Product Trio `/bedrock-audit` command. It reports the integrity of the Bedrock: which Pillars are ratified (`[COMMITTED]`), which are in flight (`[UNDER AUDIT]`), and whether any committed Pillar has **drifted** (uncommitted working-tree changes). This is a **read-only audit** — it never edits, stages, or reverts a Pillar.

The state model comes from [`macd-protocol.md`](../skills/the-hands-agent/references/macd-protocol.md): *"The Pillars are either `[COMMITTED]` or `[UNDER AUDIT]`. There is no in-between."* The committed-to-git test below is the **same proxy** the Bedrock-enforcement hook (`hooks/bedrock-guard.sh`, built in W6) uses to decide what is immutable — so this report tells you exactly what that hook will and won't let through.

## Step 1 — Locate the Bedrock

Find `productdocuments/` at the project root. If it is missing or has no `*.md` Pillars (ignoring `README.md`): report **"No Bedrock present — nothing to audit"** and stop. This is the expected, non-error result on a project that has not yet received its Pillars; degrade sensibly, do not treat it as a failure.

## Step 2 — Classify every Pillar file

For each `*.md` under `productdocuments/` (skip `README.md`), determine its git state using the project-relative path (matching the hook's worktree view):

- **`[COMMITTED]`** — tracked in git **and** clean. The file is ratified and the Bedrock hook treats it as immutable. Test:
  ```bash
  git ls-files --error-unmatch -- "productdocuments/<file>"   # exit 0 ⇒ tracked
  ```
- **`[UNDER AUDIT]`** — **untracked** (a new Pillar being authored, or a `pillar_v_amendment_*.md` not yet committed). The hook lets these through without a marker — they are legitimately in flight.
- **DRIFT** — tracked **but** modified in the working tree (or staged-but-uncommitted). Detect via:
  ```bash
  git status --porcelain -- "productdocuments/<file>"
  ```
  A non-empty porcelain line on a tracked file is drift: a ratified Pillar has changed on disk without a new commit. That is only legitimate **mid-`/amendment`**, with an active unlock marker authorizing exactly that file.

## Step 3 — Report the unlock marker

Check `<project>/.product-trio/.bedrock-unlock`:

- **Absent** — normal steady state. Any drift in Step 2 is therefore **unsanctioned**.
- **Present** — read it and report `path`, `approved_by`, and whether `expires_at` is in the future or **expired**. An expired or wrong-target marker authorizes nothing (the hook discards it on the next edit).

## Step 4 — Emit the report

Print one line per Pillar, then a marker line, then a verdict. Example:

```
Bedrock Audit — <YYYY-MM-DD HH:MM>
productdocuments/ — 4 Pillars

[COMMITTED]    Pillar I: The Charter (v1.0.0).md
[COMMITTED]    Pillar II: The Specs (v1.0.0).md
[COMMITTED]    Pillar III: The Quality Gate (v1.0.0).md
[UNDER AUDIT]  pillar_v_amendment_multi-membership_2026-05-28.md   (untracked — authoring)
⚠️ DRIFT       Pillar IV: The Ledger (v1.0.0).md                   (tracked, uncommitted changes)

Unlock marker: none active.

Verdict: 1 drift finding with NO active unlock marker — unsanctioned edit to a committed Pillar.
Recommend: revert the working-tree change, OR run /amendment to ratify it through MACD before committing.
```

Verdict rules:
- **Clean** — every Pillar `[COMMITTED]` or `[UNDER AUDIT]`, no drift → report "Bedrock intact."
- **Sanctioned drift** — drift exists **and** an unexpired marker targets exactly that file → report it as an amendment-in-progress, not a violation.
- **Unsanctioned drift** — drift with no marker (or an expired/wrong-target marker) → flag it and recommend `/amendment` (or reverting the edit). Do **not** edit or revert anything yourself; the audit only reports.

## When Stride is present vs absent

This audit is a local git + filesystem report and runs the same either way. Where it differs is the **follow-up**:

- **Stride Active** — an unsanctioned-drift finding can be carried into a Pillar V Amendment (`/amendment`) and, if it cascades into work, decomposed onto the board via `stride:task-decomposer` (see [`stride-integration.md`](../skills/the-hands-agent/references/stride-integration.md)).
- **Stride Unavailable** — record the finding in `log_of_changes.md` / `qa_log.md` and carry it into the Amendment ceremony manually.

Either way, the audit itself neither requires Stride nor edits a Pillar.
