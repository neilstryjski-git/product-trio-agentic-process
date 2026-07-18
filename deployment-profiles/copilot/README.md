# Copilot deployment profile

This profile adapts the PTAP Brain to run as a Microsoft Copilot Studio agent. In this shape The Hands are a human team working from Jira tickets, not an automated implementation agent.

## Key differences from the base profile

- AI proposes, humans ratify. The agent's output reaches at most PROPOSED status. Humans ratify at two gates: the Product Trio meeting ratifies Pillars, and backlog refinement ratifies tickets.
- Two operating modes. Greenfield runs the full pipeline, from interview to PROPOSED Pillars to a decomposition pass to tickets. Additive is a Hands-session mode that turns supplied material into tickets, with honest PENDING flags where committed Bedrock or acceptance criteria do not yet exist.
- Decomposition pass. Committed Pillars are decomposed into paste-ready Jira ticket blocks (Epic, Story, Task, Spike). Jira sub-tasks are never used; engineering work is a standalone Task linked to its Story, or a checklist inside the Story.

## Deployment shape

- `core-instructions.md` goes in the agent's instructions field. Keep it inside the roughly 8,000 character budget.
- `ticket-template.md` and the PTAP Operating Manual are attached as knowledge sources, hosted on the organization's own document platform.
- The masters live in this repo. Deploy stamped copies with the organization's grant clause filled in on the deployment note line.

## License

MIT, per the repo LICENSE.
