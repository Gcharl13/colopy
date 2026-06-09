#!/usr/bin/env python3
# ============================================================================
# thunkwire.py -- wire overlay-thunk stubs to their real, already-ported targets
# ----------------------------------------------------------------------------
# The rules code calls ~800 distinct overlay thunks as placeholder symbols
# (`overlay_call_SEG_OFF()` / named aliases like `ov_base_terrain_at`).  The
# TARGETS of most of those thunks are already ported and compiled into
# libviceroy_rules.a -- the call graph just was never tied back together.
#
# This tool closes that loop MECHANICALLY, with linker aliases (no C wrappers,
# no type juggling):  a thunk symbol becomes the same address as its target
# function, so the call site's own byte-exact argument setup flows straight
# into the real body.  Safety is arity-gated (see below); anything not provably
# safe is reported, never wired.
#
# RESOLUTION CHAIN (per thunk key SEG:OFF):
#   1. file offset of the target:
#        a. docs/thunk_signatures.json `overlay_file_offset` (precomputed), else
#        b. parse the 10/12/14-byte thunk record straight out of VICEROY.EXE
#           (window segs 0x181F/0x191F/0x1A1F; formats per tools/rtlink/README):
#             resident: EA off seg, seg!=0  -> 0x2400 + seg*16 + off
#             overlay : segid (+extra if type-A loader 0x0DAB)
#                       -> segmap[segid].base + extra*16 + off   (STRONG only)
#           direct (non-window) segs: 0x2400 + seg*16 + off, accepted only if
#           it lands exactly on a function start (re_work/functions.json).
#   2. offset -> defined symbol in the lib:
#        a. nm: a T symbol named func_0XXXXX* at exactly that offset, else
#        b. banner scan: a definition in src/ whose immediately-preceding
#           comment block cites exactly ONE distinct func_0XXXXX -- bound only
#           if that offset is a verified function start.
#   3. arity gate (alias only when the call cannot pass garbage):
#        target arity 0                -> alias (extra caller args are harmless
#                                        under the C calling convention)
#        target arity N>0             -> alias only if EVERY call site of the
#                                        stub/alias passes exactly N args
#        mid-function entry / unknown -> report, never wire
#
# OUTPUTS
#   tools/generated/thunk_wiring.ld    PROVIDE(stub = target) linker aliases
#   tools/generated/thunk_keepalive.c  address-table forcing archive extraction
#   tools/generated/thunk_wired.json   manifest (linkgap.py skips these stubs)
#   docs/THUNK_WIRING.md               committed report + remaining worklist
#
# ORDER: run thunkwire.py BEFORE linkgap.py (linkgap reads the manifest).
# ============================================================================
import json, os, re, struct, subprocess, sys, collections

HERE   = os.path.dirname(os.path.abspath(__file__))
ROOT   = os.path.dirname(HERE)                       # viceroy_source/
REPO   = os.path.dirname(ROOT)
GEN    = os.path.join(HERE, "generated")
DOCS   = os.path.join(ROOT, "docs")
LIB    = os.path.join(ROOT, "build_modern", "libviceroy_rules.a")
EXE    = os.path.join(REPO, "re_work", "VICEROY.EXE")
FUNCS  = os.path.join(REPO, "re_work", "functions.json")
SEGMAP = os.path.join(REPO, "re_work", "overlay_segmap.json")
SIGS   = os.path.join(DOCS, "thunk_signatures.json")

WINDOWS = (0x181F, 0x191F, 0x1A1F)        # thunk-table alias segments
CODE_BASE = 0x2400                        # EXE header size: file = seg*16+base+off

# ---------------------------------------------------------------------------
def sh(cmd): return subprocess.run(cmd, capture_output=True, text=True).stdout

def load_function_starts():
    data = json.load(open(FUNCS))
    starts = set()
    rows = data.get("functions", data) if isinstance(data, dict) else data
    for f in rows:
        off = f.get("foff", f.get("file_offset", f.get("offset", f.get("start"))))
        if isinstance(off, str): off = int(off, 16)
        if off is not None: starts.add(int(off))
    return starts

