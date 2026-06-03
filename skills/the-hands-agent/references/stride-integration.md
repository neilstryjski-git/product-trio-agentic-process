# Stride Integration — the Governed Execution Layer

Stride is task execution and quality management software developed by Jeff Morgan — a recognized practitioner in agentic software delivery and AI-assisted development workflows. Jeff built and uses Stride within his own consultancy practice as a governed framework for autonomous agent execution. With Jeff's approval, Stride has been integrated into the Product Trio Agentic framework as the execution layer that The Hands operate within, and the relationship between the two systems represents a budding partnership between complementary approaches to the same problem space.

That partnership carries weight beyond the technical integration. Jeff's standing in the agentic delivery community provides independent validation that the Product Trio Agentic framework is operating in a space that serious practitioners are converging on — and that the integration decision reflects genuine philosophical alignment, not convenience. Two independently developed systems, built by practitioners working from first principles, arriving at compatible answers is a stronger signal than any single system claiming the same ground alone.

**Where the Four Pillars answer *what should be built and why*, Stride answers *how the building is governed task-by-task*.**

The two systems are complementary not just in function but in philosophy. Both treat human-in-the-loop ratification as a primary mechanism, not an optional governance add-on. In the Product Trio Agentic framework, no strategic decision becomes binding without explicit Senior PM confirmation via MACD (see [`macd-protocol.md`](macd-protocol.md)). In Stride, the human PM holds authority over sprint direction, UAT, and any escalation that surfaces a strategic question. Neither system delegates judgment on direction to an agent — both systems are explicit that agents execute within a human-ratified contract, not outside it.

Equally, both systems embrace agentic autonomy where it is practical — and are deliberate about where that boundary sits. Low-level implementation decisions are intentionally commoditised: coding agents claim tasks, explore solutions, implement, and conduct peer review autonomously, without requiring human involvement at each step. The human PM is freed from line-by-line review and implementation detail precisely because the governing contract (the Bedrock, the Stride task spec) is rigorous enough to make autonomous execution safe. Autonomy is not a risk to be tolerated — it is a design goal, applied at the layer where it produces speed without compromising accountability.

## Connection points in practice

- **Bedrock to Stride tasks.** Committed Pillar decisions decompose into Stride goals and tasks on a project board, each enriched with key files, acceptance criteria, verification steps, and pitfalls drawn from the Bedrock. The Hands TPM (see [`personas.md`](personas.md)) owns this decomposition during Sprint 0 (see [`sprint-0.md`](sprint-0.md)).
- **Governed execution lifecycle.** Each task moves through a defined workflow — claim, explore, implement, review, complete — with the coding agent dispatching specialised sub-agents along the way. Human involvement is reserved for strategic decisions and UAT, not implementation steps.
- **Three Amigos review.** Code review is handled autonomously by **`stride:task-reviewer`** against the task's acceptance criteria and the Bedrock's intent — low-level quality assurance commoditised so the human PM operates at the layer where human judgment is irreplaceable. The Hands' QA Engineer persona does **not** run a parallel diff review; see the deferral rule in [`personas.md`](personas.md) and [`qa-protocol.md`](qa-protocol.md). The QA Gate (Mode 3) covers Pillar III BDD validation on top of `stride:task-reviewer`'s approval, not in place of it.
- **Telemetry and traceability.** Every completion records what was explored, reviewed, and changed — producing the same audit discipline at the execution layer that MACD and the Ledger produce at the decision layer.

## What the combination enables that neither does alone

Stride alone gives disciplined task execution but no governed source of strategic truth — tasks can be perfectly executed toward an incoherent product. Product Trio Agentic alone gives a governed source of truth but no enforced execution discipline — decisions can be beautifully documented and then sloppily built. Together they close the loop: a strategic decision is ratified into the Bedrock, decomposed into governed Stride tasks, built and reviewed by agents against that Bedrock, and any blocker that turns out to be strategic triggers a formal Pillar V Amendment — submitted by The Hands, ratified by the Brain, and enshrined in the Ledger before any deviation from the blueprint is executed — an unbroken, auditable chain from intent to merged code, with human judgment applied exactly where it matters and agentic autonomy applied everywhere it is safe.

---

## Operating instructions for The Hands

### When Stride is present (the default — Option A)

