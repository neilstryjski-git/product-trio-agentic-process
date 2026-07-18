PTAP (c) 2026 Neil Stryjski — MIT License — github.com/neilstryjski-git/product-trio-agentic-process
Deployment note: when deploying for an organization, add a grant clause here, e.g. "Deployed for internal use at [Organization]. Bedrock documents, tickets, and project artifacts produced with this agent belong to the project and [Organization]. The PTAP methodology remains licensed as above."

# PTAP Ticket Template — v0.2.0 [PROPOSED]

Status: PROPOSED — pending team ratification in backlog refinement. Field names and structure may be amended by the team; the invariant rules in the agent instructions (Bedrock references, verbatim acceptance criteria, HLD/LLD boundary) are not subject to this template's revisions.

## Mode flexibility

The template flexes by operating mode. Invariant in every mode: Type, Title, a Description with HLD/LLD separation intact, an Acceptance Criteria section that is never invented (real criteria, or an honest PENDING flag), and an LLD Notes section owned by the assigned developer. Everything else is mode-conditional:

- GREENFIELD: all fields as specified below. Bedrock References cite COMMITTED Pillars; acceptance criteria are verbatim Pillar III BDD; stories belong to epics.
- ADDITIVE: a Story or Task may stand alone with no parent Epic. Bedrock Reference cites an existing Pillar section or parent epic where one exists, otherwise reads "PENDING — additive, no committed Bedrock". Acceptance criteria are drawn from supplied material, or marked "BDD PENDING — flag for Trio". Omit empty structural fields (Linked Stories, Linked Tasks) rather than carrying blank headers.

PENDING flags are honest debt markers, not defects — but when they accumulate on a project, that is the signal to run a Greenfield session.

All tickets are output as paste-ready plain-text blocks, one block per ticket, labeled fields, no tables. Jira sub-tasks are never used; engineering work is a standalone Task linked to its Story, or a checklist inside the Story for small mechanical steps.

---

## EPIC

Type: Epic
Title: [Noun phrase — the capability, e.g., "Inception Rundown Ingestion"]
Bedrock Reference: [Pillar II, section X.X, vX.X.X]
Value Statement: [One sentence — for whom, and why it matters]
Description: [Strategic summary of the capability. HLD only — the what and the strategic how. No implementation detail.]
Definition of Done: [What is observably true when this epic closes]
Linked Stories: [Listed after decomposition]

---

## STORY

Type: Story
Title: [Verb phrase, e.g., "Pull finalized rundowns from Inception"]
Bedrock Reference: [Pillar II, section X.X, vX.X.X]
Description:
As a [role], I want [capability], so that [outcome].
[1–3 sentences of supporting context. HLD only.]
Acceptance Criteria:
[Greenfield: verbatim Given/When/Then scenarios from Pillar III — never paraphrased, never summarized. Additive: criteria drawn from supplied material. In either mode, if no real criteria exist, write "BDD PENDING — flag for Trio" rather than inventing them.]
Linked Tasks: [Task issues supporting this story, if any]
LLD Notes:
[Left empty at creation. Owned by the assigned developer: implementation approach, library choices, component notes, C3 sketches or links.]

---

## TASK

Type: Task
Title: [Verb phrase — a discrete unit of engineering work]
Linked Story: [The story this task supports]
Bedrock Reference: [Inherited from the linked story unless more specific]
Objective: [One or two sentences — what this task accomplishes]
Done When: [Observable completion condition]
LLD Notes:
[Left empty at creation. Owned by the assigned developer.]

---

## SPIKE

Type: Spike
Title: [Question phrase or investigation target, e.g., "Confirm 'finalized' flag exists in Inception API"]
Bedrock Reference: [Pillar IV, Sprint 0 item S0-XX]
Objective: [The unknown being resolved and why it blocks or shapes downstream work]
Timebox: [Effort limit, e.g., "1 day"]
Output: Decision Brief — findings and a recommendation, presented for review before the decision is committed to Pillar II via MACD.

---

## Checklist alternative

For small mechanical steps that do not warrant a standalone Task (single developer, no independent tracking), use a checklist inside the Story body:

Checklist:
- [ ] [Step]
- [ ] [Step]

Prefer a linked Task when the work is independently assignable, independently blockable, or worth its own status on the board.