def lib_symbols():
    """(defined T/W set, undefined U set referenced from the lib)."""
    defined, undef = set(), set()
    for ln in sh(["nm", LIB]).splitlines():
        p = ln.split()
        if len(p) == 3 and p[1] in "TWtw": defined.add(p[2])
        elif len(p) == 2 and p[0] == "U":  undef.add(p[1])
    return defined, undef - defined

def thunk_record(exe, seg, off):
    base = CODE_BASE + seg*16 + off
    b = exe[base:base+14]
    if len(b) < 12 or b[0] != 0x9A or b[5] != 0xEA: return None
    loader = struct.unpack("<H", b[1:3])[0]
    t_off, t_seg = struct.unpack("<HH", b[6:10])
    if t_seg:                                   # resident target, seg baked in
        return CODE_BASE + t_seg*16 + t_off
    segid = struct.unpack("<H", b[10:12])[0]
    extra = struct.unpack("<H", b[12:14])[0] if loader == 0x0DAB else 0
    return ("ovl", segid, t_off, extra)

# --- source scanning --------------------------------------------------------
C_FILES = None
def c_files():
    global C_FILES
    if C_FILES is None:
        C_FILES = []
        for d, _, fs in os.walk(os.path.join(ROOT, "src")):
            C_FILES += [os.path.join(d, f) for f in fs if f.endswith(".c")]
    return C_FILES

def strip_comments(s):
    s = re.sub(r"/\*.*?\*/", " ", s, flags=re.S)
    return re.sub(r"//[^\n]*", " ", s)

DEF_RE_T = r"(?m)^[A-Za-z_][\w \t\*]*?\b%s\s*\("
def find_definition(name, texts):
    """Locate `name`'s definition; return (param_string, file) or None."""
    pat = re.compile(DEF_RE_T % re.escape(name))
    for path, txt in texts.items():
        for m in pat.finditer(txt):
            i = m.end(); depth = 1
            while i < len(txt) and depth:
                if   txt[i] == "(": depth += 1
                elif txt[i] == ")": depth -= 1
                i += 1
            tail = txt[i:i+160].lstrip()
            if tail.startswith("{"):
                return strip_comments(txt[m.end():i-1]).strip(), path
    return None

def arity_of_params(params):
    if params in ("", "void"): return 0
    depth = 0; n = 1
    for ch in params:
        if ch in "([": depth += 1
        elif ch in ")]": depth -= 1
        elif ch == "," and depth == 0: n += 1
    return n

def call_arities(name, texts):
    """Arities used at every CALL site of `name` (decls/defs excluded)."""
    out = set()
    pat = re.compile(r"\b%s\s*\(" % re.escape(name))
    for txt in texts.values():
        for m in pat.finditer(txt):
            line_start = txt.rfind("\n", 0, m.start()) + 1
            line = txt[line_start:m.start()]
            if "extern" in line or re.match(r"\s*[A-Za-z_][\w \t\*]*$", line) \
               and txt[line_start:m.start()].strip() and not re.search(r"[=(,!&|+\-*/?:;]\s*$", line):
                # crude decl/def guard: a bare type prefix on the same line
                if re.search(r"\b(int|void|char|long|short|uint\d+_t|int\d+_t)\b[\w \t\*]*$", line):
                    continue
            i = m.end(); depth = 1
            while i < len(txt) and depth:
                if   txt[i] == "(": depth += 1
                elif txt[i] == ")": depth -= 1
                i += 1
            out.add(arity_of_params(strip_comments(txt[m.end():i-1]).strip()))
    return out

