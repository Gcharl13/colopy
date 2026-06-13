#!/usr/bin/env python3
# ============================================================================
# reachability.py -- call-graph reverse-reachability over the original
#                    VICEROY.EXE, to drive Gate-G4 UNREACHABLE verdicts.
# ----------------------------------------------------------------------------
# Builds the original call graph from re_work/disasm/func_*.asm:
#   - near calls   "call 0x3ea10"        -> edge to that file offset
#   - far  calls   "lcall 0x181f, 0x582" -> resolved via
#                  lcall_resolution_VICEROY.json (by_lcall_target) to the
#                  overlay leaf's file offset
# (Indirect "call word ptr [..]" -- ~30 sites total -- are unresolved and noted.)
#
# ROOTS = every func_0XXXXX symbol the modern C build references in src/*.c
# (the live entry surface: the modern executable starts in C and calls these).
# We forward-reach from the roots over the ORIGINAL edges. Because a function
# reimplemented in C may DROP calls the original made, original-edge reachability
# is an OVER-approximation of the modern build's reachability -- so any stub the
# over-approximation cannot reach is SOUNDLY unreachable in the modern build.
# That one-sided soundness is exactly what an UNREACHABLE verdict needs.
#
# Usage:
#   reachability.py audit [active_func_list]   # classify stubs reach/unreach
#   reachability.py callers <0xOFF | func_NAME>  # transitive callers (evidence)
# ============================================================================
import json, os, re, sys, glob, collections

HERE = os.path.dirname(os.path.abspath(__file__))
SRCROOT = os.path.dirname(HERE)                 # viceroy_source
REPO = os.path.dirname(SRCROOT)                 # colopy
DIS = os.environ.get("VICEROY_DISASM", os.path.join(REPO, "re_work", "disasm"))
LCALL = os.path.join(SRCROOT, "lcall_resolution_VICEROY.json")
SRC = os.path.join(SRCROOT, "src")

NEAR = re.compile(r'\bcall\s+0x([0-9a-fA-F]+)\b')
LCALL_RE = re.compile(r'\blcall\s+0x([0-9a-fA-F]+),\s*0x([0-9a-fA-F]+)')
HDR = re.compile(r'file 0x([0-9A-Fa-f]+)\s+size (\d+)')
FUNCNAME = re.compile(r'func_0([0-9A-Fa-f]{5,6})')


def load_lcall():
    d = json.load(open(LCALL))["by_lcall_target"]
    m = {}
    for k, v in d.items():
        off = v.get("overlay_file_offset")
        if off is not None:
            m[k.upper()] = off
    return m


def build_graph(lcallmap):
    starts = []                     # sorted list of (start, end) for containing-func lookup
    fwd = collections.defaultdict(set)
    funcsize = {}
    for path in glob.glob(os.path.join(DIS, "func_*.asm")):
        with open(path) as f:
            first = f.readline()
            m = HDR.search(first)
            if not m:
                continue
            start = int(m.group(1), 16)
            size = int(m.group(2))
            funcsize[start] = size
            starts.append((start, start + size))
            body = f.read()
        for mm in NEAR.finditer(body):
            fwd[start].add(int(mm.group(1), 16))
        for mm in LCALL_RE.finditer(body):
            key = "0x%04X:0x%04X" % (int(mm.group(1), 16), int(mm.group(2), 16))
            t = lcallmap.get(key)
            if t is not None:
                fwd[start].add(t)
    starts.sort()
    return fwd, starts, funcsize


def containing(off, starts):
    # largest start <= off whose [start,end) covers off
    lo, hi, best = 0, len(starts), None
    while lo < hi:
        mid = (lo + hi) // 2
        if starts[mid][0] <= off:
            best = starts[mid]; lo = mid + 1
        else:
            hi = mid
    if best and best[0] <= off < best[1]:
        return best[0]
    return None


def normalize_edges(fwd, starts):
    # roll callee offsets up to their containing function start
    nfwd = collections.defaultdict(set)
    rev = collections.defaultdict(set)
    for c, callees in fwd.items():
        for t in callees:
            cf = containing(t, starts)
            tgt = cf if cf is not None else t
            nfwd[c].add(tgt)
            rev[tgt].add(c)
    return nfwd, rev


