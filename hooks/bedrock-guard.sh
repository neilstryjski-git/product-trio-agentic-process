#!/usr/bin/env bash
# bedrock-guard.sh — Product Trio plugin
#
# PreToolUse hook on Write|Edit. Denies edits to COMMITTED Pillars under
# <project>/productdocuments/ unless a short-lived single-use unlock marker
# at <project>/.product-trio/.bedrock-unlock authorizes the exact file.
#
# The /amendment command writes the marker after the MACD ceremony and Senior
# PM approval. The guard validates and consumes the marker (single-use), so a
# sanctioned amendment passes and a casual edit is blocked.
#
# Reads the PreToolUse JSON envelope from stdin; uses Python for robust parsing
# (jq is not assumed to be installed on user machines). Returns:
#   - exit 0 with no stdout      → no decision; normal permission flow
#   - exit 0 with JSON deny      → tool call blocked with a reason
#
# This script is intentionally fail-OPEN on its own bugs (malformed input,
# unreadable env, etc.) so a guard regression cannot brick legitimate work.

set -u

INPUT="$(cat)"

python3 - "$INPUT" <<'PYEOF'
import json
import os
import subprocess
import sys
import time

try:
    inp = json.loads(sys.argv[1])
except Exception:
    # Malformed envelope — fail open (do not block work over our bug).
    sys.exit(0)

tool_input = inp.get("tool_input") or {}
raw_path = tool_input.get("file_path")
cwd = inp.get("cwd") or os.getcwd()

if not raw_path or not isinstance(raw_path, str):
    sys.exit(0)

# Reject path traversal sneaking. Done on the raw input before normalization
# so a crafted .. segment cannot escape productdocuments/ via realpath.
if ".." in raw_path.replace("\\", "/").split("/"):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": "Path traversal (..) is not permitted on Bedrock edits."
        }
    }))
    sys.exit(0)

# Resolve to two complementary forms:
#   - lex_abs : LEXICAL absolute (normpath only) — what the path *claims* to be
#   - abs_path: REALPATH absolute — what it actually resolves to on disk
# We compare both against productdocuments/ to defend against symlink games:
# a symlink at productdocuments/escape.md → /etc/passwd would have lex_abs
# inside productdocuments/ but abs_path outside; an alias outside that
# resolves into productdocuments/ would be the inverse. Either mismatch
# is suspicious and is denied below.
try:
    candidate = raw_path if os.path.isabs(raw_path) else os.path.join(cwd, raw_path)
    lex_abs = os.path.normpath(candidate)
    abs_path = os.path.realpath(lex_abs)
except Exception:
    sys.exit(0)

# Project root: CLAUDE_PROJECT_DIR if set, else cwd.
project_root = os.path.realpath(os.environ.get("CLAUDE_PROJECT_DIR") or cwd)
pillars_dir = os.path.join(project_root, "productdocuments")

def under_pillars(p):
    return p == pillars_dir or p.startswith(pillars_dir + os.sep)

lex_under = under_pillars(lex_abs)
real_under = under_pillars(abs_path)

# Neither lexical nor real path is in productdocuments/ — not our concern.
if not lex_under and not real_under:
    sys.exit(0)

# Mismatch — one is in, the other is out. That's a symlink escape (or alias)
# attempt around the guard. Deny.
if lex_under != real_under:
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": (
                "Symlink boundary mismatch on a productdocuments/ path: the "
                "edit's lexical and resolved locations disagree about whether "
                "it is a Pillar. Refusing to honor it. Edit the real file "
                "directly under productdocuments/, going through /amendment "
                "if it is a committed Pillar."
            ),
        }
    }))
    sys.exit(0)

# Both lex_abs and abs_path are under productdocuments/ — proceed.

# Treat "committed to git" as the proxy for "ratified Pillar".
# Untracked files (new Pillars under authoring, or Pillar V amendment files)
# pass through. Use the PROJECT-RELATIVE path so git's view of the worktree
# is the same as ours even when realpath of $CLAUDE_PROJECT_DIR differs from
# git's worktree root (e.g., macOS /var ↔ /private/var, some WSL setups).
rel = os.path.relpath(abs_path, project_root)

def is_committed(rel_path, root):
    try:
        r = subprocess.run(
            ["git", "ls-files", "--error-unmatch", "--", rel_path],
            cwd=root,
            capture_output=True,
            timeout=5,
        )
        return r.returncode == 0
    except Exception:
        return False  # no git → treat as not-committed → allow

if not is_committed(rel, project_root):
    sys.exit(0)

# --- Committed Pillar: an unlock marker is required. -----------------------

marker_path = os.path.join(project_root, ".product-trio", ".bedrock-unlock")

def deny(reason):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)

def discard_marker():
    try:
        os.remove(marker_path)
    except Exception:
        pass

if not os.path.isfile(marker_path):
    deny(
        "The Bedrock is immutable. Edits to committed Pillars in productdocuments/ "
        "require the MACD ceremony — run /amendment to initiate the Pillar V "
        "Amendment Protocol, capture the Pivot/Reason/Impact, secure Senior PM "
        f"sign-off, then re-edit. (Blocked file: {rel})"
    )

try:
    with open(marker_path, "r") as f:
        marker = json.load(f)
except Exception:
    discard_marker()
    deny("Bedrock unlock marker was malformed and has been discarded. Re-run /amendment.")

target = marker.get("path") if isinstance(marker, dict) else None
expires_at = marker.get("expires_at") if isinstance(marker, dict) else None

if not target or not isinstance(target, str):
    discard_marker()
    deny("Bedrock unlock marker has no target path. Re-run /amendment.")

try:
    expires_at = int(expires_at)
except Exception:
    discard_marker()
    deny("Bedrock unlock marker has an invalid expires_at. Re-run /amendment.")

if int(time.time()) > expires_at:
    discard_marker()
    deny("Bedrock unlock marker has expired. Re-run /amendment.")

# Marker target is project-relative.
try:
    target_abs = os.path.realpath(os.path.join(project_root, target))
except Exception:
    discard_marker()
    deny("Bedrock unlock marker target is invalid. Re-run /amendment.")

if target_abs != abs_path:
    deny(
        f"Bedrock unlock marker authorizes a different Pillar ({target}). "
        f"To edit {rel}, re-run /amendment naming that file."
    )

# Single-use: consume the marker, then allow.
discard_marker()
sys.exit(0)
PYEOF
