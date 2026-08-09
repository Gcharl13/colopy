#!/usr/bin/env python3
"""GENERATOR — run this on the REPO machine, never inside Ghidra.

Emits the self-contained Ghidra scripts for VICEROY.EXE.

Everything this project knows about VICEROY's symbols — 1,250 function
boundaries, the 89 real 1994 CodeView names carried over from MAPEDIT, the
137-module map, the 31 overlay pages, ~150 named DGROUP globals and the five
record layouts — packaged so Ghidra stops showing FUN_0002d658 / DAT_00008542
and starts showing colony_turn_end_status / g_current_colony_ptr.

Outputs (all committed, regenerate any time):
  tools/ghidra/viceroy_ghidra_symbols.py   IMPORT  — run this one in Ghidra
  tools/ghidra/viceroy_ghidra_export.py    EXPORT  — run in Ghidra to send
                                                     your edits back to the repo
  tools/ghidra/viceroy_types.h             reference copy of the layouts

This file reads the repo's JSON and WRITES those; it needs the repo tree and
plain CPython.  Copying it into ghidra_scripts/ and running it there fails on
the first repo path it touches.

Address model (verified against the bytes, see tools/ghidra/README.md):
  MZ header      = 0x2400 (576 paragraphs)
  DGROUP in file = 0x1D9A0   (DS:0x2166 -> "AMER2.MP", 7/7 string probes hit)
  load image     = file 0x2400 .. 0x22A65
  overlay pages  = file 0x20EE0 .. 0x78D40  (31 RTLink pages)

Because the overlays live PAST the load image, a normal MZ load in Ghidra maps
only ~a quarter of the code.  The script therefore targets a RAW BINARY load
(16-bit x86, base 0), where Ghidra address == file offset and all 31 overlay
pages are present.  A delta constant covers the MZ-load case.
"""
import hashlib
import json
import re
from pathlib import Path

if "currentProgram" in dir():          # pragma: no cover - Ghidra only
    raise SystemExit(
        "\n" + "=" * 68 +
        "\nWRONG SCRIPT. This is the GENERATOR; it runs on the repo machine."
        "\n" + "=" * 68 +
        "\nIt reads the repo's JSON and writes the Ghidra scripts. Inside"
        "\nGhidra there is no repo, so it dies on the first path it touches."
        "\n"
        "\nRun in Ghidra instead:"
        "\n    viceroy_ghidra_symbols.py   - import names, types, thunks"
        "\n    viceroy_ghidra_export.py    - send your edits back to the repo"
        "\n"
        "\nBoth are produced by running THIS file on the repo machine:"
        "\n    python3 tools/ghidra/make_ghidra_scripts.py"
        "\n" + "=" * 68)

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

# Outputs always land next to THIS file, so a bundled copy is self-contained.
OUT_PY = HERE / "viceroy_ghidra_symbols.py"
OUT_EXPORT = HERE / "viceroy_ghidra_export.py"
OUT_H = HERE / "viceroy_types.h"

# Every repo file this generator reads.  `--bundle DIR` copies exactly this
# list, so the two never drift apart.
INPUTS = [
    "data_extracted/viceroy_modules.json",
    "tools/viceroy_symbols.json",
    "tools/rtlink/event_emitters.json",
    "tools/rtlink/viceroy_rtlink_map.json",
    "code/VICEROY/overlay_thunks.json",
    "code/VICEROY/overlay_pages.json",
]
INPUT_DIRS = [
    "code/VICEROY/disasm_overlay_reseg",     # 31 page_XX.asm
]
OPTIONAL_INPUTS = [
    "data_extracted/ghidra_user_symbols.json",   # created by the merge script
]


def find_input(rel):
    """Locate an input whether we are in the repo or in a flat bundle.

    Search order: flat beside this script, then the same relative path beside
    it, then the canonical repo path.  That lets you drop every input into one
    folder with the generator and run it there, without maintaining a second
    copy of the path list.
    """
    name = rel.rsplit("/", 1)[-1]
    for cand in (HERE / name, HERE / rel, ROOT / rel):
        if cand.exists():
            return cand
    return ROOT / rel          # report the canonical path in the error


def bundle(dest):
    """Copy the generator and every input it needs into one directory."""
    import shutil
    dest = Path(dest).resolve()
    dest.mkdir(parents=True, exist_ok=True)
    n = 0
    for rel in INPUTS + OPTIONAL_INPUTS:
        src = find_input(rel)
        if not src.exists():
            if rel in OPTIONAL_INPUTS:
                continue
            raise SystemExit("missing required input: %s" % src)
        shutil.copy2(src, dest / src.name)
        n += 1
    for rel in INPUT_DIRS:
        src = find_input(rel)
        if not src.is_dir():
            raise SystemExit("missing required input directory: %s" % src)
        out = dest / src.name
        if out.exists():
            shutil.rmtree(out)
        shutil.copytree(src, out)
        n += len(list(out.iterdir()))
    for extra in (Path(__file__).resolve(), HERE / "merge_ghidra_export.py",
                  HERE / "README.md"):
        if extra.exists():
            shutil.copy2(extra, dest / extra.name)
            n += 1
    print("bundled %d files into %s" % (n, dest))
    print("")
    print("That directory is now self-contained.  Run:")
    print("    python3 %s/make_ghidra_scripts.py" % dest)
    print("and the two Ghidra scripts appear in the same directory.")
    raise SystemExit(0)

HEADER = 0x2400
DGROUP_FILE = 0x1D9A0
LOAD_IMAGE_END = 0x22A65


def load_user_syms():
    """Names authored by hand in Ghidra, round-tripped back into the repo.

    Written by tools/ghidra/merge_ghidra_export.py.  Kept in its own file and
    its own tier (`U`) rather than merged into the evidence files, so a human
    judgement can never be mistaken later for a byte citation.
    """
    p = find_input("data_extracted/ghidra_user_symbols.json")
    if not p.exists():
        return {"functions": {}, "globals": {},
                "plate_comments": {}, "eol_comments": {}}
    d = json.loads(p.read_text())
    for k in ("functions", "globals", "plate_comments", "eol_comments"):
        d.setdefault(k, {})
    n = sum(len(d[k]) for k in
            ("functions", "globals", "plate_comments", "eol_comments"))
    if n:
        print("user symbols from Ghidra: %d functions, %d globals, "
              "%d plate, %d EOL"
              % (len(d["functions"]), len(d["globals"]),
                 len(d["plate_comments"]), len(d["eol_comments"])))
    return d


USER_SYMS = load_user_syms()


def sanitize(name):
    """Ghidra-safe identifier."""
    n = name.replace("@", "at_").replace("\\", "_").replace(".", "_")
    n = re.sub(r"[^A-Za-z0-9_]", "_", n)
    if n and n[0].isdigit():
        n = "f_" + n
    return n


# Names Ghidra injects into a script's namespace at run time.  Anything the
# generated script reads that is not here, not a builtin, and not bound in the
# script itself is a generation bug.
GHIDRA_INJECTED = {
    "currentProgram", "currentAddress", "currentLocation", "currentSelection",
    "currentHighlight", "state", "monitor", "toAddr", "getBytes", "setBytes",
    "createLabel", "createFunction", "createBookmark", "setPlateComment",
    "setEOLComment", "setPreComment", "setPostComment",
    "getFunctionAt", "getFunctionContaining", "getInstructionAt", "getDataAt",
    "createData", "clearListing", "askYesNo", "popup", "println", "printerr",
    "getScriptArgs",
}


_ASM_LINE = re.compile(
    r"^\s+([0-9A-F]{6})\s+([0-9A-F]{4}):\s+\S+\s+(.*?)\s*$")
_LCALL = re.compile(r"^lcall\s+0x([0-9a-f]+),\s*0x([0-9a-f]+)$")
_NCALL = re.compile(r"^call\s+0x([0-9a-f]+)$")
_ADDSP = re.compile(r"^add sp, (?:0x)?([0-9a-fA-F]+)$")


