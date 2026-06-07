#!/usr/bin/env python3
"""Master decompilation-status dashboard for VICEROY.EXE.

Inventories EVERY function (the 1241 per-func disasm dumps = the full universe,
resident + overlay), classifies each by:
  - status  : done / byte-verified / partial(TBD-inner) / skeleton / superseded /
              phantom / out-of-scope / MISSING (not ported)
  - region  : overlay page 0xNN  /  resident
  - srcfile : where it's ported (if at all)
Cross-references the authoritative overlay reseg list (629) for page + extent.
Also inventories the data tables (NAMES.TXT @sections + the DGROUP structs).
Emits a searchable/filterable HTML + JSON + a coverage summary.
"""
import json, os, re, glob, html
HERE = os.path.dirname(__file__)
RE   = os.path.join(HERE, "..", "..", "code", "VICEROY")
SRC  = os.path.join(HERE, "..", "..", "viceroy_source", "src")
OUT  = os.path.join(HERE, "..", "..", "viceroy_source", "docs")
MAP  = os.path.join(HERE, "viceroy_rtlink_map.json")
EXE  = os.path.join(HERE, "..", "..", "raw", "COLONIZE", "VICEROY.EXE")

H = lambda v: v if isinstance(v, int) else int(v, 16)

# byte-proven static data tables the linear disassembler mis-framed as functions
# (first byte 0xC8 read as ENTER); see docs/RESIDENT_UNKNOWNS.md
KNOWN_DATA = {0x5651C, 0x56694, 0x5AC34, 0x5AEA0, 0x5AF2C}

def overlay_pages():
    segs = json.load(open(MAP))["segments"]
    return [(H(s["code_offset"]), H(s["code_offset"])+H(s["code_size"]), str(s["page_id"])) for s in segs]

def reseg_funcs():
    """offset(int) -> (size, page) for the 629 authoritative overlay funcs."""
    out = {}
    for p in glob.glob(os.path.join(RE, "disasm_overlay_reseg", "page_*.asm")):
        page = os.path.basename(p).replace("page_", "").replace(".asm", "")
        for off, sz in re.findall(r"; ---- func_([0-9A-Fa-f]+)\s+size=(\d+)", open(p, encoding="utf-8", errors="replace").read()):
            out[int(off, 16)] = (int(sz), page)
    return out

def universe():
    """offset(int) -> inferred-name, from the 1241 per-func dump filenames."""
    out = {}
    for f in glob.glob(os.path.join(RE, "disasm", "func_*.asm")):
        b = os.path.basename(f)[:-4]               # func_XXXXXX_role
        m = re.match(r"func_([0-9A-Fa-f]+)_?(.*)", b)
        if m:
            out[int(m.group(1), 16)] = m.group(2) or ""
    return out

STATUS_RANK = ["phantom","out-of-scope","superseded","skeleton","partial","byte-verified","done"]
def classify_src():
    """offset(int) -> {status, file, role} for every func DEFINED or noted in src/."""
    info = {}
    for f in glob.glob(os.path.join(SRC, "**", "*.c"), recursive=True):
        rel = os.path.relpath(f, os.path.join(HERE, "..", "..", "viceroy_source")).replace(os.sep, "/")
        txt = open(f, encoding="utf-8", errors="replace").read()
        lines = txt.splitlines()
        # index every func_ definition with a banner window above it
        for m in re.finditer(r"\n((?:int|void|long|unsigned|static)[^\n;{]*\bfunc_([0-9A-Fa-f]+)[A-Za-z0-9_]*\s*\([^;{]*\)\s*\n?\{)", txt):
            off = int(m.group(2), 16)
            ln = txt[:m.start()].count("\n")
            banner = "\n".join(lines[max(0,ln-34):ln+18])
            bu = banner.upper()
            if   "PHANTOM" in bu:                          st = "phantom"
            elif "OUT-OF-SCOPE" in bu or "OUT OF SCOPE" in bu: st = "out-of-scope"
            elif "STILL-SKELETON" in bu or "@AUTO" in banner or "BODY TBD" in bu: st = "skeleton"
            elif "TBD-INNER" in bu or "TBD-DATA" in bu:    st = "partial"
            elif "BYTE_VERIFIED" in bu or "BYTE-VERIFIED" in bu: st = "byte-verified"
            else:                                          st = "done"
            cur = info.get(off)
            if not cur or STATUS_RANK.index(st) > STATUS_RANK.index(cur["status"]):
                info[off] = {"status": st, "file": rel, "role": ""}
        # also catch SUPERSEDED one-line stubs (no def): "func_XXXXXX — SUPERSEDED"
        for m in re.finditer(r"func_([0-9A-Fa-f]+)[A-Za-z0-9_]*\s*[-—]+\s*SUPERSEDED", txt):
            off = int(m.group(1), 16)
            if off not in info:
                info[off] = {"status": "superseded", "file": rel, "role": ""}
    return info

