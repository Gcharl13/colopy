#!/usr/bin/env bash
# ============================================================================
# active_stubs.sh -- the TRUE Gate-G4 weak-stub worklist
# ----------------------------------------------------------------------------
# linkgap.py counts symbols undefined in libviceroy_rules.a (its "func_body"
# tally). That OVER-COUNTS what matters for G4, because at final link most of
# those are satisfied by a strong definition (in the rules lib OR the separately
# linked src/platform objects) or by a PROVIDE alias. The only stubs that are
# actually live are the weak symbols that survive un-overridden into the linked
# executable -- those show as 'W' in `nm viceroy_modern`.
#
# This script reports that link-active set: the real "what still falls through
# to a no-op stub" worklist, categorized so each item gets the right treatment
# (port a body / wire a thunk / split a multi-entry parent / UNREACHABLE verdict).
#
# Usage:  tools/active_stubs.sh [path/to/viceroy_modern]
# ============================================================================
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRCROOT="$(cd "$HERE/.." && pwd)"
EXE="${1:-$SRCROOT/build_modern/viceroy_modern}"
DIS="${VICEROY_DISASM:-$SRCROOT/../re_work/disasm}"
[ -f "$EXE" ] || { echo "ERROR: executable not found: $EXE (build first)" >&2; exit 1; }

# Un-overridden weak symbols in the final link = the live stubs.
nm "$EXE" 2>/dev/null | awk '$2=="W"||$2=="w"{print $3}' | sort -u > /tmp/_aw_all.txt
grep -E '^func_0[0-9A-Fa-f]{5,6}' /tmp/_aw_all.txt > /tmp/_aw_func.txt || true

total_all=$(wc -l < /tmp/_aw_all.txt)
total_func=$(wc -l < /tmp/_aw_func.txt)

echo "link-active weak symbols (all):        $total_all"
echo "link-active weak func_ stubs:          $total_func"
echo ""

# Categorize the func_ stubs.
#  - thunk:      RTLink far-jump trampoline (5-byte ljmp; no standalone disasm,
#                offset sits inside a thunk window) -> needs WIRING to its leaf.
#  - multientry: mid-function entry point (no disasm at the bare offset, but a
#                containing function exists) -> needs an ENTRY-SPLIT / alias.
#  - body:       a standalone function with its own disasm -> port or verdict.
> /tmp/_aw_body.txt; > /tmp/_aw_nodis.txt
while read -r sym; do
  off=$(echo "$sym" | grep -oE '^func_0[0-9A-Fa-f]{5,6}' | sed 's/func_0*//')
  offhex=$(printf '%06X' "0x$off" 2>/dev/null || echo "")
  if [ -n "$offhex" ] && [ -f "$DIS/func_${offhex}.asm" ]; then
    sz=$(head -1 "$DIS/func_${offhex}.asm" | grep -oE 'size [0-9]+' | awk '{print $2}')
    echo "$sz $offhex $sym" >> /tmp/_aw_body.txt
  else
    echo "$sym" >> /tmp/_aw_nodis.txt
  fi
done < /tmp/_aw_func.txt

n_body=$(wc -l < /tmp/_aw_body.txt 2>/dev/null || echo 0)
n_nodis=$(wc -l < /tmp/_aw_nodis.txt 2>/dev/null || echo 0)
echo "  standalone BODY (has disasm):        $n_body   <- port or UNREACHABLE verdict"
echo "  no bare disasm (thunk/multi-entry):  $n_nodis   <- wire / entry-split / verdict"
echo ""
echo "=== standalone bodies (size offset symbol) ==="
sort -n /tmp/_aw_body.txt 2>/dev/null || true
echo ""
echo "=== thunk/multi-entry symbols ==="
sort /tmp/_aw_nodis.txt 2>/dev/null | tr '\n' ' '; echo