The `product-trio` plugin declares a **hard dependency** on the `stride` plugin (declared in `.claude-plugin/plugin.json` with `marketplace: "stride-marketplace"`; cross-marketplace permission lives in the `product-trio` marketplace's `allowCrossMarketplaceDependenciesOn`). On a supported Claude Code release (≥ 2.1.110 for cross-marketplace resolution; ≥ 2.1.143 for transitive enable), installing `product-trio` auto-installs `stride`. The Hands operate as follows:

1. **At Step 2 of the Initialization Protocol** ([`sprint-0.md`](sprint-0.md)), declare `QA Mode: Stride Active`.
2. **Bedrock → tasks.** During Sprint 0 — and whenever a committed Pillar change cascades into work — the TPM decomposes Pillar items into Stride goals and tasks via `stride:stride-workflow` and `stride:task-decomposer`. Each task is enriched (`stride:task-enricher`) with `key_files`, `acceptance_criteria`, `verification_steps`, and `pitfalls` drawn from the Bedrock.
3. **Execution lifecycle.** Claim → explore (`stride:task-explorer`) → implement → review (`stride:task-reviewer`) → complete (`stride:stride-workflow`). The Tech Lead drives implementation in Solo Execution Mode; the QA Engineer triggers the QA Gate (Mode 3) for Pillar III BDD validation on top of the reviewer's diff approval.
4. **Pillar V Amendments through Stride.** When a Stride task surfaces a strategic blocker (a finding that touches the Charter or Problem Statement, per the threshold in [`amendment-protocol.md`](amendment-protocol.md)), the TPM proposes a Pillar V Amendment. The Amendment flow returns to MACD with the Brain for ratification before the deviating Stride task resumes. The `/amendment` command (built in W6) handles the ceremony, generates the Handback Summary, and writes the short-lived unlock marker the Bedrock hook consumes — so a sanctioned edit to a committed Pillar proceeds while a casual edit is denied.
5. **Telemetry.** Stride's completion contract records `explorer_result`, `reviewer_result`, `after_doing_result`, `before_review_result`, and the full `workflow_steps` array. These are the auditable execution-layer counterpart to `log_of_changes.md` and the Ledger.

### Graceful fallback — when Stride is absent or disabled

Although `product-trio` hard-declares `stride` as a dependency, the skill must still degrade safely. Stride may be absent because:

- The user is on a Claude Code release earlier than v2.1.110 / v2.1.143, where cross-marketplace auto-install / transitive enable is unavailable.
- The user explicitly disabled or uninstalled `stride`.
- The user added the `product-trio` marketplace but has not yet added `stride-marketplace`, and the dependency is in `dependency-unsatisfied` state.
- The user is running in Gemini CLI (no plugin system; see SKILL.md "Platform compatibility").

When `stride:*` skills/agents are not invokable, The Hands operate as follows:

1. **At Step 2 of the Initialization Protocol**, declare `QA Mode: Stride Unavailable`.
2. **Bedrock → tasks.** The TPM still decomposes Bedrock items into a written task list — kept in `log_of_changes.md` or a project-local TODO file — with the same enrichment shape (`key_files`, `acceptance_criteria`, `verification_steps`, `pitfalls`) drawn from the Bedrock. The format is preserved so that a later `stride` install can lift the list onto a board with minimal translation.
3. **Execution lifecycle.** Heads-down implementation runs in Solo Execution Mode. Code review reverts to a **self-review pass** by the QA Engineer persona against the task's acceptance criteria and pitfalls, explicitly *not* against the Bedrock alone — the QA Engineer reads the same inputs `stride:task-reviewer` would have read. The QA Engineer then runs the QA Gate for Pillar III BDD validation as usual.
4. **Pillar V Amendments.** The Amendment Protocol runs unchanged ([`amendment-protocol.md`](amendment-protocol.md)). In Stride Unavailable mode the `/amendment` command still drives the ceremony and (on Claude Code) the Bedrock-hook unlock; in Gemini CLI mode the discipline must be maintained manually by the Senior PM and The Hands.
5. **Telemetry.** The Tech Lead's `log_of_changes.md` becomes the sole execution-layer audit trail. Each entry should explicitly capture what would have been the `explorer_result`, `reviewer_result`, and `workflow_steps` so the audit shape stays comparable.

### Forbidden patterns

- **Do not** dispatch `stride:task-reviewer` *and* run a parallel persona-driven code review — that's the duplication the framework explicitly avoids. Review is a single act performed by `stride:task-reviewer` when present, or by the QA Engineer persona's self-review when absent. Never both.
- **Do not** assume Stride is always present despite the hard dependency. The fallback above is a real operating mode, not an aspiration — the framework's value survives Stride being absent because the Bedrock-and-MACD half is self-contained.
- **Do not** carry Stride task IDs into the Bedrock files (`productdocuments/`). Stride identifiers live in the execution layer; the Bedrock references *intent*, not task numbers.

### Recovering from `dependency-unsatisfied`

If `claude plugin list --json` reports `product-trio` as `dependency-unsatisfied` for `stride`, recover with:

```bash
claude plugin marketplace add cheezy/stride-marketplace   # if not already added
claude plugin install stride@stride-marketplace            # explicit install
# or simply re-running the dependent install:
claude plugin install product-trio@product-trio
```

Once `stride` is enabled, switch the `QA Mode` declaration to `Stride Active` and resume the full lifecycle. Tasks previously tracked in `log_of_changes.md`'s plain-list form can be lifted onto the board with `stride:task-decomposer` and `stride:task-enricher`.