def src_tokens():
    """Every func_XXXXXX token appearing ANYWHERE in src/ or include/ (covers
    role-renamed bodies, externs, supersede redirects, comments)."""
    toks = set()
    for f in glob.glob(os.path.join(SRC, "**", "*.c"), recursive=True) + \
             glob.glob(os.path.join(HERE, "..", "..", "viceroy_source", "include", "**", "*.h"), recursive=True):
        for m in re.findall(r"func_([0-9A-Fa-f]{4,6})", open(f, encoding="utf-8", errors="replace").read()):
            toks.add(int(m, 16))
    return toks

def cited_by_file():
    """file -> set of @asm-cited / func_ offsets it covers (catches role-named ports
    that don't embed the func_XXXXXX in their signature)."""
    out = {}
    for f in glob.glob(os.path.join(SRC, "**", "*.c"), recursive=True):
        rel = os.path.relpath(f, os.path.join(HERE, "..", "..", "viceroy_source")).replace(os.sep, "/")
        txt = open(f, encoding="utf-8", errors="replace").read()
        offs = set()
        for m in re.findall(r"@asm[_a-zA-Z]*\s+(?:file\s+)?0x([0-9A-Fa-f]{4,6})", txt):
            offs.add(int(m, 16))
        for m in re.findall(r"\bfunc_([0-9A-Fa-f]{4,6})", txt):
            offs.add(int(m, 16))
        if offs: out[rel] = offs
    return out

def extents(universe_offs, reseg):
    """offset -> (end, isresident_estimate). Overlay end from reseg size; resident
    end from the next function start (capped)."""
    so = sorted(universe_offs)
    ext = {}
    for i, o in enumerate(so):
        if o in reseg and reseg[o][0] > 0:
            ext[o] = o + reseg[o][0]
        else:
            nxt = so[i+1] if i+1 < len(so) else o + 0x200
            ext[o] = min(nxt, o + 0x2000)   # cap runaway resident gaps
    return ext

def region_of(off, pages):
    for a, b, pid in pages:
        if a <= off < b: return "overlay 0x"+pid.upper().zfill(2)
    return "resident"

