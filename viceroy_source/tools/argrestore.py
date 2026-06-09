#!/usr/bin/env python3
# ============================================================================
# argrestore.py -- restore commented-out thunk arguments at call sites
# ----------------------------------------------------------------------------
# During porting, thousands of overlay-thunk calls were written as zero-arg
# placeholders with the REAL byte-traced arguments preserved in an adjacent
# comment:
#
#     overlay_call_181F_0302() /* (UNIT_MAPX(i),UNIT_MAPY(i)) */
#     ovly_query_1A1F_0554(/* colony_idx */)
#
# Those argument lists came from the @asm trace -- they are the decompiled
# truth, just disconnected.  thunkwire.py resolves each stub's TARGET and its
# real arity but refuses to alias while call sites pass zero args (garbage
# registers).  This tool reconnects them:
#
#   for every stub in tools/generated/thunk_arity_blocked.json
#     (target resolved, alias blocked ONLY by call-site arity):
#       pattern A:  stub()  /* (args) */   ->  stub(args)
#       pattern B:  stub( /* args */ )     ->  stub(args)
#     applied ONLY when the comment's argument count equals the target's arity.
#
# SAFETY GATES
#   1. arity equality (above) -- a mismatched comment is never applied.
#   2. per-file COMPILE CHECK: after rewriting, the file must compile clean
#      under -D_VICEROY_MODERN; if not, the file is reverted byte-for-byte and
#      the failure is logged.  (Comments referencing renamed/out-of-scope
#      locals are thus self-rejecting.)
#   3. declarations: a rewritten stub's `extern int stub(void);` declarations
#      (header + local) are relaxed to `extern int stub();` so passing the
#      restored args is legal; the unprototyped form matches the original
#      cdecl semantics.
#
# After running:  rebuild, re-run tools/thunkwire.py (the restored sites now
# match the target arity, so the stubs WIRE), then tools/linkgap.py.
# ============================================================================
import json, os, re, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
GEN  = os.path.join(HERE, "generated")
BLOCKED = os.path.join(GEN, "thunk_arity_blocked.json")
EXTERNS = os.path.join(ROOT, "include", "overlay_externs.h")

def argn(s):
    s = s.strip()
    if not s: return 0
    depth, n = 0, 1
    for ch in s:
        if ch in "([": depth += 1
        elif ch in ")]": depth -= 1
        elif ch == "," and depth == 0: n += 1
    return n

def plausible_args(s):
    """Reject prose and generic placeholders masquerading as an arg list."""
    if not s.strip() or "*/" in s or ";" in s or "{" in s: return False
    # `arg0, arg1`-style placeholders are porter shorthand, not traced exprs
    if re.fullmatch(r"\s*arg\d+(\s*,\s*arg\d+)*\s*", s): return False
    # an arg list is identifiers/calls/operators -- prose has bare words in a row
    return not re.search(r"[A-Za-z]{3,}\s+[A-Za-z]{3,}\s+[A-Za-z]{3,}", s)

def compiles(path):
    r = subprocess.run(
        ["gcc", "-fsyntax-only", "-D_VICEROY_MODERN",
         "-I", os.path.join(ROOT, "include"), "-w", path],
        capture_output=True, text=True)
    return r.returncode == 0, r.stderr

def main():
    blocked = json.load(open(BLOCKED))
    if not blocked: sys.exit("nothing arity-blocked -- run thunkwire.py first")

    cfiles = []
    for d, _, fs in os.walk(os.path.join(ROOT, "src")):
        cfiles += [os.path.join(d, f) for f in fs if f.endswith(".c")]

    name_alt = "|".join(re.escape(s) for s in blocked)
    # A: stub() /* (args) */        B: stub( /* args */ )
    pat_a = re.compile(r"\b(" + name_alt + r")\s*\(\s*\)\s*/\*\s*\(([^*]*?)\)\s*\*/")
    pat_b = re.compile(r"\b(" + name_alt + r")\s*\(\s*/\*([^*]*?)\*/\s*\)")
    decl  = re.compile(r"\b(extern\s+[\w \t\*]+?\b(" + name_alt + r"))\s*\(\s*void\s*\)")

    restored, rejected, reverted = {}, [], []
    touched_stubs = set()

    # PRE-relax the shared header decls for every blocked stub: `(void)` -> `()`.
    # The unprototyped form is the original cdecl semantics; it stays compatible
    # with existing zero-arg calls AND permits the restored-arg calls, so the
    # per-file compile gate below tests the REWRITE, not a stale prototype.
    if os.path.exists(EXTERNS):
        h = open(EXTERNS, errors="replace").read()
        h2 = re.sub(r"\b(extern\s+[\w \t\*]+?\b(?:" + name_alt + r"))\s*\(\s*void\s*\)",
                    lambda m: m.group(1) + "()", h)
        if h2 != h: open(EXTERNS, "w").write(h2)

    for path in cfiles:
        orig = open(path, errors="replace").read()
        # relax local `(void)` decls ONCE, before spans are computed, so
        # accepted edits never shift the remaining candidates' offsets
        base = decl.sub(lambda d: d.group(1) + "()", orig)

        # Collect every candidate site UP FRONT, then apply LAST-TO-FIRST so
        # earlier spans stay valid.  Each site is applied alone and gated by
        # its own compile check; a failed site is simply skipped (the original
        # text -- including its traced-args comment -- is left untouched).
        cands = []
        for pat in (pat_a, pat_b):
            for m in pat.finditer(base):
                stub, args = m.group(1), m.group(2).strip()
                if argn(args) == blocked[stub]["arity"] and plausible_args(args):
                    cands.append((m.start(), m.end(), stub, args))
                else:
                    rejected.append((path, stub, args[:60]))
        if not cands:
            continue                      # leave the file exactly as it was
        cands.sort(reverse=True)

        cur, hits = base, []
        for start, end, stub, args in cands:
            trial = cur[:start] + f"{stub}({args})" + cur[end:]
            open(path, "w").write(trial)
            ok, err = compiles(path)
            if ok:
                cur = trial
                hits.append(stub)
            else:
                reverted.append((path, err.strip().splitlines()[:1]))
        open(path, "w").write(cur if hits else orig)
        for s in hits:
            restored[s] = restored.get(s, 0) + 1
        touched_stubs.update(hits)

    # relax the shared header decls for every stub restored somewhere
    if touched_stubs and os.path.exists(EXTERNS):
        h = open(EXTERNS, errors="replace").read()
        alt = "|".join(re.escape(s) for s in touched_stubs)
        h2 = re.sub(r"\b(extern\s+[\w \t\*]+?\b(" + alt + r"))\s*\(\s*void\s*\)",
                    lambda m: m.group(1) + "()", h)
        if h2 != h: open(EXTERNS, "w").write(h2)

    print(f"stubs with >=1 call site restored : {len(touched_stubs)}")
    print(f"total call sites rewritten        : {sum(restored.values())}")
    print(f"comment args rejected (arity/prose): {len(rejected)}")
    print(f"files reverted (compile check)    : {len(reverted)}")
    for p, e in reverted[:10]:
        print(f"  REVERTED {os.path.relpath(p, ROOT)}: {e[0] if e else '?'}")
    print("\nnext: rebuild, then tools/thunkwire.py && tools/linkgap.py")

if __name__ == "__main__":
    main()
