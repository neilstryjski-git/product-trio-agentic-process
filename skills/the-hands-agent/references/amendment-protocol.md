# Pillar V Amendment Protocol

Triggered when a technical necessity requires deviation from the HLD and the PM approves formalising it.

## When to suggest an Amendment

The TPM (see [`personas.md`](personas.md)) recommends the Amendment Protocol when:

- A library, API, or platform constraint makes the Pillar II spec unimplementable.
- A superior implementation path changes the architecture.
- A Sprint 0 gap touches the Charter or Problem Statement.

The Senior PM decides whether to invoke it. **The threshold is whether the change is fundamental enough to affect the project's strategic foundation — not complexity alone.**

## Amendment initiation

```
Speaking as TPM:
🛑 Amendment Recommended
Trigger: [Description of the blocker or superior path]
Affected Pillar: [Pillar X, Section Y]
Impact: [What changes and why]

Speaking as Tech Lead: [Technical rationale]
Speaking as QA Engineer: [Acceptance and testing implications]
```

Senior PM approves before the file is created.

## The Pillar V file

Filename: `pillar_v_amendment_[feature]_[YYYY-MM-DD].md`

```
# Pillar V: The Hands Amendment
Project: [Name] | Date: YYYY-MM-DD | Status: [PROPOSED / APPROVED / REJECTED]

## The Pivot
[What is changing from the original HLD]

## The Reason
[Why the original path is no longer viable or optimal]

## Impact on Existing Pillars
| Pillar | Section | Impact |
|---|---|---|

## Tech Lead Assessment
## QA Engineer Assessment
## Senior PM Decision
Status: [APPROVED / REJECTED] | Date: YYYY-MM-DD
Notes: [Conditions or constraints]
```

## Amendment Handback Summary

Generated automatically upon PM approval. Carried by the Senior PM into Strategic Re-engagement with The Brain.

```
Amendment Handback Summary — [Date]
Amendment File: pillar_v_amendment_[feature]_[YYYY-MM-DD].md
Trigger: [One-line summary]
Pillars Affected: [List]
QA Impact: [BDD scenarios affected / new scenarios required]
Implementation Status: [What is complete / paused]
Recommended Brain Action: Strategic Re-engagement — Trio review of Pillar V
Files for Brain review: log_of_changes.md, pillar_v_amendment_[feature]_[date].md
```

Pillars I–III remain static — substantive Pillars are **never edited by the Hands**, even under an approved amendment. Their change is ratified by The Brain in Strategic Re-engagement and committed out-of-band. The amendment's only on-disk footprint at the Hands' stage is (a) the uncommitted `pillar_v_amendment_*.md` override file, and (b) a single PROPOSED row appended to the **Pillar IV Ledger** — the one committed-Pillar edit the ceremony may make. Pillar V is the active override until The Brain enshrines the change. The Bedrock-enforcement hook makes this a hard guarantee: a marker can only authorize the Ledger; a substantive-Pillar edit is denied even with a valid marker.

## The `/amendment` command (and the Bedrock unlock)

The plugin contributes the `/amendment` slash command (built in W6). Running `/amendment`:

1. Runs the MACD ceremony (Trigger / Reason / Impact captured per the format above).
2. After Senior PM approval, writes a short-lived single-use unlock marker — **targeting the Pillar IV Ledger only** — that the Bedrock-enforcement hook (see [`macd-protocol.md`](macd-protocol.md)) checks and consumes, permitting the one sanctioned edit: a PROPOSED amendment row in the Ledger. The hook denies any Hands edit to a substantive Pillar (I/II/III) even with a marker.
3. Generates the Handback Summary for Strategic Re-engagement with The Brain.

The legacy `/amend` command from earlier framework versions is renamed `/amendment`. `/logstate` (status report of Sprint 0 progress / open gaps / active amendments) is deferred — track via the `log_of_changes.md` conventions in [`personas.md`](personas.md) until built.
