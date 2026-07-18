# Product Trio Agent Framework

**By Neil Stryjski — [productdelivered.ca](https://productdelivered.ca)**

AI coding agents can ship production-ready code in minutes. The problem isn't speed — it's what happens when nothing anchors that speed to the original intent.

Long-context AI sessions suffer from **Semantic Noise** and **Middle Degradation**. The high-stakes strategic pivots made in the middle of a brainstorming session quietly disappear. The coding agent builds confidently — just not what you meant.

This framework solves that. It separates exploration from execution, anchors every build decision to an immutable source of truth, and ensures the handoff from Product thinking to working software carries zero strategic translation tax.

---

## The Philosophy

The PM's old boundary was defined by explaining the idea. The new boundary is defined by proving it.

**Push Left** means locking direction before anyone touches a keyboard — producing the spec, the architecture, and the acceptance criteria as structured artifacts that cut through semantic noise. One rigorous process. Two audiences served: stakeholders and coding agents.

**Push Right** means being close enough to the build to course-correct in real time. Not waiting for a sprint review to find out the interpretation was wrong. The handoff to a coding agent isn't a leap of faith — it's a blueprint with no ambiguity left in it.

AI moves fast. The Product discipline is what makes that speed count.

---

## Who This Is For

- **Solo builders** who want to move fast without losing the thread of what they actually intended to build
- **Fractional PMs and product leaders** embedding AI into an existing team's workflow
- **Early-stage teams** adopting AI velocity without a governance structure to match it
- **Developers** who are tired of building the wrong thing because the brief was ambiguous

If you've ever finished a sprint and realized the coding agent drifted from the original intent — this is the framework that prevents it.

---

## The Framework

### 🧠 The Brain — Product Trio Agent

Three AI personas simulate a core product team. They debate, challenge, and produce the Bedrock. They never touch code.

| Persona | Role |
|---|---|
| **AI TPM** | Strategic Orchestrator. Translates vision into workflow. Authorized to push back on the PM. |
| **AI Design (UX)** | Advocates for user friction, adoption risk, and branding logic |
| **AI Engineering** | Advocates for feasibility, architecture, and technical debt |

The **Senior PM (you)** holds ultimate authority. Every major proposal gets a proactive response from at least two personas — friction points, technical debt, UX risks — without being asked. The Trio is a strategic partner, not a passive recorder.

### 🤝 The Bedrock — Four Immutable Pillars

The Bedrock is the source of truth. It is never edited by a coding agent. Every build decision traces back here.

A Bedrock is **one or more four-Pillar sets.** A set describes a discrete, hand-offable body of work — a product area, a releasable version, or an engagement. The four-Pillar shape is the **atomic unit**: the **primary (or only) set** sits flat at the root of `productdocuments/`, and each **additional** set lives in a meaningfully-named subfolder. Subfolders appear **only when a project actually grows past one set** — multi-set is a growth path, not a precondition, so a project that may never have a second set simply keeps its four Pillars flat. The Hands read only the **in-scope set** (a named subfolder, or the root/primary set by default).

**Pillar I — The Charter (The North Star)**
Mission, Constraints, User Personas, Domain Glossary, Problem Statement. Includes a C1 System Context diagram (Mermaid) showing how the system interacts with users and external systems. Mandatory for any new feature.

**Pillar II — The Specs (The Brain)**
Unified Strategic PRD, Technical Spec (Architecture/Security), and UX/Branding Logic. Includes a C2 Container diagram (Mermaid) for any structural or architectural change. This is where resolved LLD decisions land after Sprint 0.

**Pillar III — The Quality Gate (The Validation)**
BDD Scenarios (Given/When/Then) and the Validation/Testing Plan. The absolute Definition of Done. Focused strictly on high-value differentiators and high-friction paths — not a checklist of obvious things.

**Pillar IV — The Ledger (The Memory)**
Roadmap (Deferred Value), Change History, Sprint 0 Tasks (LLD unknowns for The Hands to resolve), and Strategic Dissent records. If the PM overrides the Trio, it's logged here — so The Hands understand why a non-standard path was chosen.

### The MACD Protocol

The Bedrock is protected by a strict change control mechanism: **Move, Add, Change, Delete**. No casual updates. Every change to a Pillar is an explicit, confirmed action with a receipt — version, date, time, decision, and who led it.

This is what separates the Bedrock from a living document that drifts. The Pillars are either [COMMITTED] or [UNDER AUDIT]. There is no in-between.

### The Mind vs. The Bedrock

> **The Mind (The Chat):** A fluid, high-entropy environment for discovery, debate, and rapid pivoting. Logic here is "Quicksand" — experimental and non-binding.

> **The Bedrock (The Files):** The immutable, high-density Source of Truth. No logic is considered real or ready for The Hands until it is written into these committed files.

The separation is the mechanism. Without it, AI sessions collapse into one long context window where early decisions and late pivots become indistinguishable.

---

### 🔧 The Hands — Implementation Agent

Three implementation personas execute the HLD. They read the Pillars, run Sprint 0, surface gaps the Brain couldn't anticipate, and escalate formally when the blueprint requires it.

| Persona | Role |
|---|---|
| **TPM** | Delivery Lead. Keeps implementation true to the Pillars. Flags Charter-level drift. |
| **Tech Lead** | Owns LLD decisions — library selection, file structure, C3 logic. Leads implementation. |
| **QA Engineer** | Owns validation against Pillar III BDD scenarios and any additional implementation tests. |

#### Sprint 0 — Before a Single Line of Code

Sprint 0 is mandatory. It is a Three Amigos session — all three personas plus the Senior PM — that runs automatically after the Pillars are read.

1. Read the in-scope set's four Pillars in full
2. Execute Brain-identified LLD unknowns from Pillar IV — answering what is answerable at setup time
3. Surface additional gaps the Brain couldn't anticipate
4. Resolve each item collaboratively, assign it to the sprint where it becomes answerable, or escalate formally
5. Define the sprint plan and decompose the first sprint only
6. Receive explicit PM sign-off — which ratifies the sprint plan — before implementation begins

HLD gaps can be skipped at the PM's direction. But they are never silently ignored — every skip is logged with rationale.

#### The Sprint Cadence — One Sprint, One Goal, One Session

Sprint 0 defines the solution; it does not decompose the entire Bedrock into one backlog. The Bedrock is sliced into **sprints** — each the smallest increment the PM can meaningfully UAT, sized to what one agent session can execute at full quality. **One sprint = one Stride goal = one session.** A coding agent's scarce resource is the context window, not calendar time — so the sprint boundary is a context boundary. (Sprint 0 itself is exempt from this law: it is **unsized** — by definition the answering of the LLD questions The Brain didn't decide or didn't know to decide, taking as long as those questions take.)

All sprint goals are created at Sprint 0, but only the first is decomposed into enriched tasks. Each later sprint opens with an autonomous **boundary ceremony**: incorporate the PM's UAT findings from the previous sprint, work that sprint's deferred unknowns, then decompose and enrich against the codebase as it exists that day — never sprints in advance. The PM's single Sprint 0 sign-off authorizes every boundary; the PM re-enters the loop through between-sprint UAT, or when an unknown turns out to touch the Charter. The plan lives in `sprint_plan.md`, owned by the TPM.

#### What The Hands Produce

| File | Owner | Purpose |
|---|---|---|
| `sprint_plan.md` | TPM | The ratified sprint sequence — outcomes, deferred unknowns, handoffs |
| `log_of_changes.md` | Tech Lead | Chronological dev log — Brain-readable on audit |
| `qa_log.md` | QA Engineer | QA record — internal to The Hands |
| `pillar_v_amendment_[feature].md` | TPM | Formal escalation when the blueprint needs to change |

#### The Amendment Protocol

If The Hands hit a technical blocker or discover a superior path that deviates from the HLD, they do not silently pivot. They trigger a **Pillar V Amendment** — a standalone file documenting the Pivot, the Reason, and the Impact — and submit it for Trio review at Strategic Re-engagement.

This is the Strategic Tripwire. The Brain finds out before a gap becomes a surprise discovered weeks later.

The threshold for an Amendment is deliberate: complexity alone isn't enough. The change must be fundamental — affecting the Charter or Problem Statement. The PM decides whether to invoke it. The AI suggests; it does not block.

#### Slash Commands & Enforced Immutability

On Claude Code, The Hands ship as a plugin with three rituals as first-class slash commands — so the framework's disciplines are invoked explicitly, not left to hope that prose triggers them:

| Command | What it does |
|---|---|
| `/sprint-0` | Runs the mandatory Three Amigos foundational-context phase — resolving answerable LLD unknowns, writing the sprint plan, decomposing the first sprint — and holds at the Senior PM sign-off gate that ratifies the plan before any implementation. |
| `/bedrock-audit` | Reports each Pillar's `[COMMITTED]` / `[UNDER AUDIT]` state and flags drift — uncommitted changes to a ratified Pillar. Read-only. |
| `/amendment` | Drives the Pillar V Amendment ceremony: MACD discussion, Senior PM approval, the Handback Summary, and the single-use unlock marker that authorizes the one sanctioned committed-Pillar edit — a PROPOSED amendment row in the Pillar IV Ledger. Substantive Pillars (I/II/III) are never edited by the Hands; The Brain enshrines those. |

And the Bedrock's immutability stops being a convention you have to remember. A **PreToolUse hook** denies any `Write`/`Edit` to a committed Pillar in `productdocuments/` unless `/amendment` has written a short-lived, single-use unlock marker for that exact file — and that marker can only ever authorize the **Pillar IV Ledger** (a PROPOSED amendment row). Substantive Pillars (I Charter, II Specs, III Quality Gate) are denied *even with a marker*: the Hands never edit them, and The Brain enshrines their changes out-of-band. A casual edit is blocked; a ratified Ledger amendment passes. (In Gemini CLI mode the hook is unavailable, so the discipline is maintained manually.)

---

## Stride — The Governed Execution Layer

Stride is task execution and quality management software developed by Jeff Morgan — a recognized practitioner in agentic software delivery and AI-assisted development workflows. Jeff built and uses Stride within his own consultancy practice as a governed framework for autonomous agent execution. With Jeff's approval, Stride has been integrated into the Product Trio Agentic framework as the execution layer that The Hands operate within, and the relationship between the two systems represents a budding partnership between complementary approaches to the same problem space.

That partnership carries weight beyond the technical integration. Jeff's standing in the agentic delivery community provides independent validation that the Product Trio Agentic framework is operating in a space that serious practitioners are converging on — and that the integration decision reflects genuine philosophical alignment, not convenience. Two independently developed systems, built by practitioners working from first principles, arriving at compatible answers is a stronger signal than any single system claiming the same ground alone.

**Where the Four Pillars answer *what should be built and why*, Stride answers *how the building is governed task-by-task*.**

The two systems are complementary in philosophy as well as function. Both treat human-in-the-loop ratification as a primary mechanism, not an optional governance add-on — no strategic decision becomes binding without explicit Senior PM confirmation, on either side. And both embrace agentic autonomy where it is practical: coding agents claim tasks, explore, implement, and review autonomously, while the human PM is freed from line-by-line review precisely because the governing contract — the Bedrock, the Stride task spec — is rigorous enough to make that autonomy safe.

Stride alone gives disciplined task execution but no governed source of strategic truth — tasks can be perfectly executed toward an incoherent product. Product Trio Agentic alone gives a governed source of truth but no enforced execution discipline — decisions can be beautifully documented and then sloppily built. Together they close the loop: a decision is ratified into the Bedrock, decomposed into governed Stride tasks, built and reviewed by agents against that Bedrock, and any blocker that turns out to be strategic triggers a formal Pillar V Amendment — submitted by The Hands, ratified by The Brain, enshrined in the Ledger before any deviation is executed. An unbroken, auditable chain from intent to merged code.

When Stride is present (the default — see Installation), code review is handled by `stride:task-reviewer`; The Hands' QA Engineer does **not** run a parallel diff review, but adds Pillar III BDD validation on top of it. When Stride is absent, the framework degrades gracefully — review reverts to a QA Engineer self-review pass and tasks are tracked in `log_of_changes.md`. The full operating contract for both modes lives in the plugin's `skills/the-hands-agent/references/stride-integration.md`.

---

## The C4 Design Standard

All architecture diagrams are produced in **Mermaid.js** and stored directly in the Pillar files — version-controlled, diffable, and instantly renderable in GitHub, VS Code, and Obsidian.

| Level | Owner | Location |
|---|---|---|
| C1 — System Context | The Brain | Pillar I — Mandatory |
| C2 — Containers | The Brain | Pillar II — Mandatory for structural changes |
| C3 — Components | The Hands | LLD / reviewed by Trio — As needed |

*"I draw the boxes (C2). The Hands draw the wires inside the boxes (C3). If the wires get too tangled, I step in."* — Speaking as Engineering

---

## Deployment Profiles

The framework is model- and vendor-agnostic. The base framework assumes **AI Hands** (Claude Code or Gemini CLI) executing autonomously against the Bedrock. But The Hands don't have to be a coding agent, and The Brain doesn't have to run on Claude.

A **deployment profile** stamps the same Brain for a different execution surface: a different host for the agent, a different ticketing system, or human Hands instead of AI ones, without touching the Bedrock discipline underneath. The methodology stays constant while the delivery surface changes.

### Microsoft Copilot Studio: human Hands via Jira

The first profile runs The Brain as a **Microsoft Copilot Studio** agent, delivering into a **human** engineering team that works from **Jira** tickets. What changes from the base framework:

- **AI proposes, humans ratify.** The agent's output reaches at most `[PROPOSED]`. Humans ratify at two gates: the Product Trio meeting ratifies Pillars, and backlog refinement ratifies tickets. Where the base profile enforces immutability with the Bedrock hook, here the human gates do.
- **Two operating modes.** *Greenfield* runs the full pipeline, from interview to PROPOSED Pillars to decomposition to tickets. *Additive* is a Hands-session mode that turns supplied material straight into tickets, carrying honest `PENDING` flags wherever committed Bedrock or real acceptance criteria don't yet exist, and never inventing them.
- **Pillars decompose to paste-ready Jira blocks:** Epic / Story / Task / Spike, with verbatim Pillar III BDD as acceptance criteria and no Jira sub-tasks.

The generic masters live in [`deployment-profiles/copilot/`](deployment-profiles/copilot/): `core-instructions.md` (sized to fit the agent's ~8K instructions field), the mode-flexible `ticket-template.md`, and a profile README. A deployment stamps a copy with the organization's own grant clause and hosts the knowledge sources on the organization's platform. The masters stay in this repo.

---

## What's in This Repo

The repo root *is* the Claude Code plugin **and** its own marketplace.

```
product-trio/
├── README.md                        ← You are here
├── LICENSE
├── .claude-plugin/
│   ├── plugin.json                  ← Plugin manifest (declares the Stride dependency)
│   └── marketplace.json             ← Marketplace catalog (hosts this plugin)
├── product-trio-brain/
│   └── system-prompt.md             ← Paste into Claude.ai or Gemini chat to activate The Brain
├── skills/
│   └── the-hands-agent/
│       ├── SKILL.md                 ← Thin skill: role, when-to-use, pointers
│       └── references/              ← Progressive disclosure, loaded on demand
│           ├── sprint-0.md
│           ├── sprint-cadence.md
│           ├── macd-protocol.md
│           ├── amendment-protocol.md
│           ├── personas.md
│           ├── qa-protocol.md
│           └── stride-integration.md
├── agents/                          ← Hands subagents
│   ├── hands-tpm.md
│   ├── hands-tech-lead.md
│   └── hands-qa.md
├── commands/                        ← Slash commands
│   ├── sprint-0.md
│   ├── amendment.md
│   └── bedrock-audit.md
├── hooks/
│   ├── hooks.json                   ← PreToolUse Write|Edit → bedrock-guard.sh
│   └── bedrock-guard.sh             ← Enforces Bedrock immutability (MACD)
├── deployment-profiles/               ← Environment-specific stamps of The Brain
│   └── copilot/                        ← Microsoft Copilot Studio + human Hands via Jira
└── productdocuments/
    └── README.md                    ← Your Bedrock: four Pillars (flat for a single set, or one named subfolder per set)
```

---

## Installation

### The Brain (Claude.ai or Gemini Chat)

1. Open `product-trio-brain/system-prompt.md`
2. Paste the contents as a system prompt or into a Claude Project
3. Provide your initial product context — The Brain activates and prepares to build the Bedrock

### The Hands — Claude Code

The Hands ship as a Claude Code plugin. Add the marketplace, then install:

```
/plugin marketplace add neilstryjski-git/product-trio-agentic-process
/plugin install product-trio@product-trio
```

(These are slash commands you type inside Claude Code. The equivalent shell form is `claude plugin marketplace add …` / `claude plugin install …`.)

Installing Product Trio **auto-installs Stride**, its governed execution layer — Product Trio declares a hard cross-marketplace dependency on the `stride` plugin (see [Stride — The Governed Execution Layer](#stride--the-governed-execution-layer)). To pull updates later: `/plugin marketplace update`.

**Minimum Claude Code version for the one-step experience:** cross-marketplace dependency resolution needs **v2.1.110+**, and transitive auto-enable of Stride needs **v2.1.143+**. On an older version you'll get a `dependency-unsatisfied` notice — add Stride's marketplace and install it explicitly:

```
/plugin marketplace add cheezy/stride-marketplace
/plugin install stride@stride-marketplace
```

Then re-run the Product Trio install. The framework still functions if Stride is absent — it degrades to a QA Engineer self-review pass (see the Stride section).

> **Bedrock enforcement & `.gitignore`.** The `/amendment` command writes a short-lived unlock marker under your project's `.product-trio/` directory, which the Bedrock hook consumes. That marker is local-only state and must never be committed. Either let `/amendment` create `.product-trio/.gitignore` (containing `*`), or — equivalently — add a single line `.product-trio/` to your project-root `.gitignore`.

### The Hands — Gemini CLI

Gemini has no plugin system, so copy the contents of `skills/the-hands-agent/SKILL.md` into your `GEMINI.md` at project root and follow the instructions as written. The Bedrock-enforcement hook and slash commands are Claude Code features; in Gemini mode the MACD discipline is maintained manually.

---

## How It Works in Practice

1. **Start with The Brain** — Seed it with your product context. The Trio debates, challenges, and produces the four Pillar files.
2. **Commit the Bedrock** — Drop the Pillar files into `productdocuments/` in your project repo.
3. **Activate The Hands** — The implementation agent reads the Pillars, runs Sprint 0 to resolve LLD unknowns and plan the sprints, then builds one sprint per session — with your UAT of each increment between sessions.
4. **Amendments surface naturally** — If The Hands hit a wall or find a better path, the Amendment Protocol packages the change and hands it back to The Brain for review. Nothing is lost. Nothing deviates silently.

---

## Why This Exists

A few months ago a gym owner told me he'd tried and failed to get custom software built for his business. Six weeks later I realized I could have built it myself — concept to active users — without a developer in the room.

But only because the Product thinking was rigorous enough to drive the build.

The developer role hasn't disappeared. It's moved from entry point to scale-up partner for a product that already works. That's a fundamentally different build cycle. And it only holds together if the strategic intent survives the handoff intact.

This framework is what makes that repeatable.

---

## More

- **Full approach:** [productdelivered.ca/approach](https://www.productdelivered.ca/approach.html)
- **Framework overview:** [productdelivered.ca/product-trio](https://www.productdelivered.ca/product-trio.html)
- **Built with this framework:** [Vechelon](https://vechelon.productdelivered.ca) · [Travel Itinerary Wizard](https://itin-wizard.productdelivered.ca)
- **Work together:** [Book a call](https://calendly.com/neil_stryjski/) · [LinkedIn](https://www.linkedin.com/in/neilstryjski/)
