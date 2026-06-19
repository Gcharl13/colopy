#!/usr/bin/env python3
"""build_coverage_map.py -- a single self-contained HTML "coverage map" of
VICEROY.EXE: the whole recognized code space laid out by file offset, colour-
coded by how well each function is identified, with an expandable side-by-side
"assembly | what it does" view per function.

Signals (honest, data-driven):
  identified (named)  = functions.json status == MANUAL (curated name)
  decoded (in C)      = function offset referenced as func_XXXXXX in
                         viceroy_source/src/**/*.c (hand-ported)
  raw                 = neither (disassembled but not yet understood)
  gap                 = bytes between functions (data tables / padding / not-yet
                         disassembled overlay)
"""
from __future__ import annotations
import json, re, glob, html
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FUNCS = json.load(open(ROOT / "code/VICEROY/functions.json"))["functions"]
DISASM = ROOT / "code/VICEROY/disasm"
OUT = ROOT / "coverage_map.html"
MAX_ASM_LINES = 200          # cap very large functions

def off(f): return int(f["file_offset"], 16)

# --- decoded-in-C signal + offset -> C file map ----------------------------
# NB: C sources reference functions as `func_05CA7E` AND `func_05CA7E_label`,
# so match the full 6-hex id without a trailing word-boundary (a `\b` would
# miss the `_label` form and badly over-report "raw").
cfile_of: dict[int, set[str]] = {}
for cf in glob.glob(str(ROOT / "viceroy_source/src/**/*.c"), recursive=True):
    rel = str(Path(cf).relative_to(ROOT))
    for m in re.finditer(r"func_([0-9A-Fa-f]{6})", open(cf, errors="replace").read()):
        cfile_of.setdefault(int(m.group(1), 16), set()).add(rel)
cref = set(cfile_of)

# --- gap content classifier (code vs data), from the EXE bytes if available ---
try:
    EXE = (ROOT / "raw/COLONIZE/VICEROY.EXE").read_bytes()
except OSError:
    EXE = None
_THUNK = re.compile(rb"\x9a..\x1f[\x18\x19\x1a]")   # overlay-thunk far-call signature

def gap_is_code(start: int, size: int, region: str) -> bool:
    """True if an unmapped gap looks like (unenumerated) code rather than data."""
    if EXE is None:                       # fallback: overlay gaps are code-heavy
        return region == "overlay"
    b = EXE[start:start+size]
    if not b:
        return False
    z = b.count(0) / len(b)
    printable = sum(1 for x in b if 0x20 <= x < 0x7f or x in (9, 10, 13)) / len(b)
    if printable > 0.55 or z > 0.75:      # strings / padding-bss = data
        return False
    t = len(_THUNK.findall(b))
    codey = sum(b.count(bytes([op])) for op in
                (0x55, 0x8b, 0x83, 0xc7, 0xe8, 0xe9, 0x74, 0x75, 0x9a)) / len(b)
    return (t > 0 and len(b)/t < 220) or codey > 0.16

ADDR_RE = re.compile(r"^([0-9A-Fa-f]{6})\s")
HDR_RE  = re.compile(r"^;\s*(Purpose|Tagged|Verified|Region)\s*:\s*(.*)$")

def classify(f):
    if f["status"] == "DATA":              return "data_fn"   # not code (mis-segmented)
    if f["status"] == "MANUAL":            return "named"
    if off(f) in cref:                     return "decoded"
    if f["status"] == "AUDITED":           return "audited"
    return "raw"

LABELS = {"named":   ("Identified", "#1b7e3c"),
          "decoded": ("Decoded in C", "#1565c0"),
          "audited": ("Role identified (audited)", "#4a9c6d"),
          "raw":     ("Raw / not yet identified", "#8a8f98"),
          "data_fn": ("Reclassified as data (not code)", "#cfd4da"),
          "gap_code":("Unmapped CODE (overlay, not yet split into functions)", "#b9c7e8"),
          "gap_data":("Unmapped data / strings / padding", "#e6e2d6"),
          "gap":     ("Unmapped", "#dfe2e7")}

def read_asm(f):
    """Return (instruction_lines, header_fields)."""
    p = DISASM / Path(f["asm_file"]).name
    if not p.is_file(): return [], {}
    body, hdr = [], {}
    for ln in p.read_text(errors="replace").splitlines():
        h = HDR_RE.match(ln)
        if h: hdr[h.group(1)] = h.group(2).strip()
        if ADDR_RE.match(ln): body.append(ln.rstrip())
    return body, hdr

def humanize(name):
    return name if name and name != "unknown" else ""

# --- build rows ------------------------------------------------------------
sf = sorted(FUNCS, key=off)
tot = sum(f["size"] for f in FUNCS)
by = {k: 0 for k in ("named", "decoded", "audited", "raw", "data_fn")}
for f in FUNCS: by[classify(f)] += f["size"]
understood = by["named"] + by["decoded"] + by["audited"]
codetot = tot - by["data_fn"]                 # data_fn isn't code
gapbytes = sum(max(0, off(b) - (off(a) + a["size"])) for a, b in zip(sf, sf[1:]))
gapcode = gapdata = 0
for a, b in zip(sf, sf[1:]):
    g = off(b) - (off(a) + a["size"])
    if g > 0:
        if gap_is_code(off(a) + a["size"], g, a["region"]): gapcode += g
        else: gapdata += g
