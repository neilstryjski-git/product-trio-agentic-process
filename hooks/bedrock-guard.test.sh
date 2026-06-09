#!/usr/bin/env bash
# bedrock-guard.test.sh — hermetic regression suite for hooks/bedrock-guard.sh
#
# Pins the 10 governance cases that were verified manually during W6 (plus the
# marker-validation deny branches and the multi-set subfolder case), so any
# future edit to bedrock-guard.sh is regression-checked. This file is TEST-ONLY:
# it never modifies the guard, and never touches the real repo or the user's git
# state — every case runs inside a throwaway temp git repo under $(mktemp -d).
#
# Run:   bash hooks/bedrock-guard.test.sh
# Exit:  0 if all cases pass, 1 if any fail.
#
# Assertion model (from the guard's contract):
#   - ALLOW = guard prints nothing and exits 0 (normal permission flow).
#   - DENY  = guard prints JSON containing  "permissionDecision": "deny".
# The guard is fail-OPEN on its own bugs, so deny is asserted on the explicit
# JSON it emits — never inferred from the absence of output.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARD="$SCRIPT_DIR/bedrock-guard.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

PASS=0
FAIL=0
ok(){ PASS=$((PASS + 1)); printf '  \033[32mPASS\033[0m  %s\n' "$1"; }
ko(){ FAIL=$((FAIL + 1)); printf '  \033[31mFAIL\033[0m  %s\n' "$1"; }

# Fresh throwaway project: git repo + productdocuments/ + one committed Pillar.
new_project(){
  local p
  p="$(mktemp -d "$WORK/proj.XXXXXX")"
  git -C "$p" init -q
  git -C "$p" config user.email t@example.com
  git -C "$p" config user.name  "Bedrock Test"
  mkdir -p "$p/productdocuments" "$p/src"
  printf '# Pillar IV: The Ledger\n' > "$p/productdocuments/pillar_4_ledger.md"
  printf '# Pillar II: The Specs\n'  > "$p/productdocuments/pillar_2_specs.md"
  printf 'x\n'                       > "$p/src/foo.txt"
  git -C "$p" add productdocuments/pillar_4_ledger.md productdocuments/pillar_2_specs.md src/foo.txt
  git -C "$p" commit -q -m init
  printf '%s' "$p"
}

# Pipe a PreToolUse envelope through the guard. Args: project_dir cwd file_path
run_guard(){
  local cpd="$1" cwd="$2" fp="$3"
  printf '{"tool_name":"Edit","cwd":"%s","tool_input":{"file_path":"%s"}}' "$cwd" "$fp" \
    | CLAUDE_PROJECT_DIR="$cpd" bash "$GUARD"
}

# Args: project target_project_relpath expires_epoch
write_marker(){
  local p="$1" target="$2" exp="$3"
  mkdir -p "$p/.product-trio"
  printf '{"path":"%s","expires_at":%s,"approved_by":"Senior PM","approved_at":"2026-05-29T00:00:00Z"}' \
    "$target" "$exp" > "$p/.product-trio/.bedrock-unlock"
}

check_allow(){ # name output
  if [ -z "$2" ]; then ok "$1"; else ko "$1 — expected ALLOW, got: $2"; fi
}
check_deny(){ # name output [reason_substring]
  if printf '%s' "$2" | grep -q '"permissionDecision": *"deny"'; then
    if [ -n "${3:-}" ] && ! printf '%s' "$2" | grep -qi "$3"; then
      ko "$1 — denied, but reason missing '$3'"
    else
      ok "$1"
    fi
  else
    ko "$1 — expected DENY, got: ${2:-<empty/allow>}"
  fi
}

echo "bedrock-guard.sh — regression suite"
echo "guard: $GUARD"
echo
NOW="$(date -u +%s)"

# --- Allow-through (no false positives) ------------------------------------

# 1. File outside productdocuments/ is none of the guard's business.
P="$(new_project)"
out="$(run_guard "$P" "$P" "$P/src/foo.txt")"
check_allow "1  non-productdocuments file is allowed" "$out"

# 2. Untracked file in productdocuments/ (new Pillar / pillar_v_amendment_*.md
#    under authoring) passes — uncommitted == not yet ratified.
P="$(new_project)"
printf '# draft\n' > "$P/productdocuments/draft.md"   # exists on disk, not committed
out="$(run_guard "$P" "$P" "$P/productdocuments/draft.md")"
check_allow "2  untracked file in productdocuments/ is allowed" "$out"

