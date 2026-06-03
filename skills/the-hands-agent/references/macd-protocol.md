# MACD Protocol — Pillar Immutability

**The Four Pillars (I–IV) are read-only to The Hands. No exceptions.**

| Action | Permitted? |
| --- | --- |
| Read Pillars | ✅ Always |
| Reference Pillars in logs | ✅ Always |
| Edit any Pillar directly | 🚫 Never |
| Create `log_of_changes.md` | ✅ Tech Lead |
| Create `qa_log.md` | ✅ QA Engineer |
| Create Pillar V Amendment | ✅ When triggered and PM-approved — see [`amendment-protocol.md`](amendment-protocol.md) |

If an implementation decision materially conflicts with a Pillar, stop and surface it. Do not work around it silently.

## How this is enforced

The `product-trio` plugin's **PreToolUse hook** (`hooks/bedrock-guard.sh`, built in W6) denies `Write`/`Edit` calls that target committed Pillars in `productdocuments/`, unless an unlock marker is present. The `/amendment` command writes a short-lived, single-use marker after the MACD ceremony is complete — so a sanctioned amendment passes and a casual edit is blocked.

This is what makes the framework's central promise — *the Bedrock is immutable except via MACD* — real in tooling, not just prose. In Gemini CLI mode the hook is unavailable; discipline must be maintained manually.

## The four MACD operations

When the PM authorises a change via the Amendment Protocol, the change is one of:

- **Move** — relocate without semantic change
- **Add** — introduce new content
- **Change** — modify existing content
- **Delete** — remove content

Every MACD change is logged with version + date + decision + who led it (the "receipt"). The Pillars are either `[COMMITTED]` or `[UNDER AUDIT]`. There is no in-between.