span = (off(sf[-1]) + sf[-1]["size"]) - off(sf[0])

def esc(s): return html.escape(str(s))

# proportional summary bar
total_all = (by["named"] + by["decoded"] + by["audited"] + by["raw"]
             + by["data_fn"] + gapbytes)
def pct(x): return f"{100*x/total_all:.1f}%"

parts = []
parts.append(f"""<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>VICEROY.EXE — coverage map</title>
<style>
 body{{font:14px/1.45 -apple-system,Segoe UI,Roboto,sans-serif;margin:0;color:#1c2024;background:#fafbfc}}
 .wrap{{max-width:1100px;margin:0 auto;padding:20px}}
 h1{{font-size:20px;margin:0 0 4px}} .sub{{color:#666;margin:0 0 18px}}
 .bar{{display:flex;height:26px;border-radius:6px;overflow:hidden;margin:10px 0 6px;border:1px solid #d4d8de}}
 .bar span{{display:block}}
 .legend{{display:flex;flex-wrap:wrap;gap:14px;margin:8px 0 20px;font-size:13px}}
 .legend i{{display:inline-block;width:12px;height:12px;border-radius:3px;margin-right:6px;vertical-align:-1px}}
 .strip{{display:flex;flex-wrap:wrap;gap:1px;margin:6px 0 22px;line-height:0}}
 .strip b{{display:block;height:14px;border-radius:1px}}
 .stat{{display:inline-block;margin-right:18px}} .stat b{{font-size:18px}}
 details{{border:1px solid #e2e5ea;border-left-width:4px;border-radius:5px;margin:5px 0;background:#fff}}
 summary{{cursor:pointer;padding:7px 10px;display:flex;gap:10px;align-items:center;font-family:ui-monospace,Menlo,monospace;font-size:12.5px}}
 summary .nm{{font-family:inherit}} summary .off{{color:#888}}
 .tag{{font-size:11px;padding:1px 7px;border-radius:10px;color:#fff;white-space:nowrap}}
 .grid{{display:grid;grid-template-columns:1fr 320px;gap:0;border-top:1px solid #eee}}
 .asm{{font-family:ui-monospace,Menlo,monospace;font-size:11.5px;white-space:pre;overflow-x:auto;padding:10px;background:#fcfcfd;margin:0}}
 .mean{{padding:10px;background:#f6f8fa;border-left:1px solid #eee;font-size:12.5px}}
 .mean h4{{margin:0 0 6px;font-size:12px;text-transform:uppercase;letter-spacing:.04em;color:#777}}
 .mean code{{background:#eef1f4;padding:1px 4px;border-radius:3px}}
 .gap{{text-align:center;color:#9aa0a6;font-size:11.5px;font-family:ui-monospace,monospace;margin:3px 0}}
 @media(max-width:720px){{.grid{{grid-template-columns:1fr}}.mean{{border-left:0;border-top:1px solid #eee}}}}
</style></head><body><div class="wrap">
<h1>VICEROY.EXE — code coverage map</h1>
<p class="sub">Every recognized function, laid out by file offset. Colour = how well it is understood.
Click a row to see its raw assembly beside what it does. Read-only.<br>
<b>Reading the pale blocks:</b> these are now mostly genuine <b>data</b> (light-tan)
— strings, lookup tables, padding — handled by the data-extraction track, not
decoded into functions. The overlay function sizes were previously truncated at
the first internal <code>RETF</code>, which made ~70% of overlay code show as
false "gaps"; those have been corrected to their true extents (adopted from the
RTLink re-segmentation), so that code is now attributed to its functions. Any
light-blue that remains is residual unmapped code. (See
<code>docs/UNMAPPED_REGIONS_AUDIT.md</code>.)</p>

<div>
 <span class="stat" style="color:{LABELS['named'][1]}"><b>{len([f for f in FUNCS if classify(f)=='named'])}</b> identified</span>
 <span class="stat" style="color:{LABELS['decoded'][1]}"><b>{len([f for f in FUNCS if classify(f)=='decoded'])}</b> decoded in C</span>
 <span class="stat" style="color:{LABELS['audited'][1]}"><b>{len([f for f in FUNCS if classify(f)=='audited'])}</b> audited</span>
 <span class="stat" style="color:{LABELS['raw'][1]}"><b>{len([f for f in FUNCS if classify(f)=='raw'])}</b> raw</span>
 <span class="stat"><b>{100*understood/codetot:.0f}%</b> of recognized code understood</span>
</div>
<div class="bar">
 <span style="width:{pct(by['named'])};background:{LABELS['named'][1]}" title="identified {pct(by['named'])}"></span>
 <span style="width:{pct(by['decoded'])};background:{LABELS['decoded'][1]}" title="decoded {pct(by['decoded'])}"></span>
 <span style="width:{pct(by['audited'])};background:{LABELS['audited'][1]}" title="audited {pct(by['audited'])}"></span>
 <span style="width:{pct(by['raw'])};background:{LABELS['raw'][1]}" title="raw {pct(by['raw'])}"></span>
 <span style="width:{pct(gapcode)};background:{LABELS['gap_code'][1]}" title="unmapped code {pct(gapcode)}"></span>
 <span style="width:{pct(by['data_fn']+gapdata)};background:{LABELS['gap_data'][1]}" title="unmapped data {pct(by['data_fn']+gapdata)}"></span>
</div>
<div class="legend">""")
for k in ("named", "decoded", "audited", "raw", "data_fn", "gap_code", "gap_data"):
    parts.append(f'<span><i style="background:{LABELS[k][1]}"></i>{LABELS[k][0]}</span>')