# 3. Committed Pillar with a valid, matching, unexpired marker -> allow + consume.
P="$(new_project)"
write_marker "$P" "productdocuments/pillar_4_ledger.md" "$((NOW + 600))"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_4_ledger.md")"
check_allow "3  committed Pillar with valid marker is allowed" "$out"
if [ ! -f "$P/.product-trio/.bedrock-unlock" ]; then
  ok "3a marker is consumed (single-use) after a sanctioned edit"
else
  ko "3a marker should have been consumed but still exists"
fi

# --- Deny (no false negatives) ---------------------------------------------

# 4. Committed Pillar, no marker -> deny with the run-/amendment reason.
P="$(new_project)"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_4_ledger.md")"
check_deny "4  committed Pillar without a marker is denied" "$out" "Bedrock is immutable"

# 5. Committed Pillar, expired marker -> deny + marker discarded.
P="$(new_project)"
write_marker "$P" "productdocuments/pillar_4_ledger.md" "$((NOW - 10))"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_4_ledger.md")"
check_deny "5  committed Pillar with an expired marker is denied" "$out" "expired"
if [ ! -f "$P/.product-trio/.bedrock-unlock" ]; then
  ok "5a expired marker is discarded"
else
  ko "5a expired marker should have been discarded but still exists"
fi

# 6. Committed Pillar, marker targets a DIFFERENT file -> deny + marker RETAINED
#    (it is still valid for its real target).
P="$(new_project)"
write_marker "$P" "productdocuments/other.md" "$((NOW + 600))"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_4_ledger.md")"
check_deny "6  marker for a different Pillar does not authorize this one" "$out" "different Pillar"
if [ -f "$P/.product-trio/.bedrock-unlock" ]; then
  ok "6a wrong-target marker is retained (still valid for its real target)"
else
  ko "6a wrong-target marker should have been retained but was removed"
fi

# 7. Path traversal (.. segment) -> deny before normalization.
P="$(new_project)"
out="$(run_guard "$P" "$P" "$P/productdocuments/../secret.md")"
check_deny "7  path traversal (..) is denied" "$out" "traversal"

# 8. Symlink-out: lexically inside productdocuments/, really outside -> deny.
P="$(new_project)"
mkdir -p "$WORK/outside"
printf 'secret\n' > "$WORK/outside/target.md"
ln -s "$WORK/outside/target.md" "$P/productdocuments/escape.md"
out="$(run_guard "$P" "$P" "$P/productdocuments/escape.md")"
check_deny "8  symlink escaping productdocuments/ is denied" "$out" "boundary mismatch"

# 9. Alias-in: lexically outside, really inside productdocuments/ -> deny.
P="$(new_project)"
ln -s "$P/productdocuments/pillar_4_ledger.md" "$P/alias.md"
out="$(run_guard "$P" "$P" "$P/alias.md")"
check_deny "9  symlink aliasing into productdocuments/ is denied" "$out" "boundary mismatch"

# 10. CLAUDE_PROJECT_DIR is a symlink to the git worktree (the macOS /var<->
#     /private/var, WSL class of bug). The guard must realpath the project root
#     and resolve the committed Pillar via the PROJECT-RELATIVE git proxy (I2),
#     still denying the edit. The file path is given REAL so this drives the
#     committed-check branch rather than the symlink-mismatch branch (8/9).
#     If the realpath() on the project root regressed, this would wrongly ALLOW.
P="$(new_project)"
LINK="$WORK/link.$$"
ln -s "$P" "$LINK"
out="$(run_guard "$LINK" "$LINK" "$P/productdocuments/pillar_4_ledger.md")"
check_deny "10 committed Pillar denied when CLAUDE_PROJECT_DIR is a symlink (I2 proxy)" "$out" "Bedrock is immutable"

# --- Marker-validation deny branches (beyond the 10 W6 cases) ---------------
# A committed Pillar with a corrupt marker must be denied AND the bad marker
# discarded — these branches are fail-open-adjacent, so pin them explicitly.

# 11. Malformed (non-JSON) marker -> deny + discard.
P="$(new_project)"
mkdir -p "$P/.product-trio"
printf 'not-json{' > "$P/.product-trio/.bedrock-unlock"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_4_ledger.md")"
check_deny "11 malformed marker is rejected" "$out" "malformed"
if [ ! -f "$P/.product-trio/.bedrock-unlock" ]; then
  ok "11a malformed marker is discarded"
