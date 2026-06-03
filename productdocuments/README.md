# productdocuments/

This folder is where your project's **Bedrock** lives — the four Pillar files produced by The Brain.

When you activate The Brain on a new project, drop the exported Pillar files here before handing off to The Hands.

```
productdocuments/
├── [ProjectName] Pillar I: The Charter (v1.0.0).md
├── [ProjectName] Pillar II: The Specs (v1.0.0).md
├── [ProjectName] Pillar III: The Quality Gate (v1.0.0).md
└── [ProjectName] Pillar IV: The Ledger (v1.0.0).md
```

## Multiple Pillar sets

A Bedrock can hold **more than one four-Pillar set**. Each set describes a discrete, hand-offable body of work — a product area, a releasable version, or an engagement. The **primary (or only) set stays flat at the root**; each **additional** set lives in its own **meaningfully-named subfolder**:

```
productdocuments/
├── [the primary set — Pillar I … IV, flat]   ← read when no set is named
├── voc_mt_ia/                       ← an additional named set
│   └── [...] Pillar I / II / III / IV ...
└── rider_portal/                    ← another named set
```

Conventions:
- **The primary (or only) set stays flat at the root** (the four files above). Each **additional** set gets a subfolder — and subfolders appear **only when the project actually grows past one set.** Multi-set is a growth path, not a precondition: a project that may never have a second set keeps it flat.
- **Set names are meaningful, never version numbers** (`voc_mt_ia`, not `1.2/`).
- **Work declares its in-scope set** — a named subfolder, or the root/primary set by default; The Hands read only that set's Pillars.
- A set's Charter may carry an `ARCHIVED` status so a superseded set is not read into scope.
- Cross-set references **link, never duplicate**; note the dependency in the referencing set's Ledger.

The Hands agent reads the **in-scope set** automatically on every session start. If this folder is missing or the in-scope set is empty, The Hands will stop and notify you before taking any action.

**These files are the contract between The Brain and The Hands. Do not edit them directly — all changes go through the MACD Protocol.**