CALLSITE = re.compile(r'\bfunc_0([0-9A-Fa-f]{5,6})\s*\(')


def src_root_offsets():
    # roots = real call sites / definitions in modern C (identifier followed by
    # '('), excluding extern declarations and prose comments. Over-approximates
    # the live surface (some C callers may themselves be dead), which keeps any
    # UNREACHABLE result sound.
    roots = set()
    for path in glob.glob(os.path.join(SRC, "**", "*.c"), recursive=True):
        try:
            lines = open(path, errors="ignore").readlines()
        except OSError:
            continue
        for line in lines:
            if "extern" in line:
                continue
            s = line.lstrip()
            if s.startswith("*") or s.startswith("/*") or s.startswith("//"):
                continue
            for m in CALLSITE.finditer(line):
                roots.add(int(m.group(1), 16))
    return roots


def offset_of(token):
    m = FUNCNAME.search(token)
    if m:
        return int(m.group(1), 16)
    return int(token, 16)


def forward_reach(roots, nfwd, starts):
    seen = set()
    dq = collections.deque()
    for r in roots:
        cf = containing(r, starts)
        node = cf if cf is not None else r
        if node not in seen:
            seen.add(node); dq.append(node)
    while dq:
        n = dq.popleft()
        for t in nfwd.get(n, ()):
            if t not in seen:
                seen.add(t); dq.append(t)
    return seen


def main():
    if len(sys.argv) < 2:
        print(__doc__); return 2
    lcallmap = load_lcall()
    fwd, starts, funcsize = build_graph(lcallmap)
    nfwd, rev = normalize_edges(fwd, starts)
    cmd = sys.argv[1]

    if cmd == "callers":
        tgt = containing(offset_of(sys.argv[2]), starts) or offset_of(sys.argv[2])
        seen, layers = {tgt}, [[tgt]]
        frontier = [tgt]
        while frontier:
            nxt = []
            for n in frontier:
                for c in sorted(rev.get(n, ())):
                    if c not in seen:
                        seen.add(c); nxt.append(c)
            if nxt:
                layers.append(sorted(nxt))
            frontier = nxt
        print("transitive callers of 0x%X (%d total):" % (tgt, len(seen) - 1))
        for d, layer in enumerate(layers):
            if d == 0:
                continue
            print("  depth %d: %s" % (d, " ".join("func_%06X" % x for x in layer)))
        if len(seen) == 1:
            print("  (no static callers -- entry point, indirect-only, or dead)")
        return 0

    # default: audit
    listfile = sys.argv[2] if len(sys.argv) > 2 else None
    if listfile:
        stubs = [offset_of(l.strip()) for l in open(listfile) if l.strip()]
    else:
        stubs = []
    roots = src_root_offsets()
    reach = forward_reach(roots, nfwd, starts)
    print("graph: %d functions, %d roots (func_ refs in src/), %d reachable" %
          (len(funcsize), len(roots), len(reach)))
    if not stubs:
        return 0
    stubset = set(containing(s, starts) or s for s in stubs)
    unreach, reachable = [], []
    for s in stubs:
        node = containing(s, starts)
        raw = node if node is not None else s          # thunks: use raw offset
        callers = rev.get(raw, ())
        live_callers = [c for c in callers if c not in stubset]   # callers that aren't themselves dead stubs
        rec = (s, len(callers), len(live_callers), raw in reach)
        (reachable if raw in reach else unreach).append(rec)
    print("\nNO STATIC-CALL PATH from live call sites: %d" % len(unreach))
    print("  (candidate UNREACHABLE -- but the graph has only direct near/far")
    print("   edges; rule out indirect dispatch (jump tables / fn-pointers)")
    print("   before a ledger verdict. A meaningful name usually => dispatched.)")
    for s, nc, nlc, _ in sorted(unreach):
        print("  func_%06X  callers=%d (live=%d)" % (s, nc, nlc))
    print("\nHAS STATIC-CALL PATH (reachable -- needs port/wire): %d" % len(reachable))
    for s, nc, nlc, _ in sorted(reachable):
        tag = "  <- 0 direct callers (reached via dispatch table / fn-pointer)" if nc == 0 else ""
        print("  func_%06X  callers=%d (live=%d)%s" % (s, nc, nlc, tag))
    return 0


if __name__ == "__main__":
    sys.exit(main())