parts.append("</div>")

# whole-binary proportional strip (each function a block sized ~ by bytes)
parts.append('<h3 style="margin:6px 0">The whole binary at a glance</h3><div class="strip">')
for a, b in zip(sf, sf[1:] + [None]):
    cls = classify(a)
    w = max(2, round(120 * a["size"] / span))
    parts.append(f'<b style="width:{w}px;background:{LABELS[cls][1]}" '
                 f'title="0x{off(a):X} {esc(a["name"])} ({a["size"]}B) — {LABELS[cls][0]}"></b>')
    if b is not None:
        g = off(b) - (off(a) + a["size"])
        if g > 0:
            w = max(1, round(120 * g / span))
            gk = "gap_code" if gap_is_code(off(a)+a["size"], g, a["region"]) else "gap_data"
            parts.append(f'<b style="width:{w}px;background:{LABELS[gk][1]}" title="{LABELS[gk][0]} — {g} bytes"></b>')
parts.append("</div>")

# per-function expandable list
parts.append('<h3 style="margin:18px 0 6px">Function by function</h3>')
for a, b in zip(sf, sf[1:] + [None]):
    cls = classify(a); label, col = LABELS[cls]
    body, hdr = read_asm(a)
    nm = humanize(a["name"]) or "(unnamed)"
    trunc = ""
    if len(body) > MAX_ASM_LINES:
        trunc = f"\n… {len(body)-MAX_ASM_LINES} more lines (truncated)"
        body = body[:MAX_ASM_LINES]
    asm = esc("\n".join(body)) + esc(trunc) if body else "(no disassembly listing)"
    # meaning column
    mean = []
    if cls == "named":
        mean.append(f"<b>Identified function.</b> Named <code>{esc(a['name'])}</code> in the function registry.")
    elif cls == "decoded":
        files = sorted(cfile_of.get(off(a), []))
        mean.append("<b>Reconstructed in C</b> (hand-ported from these bytes):")
        mean.append("<br>" + "<br>".join(f"<code>{esc(x)}</code>" for x in files[:4]))
    elif cls == "audited":
        mean.append(f"<b>Role identified</b> as <code>{esc(a['name'])}</code> (see "
                    "<code>docs/RAW_FUNCTION_AUDIT.md</code>). Classified from its own "
                    "bytes — not a full byte-port yet.")
    elif cls == "data_fn":
        mean.append("<b>Not code.</b> This entry is a data / zero-fill block the "
                    "auto-segmenter wrongly split as a function — reclassified as data "
                    "(see <code>docs/RAW_FUNCTION_AUDIT.md</code>).")
    else:
        mean.append("<b>Not yet identified.</b> Disassembled, but its purpose hasn't been worked out — this is the kind of gap that remains.")
    if hdr.get("Tagged"): mean.append(f'<div style="margin-top:8px"><h4>String hints</h4>{esc(hdr["Tagged"])}</div>')
    if hdr.get("Purpose") and hdr["Purpose"] != "UNKNOWN":
        mean.append(f'<div style="margin-top:8px"><h4>Purpose</h4>{esc(hdr["Purpose"])}</div>')
    parts.append(
        f'<details><summary style="border-left:0">'
        f'<span class="tag" style="background:{col}">{label}</span>'
        f'<span class="off">0x{off(a):06X}</span>'
        f'<span class="nm">{esc(nm)}</span>'
        f'<span class="off">· {a["size"]}B · {esc(a["region"])}</span></summary>'
        f'<div class="grid"><pre class="asm">{asm}</pre>'
        f'<div class="mean"><h4>What it does</h4>{"".join(mean)}</div></div></details>')
    if b is not None:
        g = off(b) - (off(a) + a["size"])
        if g > 64:   # only flag sizeable gaps
            start = off(a) + a["size"]
            gk = "CODE (overlay, not yet split into functions)" if gap_is_code(start, g, a["region"]) else "data / strings / padding"
            parts.append(f'<div class="gap">— unmapped 0x{start:06X}..0x{off(b):06X} · {g} bytes · {gk} —</div>')

parts.append("</div></body></html>")
OUT.write_text("".join(parts), encoding="utf-8")
size_mb = OUT.stat().st_size / 1e6
print(f"wrote {OUT}  ({size_mb:.1f} MB)  named={by['named']}B decoded={by['decoded']}B raw={by['raw']}B gap={gapbytes}B")
