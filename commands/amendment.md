---
description: Initiate the Pillar V Amendment Protocol — drive the MACD ceremony with the Hands personas, secure Senior PM approval, write a single-use unlock marker the Bedrock-enforcement hook consumes, author the pillar_v_amendment_*.md file, perform any sanctioned Pillar edit, and generate the Handback Summary for Strategic Re-engagement with The Brain.
---

# /amendment — Pillar V Amendment Protocol

You are running the Product Trio `/amendment` command. The Bedrock is immutable by default; this command is the **only** sanctioned path to a committed-Pillar edit. The Bedrock-enforcement PreToolUse hook (`hooks/bedrock-guard.sh`) will block any uncoordinated Write/Edit on a committed Pillar in `productdocuments/` until you complete this ceremony and write the unlock marker.

The Hands' canonical Amendment Protocol lives in [`skills/the-hands-agent/references/amendment-protocol.md`](../skills/the-hands-agent/references/amendment-protocol.md). Read it if you don't have it loaded. The MACD rules live in [`skills/the-hands-agent/references/macd-protocol.md`](../skills/the-hands-agent/references/macd-protocol.md). Persona Speaking-as labels live in [`skills/the-hands-agent/references/personas.md`](../skills/the-hands-agent/references/personas.md).

## Step 1 — Confirm the threshold

Before running the ceremony, confirm with the Senior PM that an Amendment is genuinely warranted. The threshold (from `amendment-protocol.md`): the change must be fundamental enough to affect the project's strategic foundation, not merely complex.

If the PM declines to invoke the Amendment Protocol, **stop**. Do not write any marker, do not author the Pillar V file, do not edit any Pillar. Log the decision in `log_of_changes.md` per the `Skipped HLD Gaps` format in [`personas.md`](../skills/the-hands-agent/references/personas.md) and return to Solo Execution Mode.

## Step 2 — Run the Three Amigos ceremony

Output the following block, replacing the brackets with the actual content. Use the Speaking-as labels exactly.

```
Speaking as TPM:
🛑 Amendment Recommended
Trigger: [Description of the blocker or the superior path being proposed]
Affected Pillar: [Pillar X, Section Y]
Impact: [What changes and why]

Speaking as Tech Lead: [Technical rationale — feasibility, debt, refactor surface]
Speaking as QA Engineer: [Acceptance and testing implications — BDD scenarios affected, new scenarios required]
```

Then prompt the Senior PM:

> Senior PM, do you approve the Amendment? Reply with `APPROVED` to proceed, `REJECTED` to halt, or ask follow-up questions.

If the PM replies `REJECTED` or asks follow-ups, stop and address them. Do not proceed to Step 3 until you have explicit `APPROVED`.

## Step 3 — Author the Pillar V file

The Pillar V file is a **new** file in `productdocuments/`. Because it is not yet committed to git, the Bedrock-enforcement hook will allow the Write without an unlock marker.

Filename: `productdocuments/pillar_v_amendment_[feature]_[YYYY-MM-DD].md` (slug the feature in kebab-case; date is today).

Use the structure documented in [`amendment-protocol.md`](../skills/the-hands-agent/references/amendment-protocol.md) under "The Pillar V file". Status is `PROPOSED` until the PM marks it `APPROVED`, and the PM Decision section reflects what just happened in Step 2.

## Step 4 — If a committed Pillar must also be edited, write the unlock marker

This step is **only** necessary if the Amendment requires modifying an already-committed Pillar file (e.g., editing `productdocuments/pillar-2.md` directly). If the Amendment is purely the new `pillar_v_amendment_*.md` (an override that leaves Pillars I–IV unchanged on disk), skip to Step 5.

### 4a. Ensure the marker directory is gitignored

The unlock marker is local-only state — it must never be committed. Before writing the marker, ensure the project has `.product-trio/.gitignore` containing `*`:

1. Check whether `<project>/.product-trio/.gitignore` exists.
2. If absent or does not contain `*`, create or update it to contain a single line: `*`.
3. (This means `.product-trio/` ignores all its own contents from git; the directory itself need not be tracked.)