BANNER_FUNC = re.compile(r"\bfunc_0([0-9A-Fa-f]{5})\b")
def banner_bindings(texts, starts, taken_offsets):
    """offset -> semantic symbol, from single-cite banner blocks."""
    defn = re.compile(r"(?m)^([A-Za-z_][\w \t\*]*?)\b([A-Za-z_]\w+)\s*\(([^;{}]*?)\)\s*\{")
    bind = {}
    for path, txt in texts.items():
        prev_end = 0
        for m in defn.finditer(txt):
            name = m.group(2)
            if name.startswith(("if","for","while","switch","return","sizeof")):
                continue
            gap = txt[prev_end:m.start()]
            prev_end = m.end()
            cites = {int(h,16) for h in BANNER_FUNC.findall(gap[-2500:])}
            cites = {c for c in cites if c in starts and c not in taken_offsets}
            if len(cites) == 1:
                off = cites.pop()
                if off not in bind: bind[off] = name
                elif bind[off] != name: bind[off] = None      # ambiguous
    return {o: n for o, n in bind.items() if n}

# ---------------------------------------------------------------------------
def main():
    for p in (LIB, EXE, FUNCS, SEGMAP, SIGS):
        if not os.path.exists(p): sys.exit(f"missing input: {p}")
    exe     = open(EXE, "rb").read()
    starts  = load_function_starts()
    segmap  = {int(k): v for k, v in json.load(open(SEGMAP)).items()}
    sigs    = json.load(open(SIGS))
    defined, undef = lib_symbols()

    texts = {p: open(p, errors="replace").read() for p in c_files()}

    # offset -> lib symbol (pass 1: func_-prefixed nm symbols are authoritative)
    off2sym = {}
    for s in defined:
        m = re.match(r"func_0([0-9A-Fa-f]{5})", s)
        if m: off2sym.setdefault(int(m.group(1), 16), s)
    # pass 2: banner-bound semantic names (only offsets not already claimed)
    for off, name in banner_bindings(texts, starts, set(off2sym)).items():
        if name in defined: off2sym.setdefault(off, name)

    # every thunk-ish stub symbol the lib still needs
    stub_re = re.compile(r"^(overlay_call|ovly)_([0-9A-Fa-f]{3,4})_([0-9A-Fa-f]{2,4})$")
    stubs = sorted(s for s in undef if stub_re.match(s))

    sorted_starts = sorted(starts)
    import bisect
    def floor_start(off):
        i = bisect.bisect_right(sorted_starts, off) - 1
        return sorted_starts[i] if i >= 0 else None

    wired, report = [], collections.defaultdict(list)
    alias_done = {}
    arity_cache, def_cache = {}, {}

    def target_arity(sym):
        if sym not in arity_cache:
            d = find_definition(sym, texts)
            def_cache[sym] = d
            arity_cache[sym] = arity_of_params(d[0]) if d else None
        return arity_cache[sym]

    def try_wire(stub_sym, tgt_sym, via):
        if stub_sym in alias_done: return
        ta = target_arity(tgt_sym)
        if ta is None:
            report["target definition unparsable"].append((stub_sym, tgt_sym)); return
        if ta > 0:
            cas = call_arities(stub_sym, texts)
            if cas and cas != {ta}:
                report[f"arity mismatch (target wants {ta})"].append(
                    (stub_sym, tgt_sym, sorted(cas))); return
            if not cas:
                report["no call sites found (header-only ref)"].append((stub_sym, tgt_sym)); return
        alias_done[stub_sym] = tgt_sym
        wired.append((stub_sym, tgt_sym, via, ta))

    for s in stubs:
        m = stub_re.match(s)
        seg, off = int(m.group(2), 16), int(m.group(3), 16)
        key = f"0x{seg:04X}:0x{off:04X}"
        e = sigs.get(key, {})
        foff, via = None, None
        # the EXE thunk record is authoritative for window segs -- the json
        # overlay_file_offset column was found systematically stale (0/506
        # agreement; exe-derived offsets hit verified function starts 77% vs 18%)
        if seg in WINDOWS:
            r = thunk_record(exe, seg, off)
            if isinstance(r, int):
                foff, via = r, "exe:resident"
            elif isinstance(r, tuple):
                _, segid, t_off, extra = r
                sm = segmap.get(segid)
                if sm and sm.get("confidence") == "STRONG":
                    foff, via = sm["base"] + extra*16 + t_off, "exe:overlay"
        else:
            cand = CODE_BASE + seg*16 + off
            if cand in starts: foff, via = cand, "direct"
        if foff is None and e.get("overlay_file_offset") is not None:
            foff, via = e["overlay_file_offset"], "json"
        if foff is None:
            report["unresolvable (no exe record, weak segmap, no json)"].append((s, key)); continue
        foff = int(foff)
        tgt = off2sym.get(foff)
        if tgt:
            try_wire(s, tgt, via)
            # also wire the semantic alias name from the signature file
            n = e.get("name")
            if n and n != s and n in undef and n not in alias_done:
                try_wire(n, tgt, via + "+name")
        else:
            base = floor_start(foff)
            if base is not None and base in off2sym and foff != base:
                report["mid-function entry (needs entry split)"].append(
                    (s, f"{off2sym[base]}+0x{foff-base:X}"))
            elif foff in starts:
                report["target is a known function but NOT in the build"].append(
                    (s, f"file 0x{foff:06X}"))
            else:
                report["offset not a known function start"].append((s, hex(foff)))

    # ---- emit ---------------------------------------------------------------
    os.makedirs(GEN, exist_ok=True)
    with open(os.path.join(GEN, "thunk_wiring.ld"), "w") as f:
        f.write("/* AUTO-GENERATED by tools/thunkwire.py -- do not edit.\n"
                " * Each thunk stub becomes the ADDRESS of its real ported target,\n"
                " * so the call site's own argument setup flows into the real body.\n"
                " * Arity-gated: only provably-safe aliases are emitted. */\n")
        for stub, tgt, via, ta in sorted(wired):
            f.write(f"PROVIDE({stub} = {tgt});   /* {via}, arity {ta} */\n")
    with open(os.path.join(GEN, "thunk_keepalive.c"), "w") as f:
        f.write("/* AUTO-GENERATED by tools/thunkwire.py -- do not edit.\n"
                " * Referencing every alias target forces its archive member to be\n"
                " * extracted, so the PROVIDE() aliases always resolve. */\n")
        tgts = sorted({t for _, t, _, _ in wired})
        for t in tgts: f.write(f"extern char {t};\n")
        f.write("\nvoid *viceroy_thunk_keepalive[] = {\n")
        for t in tgts: f.write(f"    (void *)&{t},\n")
        f.write("};\n")
    json.dump({s: t for s, t, _, _ in wired},
              open(os.path.join(GEN, "thunk_wired.json"), "w"), indent=1)

    with open(os.path.join(DOCS, "THUNK_WIRING.md"), "w") as f:
        f.write("# Overlay-thunk wiring (auto-generated by tools/thunkwire.py)\n\n")
        f.write(f"Thunk-pattern stubs referenced by the lib: **{len(stubs)}**\n\n")
        f.write(f"**WIRED (linker alias to the real ported function): {len(wired)}**\n")
        f.write(f"(plus {sum(1 for s in alias_done if not stub_re.match(s))} semantic alias names)\n\n")
        f.write("| stub | target | resolved via | arity |\n|---|---|---|--:|\n")
        for stub, tgt, via, ta in sorted(wired):
            f.write(f"| `{stub}` | `{tgt}` | {via} | {ta} |\n")
        f.write("\n## Not wired (worklist, by reason)\n")
        for reason, items in sorted(report.items(), key=lambda kv: -len(kv[1])):
            f.write(f"\n### {reason} — {len(items)}\n\n")
            for it in items:
                f.write(f"- `{'` | `'.join(str(x) for x in it)}`\n")
        f.write("\n## Regenerate\n```\npython3 tools/thunkwire.py   # then tools/linkgap.py\n```\n")

    print(f"stub symbols examined : {len(stubs)}")
    print(f"WIRED (incl. aliases) : {len(alias_done)}  ({len(wired)} rows)")
    for reason, items in sorted(report.items(), key=lambda kv: -len(kv[1])):
        print(f"  not wired: {len(items):4d}  {reason}")
    print(f"wrote {GEN}/thunk_wiring.ld, thunk_keepalive.c, thunk_wired.json, "
          f"{DOCS}/THUNK_WIRING.md")

if __name__ == "__main__":
    main()
