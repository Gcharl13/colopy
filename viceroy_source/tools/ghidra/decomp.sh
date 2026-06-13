#!/usr/bin/env bash
# ============================================================================
# decomp.sh -- Ghidra-assisted decompiler for VICEROY.EXE
# ----------------------------------------------------------------------------
# Produces DRAFT C bodies for the reverse-engineering port.  Ghidra C is a
# fast first pass and an independent cross-check of the hand-port; it is NOT
# ground truth.  Every ported value still cites its @asm file offset -- the
# re_work/disasm/*.asm sweep remains the source of truth.
#
# COPYRIGHT CONSTRAINT: reads the user-supplied re_work/VICEROY.EXE (gitignored)
# at runtime; the decompiled .c output is VICEROY-derived and lands in a
# gitignored work dir (same policy as re_work/disasm).  Nothing here embeds or
# commits VICEROY.EXE bytes.
#
# Requires: JDK 21+ and a Ghidra install (>= 12.x).  Point GHIDRA_HOME at it,
# or drop it under /home/user/ghidra/ghidra_*_PUBLIC for auto-detect.
#
# Usage:
#   tools/ghidra/decomp.sh 0x3e162 0x4900 ...      # ad-hoc offsets
#   tools/ghidra/decomp.sh --list offsets.txt      # one func_XXXXXX or 0xHEX per line
# Output: $GHIDRA_OUT/func_<hex>.c  (default /home/user/ghidra/out)
# ============================================================================
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRCROOT="$(cd "$HERE/../.." && pwd)"                 # viceroy_source/
EXE="${VICEROY_EXE:-$SRCROOT/../re_work/VICEROY.EXE}"
PROJDIR="${GHIDRA_PROJ:-/home/user/ghidra/proj}"
OUT="${GHIDRA_OUT:-/home/user/ghidra/out}"
PROJ=viceroyflat

if [ -z "${GHIDRA_HOME:-}" ]; then
  GHIDRA_HOME="$(ls -d /home/user/ghidra/ghidra_*_PUBLIC 2>/dev/null | head -1 || true)"
fi
HEADLESS="$GHIDRA_HOME/support/analyzeHeadless"
[ -x "$HEADLESS" ] || { echo "ERROR: Ghidra not found (set GHIDRA_HOME). Looked at: $HEADLESS" >&2; exit 1; }
[ -f "$EXE" ]      || { echo "ERROR: VICEROY.EXE not found at $EXE (set VICEROY_EXE)." >&2; exit 1; }
mkdir -p "$PROJDIR" "$OUT"

# Collect target offsets (accepts func_XXXXXX names or raw 0xHEX).
offs=()
if [ "${1:-}" = "--list" ]; then
  [ -n "${2:-}" ] || { echo "ERROR: --list needs a file" >&2; exit 1; }
  while read -r line; do
    line="${line%%#*}"; line="$(echo "$line" | tr -d '[:space:]')"
    line="${line#func_}"; line="${line#0x}"
    [ -n "$line" ] && offs+=("0x$line")
  done < "$2"
else
  [ "$#" -gt 0 ] || { echo "ERROR: give offsets or --list <file>" >&2; exit 1; }
  for a in "$@"; do a="${a#func_}"; a="${a#0x}"; offs+=("0x$a"); done
fi

# Import + analyze ONCE (slow, ~100s); reused for every later run.
if [ ! -f "$PROJDIR/$PROJ.gpr" ]; then
  echo ">> first run: importing + analyzing VICEROY.EXE (one-time, ~2 min) ..."
  "$HEADLESS" "$PROJDIR" "$PROJ" -import "$EXE" \
    -processor "x86:LE:16:Real Mode" -loader BinaryLoader \
    -scriptPath "$HERE" >/dev/null 2>&1 || true
fi

# Fast path: decompile against the saved program, no re-analysis.
echo ">> decompiling ${#offs[@]} function(s) -> $OUT"
"$HEADLESS" "$PROJDIR" "$PROJ" -process VICEROY.EXE -noanalysis \
  -scriptPath "$HERE" -postScript ReconDecomp.java "$OUT" "${offs[@]}" 2>&1 \
  | grep -E "TARGET|WROTE|NO FUNC|null addr|SCRIPT ERROR" || true
echo ">> done. DRAFT C in $OUT (gitignored, VICEROY-derived -- do not commit; cite the .asm)."