Conventional alternative: instead of the per-directory `.product-trio/.gitignore`, the project may carry a single line `.product-trio/` in its **project-root `.gitignore`**. Either approach keeps the marker out of git; if the root `.gitignore` already ignores `.product-trio/`, the per-directory file is unnecessary.

### 4b. Write the unlock marker

Write `<project>/.product-trio/.bedrock-unlock` with the following JSON content. The marker is **single-use** (the guard deletes it on consume) and **short-lived** (expires 10 minutes from now). It authorizes editing a **specific** file — to edit a different Pillar, re-run `/amendment`.

```json
{
  "path": "productdocuments/<the-pillar-file-being-edited>.md",
  "expires_at": <unix-epoch-seconds-of-now-plus-600>,
  "amendment_file": "productdocuments/pillar_v_amendment_<feature>_<YYYY-MM-DD>.md",
  "approved_by": "Senior PM",
  "approved_at": "<ISO-8601 UTC>"
}
```

Compute `expires_at` as the current unix epoch seconds + 600. (e.g., `date -u +%s` then `+ 600`.) Use the project-relative path for `path`. Do not include absolute paths.

### 4c. Perform the sanctioned Pillar edit

Now Write/Edit the Pillar file. The Bedrock-enforcement hook will read the marker, confirm the path matches and the expiry is in the future, **consume the marker (delete it)**, and allow the edit. The marker is single-use — the next casual edit attempt will be blocked.

## Step 5 — Generate the Amendment Handback Summary

Output the Handback Summary block from [`amendment-protocol.md`](../skills/the-hands-agent/references/amendment-protocol.md):

```
Amendment Handback Summary — <YYYY-MM-DD>
Amendment File: productdocuments/pillar_v_amendment_<feature>_<YYYY-MM-DD>.md
Trigger: <one-line summary>
Pillars Affected: <list>
QA Impact: <BDD scenarios affected / new scenarios required>
Implementation Status: <what is complete / paused>
Recommended Brain Action: Strategic Re-engagement — Trio review of Pillar V
Files for Brain review: log_of_changes.md, productdocuments/pillar_v_amendment_<feature>_<YYYY-MM-DD>.md
```

## Step 6 — Log it in `log_of_changes.md`

Append an entry per the standard format in [`personas.md`](../skills/the-hands-agent/references/personas.md):

```
## [YYYY-MM-DD HH:MM] — Pillar V Amendment: <feature>
Action: Initiated and approved Amendment for <affected Pillar>
Files Modified: productdocuments/pillar_v_amendment_<feature>_<YYYY-MM-DD>.md[, productdocuments/<pillar-file>.md if edited]
Libraries Installed: None
Deviation from HLD: See pillar_v_amendment_<feature>_<YYYY-MM-DD>.md
Notes: Strategic Re-engagement with The Brain required to enshrine Pillar V into Pillars II–III.
```

## Forbidden shortcuts

- **Never** write the unlock marker without completing the Three Amigos ceremony and securing explicit Senior PM `APPROVED`. The marker is the receipt of a ratified MACD decision, not a bypass.
- **Never** extend the marker expiry beyond a few minutes "to be safe." Single-use + short-lived is the whole point.
- **Never** edit a Pillar with the marker pointing at a different file — write a new marker for the new target, or re-run `/amendment`.
- **Never** commit `.product-trio/` contents. The guard's authority depends on the marker being local-only state.

## When Stride is present

If Stride is active (see [`stride-integration.md`](../skills/the-hands-agent/references/stride-integration.md)), after Step 5 the Senior PM carries the Handback Summary into Strategic Re-engagement with The Brain. Any new tasks that the Amendment generates are decomposed into Stride goals/tasks via `stride:task-decomposer` and enriched by `stride:task-enricher`. The Amendment itself is recorded on the Stride board as a Pillar V event on the appropriate goal.

## When Stride is absent

If `QA Mode: Stride Unavailable`, the Handback Summary is preserved in `log_of_changes.md` and `qa_log.md`. The PM carries it into Strategic Re-engagement manually. Resume Solo Execution Mode only after Brain ratification.
