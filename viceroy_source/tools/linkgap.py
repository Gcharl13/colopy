#!/usr/bin/env python3
# ============================================================================
# linkgap.py -- close the modern-build LINK gap for libviceroy_rules.a
# ----------------------------------------------------------------------------
# PROBLEM
#   The rules library COMPILES clean under -D_VICEROY_MODERN, but it is not yet
#   LINKABLE into an executable: ~1900 symbols are referenced and never defined
#   (DGROUP globals, overlay thunks, not-yet-ported function bodies). Defining
#   them by hand is the bulk of the remaining "make it runnable" work.
#
# WHAT THIS DOES (mechanical, re-runnable, shrinks as real code lands)
#   1. Reads `nm` on the archive -> the TRUE externally-undefined symbol set
#      (referenced-but-undefined MINUS anything the archive itself defines).
#   2. Classifies every undefined symbol:
#        dgroup_global  -- a g_*_HEXADDR data variable whose name encodes its
#                          DGROUP offset.  Resolved BYTE-EXACTLY by aliasing the
#                          symbol onto &g_dgroup[offset] in a linker script.  No
#                          source edit, no separate storage -> the validation
#                          (memcmp vs the original data segment) stays intact.
#        overlay_thunk  -- overlay_call_SEG_OFF / ovly_* .  Weak no-op stub now;
#                          report records whether a resolved target is known
#                          (docs/thunk_signatures.json) so it can be wired later.
#        func_body      -- func_0XXXXX, a not-yet-ported original function.
#        named_gap      -- everything else (helpers in excluded render/ audio/,
#                          or genuinely missing).
#   3. Emits THREE artifacts under tools/generated/ :
#        linkfloor.ld         -- ld fragment: byte-exact DGROUP-global aliases
#        linkfloor_stubs.c    -- __attribute__((weak)) no-op defs for the rest
#        (report)             -- docs/LINK_GAP.md, the shrinking worklist
#
#   Weak stubs are the key to "shrinks automatically": a weak symbol is silently
#   overridden by the first STRONG definition the linker sees.  Port a function
#   (or pull render/*.c back into the build) and its stub simply drops out --
#   re-run linkgap.py and the worklist count falls.  No churn.
#
# SAFETY
#   Only HIGH-CONFIDENCE data names are aliased into g_dgroup (writing to memory,
#   so misclassifying code as data would be catastrophic): a leading data prefix
#   + a SINGLE trailing hex group, never the SEG_OFF double-hex thunk pattern and
#   never a code prefix (func_/near_/cs_/page/overlay_call_/ovly_).  Anything
#   ambiguous falls through to a no-op stub, which is always safe.
#
# USAGE
#   cd viceroy_source && python3 tools/linkgap.py [--lib build_modern/libviceroy_rules.a]
# ============================================================================
import argparse, json, os, re, subprocess, sys, collections

HERE      = os.path.dirname(os.path.abspath(__file__))
ROOT      = os.path.dirname(HERE)                     # viceroy_source/
GEN       = os.path.join(HERE, "generated")
DOCS      = os.path.join(ROOT, "docs")
THUNKS    = os.path.join(DOCS, "thunk_signatures.json")

# --- name patterns ----------------------------------------------------------
# A SEG_OFF overlay address baked into a name: two hex groups, the first 4 wide.
RE_SEGOFF   = re.compile(r"_[0-9A-Fa-f]{4}_[0-9A-Fa-f]{2,4}$")
# A single trailing DGROUP offset: _ABCD or _ABC (3-4 hex), optional _rec suffix.
RE_HEXADDR  = re.compile(r"_([0-9A-Fa-f]{3,4})(_rec)?$")
# Names we will NEVER treat as DGROUP data (they are code or thunks).
RE_CODELIKE = re.compile(r"^(func_0|near_|cs_|page|overlay_call_|ovly_|sub_)")
# Data-ish leading prefixes we trust to alias into g_dgroup.
DATA_PREFIX = re.compile(r"^(g_|revolution_|ff_|king_|native_|colony_|unit_|"
                         r"market_|map_|ai_|hud_flag|panel_|score_flag|"
                         r"turn_|sol_|ref_)")

def nm_symbols(lib):
    """Return (true_undefined, defined_all, defined_data).
    defined_data = B/C/D definitions only (actual storage) -- a T-defined
    g_*_HEX symbol is a legitimate getter FUNCTION named after its offset,
    not a byte-exactness leak."""
    out = subprocess.run(["nm", lib], capture_output=True, text=True).stdout
    defined, defined_data, undef = set(), set(), set()
    for line in out.splitlines():
        p = line.split()
        if len(p) == 3 and p[1] in "TDBRCtdbrc":   # incl. C(ommon)/B(ss) tentative defs
            defined.add(p[2])
            if p[1] in "DBCdbc": defined_data.add(p[2])
        elif len(p) == 2 and p[0] == "U":
            undef.add(p[1])
    return undef - defined, defined, defined_data

