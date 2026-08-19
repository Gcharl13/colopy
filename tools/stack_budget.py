#!/usr/bin/env python3
"""stack_budget.py — the WORST-CASE STACK PATH, which -Wframe-larger-than cannot see.

`-Wframe-larger-than=N` is per-function. Every board crash this project has had
from the stack was *depth*: a legal frame under another legal frame under a
third, summing past the task's stack. Three times now:

  2026-08-17  a 1,216-byte `arrived[]` in advance_goto, under the end-turn chain
  2026-08-17  3 KB of menu row buffers in in_click_inner, above every command
  (and the 25,600-byte scene band before those, which the per-frame gate DID
   catch — it is the only one it could have)

This walks the real call graph and reports the deepest path from each entry
point, so the number that actually matters is a number.

How it works: `-fstack-usage` gives each function's own frame; `objdump -d`
gives the call edges. Recursion is broken at the first repeat and the cycle is
reported, since a bounded recursion cannot be sized from static data alone.
Indirect calls through function pointers are invisible to this and are listed
separately — the sim's ask hook and the render callbacks are the ones that
matter, and they are shallow.

Usage:
  python3 tools/stack_budget.py                 # top paths, one per entry
  python3 tools/stack_budget.py --limit 4096    # fail if any path exceeds
  python3 tools/stack_budget.py --path in_key   # the full chain for one entry
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC_DIRS = ["core", "data", "render", "game"]
INCLUDES = ["-Icport/core", "-Icport/data", "-Icport/render", "-Icport/game"]

# The board's entry points into the core: everything the loop task can call.
ENTRIES = ["in_key", "in_click", "colopy_load_sav", "colopy_save_sav",
           "colopy_new_game", "colopy_digest", "rm_draw_map", "rm_draw_colony",
           "rm_draw_europe", "rm_draw_report", "rm_draw_dialog_rows_notes"]

SU = re.compile(r"^(.+?):(\d+):(\d+):(.+?)\t(\d+)\t(\w+)")
CALL = re.compile(r"\bcall\w*\s+[0-9a-f]+\s+<([A-Za-z_][A-Za-z0-9_.]*)>")


def build(tmp: Path) -> tuple[dict, dict, set]:
    """Compile every core source for frames and call edges."""
    frames: dict[str, int] = {}
    edges: dict[str, set] = {}
    indirect: set[str] = set()
    srcs = [p for d in SRC_DIRS for p in sorted((ROOT / "cport" / d).glob("*.c"))]
    for src in srcs:
        obj = tmp / (src.stem + ".o")
        cmd = ["gcc", "-std=c11", "-O2", "-fstack-usage", "-c",
               str(src), "-o", str(obj)] + INCLUDES
        r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
        if r.returncode:
            print("compile failed:", src, file=sys.stderr)
            print(r.stderr[-800:], file=sys.stderr)
            raise SystemExit(2)
        # gcc writes the .su beside the OUTPUT object, not the cwd
        su = obj.with_suffix(".su")
        if su.exists():
            for line in su.read_text().splitlines():
                m = SU.match(line)
                if not m:
                    continue
                # gcc names clones "f.isra"/"f.part.0"; the base name is what
                # the call edges use.
                fn = m.group(4).split(".")[0]
                frames[fn] = max(frames.get(fn, 0), int(m.group(5)))
            su.unlink()
        d = subprocess.run(["objdump", "-d", "--no-show-raw-insn", str(obj)],
                           capture_output=True, text=True).stdout
        cur = None
        for line in d.splitlines():
            h = re.match(r"^[0-9a-f]+ <([A-Za-z_][A-Za-z0-9_.]*)>:", line)
            if h:
                cur = h.group(1).split(".")[0]
                edges.setdefault(cur, set())
                continue
            if cur is None:
                continue
            c = CALL.search(line)
            if c:
                edges[cur].add(c.group(1).split(".")[0])
            elif re.search(r"\bcall\w*\s+\*", line):
                indirect.add(cur)
    return frames, edges, indirect


def deepest(fn: str, frames, edges, seen: tuple) -> tuple[int, list, str]:
    """Max stack from fn down. Returns (bytes, path, note)."""
    if fn in seen:
        return 0, [], "recursion at %s" % fn
    own = frames.get(fn, 0)
    best, bestpath, note = 0, [], ""
    for callee in sorted(edges.get(fn, ())):
        if callee not in frames and callee not in edges:
            continue                    # libc and friends: not ours to size
        sub, path, n = deepest(callee, frames, edges, seen + (fn,))
        if sub > best:
            best, bestpath = sub, path
        if n and not note:
            note = n
    return own + best, [(fn, own)] + bestpath, note


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=0,
                    help="exit 1 if any entry's worst path exceeds this")
    ap.add_argument("--path", help="print the full chain for one entry")
    args = ap.parse_args()

    with tempfile.TemporaryDirectory() as td:
        frames, edges, indirect = build(Path(td))

    rows = []
    for e in ENTRIES:
        if e not in frames and e not in edges:
            continue
        total, path, note = deepest(e, frames, edges, ())
        rows.append((total, e, path, note))
    rows.sort(reverse=True)

    if args.path:
        for total, e, path, note in rows:
            if e != args.path:
                continue
            print("%s: %d bytes%s" % (e, total, "  (%s)" % note if note else ""))
            for fn, own in path:
                if own:
                    print("  %6d  %s" % (own, fn))
        return 0

    print("worst-case stack path, per entry point (bytes):")
    for total, e, path, note in rows:
        top = "  <- " + " <- ".join(f for f, o in path[1:4] if o)
        print("  %6d  %-28s%s%s" % (total, e, top,
                                    "  [%s]" % note if note else ""))
    if indirect:
        print("\nfunctions calling through a POINTER (invisible here): %s"
              % ", ".join(sorted(indirect)[:8]))
    over = [r for r in rows if args.limit and r[0] > args.limit]
    if over:
        print("\nOVER the %d-byte limit:" % args.limit)
        for total, e, path, note in over:
            print("  %s: %d" % (e, total))
            for fn, own in path:
                if own:
                    print("      %6d  %s" % (own, fn))
        return 1
    if args.limit:
        print("\nall entries within the %d-byte limit" % args.limit)
    return 0


if __name__ == "__main__":
    sys.exit(main())