else
  ko "11a malformed marker should have been discarded but still exists"
fi

# 12. Marker with no target path -> deny + discard.
P="$(new_project)"
mkdir -p "$P/.product-trio"
printf '{"expires_at":%s}' "$((NOW + 600))" > "$P/.product-trio/.bedrock-unlock"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_4_ledger.md")"
check_deny "12 marker with no target path is rejected" "$out" "no target path"
if [ ! -f "$P/.product-trio/.bedrock-unlock" ]; then
  ok "12a targetless marker is discarded"
else
  ko "12a targetless marker should have been discarded but still exists"
fi

# 13. Marker with a non-integer expires_at -> deny + discard.
P="$(new_project)"
mkdir -p "$P/.product-trio"
printf '{"path":"productdocuments/pillar_4_ledger.md","expires_at":"soon"}' > "$P/.product-trio/.bedrock-unlock"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_4_ledger.md")"
check_deny "13 marker with invalid expires_at is rejected" "$out" "invalid expires_at"
if [ ! -f "$P/.product-trio/.bedrock-unlock" ]; then
  ok "13a invalid-expiry marker is discarded"
else
  ko "13a invalid-expiry marker should have been discarded but still exists"
fi

# --- Multi-set Bedrock: the hook guards committed Pillars in subfolders ------
# The framework's multi-set model (each set in productdocuments/<name>/) relies
# on the guard being subdir-aware. Pin that: a committed Pillar inside a set
# subfolder is governed identically to a flat one.

# 14. Committed Ledger in productdocuments/<set>/ -> deny without a marker.
P="$(new_project)"
mkdir -p "$P/productdocuments/voc_mt_ia"
printf '# Pillar IV: The Ledger\n' > "$P/productdocuments/voc_mt_ia/pillar_4_ledger.md"
git -C "$P" add productdocuments/voc_mt_ia/pillar_4_ledger.md >/dev/null 2>&1
git -C "$P" commit -q -m set
out="$(run_guard "$P" "$P" "$P/productdocuments/voc_mt_ia/pillar_4_ledger.md")"
check_deny "14 committed Ledger in a productdocuments/<set>/ subfolder is denied (multi-set)" "$out" "Bedrock is immutable"

# 14a. A valid marker targeting that subfolder Ledger authorizes the edit + consumes.
write_marker "$P" "productdocuments/voc_mt_ia/pillar_4_ledger.md" "$((NOW + 600))"
out="$(run_guard "$P" "$P" "$P/productdocuments/voc_mt_ia/pillar_4_ledger.md")"
check_allow "14a sanctioned edit of a subfolder-set Ledger is allowed" "$out"
if [ ! -f "$P/.product-trio/.bedrock-unlock" ]; then
  ok "14b subfolder-set marker is consumed"
else
  ko "14b subfolder-set marker should have been consumed but still exists"
fi

# --- Ledger-only rule: substantive Pillars (I/II/III) are immutable ----------
# The Hands may edit ONLY the Pillar IV Ledger via the ceremony. A substantive
# Pillar is denied even WITH a structurally valid, matching, unexpired marker —
# and the deny is marker-independent (the marker is never read or consumed).

# 15. Committed substantive Pillar (II Specs) WITH a valid marker -> still DENY.
P="$(new_project)"
write_marker "$P" "productdocuments/pillar_2_specs.md" "$((NOW + 600))"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_2_specs.md")"
check_deny "15 substantive Pillar denied even with a valid marker" "$out" "Substantive Pillars"
if [ -f "$P/.product-trio/.bedrock-unlock" ]; then
  ok "15a marker is retained on a substantive-Pillar deny (rule is marker-independent)"
else
  ko "15a marker should have been retained (substantive deny must not read/consume it)"
fi

# 16. Committed substantive Pillar, NO marker -> DENY with the substantive reason
#     (the Brain-ratified message), not the generic run-/amendment message.
P="$(new_project)"
out="$(run_guard "$P" "$P" "$P/productdocuments/pillar_2_specs.md")"
check_deny "16 substantive Pillar without a marker is denied (Brain-ratified path)" "$out" "Substantive Pillars"

echo
echo "----------------------------------------"
printf 'Total: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