def is_dgroup_global(sym):
    """High-confidence DGROUP data name -> returns offset, else None."""
    if (DATA_PREFIX.match(sym) and not RE_CODELIKE.match(sym)
            and not RE_SEGOFF.search(sym)):
        m = RE_HEXADDR.search(sym)
        if m:
            return int(m.group(1), 16)
    return None

def classify(sym, resolved_thunks):
    # overlay thunks ---------------------------------------------------------
    if sym.startswith("overlay_call_") or sym.startswith("ovly_"):
        key = None
        m = re.search(r"_([0-9A-Fa-f]{3,4})_([0-9A-Fa-f]{2,4})$", sym)
        if m:
            key = f"0x{int(m.group(1),16):04X}:0x{int(m.group(2),16):04X}"
        return ("overlay_thunk", resolved_thunks.get(key))
    # not-yet-ported original function bodies --------------------------------
    if sym.startswith("func_0"):
        return ("func_body", None)
    # high-confidence DGROUP data -> byte-exact alias ------------------------
    off = is_dgroup_global(sym)
    if off is not None:
        return ("dgroup_global", off)
    # everything else --------------------------------------------------------
    return ("named_gap", None)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--lib", default=os.path.join(ROOT, "build_modern",
                                                  "libviceroy_rules.a"))
    args = ap.parse_args()
    if not os.path.exists(args.lib):
        sys.exit(f"library not found: {args.lib} (build it first)")

    resolved = {}
    if os.path.exists(THUNKS):
        for k, v in json.load(open(THUNKS)).items():
            if isinstance(v, dict) and v.get("name"):
                resolved[k] = v["name"]

    undef, defined, defined_data = nm_symbols(args.lib)
    # byte-exactness leak: DGROUP-named globals with a stray tentative/strong
    # DATA definition in the library -> they get their OWN storage instead of
    # aliasing into g_dgroup, so memcmp-vs-original silently diverges on them.
    # (T-defined g_*_HEX symbols are getter functions, not leaks.)
    leaks = sorted(s for s in defined_data if is_dgroup_global(s) is not None)

    # mixed-usage hazard: a symbol whose NAME says data but which is CALLED
    # like a function somewhere -> aliasing it into g_dgroup would make those
    # call sites jump into the data segment.  Demote to a weak stub + report.
    # (comments are stripped first -- prose like "g_foo_1234 (was ...)" must
    # not read as a call)
    src_blob = []
    for d, _, fs in os.walk(os.path.join(ROOT, "src")):
        src_blob += [open(os.path.join(d, f), errors="replace").read()
                     for f in fs if f.endswith(".c")]
    src_blob = "\n".join(src_blob)
    src_blob = re.sub(r"/\*.*?\*/", " ", src_blob, flags=re.S)
    src_blob = re.sub(r"//[^\n]*", " ", src_blob)

    buckets = collections.defaultdict(list)
    aliases = {}                                   # sym -> offset
    mixed = []
    for s in sorted(undef):
        kind, info = classify(s, resolved)
        if kind == "dgroup_global" and re.search(r"\b%s\s*\(" % re.escape(s), src_blob):
            mixed.append(s)
            kind, info = "named_gap", None         # weak stub, never an alias
        buckets[kind].append((s, info))
        if kind == "dgroup_global":
            aliases[s] = info

    os.makedirs(GEN, exist_ok=True)

    # 1. linker script: byte-exact DGROUP-global aliases ---------------------
    with open(os.path.join(GEN, "linkfloor.ld"), "w") as f:
        f.write("/* AUTO-GENERATED by tools/linkgap.py -- do not edit.\n"
                " * Byte-exact aliases: each DGROUP global lives at its real\n"
                " * offset inside g_dgroup[], so reads/writes hit the same byte\n"
                " * the original game did.  Supply as an extra linker INPUT file\n"
                " * (not -T) so it augments, not replaces, the default script.\n */\n")
        for s, off in sorted(aliases.items(), key=lambda kv: kv[1]):
            f.write(f"PROVIDE({s} = g_dgroup + 0x{off:X});\n")

    # 2. weak no-op stubs for thunks / func bodies / named gaps --------------
    # symbols already wired to their real targets by thunkwire.py get NO stub
    # (the PROVIDE alias in thunk_wiring.ld must be the only definition)
    wired = {}
    wired_path = os.path.join(GEN, "thunk_wired.json")
    if os.path.exists(wired_path):
        wired = json.load(open(wired_path))
    # symbols aliased by the COMMITTED extra fragment (offsets cited in their
    # former definitions) also get no stub -- PROVIDE can't override a weak def
    extra_ld = os.path.join(HERE, "linkfloor_extra.ld")
    if os.path.exists(extra_ld):
        for sym in re.findall(r"PROVIDE\((\w+)\s*=", open(extra_ld).read()):
            wired[sym] = "linkfloor_extra.ld"
    # NEVER stub a symbol libc/libm provides: a weak stub compiled into the
    # executable beats the shared library (the linker stops searching once a
    # symbol is defined), silently no-op'ing fopen/memcpy/read/...
    libc_syms = set()
    for soname in ("libc.so.6", "libm.so.6"):
        path = subprocess.run(["gcc", f"-print-file-name={soname}"],
                              capture_output=True, text=True).stdout.strip()
        if path and os.path.exists(path):
            out = subprocess.run(["nm", "-D", path], capture_output=True, text=True).stdout
            for ln in out.splitlines():
                p = ln.split()
                if len(p) >= 3 and p[-2] in ("T", "W", "i"):
                    libc_syms.add(p[-1].split("@")[0])
    stub_syms = [s for k in ("overlay_thunk", "func_body", "named_gap")
                 for (s, _) in buckets[k]
                 if s not in wired and s not in libc_syms]
    with open(os.path.join(GEN, "linkfloor_stubs.c"), "w") as f:
        f.write("/* AUTO-GENERATED by tools/linkgap.py -- do not edit.\n"
                " * Weak no-op definitions so the executable LINKS today.  Each is\n"
                " * __attribute__((weak)): the first STRONG definition (a real port,\n"
                " * or render/*.c pulled back into the build) silently overrides it.\n"
                " * Re-run linkgap.py after porting and these shrink automatically.\n */\n"
                "#include \"viceroy_types.h\"\n\n")
        for s in stub_syms:
            f.write(f"__attribute__((weak)) long {s}(void) {{ return 0; }}\n")

    # 3. the shrinking worklist ---------------------------------------------
    total = len(undef)
    with open(os.path.join(DOCS, "LINK_GAP.md"), "w") as f:
        f.write("# Modern-build LINK gap (auto-generated by tools/linkgap.py)\n\n")
        f.write(f"Externally-undefined symbols in `libviceroy_rules.a`: **{total}**\n\n")
        f.write("| category | count | how it closes |\n|---|--:|---|\n")
        rows = [
            ("dgroup_global", "byte-exact `g_dgroup` alias (linkfloor.ld) — DONE on link"),
            ("overlay_thunk", "wire to resolved target, else port the overlay leaf"),
            ("func_body",     "port the original `func_0XXXXX` body"),
            ("named_gap",     "implement, or re-include excluded render/ audio/ source"),
        ]
        for k, how in rows:
            f.write(f"| {k} | {len(buckets[k])} | {how} |\n")
        wired = sum(1 for (_, i) in buckets["overlay_thunk"] if i)
        f.write(f"\nOf {len(buckets['overlay_thunk'])} overlay thunks, "
                f"**{wired}** already have a resolved target name in "
                f"`thunk_signatures.json` (ready to wire).\n\n")
        f.write("## Generated artifacts\n"
                "- `tools/generated/linkfloor.ld` — byte-exact DGROUP-global aliases\n"
                "- `tools/generated/linkfloor_stubs.c` — weak no-op floor for the rest\n\n")
        f.write(f"## Byte-exactness leak — {len(leaks)} DGROUP globals defined in-lib\n\n"
                "These carry a DGROUP-offset name but have a stray tentative/strong\n"
                "definition in the source, so they get their OWN storage instead of\n"
                "aliasing into `g_dgroup` — `memcmp` vs the original data segment will\n"
                "diverge on them. Fix: change the definition to `extern` (or delete it)\n"
                "so the `linkfloor.ld` alias takes over.\n\n")
        for s in leaks:
            f.write(f"- `{s}`\n")
        f.write("\n")
        f.write(f"## Mixed data/function usage — {len(mixed)} symbols (porter "
                "inconsistency)\n\n"
                "Named like DGROUP data but CALLED like a function somewhere in\n"
                "src/ — one file modeled the offset as a variable, another as a\n"
                "getter. NOT aliased (a call would jump into the data segment);\n"
                "each gets a weak stub until the two models are reconciled.\n\n")
        for s in mixed:
            f.write(f"- `{s}`\n")
        f.write("\n")
        f.write("## named_gap detail (the real worklist — sample)\n\n")
        for s, _ in buckets["named_gap"][:60]:
            f.write(f"- `{s}`\n")

    print(f"undefined symbols: {total}")
    for k in ("dgroup_global", "overlay_thunk", "func_body", "named_gap"):
        print(f"  {k:16} {len(buckets[k])}")
    print(f"aliased byte-exact: {len(aliases)}   weak-stubbed: {len(stub_syms)}")
    print(f"byte-exactness leaks (DGROUP globals defined in-lib): {len(leaks)}")
    print(f"wrote {GEN}/linkfloor.ld, {GEN}/linkfloor_stubs.c, {DOCS}/LINK_GAP.md")

if __name__ == "__main__":
    main()