def derive_arg_counts(names_by_offset, thunk_target_by_stub):
    """Recover argument counts from the CALLERS, byte-verified.

    16-bit cdecl makes the caller clean the stack, so a call followed by
    `add sp, N` says the callee took N/2 words of arguments.  That is evidence
    in the instruction stream, not an inference from the callee's prologue —
    and it is corroborated many times over, because most functions are called
    from several sites that must all agree.

    Two call forms are read:
      far  `lcall seg:off`  -> an RTLink thunk stub; the real callee comes
                               from the same resolution used for the thunk
                               annotations
      near `call 0xIP`      -> an IP inside the current overlay page, so the
                               callee is page_base + IP

    ACCEPTED only when every observed call site agrees.  A target whose
    callers disagree is dropped, not averaged — disagreement means either a
    varargs callee or a mis-parsed site, and neither justifies a number.
    ABSENCE of `add sp` is NOT read as "zero arguments": compilers defer and
    coalesce stack cleanup, so silence is unknown, not zero.

    Validated against the seven thunk signatures transcribed by hand in
    viceroy_source/src/native/page0B_native_raid.c — 7/7 agree.
    """
    import collections
    d = find_input("code/VICEROY/disasm_overlay_reseg")
    if not d.is_dir():
        print("arg counts: skipped (no resegmented disasm)")
        return {}

    votes = collections.defaultdict(collections.Counter)
    for path in sorted(d.glob("page_*.asm")):
        rows = []
        for line in path.read_text(errors="ignore").splitlines():
            m = _ASM_LINE.match(line)
            if m:
                rows.append((int(m.group(1), 16), int(m.group(2), 16),
                             m.group(3)))
        if not rows:
            continue
        page_base = rows[0][0] - rows[0][1]
        for i, (file_off, _ip, text) in enumerate(rows):
            m = _LCALL.match(text)
            if m:
                stub = HEADER + int(m.group(1), 16) * 16 + int(m.group(2), 16)
                target = thunk_target_by_stub.get(stub)
            else:
                m = _NCALL.match(text)
                target = page_base + int(m.group(1), 16) if m else None
            if target is None:
                continue
            for j in range(i + 1, min(i + 3, len(rows))):
                a = _ADDSP.match(rows[j][2])
                if a:
                    votes[target][int(a.group(1), 16) // 2] += 1
                    break

    out, split, unknown = {}, 0, 0
    for target, counter in votes.items():
        if target not in names_by_offset:
            unknown += 1
            continue
        if len(counter) != 1:
            split += 1
            continue
        n = next(iter(counter))
        if 0 < n <= 16:
            out[target] = {"n": n, "sites": counter[n]}

    print("arg counts: %d functions given a signature from caller stack "
          "cleanup" % len(out))
    print("   dropped: %d with disagreeing callers, %d not a known function"
          % (split, unknown))
    return out


def resolve_thunks(names_by_offset):
    """Resolve RTLink thunk stubs to the functions they actually reach.

    Every cross-page call in VICEROY goes `lcall <thunkseg>:<off>` into a stub
    in the load-image thunk table (file 0x1A5F0..0x1D5E6); the stub calls the
    RTLink runtime, which pages the overlay in and jumps on.  In a static
    listing that whole chain is opaque, so each inter-module call decompiles
    as an anonymous FUN_ with no hint of what it does.

    Two byte-verified paths to the target, per tools/rtlink and
    code/VICEROY/overlay_thunks.md:

      type B (362): the LJMP already carries seg:off.  Those segments are
        load-image relative, so target file = 0x2400 + seg*16 + off — the
        same formula the load image uses everywhere else.

      type A (658): the LJMP segment is 0, patched by the loader at run time.
        The 4 trailer bytes carry it: trailer_word_1 is the overlay PAGE id
        (observed range 1..31, exactly the 31 pages), and the LJMP offset is
        an IP within that page's code, so target file = page.code_offset +
        ljmp_off.

    ACCEPTANCE: a resolution counts only if it lands EXACTLY on a known
    function start.  That is a real test, not a formatting check — an
    off-by-one in either formula would scatter the results across mid-function
    addresses instead of hitting boundaries.  Anything that misses is dropped
    rather than guessed at, so an unresolved call site simply gets no comment.
    """
    thunk_file = find_input("code/VICEROY/overlay_thunks.json")
    pages_file = find_input("code/VICEROY/overlay_pages.json")
    if not (thunk_file.exists() and pages_file.exists()):
        print("thunk resolution: skipped (overlay_thunks/overlay_pages absent)")
        return []

    entries = json.loads(thunk_file.read_text())["thunks"]
    pages = json.loads(pages_file.read_text())["pages"]
    code_off = {int(k, 16): int(v["code_offset"], 16) for k, v in pages.items()}

    out, stats = [], {"B": 0, "A": 0, "miss_B": 0, "miss_A": 0, "unpatched": 0}
    for t in entries:
        stub = t["thunk_offset"]
        seg, off = t["ljmp_seg"], t["ljmp_off"]
        if seg:
            target, how = HEADER + seg * 16 + off, "B"
        else:
            page = t.get("trailer_word_1")
            if page is None or page not in code_off:
                stats["unpatched"] += 1
                continue
            target, how = code_off[page] + off, "A"
        nm = names_by_offset.get(target)
        if nm is None:
            stats["miss_" + how] += 1
            continue
        stats[how] += 1
        out.append({"a": stub, "t": target, "n": nm, "h": how})

    print("thunk resolution: %d/%d call targets recovered "
          "(%d type-B direct, %d type-A via page trailer)"
          % (len(out), len(entries), stats["B"], stats["A"]))
    print("   unresolved: %d off a function start, %d with no page id"
          % (stats["miss_B"] + stats["miss_A"], stats["unpatched"]))
    return out


WIDTH = {"u8": 1, "s8": 1, "char": 1, "u16": 2, "s16": 2, "u32": 4, "s32": 4}

# Legacy per-field global names whose OFFSET agrees with the struct but whose
# NAME disagrees.  Recorded, not silently resolved — see notes/TRUTH_HIERARCHY.
KNOWN_NAME_CONFLICTS = {
    0x5DE0: ("MARKET_PRICE_5DE0", "ColonyRecord.stock",
             "a colony record holds warehouse stock, not market prices; the "
             "legacy name is unsourced. Offsets agree, so the layout is not "
             "in doubt — only the label."),
}


def verify_field_aliases(globs, tables):
    """Cross-check the struct layouts against the standalone global symbols.

    Many DGROUP globals were named field-by-field long before these structs
    existed (UNIT_Y at 0x3145, COL_OWNER_5D60, ...).  Each such name that
    falls inside a record table is an INDEPENDENT witness to that record's
    base and stride: if a legacy address does not land exactly on a field
    boundary of element 0, one of the two is wrong.

    Also refuses silently-broken geometry: overlapping fields, fields running
    past the stride, arrays colliding, arrays leaving the 64 KB window.
    """
    problems = []
    for t in tables:
        occupied = {}
        for f in t["fields"]:
            w = WIDTH[f["t"]] * (f["c"] or 1)
            if f["o"] + w > t["stride"]:
                problems.append("%s.%s runs to +0x%X, past stride 0x%X"
                                % (t["name"], f["nm"], f["o"] + w, t["stride"]))
            for b in range(f["o"], f["o"] + w):
                if b in occupied:
                    problems.append("%s: %s overlaps %s at +0x%X"
                                    % (t["name"], occupied[b], f["nm"], b))
                occupied[b] = f["nm"]
        t["_starts"] = {f["o"] for f in t["fields"]}

    spans = sorted((t["ds"], t["ds"] + t["n"] * t["stride"], t["name"])
                   for t in tables)
    for (s1, e1, n1), (s2, e2, n2) in zip(spans, spans[1:]):
        if e1 > s2:
            problems.append("array %s [0x%X,0x%X) overlaps %s [0x%X,0x%X)"
                            % (n1, s1, e1, n2, s2, e2))
    for s, e, n in spans:
        if e > 0x10000:
            problems.append("array %s ends 0x%X, past the 64 KB DGROUP window"
                            % (n, e))

    agree = conflict = stray = 0
    for t in tables:
        lo, hi = t["ds"], t["ds"] + t["n"] * t["stride"]
        for g in globs:
            if not (lo < g["ds"] < hi):
                continue
            off = (g["ds"] - lo) % t["stride"]
            if off in t["_starts"]:
                if g["ds"] in KNOWN_NAME_CONFLICTS:
                    conflict += 1
                else:
                    agree += 1
            else:
                stray += 1
                problems.append(
                    "legacy global %s (DS:0x%04X) sits at %s+0x%X, which is "
                    "not a field boundary — base/stride or the symbol is wrong"
                    % (g["n"], g["ds"], t["name"], off))
    for t in tables:
        del t["_starts"]

    print("field-alias cross-check: %d legacy globals land exactly on struct "
          "field offsets" % agree)
    for addr, (old, new, why) in sorted(KNOWN_NAME_CONFLICTS.items()):
        print("  NAME CONFLICT DS:0x%04X  %s vs %s" % (addr, old, new))
        print("    %s" % why)
    if problems:
        raise SystemExit("REFUSING TO WRITE: record geometry is inconsistent\n"
                         + "\n".join("    " + p for p in problems))


def check_free_names(body):
    """Refuse to write a script that reads a name nothing defines.

    SCRIPT_TEMPLATE is a *string*, so a constant living only in this
    generator's namespace is invisible to every local test and then dies as a
    NameError inside Ghidra — after the run has already half-applied itself.
    That is exactly how LOAD_IMAGE_END shipped broken on 2026-08-08.
    """
    import ast
    import builtins

    tree = ast.parse(body)
    bound = set(dir(builtins)) | GHIDRA_INJECTED
    for node in ast.walk(tree):
        if isinstance(node, (ast.FunctionDef, ast.ClassDef)):
            bound.add(node.name)
            args = getattr(node, "args", None)
            if args is not None:
                bound.update(a.arg for a in
                             args.posonlyargs + args.args + args.kwonlyargs)
                for extra in (args.vararg, args.kwarg):
                    if extra is not None:
                        bound.add(extra.arg)
        elif isinstance(node, ast.Name) and isinstance(node.ctx, ast.Store):
            bound.add(node.id)
        elif isinstance(node, (ast.Import, ast.ImportFrom)):
            bound.update((a.asname or a.name).split(".")[0] for a in node.names)
        elif isinstance(node, ast.ExceptHandler) and node.name:
            bound.add(node.name)
        elif isinstance(node, ast.comprehension):
            bound.update(n.id for n in ast.walk(node.target)
                         if isinstance(n, ast.Name))

    free = {}
    for node in ast.walk(tree):
        if isinstance(node, ast.Name) and isinstance(node.ctx, ast.Load):
            free.setdefault(node.id, node.lineno)

    missing = sorted((n, ln) for n, ln in free.items() if n not in bound)
    if missing:
        raise SystemExit(
            "REFUSING TO WRITE %s\n"
            "the generated script reads name(s) nothing defines:\n%s\n"
            "Define them inside SCRIPT_TEMPLATE, not just in this generator."
            % (OUT_PY, "\n".join("    %s   (line %d)" % m for m in missing)))


def main():
    mods = json.loads(find_input("data_extracted/viceroy_modules.json").read_text())
    syms = json.loads(find_input("tools/viceroy_symbols.json").read_text())
    emitters = json.loads(
        find_input("tools/rtlink/event_emitters.json").read_text())
    rtl = json.loads(
        find_input("tools/rtlink/viceroy_rtlink_map.json").read_text())

    # --- GAME.TXT keys per emitting function ------------------------------
    keys_by_func = {}
    for key, rec in emitters.items():
        if not isinstance(rec, dict):
            continue
        for e in rec.get("emitters", []):
            keys_by_func.setdefault(e.get("func", ""), []).append(key)

    # --- functions --------------------------------------------------------
    page_label = {p: v["module"] for p, v in mods["page_labels"].items()}
    funcs = []
    for r in mods["functions"]:
        off = int(r["file_offset"], 16)
        real = r.get("real_name") or ""
        role = r.get("name") or ""
        module = r.get("module") or ""
        page = r.get("page") or ""
        # Only tier-B anchors are CONFIRMED CodeView names (the whole MAPEDIT
        # function matched instruction-for-instruction).  Tier-A `real_name`s
        # come from PARTIAL fingerprint matches, which the matcher itself
        # calls leads, not assignments — mostly shared compiler prologues.
        # Applying those as symbol names would launder a guess into a fact,
        # so they go in the comment as a candidate and the symbol keeps its
        # module-derived name.
        confirmed = real if r.get("tier") == "B" else ""
        lead = real if (real and r.get("tier") != "B") else ""

        if confirmed:
            nm = sanitize(confirmed)
            tier = "B"                       # real 1994 CodeView name
        elif role and role != "unknown" and not role.startswith("func_"):
            nm = sanitize(role)
            tier = "R"                       # role name from analysis
        else:
            base = sanitize(module).strip("_") or "unattributed"
            nm = "%s_%06X" % (base, off)
            tier = "M"                       # module-derived placeholder
        # A name you wrote in Ghidra and exported wins over the generated
        # placeholder — but NEVER over a confirmed 1994 CodeView name, and it
        # is tiered `U` so the plate comment says where it came from.  See
        # tools/ghidra/merge_ghidra_export.py on why this is a separate tier.
        user = USER_SYMS["functions"].get("0x%06X" % off)
        if user and tier != "B":
            nm, tier = sanitize(user), "U"

        funcs.append({
            "a": off, "n": nm, "t": tier, "m": module, "p": page,
            "s": r.get("size") or 0, "lead": lead,
            "k": keys_by_func.get("func_%06X" % off, []),
        })

    # --- overlay page blocks ---------------------------------------------
    pages = [{"id": "%02X" % s["page_id"], "a": s["code_offset"],
              "z": s["code_size"]} for s in rtl["segments"]]

    # --- RTLink thunks: resolve cross-page calls to their real targets ----
    names_by_offset = {f["a"]: f["n"] for f in funcs}
    thunks = resolve_thunks(names_by_offset)

    # --- argument counts, from caller-side stack cleanup ------------------
    nargs = derive_arg_counts(names_by_offset,
                              {t["a"]: t["t"] for t in thunks})
    for f in funcs:
        got = nargs.get(f["a"])
        if got:
            f["na"] = got["n"]
            f["nas"] = got["sites"]

    # --- DGROUP globals ---------------------------------------------------
    globs = []
    for k, v in syms["globals"].items():
        ds = int(k, 16)
        v = USER_SYMS["globals"].get("0x%04X" % ds, v)
        globs.append({"ds": ds, "n": sanitize(v),
                      "f": DGROUP_FILE + ds,
                      "init": (DGROUP_FILE + ds) < LOAD_IMAGE_END})
    globs.sort(key=lambda g: g["ds"])

    # ---------------------------------------------------------------- emit
    tables = [{"name": n, "ds": base, "stride": stride,
               "count": ("g_colony_count" if n == "ColonyRecord" else
                         "g_unit_count" if n == "UnitRecord" else
                         "g_settlement_count" if n == "NativeSettlement" else
                         "fixed 4"),
               "n": DISPLAY_COUNTS[n],
               "fields": [{"o": o, "t": t, "nm": nm, "c": c}
                          for o, t, nm, c in fields]}
              for n, base, stride, _s, fields in RECORDS]

    data = {"funcs": funcs, "pages": pages, "globals": globs,
            "records": syms["record_windows"], "tables": tables,
            "thunks": thunks}

    payload = json.dumps(data, indent=0)
    body = SCRIPT_TEMPLATE.replace("@@DATA@@", payload)
    exp = EXPORT_TEMPLATE.replace("@@DATA@@", payload)

    # Content-addressed build stamp, printed as each script's first line at
    # run time.  Sole purpose: make "am I running the file I just generated?"
    # answerable in one glance instead of by comparing tracebacks.
    #
    # It covers BOTH scripts.  Stamping only the import body meant a fix to
    # the export script left the stamp unchanged, so the one check the user
    # has would have said "current" about a stale file.
    stamp = hashlib.sha256((body + exp).encode()).hexdigest()[:12]
    body = body.replace("@@STAMP@@", stamp)
    exp = exp.replace("@@STAMP@@", stamp)

    check_free_names(body)
    OUT_PY.write_text(body)

    # The export script shares the payload: it has to know the exact baseline
    # the import laid down, or "what changed" is meaningless.
    check_free_names(exp)
    OUT_EXPORT.write_text(exp)

    print("record layouts:")
    verify_records()
    verify_field_aliases(globs, tables)
    OUT_H.write_text(build_header(syms))

    b = sum(1 for f in funcs if f["t"] == "B")
    r = sum(1 for f in funcs if f["t"] == "R")
    leads = sum(1 for f in funcs if f.get("lead"))
    print("functions : %d  (%d CONFIRMED CodeView names, %d role names, "
          "%d module-derived)" % (len(funcs), b, r, len(funcs) - b - r))
    print("            %d unconfirmed candidates noted in comments only" % leads)
    print("globals   : %d  (%d initialised/in-file)"
          % (len(globs), sum(1 for g in globs if g["init"])))
    print("pages     : %d" % len(pages))
    print("->", OUT_PY, "  (run this one in Ghidra)")
    print("->", OUT_EXPORT, "  (run in Ghidra to send edits back)")
    print("->", OUT_H)
    print("")
    print("BUILD %s" % stamp)
    print("The script prints this as its FIRST line in Ghidra's console.")
    print("If the two do not match, Ghidra is running an older copy that is")
    print("still sitting in ghidra_scripts/ - replace it and re-run.")


# Curated record layouts with REAL field widths.  Deriving these from
# viceroy_symbols.json's record_fields gives byte-correct strides but types
# every field `u8`, which is useless in the decompiler (`colony->gold` must
# read as a 32-bit value, `stock[]` as a u16 array).  Sources per record are
# cited below; unknown spans are emitted as padding, never invented.
#
# (offset, ctype, name, count)   count None = scalar
# How many elements to lay down when the script applies each table as an
# array.  The real counts are runtime values (zero in a static dump), and the
# decompiler resolves base + i*stride from the ELEMENT type, not the length —
# so these are display convenience, chosen generous.  The block is 64 KB;
# nothing here overflows it.
DISPLAY_COUNTS = {
    "ColonyRecord": 16,
    "UnitRecord": 64,
    "PowerRecord": 4,          # fixed: four European powers
    "NativeSettlement": 32,
    "AIPersonality": 4,        # fixed: one per power
}

RECORDS = [
    ("ColonyRecord", 0x5D46, 0xCA,
     "spec/systems/save.md (SAV cross-decode, 2026-08-08) + DATA_MODEL.md", [
         (0x00, "u8", "map_x", None),
         (0x01, "u8", "map_y", None),
         (0x02, "char", "name", 24),
         (0x1A, "u8", "owner_power", None),
         (0x1C, "u8", "colony_flags", None),        # b1 SoL100 b2 SoL50 b7 blink
         (0x1F, "u8", "population", None),
         (0x20, "u8", "occupation", 32),            # per-colonist job
         (0x40, "u8", "profession", 32),            # per-colonist specialty
         (0x60, "u8", "work_duration", 16),         # 4-bit pairs
         (0x70, "s8", "tiles", 8),                  # N,E,S,W,NW,NE,SE,SW
         (0x84, "u8", "buildings", 6),              # 48-bit TIER-PACKED
         (0x8A, "u16", "custom_house_flags", None),
         (0x92, "u16", "hammers", None),
         (0x94, "u8", "building_in_production", None),
         (0x95, "u8", "warehouse_level", None),
         (0x97, "u8", "depletion_counter", None),
         (0x98, "u16", "hammers_purchased", None),
         (0x9A, "u16", "stock", 16),
         (0xBA, "u8", "population_on_map", 4),
         (0xBE, "u8", "fortification_on_map", 4),
         (0xC2, "s32", "rebel_dividend", None),
         (0xC6, "s32", "rebel_divisor", None),
     ]),
    ("UnitRecord", 0x3144, 0x1C,
     "docs/DATA_MODEL.md + tools/viceroy_symbols.json", [
         (0x00, "u8", "map_x", None),
         (0x01, "u8", "map_y", None),
         (0x02, "u8", "type", None),
         (0x03, "u8", "owner_flags", None),         # low nibble = nation
         (0x04, "u8", "flags", None),
         (0x06, "u8", "moves_remaining", None),
         (0x07, "u8", "profession", None),
         (0x08, "u8", "orders", None),
         (0x09, "u8", "goto_x", None),
         (0x0A, "u8", "goto_y", None),
         (0x0C, "u8", "cargo_slot_count", None),
         (0x0D, "u8", "cargo_kind_packed", 3),
         (0x10, "u8", "cargo_qty", 4),
         (0x15, "u8", "class_profession", None),
         (0x16, "u8", "turn_counter", None),
         (0x17, "u8", "vet_type", None),
         (0x18, "u16", "chain_prev", None),
         (0x1A, "u16", "chain_next", None),
     ]),
    ("PowerRecord", 0x8808, 0x13C,
     "docs/DATA_MODEL.md (byte-verified offsets) + the SAV decode", [
         (0x01, "u8", "tax_rate", None),
         (0x02, "u8", "dock_pool", 3),
         (0x07, "s32", "founding_fathers_bitmap", None),
         (0x0C, "u16", "liberty_bells", None),
         (0x0E, "u16", "bell_pool", None),
         (0x10, "u16", "crosses_per_turn", None),
         (0x12, "u16", "ff_pending_slot", None),
         (0x14, "u16", "founding_fathers_count", None),
         (0x1E, "u16", "artillery_bought_count", None),
         (0x20, "u16", "boycott_mask", None),
         (0x22, "s32", "royal_money", None),
         (0x2A, "s32", "gold", None),
         (0x2E, "u16", "crosses_accum", None),
         (0x30, "u16", "cross_threshold", None),
         (0x32, "u8", "home_x", None),
         (0x33, "u8", "home_y", None),
         (0x34, "u8", "war_matrix", 12),
         (0x40, "u8", "treaty_relation", 4),
         (0x44, "u8", "ref_dragoons", None),
         (0x45, "u8", "ref_regulars", None),
         (0x46, "u8", "ref_artillery", None),
         (0x4C, "u8", "market_price", 16),
         (0x5C, "u16", "market_pool", 16),
         (0x7C, "s32", "market_traded_value", 16),
         (0xBC, "s32", "market_traded_tons", 16),
         (0xFC, "s32", "market_base_value", 16),
     ]),
    ("NativeSettlement", 0x54EC, 0x12,
     "spec/systems/save.md + smcol cross-check", [
         (0x00, "u8", "map_x", None),
         (0x01, "u8", "map_y", None),
         (0x02, "u8", "tribe", None),               # importSav: tribe = this - 4
         (0x03, "u8", "flags", None),               # b2 capital, b3 chief_seen
         (0x04, "u8", "population", None),
         (0x05, "u8", "mission", None),             # 0xFF none
         (0x06, "u8", "growth_counter", None),
         (0x0A, "u16", "alarm_by_power", 4),
     ]),
    ("AIPersonality", 0x540E, 0x34,
     "tools/viceroy_symbols.json (mostly unmapped)", [
         (0x30, "u8", "field_30", None),
         (0x31, "u8", "controller_flag", None),     # 0 = human seat
         (0x32, "u8", "named_colony_count", None),
     ]),
]

SIZEOF = {"u8": 1, "s8": 1, "char": 1, "u16": 2, "s16": 2, "s32": 4}


def verify_records():
    """Arithmetic self-check: fields must not overlap and must fit the stride.

    NOT done with a host C compiler: `s32` is `signed long`, which is 4 bytes
    under Ghidra's 16-bit x86 compiler spec (and in the 1994 build) but 8 on
    an LP64 host, so a gcc sizeof() check reports false failures.  The layout
    is checked here in the units that actually matter — byte offsets.
    """
    for name, base, stride, _src, fields in RECORDS:
        pos = 0
        for off, ctype, fname, count in sorted(fields):
            if off < pos:
                raise SystemExit("%s.%s at 0x%X overlaps previous field end 0x%X"
                                 % (name, fname, off, pos))
            pos = off + SIZEOF[ctype] * (count or 1)
        if pos > stride:
            raise SystemExit("%s overruns its stride: 0x%X > 0x%X"
                             % (name, pos, stride))
        mapped = sum(SIZEOF[c] * (n or 1) for _, c, _, n in fields)
        print("  %-18s stride 0x%-4X mapped %3d/%3d bytes (%d%%)"
              % (name, stride, mapped, stride, 100 * mapped // stride))


def build_header(syms):
    """C header for Ghidra's File > Parse C Source.

    Byte-granular by construction: every gap becomes an explicit u8 pad array
    and each struct is asserted to total its true stride, so Ghidra's
    alignment rules cannot shift a field.
    """
    out = [
        "/* VICEROY.EXE record layouts — generated by",
        " * tools/ghidra/make_ghidra_scripts.py.  DO NOT hand-edit.",
        " *",
        " * Ghidra:  File > Parse C Source  (see tools/ghidra/README.md).",
        " * Every struct is padded to its byte-verified stride and contains",
        " * only byte-granular members, so no alignment rule can move a",
        " * field.  Unmapped spans are `_pad`, never invented names.",
        " *",
        " * IMPORTANT — parse this against the 16-BIT PROGRAM, not a 64-bit",
        " * architecture: `s32` is `signed long`, which is 4 bytes under",
        " * Ghidra's 16-bit x86 compiler spec (as in the 1994 build) but 8",
        " * under an LP64 spec, which would silently shift every field after",
        " * the first s32 and corrupt the layout.",
        " */",
        "",
        "typedef unsigned char  u8;",
        "typedef signed char    s8;",
        "typedef unsigned short u16;",
        "typedef signed short   s16;",
        "typedef signed long    s32;",
        "",
    ]
    for name, base, stride, source, fields in RECORDS:
        out.append("/* %s — DGROUP base 0x%04X, stride 0x%X (%d bytes)" %
                   (name, base, stride, stride))
        out.append(" * source: %s */" % source)
        out.append("typedef struct %s {" % name)
        pos = 0
        pad = 0
        for off, ctype, fname, count in sorted(fields):
            if off < pos:
                raise SystemExit("%s: field %s at 0x%X overlaps 0x%X"
                                 % (name, fname, off, pos))
            if off > pos:
                out.append("    u8   _pad_%02X[0x%X];" % (pos, off - pos))
                pad += 1
                pos = off
            width = SIZEOF[ctype] * (count or 1)
            decl = ("%s[%d]" % (fname, count)) if count else fname
            out.append("    %-4s %-26s /* +0x%02X */" %
                       (ctype, decl + ";", off))
            pos += width
        if pos > stride:
            raise SystemExit("%s: fields overrun stride (0x%X > 0x%X)"
                             % (name, pos, stride))
        if pos < stride:
            out.append("    u8   _pad_%02X[0x%X];" % (pos, stride - pos))
        out.append("} %s;" % name)
        out.append("")
    return "\n".join(out)


SCRIPT_TEMPLATE = r'''# VICEROY.EXE symbol import for Ghidra  (GENERATED — do not hand-edit)
# Regenerate: python3 tools/ghidra/make_ghidra_scripts.py
#
# BUILD @@STAMP@@
# If a traceback from this file does not match the line numbers you expect,
# check that stamp against the one the repo prints — you are probably running
# an older copy that is still sitting in ghidra_scripts/.
#
# WHAT IT DOES
#   * names every one of the 1,250 known functions (89 carry their real 1994
#     CodeView names, recovered from MAPEDIT.EXE by instruction fingerprint)
#   * plate-comments each function with its module, overlay page, size and the
#     GAME.TXT message keys it emits
#   * creates a DGROUP memory block and labels ~150 named globals in it
#   * bookmarks the 31 RTLink overlay page boundaries
#
# HOW TO LOAD THE BINARY (important — see tools/ghidra/README.md)
#   Import VICEROY.EXE as **Raw Binary**, language x86:LE:16:Real Mode,
#   base address 0.  Then Ghidra address == file offset and all 31 overlay
#   pages are visible.  A normal MZ import maps only the load image (a
#   quarter of the code) — if you did that, set MZ_LOAD = True below.
#
# RUNTIME: works under BOTH Ghidra Python providers.
#   * PyGhidra (CPython 3, bundled and default since Ghidra 11.3)
#   * Jython 2.7 (the older provider, an installable extension)
# Only stdlib `json` plus the injected flat API are used, and the one Java
# type it needs is imported explicitly (a bare `ghidra.program...` reference
# resolves under neither provider).  No f-strings, no print_function needed.
#
# @category Colonization

MZ_LOAD = False          # True if imported as MS-DOS Executable rather than raw

# Synthetic home for the BSS half of DGROUP.  MUST be a valid address in the
# program's address space: x86 real mode tops out near 1 MB, so a "safely
# high" value like 0x200000 is NOT addressable and block creation fails.
# The file itself is ~495 KB (0x78D3E), so 0x80000 sits just past it and
# inside the 1 MB real-mode range.  Fallbacks are tried automatically.
DGROUP_BLOCK_ADDR = 0x80000
DGROUP_FALLBACKS = (0x80000, 0x90000, 0xF0000, 0x200000)

import json

try:
    from ghidra.program.model.symbol import SourceType
    SRC = SourceType.IMPORTED
except Exception as _e:      # pragma: no cover - provider without the class
    SRC = None
    print("WARNING: could not import SourceType (%s); renames will be skipped"
          % _e)

DATA = json.loads(r"""@@DATA@@""")

HEADER = 0x2400
DGROUP_FILE = 0x1D9A0
LOAD_IMAGE_END = 0x22A65        # end of the MZ load image; DGROUP is BSS above
DELTA = -HEADER if MZ_LOAD else 0


def A(file_off):
    return toAddr(file_off + DELTA)


BUILD = "@@STAMP@@"

# Set False to stop the script defining/applying the record types (phase 4).
# Naming and DGROUP setup still run.
APPLY_TYPES = True

# Set False to skip the RTLink thunk pass (phase 5).  It walks every
# instruction in the program looking for far calls, which takes a moment on a
# 495 KB image.
ANNOTATE_THUNKS = True

# Set False to leave function signatures alone (phase 6).  Argument COUNTS are
# byte-verified; argument types are not, so every parameter is laid down as a
# plain 2-byte word.
APPLY_SIGNATURES = True

# Fixed-width Ghidra builtins.  Deliberately NOT IntegerDataType/LongDataType,
# whose sizes come from the language's data organisation — the whole point is
# that these widths are byte-verified and must not float.
_TYPES = {
    "u8":   ("ByteDataType", 1),
    "s8":   ("SignedByteDataType", 1),
    "char": ("CharDataType", 1),
    "u16":  ("WordDataType", 2),
    "s16":  ("SignedWordDataType", 2),
    "u32":  ("DWordDataType", 4),
    "s32":  ("SignedDWordDataType", 4),
}


def _dt(kind):
    """Instantiate a fixed-width builtin by name, plus its byte width."""
    import ghidra.program.model.data as D
    cls, width = _TYPES[kind]
    return getattr(D, cls)(), width


def apply_signatures():
    """Give each function the argument count its callers prove it takes.

    The count is byte evidence (cdecl `add sp, N` after the call, agreed by
    every observed site); the argument TYPES are not — each is laid down as a
    plain 2-byte word, which is what the stack slot actually is.  Naming them
    param_1..param_n rather than guessing meanings keeps the honest part and
    discards nothing: the decompiler stops inventing its own arity, which is
    the thing that made call sites unreadable.
    """
    from ghidra.program.model.data import WordDataType
    from ghidra.program.model.listing import ParameterImpl, Function
    from ghidra.program.model.symbol import SourceType as _S

    fm = currentProgram.getFunctionManager()
    applied = missing = 0
    for f in DATA["funcs"]:
        n = f.get("na")
        if not n:
            continue
        try:
            fn = fm.getFunctionAt(A(f["a"]))
            if fn is None:
                missing += 1
                continue
            params = [ParameterImpl("param_%d" % (i + 1), WordDataType(),
                                    currentProgram)
                      for i in range(n)]
            fn.replaceParameters(
                params, Function.FunctionUpdateType.DYNAMIC_STORAGE_FORMAL_PARAMS,
                True, _S.USER_DEFINED)
            applied += 1
        except Exception:
            missing += 1
    print("signatures applied   : %d  (arg counts from caller stack cleanup)"
          % applied)
    if missing:
        print("signatures skipped   : %d  (no function at that address)"
              % missing)


def annotate_thunk_calls():
    """Name the thunk stubs and label every call site with its real target.

    A cross-page call is `9A off16 seg16` (far CALL) into the thunk table.
    Ghidra resolves that seg:off with its own segment arithmetic, which is
    0x2400 out from the file offsets this database uses, so it lands nowhere
    useful and the callee shows as an anonymous FUN_.  Rather than fight the
    address model, decode the operand straight from the instruction bytes and
    state the answer in an EOL comment.

    Reading the bytes (not the operand objects) keeps this independent of how
    the loaded language chooses to render a far call.
    """
    by_stub = {}
    for e in DATA["thunks"]:
        by_stub[e["a"]] = e
    if not by_stub:
        return 0

    labelled = 0
    for e in DATA["thunks"]:
        try:
            createLabel(A(e["a"]), "thunk_" + e["n"], False)
            labelled += 1
        except Exception:
            pass

    sites = 0
    for ins in currentProgram.getListing().getInstructions(True):
        try:
            b = ins.getBytes()
            if len(b) < 5 or (b[0] & 0xFF) != 0x9A:
                continue
            off = (b[1] & 0xFF) | ((b[2] & 0xFF) << 8)
            seg = (b[3] & 0xFF) | ((b[4] & 0xFF) << 8)
        except Exception:
            continue
        e = by_stub.get(HEADER + seg * 16 + off)
        if e is None:
            continue
        try:
            setEOLComment(ins.getAddress(),
                          "-> %s   (file 0x%05X, via type-%s thunk)"
                          % (e["n"], e["t"], e["h"]))
            sites += 1
        except Exception:
            pass

    print("thunk stubs labelled : %d" % labelled)
    print("call sites annotated : %d  (EOL comment names the real callee)"
          % sites)
    return sites


def build_structs():
    """Define the five record layouts directly in the Data Type Manager.

    Replaces `File > Parse C Source` on viceroy_types.h.  Each struct is
    created at its byte-verified stride and fields are dropped in at their
    offsets, so unmapped spans stay `undefined1` — honest gaps, never
    invented names, and no alignment rule can shift anything.
    """
    from ghidra.program.model.data import (StructureDataType, ArrayDataType,
                                           CategoryPath)
    dtm = currentProgram.getDataTypeManager()
    path = CategoryPath("/viceroy")
    out = {}
    for t in DATA["tables"]:
        try:
            s = StructureDataType(path, t["name"], t["stride"])
            for f in t["fields"]:
                dt, w = _dt(f["t"])
                if f["c"]:
                    dt = ArrayDataType(dt, f["c"], w)
                s.replaceAtOffset(f["o"], dt, dt.getLength(), f["nm"], None)
            out[t["name"]] = dtm.addDataType(s, None)
        except Exception as e:
            print("!! could not define %s (%s)" % (t["name"], e))
    if out:
        print("record types defined: %s" % ", ".join(sorted(out)))
        print("   (Data Type Manager > <program> > viceroy - no C parse needed)")
    return out


def apply_tables(structs, dg):
    """Lay each record table down as an array at its DGROUP base."""
    from ghidra.program.model.data import ArrayDataType
    done = 0
    for t in DATA["tables"]:
        dt = structs.get(t["name"])
        if dt is None:
            continue
        try:
            addr = dg.add(t["ds"])
            span = t["n"] * t["stride"]
            clearListing(addr, addr.add(span - 1))
            createData(addr, ArrayDataType(dt, t["n"], dt.getLength()))
            print("   %-18s %s  [%d x 0x%X]"
                  % (t["name"] + "[]", addr, t["n"], t["stride"]))
            done += 1
        except Exception as e:
            print("!! could not apply %s at DS:0x%04X (%s)"
                  % (t["name"], t["ds"], e))
    print("record tables applied: %d/%d" % (done, len(DATA["tables"])))


def retype_pointers(structs, dg):
    """Type the current-record globals as 2-byte NEAR pointers.

    Size is forced to 2 rather than left to the language's default: these
    hold near offsets into DGROUP, and a 4-byte far pointer would swallow two
    bytes of whatever follows and mislabel it.
    """
    from ghidra.program.model.data import PointerDataType
    PTRS = [("g_current_colony_ptr", 0x8542, "ColonyRecord"),
            ("g_current_power_ptr", 0x84FC, "PowerRecord"),
            ("g_active_settlement_ptr", 0x8D4A, "NativeSettlement")]
    done = 0
    for nm, ds, tyname in PTRS:
        dt = structs.get(tyname)
        if dt is None:
            continue
        try:
            addr = dg.add(ds)
            clearListing(addr, addr.add(1))
            createData(addr, PointerDataType(dt, 2))
            print("   %-24s %s  as %s * (near, 2 bytes)" % (nm, addr, tyname))
            done += 1
        except Exception as e:
            print("!! could not retype %s at DS:0x%04X (%s)" % (nm, ds, e))
    print("record pointers typed: %d/%d" % (done, len(PTRS)))


def main():
    # First line out, before anything can fail: which copy of this file is
    # actually running.  Ghidra runs whatever is in ghidra_scripts/, which is
    # not necessarily the file you just regenerated.
    print("=" * 64)
    print("viceroy_ghidra_symbols  BUILD %s" % BUILD)
    print("=" * 64)

    fm = currentProgram.getFunctionManager()
    st = currentProgram.getSymbolTable()
    mem = currentProgram.getMemory()

    named = renamed = commented = failed = skipped = 0
    for f in DATA["funcs"]:
        try:
            addr = A(f["a"])
        except Exception:
            skipped += 1
            continue
        if mem.getBlock(addr) is None:
            skipped += 1                  # not mapped (MZ load, overlay page)
            continue

        fn = fm.getFunctionAt(addr)
        if fn is None:
            fn = createFunction(addr, f["n"])
            if fn is not None:
                named += 1
        if fn is not None and SRC is not None:
            try:
                fn.setName(f["n"], SRC)
                renamed += 1
            except Exception as e:
                failed += 1
                if failed <= 5:           # report a few, don't spam
                    print("  rename failed at 0x%06X (%s): %s"
                          % (f["a"], f["n"], e))

        tier = {"B": "REAL NAME (MAPEDIT CodeView match)",
                "R": "role name (analysis)",
                "M": "module-derived placeholder"}[f["t"]]
        lines = ["%s   [%s]" % (f["n"], tier),
                 "module : %s" % (f["m"] or "?"),
                 "page   : %s" % (f["p"] or "resident"),
                 "size   : %d bytes   file 0x%06X" % (f["s"], f["a"])]
        if f.get("lead"):
            lines.append("CANDIDATE (unconfirmed, partial fingerprint match "
                         "- verify before adopting): %s" % f["lead"])
        if f["k"]:
            lines.append("emits  : %s" % ", ".join(sorted(f["k"])))
        if f["t"] == "U":
            lines.append("NAME  : written by hand in Ghidra (tier U - human")
            lines.append("        judgement, not a byte citation)")
        if f.get("na"):
            lines.append("args   : %d word(s), agreed by %d call site(s) "
                         "(cdecl caller cleanup)" % (f["na"], f["nas"]))
        setPlateComment(addr, "\n".join(lines))
        commented += 1

    # ---- DGROUP -----------------------------------------------------------
    # ONE contiguous 64 KB window, not two halves.  DGROUP's initialised part
    # lives in the file at 0x1D9A0 and runs to the end of the load image
    # (0x22A65 = DS:0x50C5); everything above that is BSS, past the end of the
    # file.  In a raw-binary import the bytes immediately after 0x22A65 are
    # already occupied by overlay data, so BSS cannot simply be appended -
    # hence a synthetic block, with the initialised bytes COPIED into it so
    # that one DS value covers the whole segment.
    #
    # Why this matters: real mode writes `mov bx,[0x8542]`, meaning DS:0x8542.
    # Unless Ghidra knows DS, that displacement stays a bare constant and every
    # global in the program decompiles as a naked number.  Labelling the two
    # halves at two different addresses (the previous behaviour) could never
    # fix that, because no single DS value reached both.
    dg = None
    existing = mem.getBlock("DGROUP")
    if existing is not None:
        dg = existing.getStart()
        print("DGROUP block already present at %s" % dg)
        if not existing.isInitialized():
            print("!! ...but it is UNINITIALISED - left over from an older run")
            print("!! of this script.  Delete it and re-run, or the initialised")
            print("!! half of DGROUP will read as zeros:")
            print("!!   Window > Memory Map, select DGROUP, click the red X.")
    else:
        errs = []
        for cand in DGROUP_FALLBACKS:
            try:
                base = toAddr(cand)
                if base is None:
                    errs.append("0x%X: toAddr returned None" % cand)
                    continue
                mem.createInitializedBlock("DGROUP", base, 0x10000,
                                           0, monitor, False)
                dg = base
                print("DGROUP block created at %s (0x%X), 64 KB" % (dg, cand))
                break
            except Exception as e:
                errs.append("0x%X: %s" % (cand, e))
        if dg is None:
            print("!! COULD NOT CREATE THE DGROUP BLOCK - the record tables")
            print("!! will have no addresses.  Attempts:")
            for e in errs:
                print("     %s" % e)

    # DGROUP MUST BE WRITABLE.  createInitializedBlock defaults to read-only,
    # and a read-only block is a promise to the decompiler that the bytes
    # never change - so it constant-folds every read.  BSS is zero-filled,
    # which means `if (g_some_flag)` folds to false and the ENTIRE guarded
    # body is deleted from the decompilation.  Symptom: a 274-byte function
    # decompiles to three lines plus "Read-only address is written" warnings.
    if dg is not None:
        try:
            blk = mem.getBlock(dg)
            blk.setRead(True)
            blk.setWrite(True)
            blk.setExecute(False)
            print("DGROUP permissions set to rw-")
        except Exception as e:
            print("!! could not make DGROUP writable (%s)" % e)
            print("!! the decompiler will constant-fold reads from it and")
            print("!! delete guarded code.  Fix by hand: Window > Memory Map,")
            print("!! tick the W column on the DGROUP row.")

    # Copy the initialised half in, so DS:0x0000..0x50C4 reads real data.
    init_len = LOAD_IMAGE_END - DGROUP_FILE
    if dg is not None:
        try:
            src = getBytes(A(DGROUP_FILE), init_len)
            mem.setBytes(dg, src)
            print("DGROUP initialised half copied: %d bytes from file 0x%X"
                  % (init_len, DGROUP_FILE))
        except Exception as e:
            print("!! could not copy the initialised half (%s) - DS:0x0000..0x%X"
                  % (e, init_len - 1))
            print("!! will read as zeros.  BSS globals are unaffected.")

    # Every global goes in the one window, initialised or not.
    gi = gb = 0
    if dg is not None:
        for g in DATA["globals"]:
            try:
                createLabel(dg.add(g["ds"]), g["n"], True)
                if g["init"]:
                    gi += 1
                else:
                    gb += 1
            except Exception:
                pass

    # ---- teach Ghidra what DS holds --------------------------------------
    # With the block at a paragraph-aligned address, DS = block>>4 makes every
    # `[0xNNNN]` displacement in the program resolve to DGROUP:0xNNNN - which
    # is where the labels now are.  Without this the decompiler shows
    # `*(int *)0x8542` instead of `g_current_colony_ptr`.
    if dg is not None:
        try:
            from java.math import BigInteger
            ds_reg = currentProgram.getRegister("DS")
            if ds_reg is None:
                print("!! no DS register in this language - is the program"
                      " really x86:LE:16:Real Mode?")
            else:
                ds_val = BigInteger.valueOf(dg.getOffset() >> 4)
                ctx = currentProgram.getProgramContext()
                spans = 0
                for blk in mem.getBlocks():
                    if blk.getName() == "DGROUP":
                        continue
                    try:
                        ctx.setValue(ds_reg, blk.getStart(), blk.getEnd(),
                                     ds_val)
                        spans += 1
                    except Exception:
                        pass
                print("DS set to 0x%04X over %d block(s) - globals should now"
                      " decompile by name" % (dg.getOffset() >> 4, spans))
                print("   (if they do not, re-run Analysis > Auto Analyze, or"
                      " right-click a function > Decompiler > Refresh)")
        except Exception as e:
            print("!! could not set DS (%s); set it by hand: select all in the"
                  " Listing," % e)
            print("!! right-click > Registers > Set Register Values, DS = 0x%04X"
                  % (dg.getOffset() >> 4))

    # ---- record types: define, apply, retype ------------------------------
    # Everything that used to be manual after the script ran:
    #   File > Parse C Source   -> build_structs()   (no C parser involved)
    #   G + T at each table base -> apply_tables()
    #   Ctrl-L on each pointer   -> retype_pointers()
    # Building the structs in code rather than parsing viceroy_types.h also
    # sidesteps the C parser's data organisation: widths are stated outright
    # instead of depending on what `long` means for the loaded language.
    structs = {}
    if APPLY_TYPES and dg is not None:
        structs = build_structs()
        if structs:
            apply_tables(structs, dg)
            retype_pointers(structs, dg)

    # ---- RTLink thunks ----------------------------------------------------
    if ANNOTATE_THUNKS:
        try:
            annotate_thunk_calls()
        except Exception as e:
            print("!! thunk annotation failed (%s) - everything else stands" % e)

    # ---- function signatures ----------------------------------------------
    if APPLY_SIGNATURES:
        try:
            apply_signatures()
        except Exception as e:
            print("!! signature pass failed (%s) - everything else stands" % e)

    # ---- overlay page bookmarks ------------------------------------------
    pages = 0
    for p in DATA["pages"]:
        try:
            addr = A(p["a"])
            if mem.getBlock(addr) is not None:
                createBookmark(addr, "RTLink",
                               "overlay page 0x%s  (%d bytes)" % (p["id"], p["z"]))
                pages += 1
        except Exception:
            pass

    print("functions created  : %d" % named)
    print("functions named    : %d" % renamed)
    if failed:
        print("renames FAILED     : %d  (see messages above)" % failed)
    if skipped:
        print("skipped (unmapped) : %d  <- set MZ_LOAD/re-import if unexpected"
              % skipped)
    print("plate comments     : %d" % commented)
    print("globals in-file    : %d" % gi)
    print("globals in DGROUP  : %d" % gb)
    print("overlay bookmarks  : %d" % pages)
    # ---- where to look, in THIS program's own address format --------------
    # A 16-bit real-mode program shows segmented addresses (segment:offset),
    # so never compute these by hand — copy the right-hand column.
    print("")
    print("=" * 64)
    print("WHERE THINGS ARE")
    print("=" * 64)
    if dg is None:
        print("  DGROUP was not created - see the errors above")
    else:
        for t in DATA["tables"]:
            try:
                print("  %-18s DS:0x%04X  ->  %s     [%s, stride 0x%X]"
                      % (t["name"] + "[]", t["ds"], dg.add(t["ds"]),
                         t["count"], t["stride"]))
            except Exception as e:
                print("  %-18s DS:0x%04X  -> ERROR %s" % (t["name"], t["ds"], e))
        for nm, ds in (("g_current_colony_ptr", 0x8542),
                       ("g_current_power_ptr", 0x84FC),
                       ("g_active_settlement_ptr", 0x8D4A)):
            try:
                print("  %-24s DS:0x%04X  ->  %s" % (nm, ds, dg.add(ds)))
            except Exception:
                pass
    print("")
    if APPLY_TYPES:
        print("Nothing further to do by hand.  Check it took: G -> 53b14,")
        print("the decompiler should read g_current_colony_ptr->colony_flags.")
        print("(If the old text persists: right-click > Decompiler > Refresh.)")
    else:
        print("APPLY_TYPES is False - the record types were not defined or")
        print("applied.  Set it True at the top of this script, or do it by")
        print("hand per tools/ghidra/README.md section 3.2.")


main()
'''

EXPORT_TEMPLATE = r'''# VICEROY.EXE symbol EXPORT from Ghidra  (GENERATED - do not hand-edit)
# Regenerate: python3 tools/ghidra/make_ghidra_scripts.py
#
# BUILD @@STAMP@@
#
# Run this in Ghidra AFTER you have renamed things, to send your work back to
# the repo.  It compares the live program against the baseline the import
# script applied and writes only the DIFFERENCES, so re-running it is cheap
# and the output stays small.
#
# It writes a JSON file and prints the path.  Copy that file to the repo
# machine and run:
#     python3 tools/ghidra/merge_ghidra_export.py <the-file>
#
# WHAT IT CAPTURES
#   * function renames (yours vs the imported name, and any FUN_ you named)
#   * DGROUP global renames
#   * plate comments you wrote (the generated ones carry a "module :" line and
#     are skipped)
#   * EOL comments you wrote (the generated thunk notes start "-> " and are
#     skipped)
#
# WHAT IT DOES NOT CAPTURE
#   Struct edits, parameter renames, and data-type changes.  Those live in the
#   Data Type Manager rather than the symbol table; the repo's record layouts
#   are byte-verified in make_ghidra_scripts.py's RECORDS table, which is
#   where a real layout correction belongs.

import json
import os

MZ_LOAD = False
BUILD = "@@STAMP@@"
HEADER = 0x2400
DELTA = -HEADER if MZ_LOAD else 0

DATA = json.loads(r"""@@DATA@@""")

# Prefixes Ghidra generates by itself.  `thunk_` is the big one: Ghidra's
# analyser recognises jump-only stubs and names them thunk_<target> — so after
# the import script renames a target, Ghidra invents thunk_<our name> and it
# looks hand-written unless you check where it came from.
AUTO_PREFIXES = ("FUN_", "SUB_", "LAB_", "DAT_", "UNK_", "EXT_", "thunk_",
                 "caseD_", "switchD_", "jumpTable", "s_", "u_", "PTR_",
                 "ARRAY_", "SUBR_")


def is_auto(name):
    for p in AUTO_PREFIXES:
        if name.startswith(p):
            return True
    return False


def user_typed(sym):
    """True only if a human named this.

    Ghidra records provenance on every symbol.  DEFAULT is a placeholder,
    ANALYSIS is the analyser's own work, IMPORTED is what the import script
    applied — only USER_DEFINED means somebody typed it.  Checking that is far
    more reliable than pattern-matching names, which is how 198 auto-generated
    thunk_/caseD_ symbols got into the first export.
    """
    try:
        from ghidra.program.model.symbol import SourceType
        return sym.getSource() == SourceType.USER_DEFINED
    except Exception:
        return not is_auto(sym.getName())


def main():
    print("=" * 64)
    print("viceroy_ghidra_export  BUILD %s" % BUILD)
    print("=" * 64)

    listing = currentProgram.getListing()
    mem = currentProgram.getMemory()
    base = {}
    for f in DATA["funcs"]:
        base[f["a"]] = f["n"]
    gbase = {}
    for g in DATA["globals"]:
        gbase[g["ds"]] = g["n"]
    # Addresses this script's own thunk pass labelled.  Ghidra frequently
    # turns those into thunk functions and re-derives a name for them; that is
    # our output coming back, not yours.
    ours = set()
    for t in DATA["thunks"]:
        ours.add(t["a"])

    out = {"build": BUILD, "functions": [], "globals": [],
           "plate_comments": [], "eol_comments": []}
    dropped = {"auto": 0, "ours": 0}

    # ---- function names ---------------------------------------------------
    for fn in currentProgram.getFunctionManager().getFunctions(True):
        try:
            off = fn.getEntryPoint().getOffset() - DELTA
            cur = fn.getName()
            sym = fn.getSymbol()
        except Exception:
            continue
        was = base.get(off)
        if was is None:
            # A function the repo does not know about.  Worth exporting only
            # if a human named it: Ghidra's own placeholders and analyser
            # names carry nothing the repo lacks.
            if off in ours:
                dropped["ours"] += 1
            elif is_auto(cur) or (sym is not None and not user_typed(sym)):
                dropped["auto"] += 1
            else:
                out["functions"].append({"a": off, "was": None, "now": cur,
                                         "new_function": True})
        elif cur != was:
            if is_auto(cur):
                dropped["auto"] += 1
            else:
                out["functions"].append({"a": off, "was": was, "now": cur})

    # ---- DGROUP global names ----------------------------------------------
    dgb = mem.getBlock("DGROUP")
    if dgb is not None:
        st = currentProgram.getSymbolTable()
        start = dgb.getStart().getOffset()
        for sym in st.getSymbolIterator(True):
            try:
                a = sym.getAddress()
                if not dgb.contains(a):
                    continue
                ds = a.getOffset() - start
                cur = sym.getName()
            except Exception:
                continue
            was = gbase.get(ds)
            if is_auto(cur):
                dropped["auto"] += 1
            elif was is None:
                if user_typed(sym):
                    out["globals"].append({"ds": ds, "was": None, "now": cur,
                                           "new_global": True})
                else:
                    dropped["auto"] += 1
            elif cur != was:
                out["globals"].append({"ds": ds, "was": was, "now": cur})

    # ---- comments ---------------------------------------------------------
    # Generated plate comments always contain a "module :" line; generated EOL
    # comments always start "-> ".  Anything else at those addresses is yours.
    for blk in mem.getBlocks():
        if blk.getName() == "DGROUP":
            continue
        try:
            it = listing.getCommentAddressIterator(blk.getAddressRange(), True)
        except Exception:
            continue
        for a in it:
            try:
                plate = listing.getComment(3, a)     # PLATE_COMMENT
                eol = listing.getComment(0, a)       # EOL_COMMENT
            except Exception:
                continue
            if plate and "module :" not in plate:
                out["plate_comments"].append(
                    {"a": a.getOffset() - DELTA, "text": plate})
            if eol and not eol.startswith("-> "):
                out["eol_comments"].append(
                    {"a": a.getOffset() - DELTA, "text": eol})

    # ---- write ------------------------------------------------------------
    name = "viceroy_ghidra_export.json"
    for d in (os.path.expanduser("~"), os.getcwd()):
        try:
            path = os.path.join(d, name)
            fh = open(path, "w")
            fh.write(json.dumps(out, indent=1, sort_keys=True))
            fh.close()
            break
        except Exception:
            path = None
    print("function renames  : %d" % len(out["functions"]))
    print("global renames    : %d" % len(out["globals"]))
    print("your plate comments: %d" % len(out["plate_comments"]))
    print("your EOL comments : %d" % len(out["eol_comments"]))
    print("skipped, Ghidra's own naming : %d" % dropped["auto"])
    print("skipped, this script's thunk labels : %d" % dropped["ours"])
    print("")
    if path:
        print("WROTE  %s" % path)
        print("")
        print("Copy it to the repo machine, then run:")
        print("    python3 tools/ghidra/merge_ghidra_export.py <that file>")
    else:
        print("!! could not write the export file anywhere - check permissions")
    if not any(out[k] for k in ("functions", "globals", "plate_comments",
                                "eol_comments")):
        print("")
        print("(Nothing differs from the imported baseline yet - rename some")
        print(" things in Ghidra first, then run this again.)")


main()
'''


USAGE = """usage:
  python3 make_ghidra_scripts.py               generate the Ghidra scripts
  python3 make_ghidra_scripts.py --list        list every file it reads
  python3 make_ghidra_scripts.py --bundle DIR  copy itself + every input into
                                               DIR, so DIR is self-contained
"""


def list_inputs():
    print("Inputs this generator reads (found = resolved on this machine):")
    for rel in INPUTS:
        p = find_input(rel)
        print("  [%s] %-45s %s" % ("found" if p.exists() else "  -  ", rel, p))
    for rel in INPUT_DIRS:
        p = find_input(rel)
        n = len(list(p.glob("*.asm"))) if p.is_dir() else 0
        print("  [%s] %-45s %s  (%d .asm)"
              % ("found" if p.is_dir() else "  -  ", rel, p, n))
    print("\nOptional (absent is fine):")
    for rel in OPTIONAL_INPUTS:
        p = find_input(rel)
        print("  [%s] %-45s %s" % ("found" if p.exists() else "absent", rel, p))
    print("\nOutputs (always written next to this script):")
    for p in (OUT_PY, OUT_EXPORT, OUT_H):
        print("      %s" % p)
    raise SystemExit(0)


if __name__ == "__main__":
    import sys
    argv = sys.argv[1:]
    if argv[:1] == ["--list"]:
        list_inputs()
    elif argv[:1] == ["--bundle"]:
        if len(argv) != 2:
            raise SystemExit(USAGE)
        bundle(argv[1])
    elif argv:
        raise SystemExit(USAGE)
    main()