def build():
    pages = overlay_pages()
    reseg = reseg_funcs()
    uni   = universe()
    src   = classify_src()
    toks  = src_tokens()
    # universe = union of per-func dumps + reseg offsets (reseg is authoritative for overlay)
    alloffs = set(uni) | set(reseg)
    # @asm-citation coverage: a function is ported in file F iff F cites its EXACT
    # entry offset (func_XXXXXX token or @asm 0xXXXXXX). Exact match avoids the
    # cross-function false positives a wide-extent check produced.
    cbf = cited_by_file()
    cited_file = {}
    for f, offs in cbf.items():
        for o in offs:
            cited_file.setdefault(o, f)
    def coverage(off):
        return cited_file.get(off)
    rows = []
    for off in sorted(alloffs):
        name = uni.get(off, "")
        si   = src.get(off)
        reg = region_of(off, pages)
        in_reseg = off in reseg
        is_overlay = reg.startswith("overlay")
        cfile = None
        if off in KNOWN_DATA:
            status = "data"                            # byte-proven static table mis-framed as a fn (RESIDENT_UNKNOWNS.md)
        elif si:
            status = si["status"]                      # ported with a recognised status
        elif off in toks:
            status = "referenced"                      # role-renamed body / extern / supersede redirect
        elif is_overlay and not in_reseg:
            status = "phantom"                         # per-func-dump artifact; authoritative reseg omits it
        elif re.search(r"stream|putchar|getchar|unlink|find[ _]file|find[ _]char|coreleft|exit|cstart|"
                       r"dos[ _]version|rtlink|dispatch[ _]overlay|repeat[ _]dispatch|entry[ _]point|"
                       r"system[ _]init|loader|thunk[ _]table|format|map[ _]int|write[ _]int|"
                       r"\bopen\b|\bclose\b", name, re.I):
            status = "out-of-scope"                    # DOS C-runtime / overlay-loader / boot (scope cut)
        else:
            status = "MISSING"                         # genuine IN-SCOPE gap (real fn, no src presence)
        # upgrade OOS/MISSING false-positives that are actually ported under a role
        # name (their exact entry offset is cited in a .c). 'referenced' stays as-is.
        if status in ("out-of-scope", "MISSING"):
            cfile = coverage(off)
            if cfile:
                status = "done"
        rows.append({"off": "0x%05X" % off, "name": name, "status": status,
                     "region": reg, "file": (si["file"] if si else cfile) or "",
                     "size": reseg.get(off, (0,""))[0], "reseg": in_reseg})
    # coverage stats
    from collections import Counter
    by_status = Counter(r["status"] for r in rows)
    by_region_missing = Counter(r["region"].split()[0] for r in rows if r["status"]=="MISSING")
    json.dump({"rows": rows, "by_status": by_status,
               "missing_by_region": by_region_missing}, open(os.path.join(OUT,"decompile_status.json"),"w"))
    # ---- data tables ----
    tables = DATA_TABLES
    # ---- HTML ----
    statc = {"done":"#3fb950","byte-verified":"#2ea043","partial":"#d29922",
             "skeleton":"#bb8009","referenced":"#388bfd","superseded":"#8b949e",
             "phantom":"#6e7681","data":"#a371f7","out-of-scope":"#484f58","MISSING":"#f85149"}
    chips = "".join(f'<button class="chip on" data-f="status" data-v="{s}"><span class="dot" style="background:{c}"></span>{s} <em>{by_status.get(s,0)}</em></button>'
                    for s,c in statc.items())
    regions = sorted({r["region"] for r in rows}, key=lambda x:(x=="resident", x))
    rchips = "".join(f'<button class="chip on" data-f="region" data-v="{html.escape(rg)}">{html.escape(rg)}</button>' for rg in regions)
    cards = []
    for r in rows:
        c = statc.get(r["status"], "#888")
        cards.append(
          f'<tr data-status="{r["status"]}" data-region="{html.escape(r["region"])}" '
          f'data-text="{html.escape((r["off"]+" "+r["name"]+" "+r["file"]).lower())}">'
          f'<td class="mono">{r["off"]}</td>'
          f'<td><span class="st" style="background:{c}1a;color:{c};border:1px solid {c}55">{r["status"]}</span></td>'
          f'<td>{html.escape(r["region"])}</td>'
          f'<td>{html.escape(r["name"].replace("_"," ")) or "<i>unnamed</i>"}</td>'
          f'<td class="mono small">{html.escape(r["file"])}</td></tr>')
    trows = "".join(f'<tr><td>{html.escape(t[0])}</td><td class="mono">{html.escape(t[1])}</td><td>{html.escape(t[2])}</td></tr>' for t in tables)
    htmlout = (TEMPLATE.replace("{{CHIPS}}", chips).replace("{{RCHIPS}}", rchips)
               .replace("{{ROWS}}", "\n".join(cards)).replace("{{TROWS}}", trows)
               .replace("{{TOTAL}}", str(len(rows)))
               .replace("{{DONE}}", str(by_status.get("done",0)+by_status.get("byte-verified",0)))
               .replace("{{MISS}}", str(by_status.get("MISSING",0)))
               .replace("{{MISSRES}}", str(by_region_missing.get("resident",0))))
    open(os.path.join(OUT,"decompile_status.html"),"w",encoding="utf-8").write(htmlout)
    print(f"functions inventoried = {len(rows)}")
    for s in statc: print(f"  {s:14} {by_status.get(s,0)}")
    print(f"MISSING by region: {dict(by_region_missing)}")

DATA_TABLES = [
 ("NAMES.TXT @UNIT","DGROUP 0x5230 stride 0xE","DONE — decoded (types incl. Caravel/Soldier/Pioneer)"),
 ("NAMES.TXT @DIFFICULTY","DGROUP -0x7C6C","DONE — 5 names (Discoverer..Viceroy)"),
 ("NAMES.TXT 38 @sections","see DATA_MODEL.md","DONE — section->table-base map byte-traced (func_0749E0)"),
 ("ColonyRecord","base 0x5D46 stride 0xCA","byte-verified (x/y,owner,stockpile[16],SoL bells)"),
 ("UnitRecord","base 0x3144 stride 0x1C","byte-verified (type+2,owner+3,state+8,vet+0x17)"),
 ("PowerRecord","base 0x8808 stride 0x13C","byte-verified (tax+1,rebel%+2,gold+0x2A,FF+7,bells+0xC)"),
 ("NativeSettlement","base 0x54EC stride 0x12","byte-verified (tribe,pop,mission flag,alarm)"),
 ("AIPersonality","base 0x540E stride 0x34","byte-verified (controller +0x31)"),
 ("Starting gold by difficulty","resident @0x036599/0x036779","byte-verified (1000/300/0/0/0)"),
 ("REF/king-anger thresholds","0x53DA.. (func_0755CC)","byte-verified (diff*8+15, etc.)"),
 ("Market price model","src/market/pricing.c","byte-verified (per-good drift)"),
 ("Combat odds","ATK/(ATK+DEF)","byte-verified (func_05CA7E land, func_05B2C2 ship)"),
]

TEMPLATE = r"""<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>VICEROY.EXE - Decompilation Status</title>
<style>
:root{--bg:#0d1117;--panel:#161b22;--line:#30363d;--ink:#e6edf3;--muted:#9aa7b4;--accent:#58a6ff}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:13px/1.45 -apple-system,Segoe UI,Roboto,Arial,sans-serif}
.wrap{max-width:1300px;margin:0 auto;padding:22px 18px 80px}
h1{font-size:24px;margin:0 0 3px}h2{font-size:17px;margin:30px 0 8px;border-bottom:1px solid var(--line);padding-bottom:5px}
.sub{color:var(--muted);margin:0 0 12px}a{color:var(--accent)}
.cards{display:flex;gap:12px;flex-wrap:wrap;margin:12px 0}
.stat{background:var(--panel);border:1px solid var(--line);border-radius:10px;padding:10px 16px;min-width:130px}
.stat .n{font-size:24px;font-weight:700}.stat .l{color:var(--muted);font-size:12px}
.bar{position:sticky;top:0;background:rgba(13,17,23,.96);backdrop-filter:blur(6px);padding:10px 0;border-bottom:1px solid var(--line);z-index:5}
#q{width:100%;padding:8px 11px;background:var(--panel);border:1px solid var(--line);border-radius:8px;color:var(--ink);font-size:14px}
.chips{display:flex;flex-wrap:wrap;gap:6px;margin-top:8px}
.chip{display:inline-flex;align-items:center;gap:5px;background:#0d1117;border:1px solid var(--line);color:var(--ink);border-radius:16px;padding:3px 9px;font-size:11.5px;cursor:pointer}
.chip.off{opacity:.32}.chip em{color:var(--accent);font-style:normal}.chip .dot{width:9px;height:9px;border-radius:2px}
table{width:100%;border-collapse:collapse;margin-top:10px}th,td{text-align:left;padding:4px 8px;border-bottom:1px solid #1c2230;font-size:12.5px;vertical-align:top}
th{color:var(--muted);position:sticky;top:74px;background:var(--bg)}
.mono{font-family:ui-monospace,Consolas,monospace}.small{font-size:11px;color:var(--muted)}
.st{border-radius:5px;padding:0 7px;font-size:11px;white-space:nowrap}
#count{color:var(--muted);margin:8px 0}
</style></head><body><div class="wrap">
<h1>Sid Meier&rsquo;s Colonization &mdash; Decompilation Status</h1>
<p class="sub">Every function in <code>VICEROY.EXE</code> with its decompile status &amp; region (resident vs overlay).
Built from the disassembly + the ported C. See also: <a href="event_catalog.html">event catalog</a>,
<a href="event_graph.html">function network</a>, <a href="DOC_INDEX.md">doc source-of-truth index</a>.</p>
<div class="cards">
  <div class="stat"><div class="n">{{TOTAL}}</div><div class="l">functions total</div></div>
  <div class="stat"><div class="n" style="color:#3fb950">{{DONE}}</div><div class="l">done / byte-verified</div></div>
  <div class="stat"><div class="n" style="color:#f85149">{{MISS}}</div><div class="l">not yet ported</div></div>
  <div class="stat"><div class="n" style="color:#f85149">{{MISSRES}}</div><div class="l">&hellip; of which resident</div></div>
</div>
<div class="bar">
  <input id="q" placeholder="Search by offset, name, or file&hellip;" autocomplete="off">
  <div class="chips">{{CHIPS}}</div>
  <div class="chips">{{RCHIPS}}</div>
</div>
<div id="count"></div>
<table id="tbl"><thead><tr><th>Offset</th><th>Status</th><th>Region</th><th>Inferred role</th><th>Ported in</th></tr></thead>
<tbody>{{ROWS}}</tbody></table>
<h2>Key data tables &amp; models</h2>
<table><thead><tr><th>Table / model</th><th>Location</th><th>Status</th></tr></thead><tbody>{{TROWS}}</tbody></table>
</div><script>
const tb=document.getElementById('tbl').tBodies[0], rows=[...tb.rows], q=document.getElementById('q'), count=document.getElementById('count');
const off={status:new Set(),region:new Set()};
function apply(){const s=q.value.trim().toLowerCase();let n=0;
 for(const r of rows){const okS=!off.status.has(r.dataset.status), okR=!off.region.has(r.dataset.region),
   okT=!s||r.dataset.text.includes(s); const show=okS&&okR&&okT; r.style.display=show?'':'none'; if(show)n++;}
 count.textContent=n+' functions shown';}
document.querySelectorAll('.chip').forEach(b=>b.onclick=()=>{const f=b.dataset.f,v=b.dataset.v;
 if(off[f].has(v)){off[f].delete(v);b.classList.remove('off');}else{off[f].add(v);b.classList.add('off');}apply();});
q.addEventListener('input',apply);apply();
</script></body></html>"""

if __name__ == "__main__":
    build()
