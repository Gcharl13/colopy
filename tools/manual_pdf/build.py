#!/usr/bin/env python3
"""Viceroy Technical Manual — PDF builder.

Self-contained implementation of MANUAL_BUILD_SPEC_1 for this repository:
  source  docs/COLONIZATION_TECHNICAL_REFERENCE.md
  output  docs/Viceroy_Technical_Reference.pdf

Pipeline: preprocess markdown -> per-section HTML -> DOM transforms
(struct listings -> byte plates / ribbons, region listings -> UI wireframes,
dressed tables, hex styling, code highlighting) -> two-pass Chromium render
(pass 1 measures section folios for the contents list) -> running-head/folio
overlay -> zero-margin cover -> pypdf merge with bookmarks and metadata.

Faces (TeX Gyre unavailable offline; nearest ancestors substituted):
  Display  URW Gothic          (ancestor of TeX Gyre Adventor)
  Heading  Nimbus Sans Narrow  (ancestor of TeX Gyre Heros Cn)
  Body     Charter RE          (Bitstream Charter, Type1 -> OTF, t1_to_otf.py)
  Data     DejaVu Sans Mono
"""
import html as htmlmod
import math
import re
import sys
from pathlib import Path

import markdown
from bs4 import BeautifulSoup, NavigableString

try:
    import sprites as SPR
except ImportError:
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import sprites as SPR

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "docs/COLONIZATION_TECHNICAL_REFERENCE.md"
OUTDIR = ROOT / "docs"
WORK = Path(__file__).resolve().parent / "_work"
CSS = Path(__file__).resolve().parent / "style.css"
CHROMIUM = "/opt/pw-browsers/chromium"

GAME_TITLE = "SID MEIER'S COLONIZATION"
DOC_TITLE = "Sid Meier's Colonization — Technical Reference"

MARGINS = {"top": "0.82in", "bottom": "0.78in", "left": "0.90in", "right": "0.75in"}

CAT = {
    "pos":  ("#2E6E70", "#DCEBEA"),
    "num":  ("#3C4E8F", "#E0E4F2"),
    "econ": ("#A2661A", "#F4E7D2"),
    "flag": ("#7A3A6B", "#EEDFEB"),
    "pad":  ("#8A939C", "#E9ECEF"),
    "arr":  ("#5F7A3F", "#E6EDDC"),
    "text": ("#1F5F86", "#DCE9F1"),
    "warn": ("#A93B25", "#F5DFD9"),
}
INK, MUTED, FAINT, RULE = "#191C21", "#6B747D", "#8A939C", "#C9CDD3"
HEAD_FACE = "Nimbus Sans Narrow"
MONO_FACE = "DejaVu Sans Mono"

PARTS = [
    ("I", "The machine and its files", ["1", "2", "3", "4"]),
    ("II", "World and terrain", ["5", "6", "7"]),
    ("III", "Economy and colonies", ["8", "9", "10", "11"]),
    ("IV", "Units and combat", ["12", "13", "14"]),
    ("V", "Politics and powers", ["15", "16", "17", "18", "19", "20", "21"]),
    ("VI", "Events and messages", ["22", "23", "24"]),
    ("VII", "User interface", ["25", "26", "27"]),
    ("VIII", "The editor and appendices", ["28", "29", "A", "B"]),
]

WARNINGS = []


def warn(msg):
    WARNINGS.append(msg)
    print(f"  [warn] {msg}", file=sys.stderr)


# --------------------------------------------------------------------------
# 1. Load + preprocess source
# --------------------------------------------------------------------------

def load_source():
    text = SRC.read_text()
    # Drop the title block and the hand-written contents list: keep from '## 1.'
    m = re.search(r"^## 1\. ", text, re.M)
    preamble = text[: m.start()]
    body = text[m.start():]
    about = ""
    pm = re.search(r"^# .*?\n\n(.*?)\n\n## Contents", preamble, re.S | re.M)
    if pm:
        about = " ".join(pm.group(1).split())
    # Defensive re-implementation strips (per spec §3; source is authored clean)
    body = body.replace("**Yes** — ", "")
    body = re.sub(r"\b\w+_ex\(\)", "", body)
    return about, body


def split_sections(body):
    """Return ordered [(key, title, md_text)] split on '## N.' / '## A.' heads."""
    parts = re.split(r"^## (\d+|[AB])\. (.+)$", body, flags=re.M)
    out = []
    it = iter(parts[1:])
    for key, title, text in zip(it, it, it):
        out.append((key, title.strip(), text))
    return out


# --------------------------------------------------------------------------
# 2. Struct parsing -> byte plates / ribbons
# --------------------------------------------------------------------------

TYPE_SIZES = {"uint8_t": 1, "int8_t": 1, "char": 1, "uint16_t": 2, "int16_t": 2,
              "uint32_t": 4, "int32_t": 4, "uint64_t": 8, "int64_t": 8}
STRUCT_SIZES = {}  # populated in document order; lets e.g. RouteRecord embed StopRecord

FIELD_RE = re.compile(
    r"^\s*(\w+)((?:\s+far)?\s*\*)?\s*([^;/]+?)\s*;\s*(?://\s*(.*))?$")
INLINE_RE = re.compile(
    r"^\s*struct\s*\{([^}]*)\}\s*(\w+)(?:\[(\d+)\])?\s*;\s*(?://\s*(.*))?$")
UNMAP_RE = re.compile(
    r"^\s*//\s*\+0x([0-9A-Fa-f]+)(?:\.\.\+0x([0-9A-Fa-f]+))?\s+unmapped\b(.*)$")
OFF_RE = re.compile(r"^\+0x([0-9A-Fa-f]+)\s*(.*)$", re.S)
OFF_TAIL_RE = re.compile(r"^(?:(?:\.\.|/)\+0x[0-9A-Fa-f]+)*\s*:?\s*")


def clean_note(note):
    """Drop offset-comment residue: leading '..+0xNN', '/+0xNN', ':'."""
    return OFF_TAIL_RE.sub("", note.strip(), count=1).strip()


def classify(name, ctype, note):
    n, t = (name or "").lower(), (note or "").lower()
    if name is None or n.startswith(("unused", "pad")) or "unmapped" in t:
        return "pad"
    if any(k in n or k in t for k in ("hostile", "burn", "loot", "combat", "war_")):
        return "warn"
    if any(k in n for k in ("cargo", "stock", "price", "gold", "treasur", "tax",
                            "hammer", "tool", "market", "good")):
        return "econ"
    if "flag" in n or "mask" in n or "bits" in n or "bitmask" in t:
        return "flag"
    if ctype == "char" or "name" in n or "text" in n or "str" in n:
        return "text"
    if re.search(r"\[", name or "") or "array" in t:
        return "arr"
    if any(k in n for k in ("map_x", "map_y", "_x", "_y", "type", "idx", "id",
                            "owner", "seg", "offset", "ptr", "link", "heading",
                            "next", "back", "num", "slot", "row", "col", "key")):
        return "pos"
    return "num"


def parse_struct(seg_body, name, closer_note, opener_note):
    """Return dict(name, total, fields, variable). fields: list of dicts."""
    fields = []
    offset = 0
    variable = False
    for line in seg_body.splitlines():
        if not line.strip() or line.strip().startswith("typedef"):
            continue
        um = UNMAP_RE.match(line)
        if um:
            lo = int(um.group(1), 16)
            hi = int(um.group(2), 16) if um.group(2) else lo
            fields.append(dict(off=lo, size=hi - lo + 1, name=None, ctype="—",
                               note="unmapped" + (um.group(3) or "").strip(" ;"),
                               cat="pad"))
            offset = hi + 1
            continue
        if line.strip().startswith("//"):
            continue  # free comment / continuation line
        im = INLINE_RE.match(line)
        if im:
            inner, iname, icount, inote = im.groups()
            unit = 0
            for stmt in inner.split(";"):
                sm = re.match(r"\s*(\w+)\s+(.+?)\s*$", stmt.strip())
                if sm and sm.group(1) in TYPE_SIZES:
                    unit += TYPE_SIZES[sm.group(1)] * len(sm.group(2).split(","))
            inote = inote or ""
            om = OFF_RE.match(inote.strip())
            if om:
                offset = int(om.group(1), 16)
                inote = om.group(2).strip()
            n = int(icount) if icount else 1
            fields.append(dict(off=offset, size=unit * n,
                               name=f"{iname}[{icount}]" if icount else iname,
                               ctype=f"struct{{{inner.strip()}}}",
                               note=clean_note(inote), cat=None))
            offset += unit * n
            continue
        fm = FIELD_RE.match(line)
        if not fm:
            return None  # unparseable structural line -> keep as code
        ctype, ptr, decls, note = (fm.group(1), fm.group(2) or "",
                                   fm.group(3), fm.group(4) or "")
        om = OFF_RE.match(note.strip())
        if om:
            offset = int(om.group(1), 16)
            note = om.group(2).strip()
        names, size = [], 0
        for decl in decls.split(","):
            decl = decl.strip()
            is_ptr = bool(ptr.strip()) or decl.startswith("*")
            decl = decl.lstrip("*").strip()
            am = re.match(r"(\w+)(?:\[([^\]]*)\])?$", decl)
            if not am:
                return None
            dname, count = am.group(1), am.group(2)
            if is_ptr:
                base = 4 if "far" in ptr else 2  # 16-bit: far seg:off / near
            elif ctype in TYPE_SIZES:
                base = TYPE_SIZES[ctype]
            elif ctype in STRUCT_SIZES:
                base = STRUCT_SIZES[ctype]
            else:
                return None
            if count is not None and count.strip():
                try:
                    dsize = base * int(count.strip(), 0)
                except ValueError:
                    dsize = None
                    variable = True
                dname = f"{dname}[{count.strip()}]"
            else:
                dsize = base
            names.append(dname)
            size = None if (dsize is None or size is None) else size + dsize
        shown_type = ctype + (" far *" if (ptr and "far" in ptr)
                              else " *" if ptr.strip() else "")
        fields.append(dict(off=offset, size=size, name=", ".join(names),
                           ctype=shown_type, note=clean_note(note), cat=None))
        if size is not None:
            offset += size
    for f in fields:
        if f["cat"] is None:
            f["cat"] = classify(f["name"], f["ctype"], f["note"])
    total = None
    for src in (closer_note or "", opener_note or ""):
        m = (re.search(r"sizeof\s*=\s*0x([0-9A-Fa-f]+)", src)
             or re.search(r"stride\s+0x([0-9A-Fa-f]+)", src)
             or re.search(r"ends exactly at \+0x([0-9A-Fa-f]+)", src)
             or re.search(r"~?0x([0-9A-Fa-f]+)\+?\s+bytes", src))
        if m:
            total = int(m.group(1), 16)
            break
        m = re.search(r"(\d+)\s+bytes", src)
        if m:
            total = int(m.group(1))
            break
    if total is None and not variable:
        total = max((f["off"] + f["size"]) for f in fields) if fields else 0
    if total is not None:
        STRUCT_SIZES[name] = total
    return dict(name=name, total=total, fields=fields, variable=variable,
                closer=(closer_note or "").strip(" /"), opener=(opener_note or "").strip(" /"))


def esc(s):
    return htmlmod.escape(str(s), quote=True)


def svg_text(x, y, s, size, fill=INK, anchor="start", face=HEAD_FACE, weight="normal",
             spacing=None):
    sp = f' letter-spacing="{spacing}"' if spacing else ""
    return (f'<text x="{x}" y="{y}" font-family="{esc(face)}" font-size="{size}"'
            f' font-weight="{weight}" fill="{fill}" text-anchor="{anchor}"{sp}>{esc(s)}</text>')


def byte_plate_svg(st):
    """16 bytes per row byte plate."""
    total = st["total"]
    gut, cw, ch, ruler = 46, 38, 23, 15
    rows = max(1, math.ceil(total / 16))
    W, H = 660, ruler + rows * ch + 4
    e = [f'<svg viewBox="0 0 {W} {H}" xmlns="http://www.w3.org/2000/svg">']
    # ruler
    for c in range(16):
        e.append(svg_text(gut + c * cw + cw / 2, ruler - 5, f"+{c:X}", 8.2,
                          fill=FAINT, anchor="middle", face=MONO_FACE))
    # byte->field map
    cover = {}
    for i, f in enumerate(st["fields"]):
        for b in range(f["off"], f["off"] + f["size"]):
            if b < total:
                cover[b] = i
    # cells
    for r in range(rows):
        y = ruler + r * ch
        e.append(svg_text(gut - 6, y + ch / 2 + 3, f"+0x{r * 16:02X}", 8.2,
                          fill=MUTED, anchor="end", face=MONO_FACE))
        for c in range(16):
            b = r * 16 + c
            if b >= total:
                break
            x = gut + c * cw
            fi = cover.get(b)
            dark, light = CAT[st["fields"][fi]["cat"]] if fi is not None else CAT["pad"]
            if fi is None:
                light = "#F2F3F4"
            e.append(f'<rect x="{x}" y="{y}" width="{cw}" height="{ch}" '
                     f'fill="{light}" stroke="{RULE}" stroke-width="0.5"/>')
            if fi is not None and st["fields"][fi]["off"] == b:
                e.append(f'<rect x="{x}" y="{y}" width="2.6" height="{ch}" fill="{dark}"/>')
    # labels on runs of >=4 cells within a row
    for i, f in enumerate(st["fields"]):
        if not f["name"]:
            continue
        dark, _ = CAT[f["cat"]]
        enum = enum_labels_for(f)
        if enum:
            labels, es = enum
            # per-element ticks + text labels drawn inside the grid cells
            for k, lab in enumerate(labels):
                lo = f["off"] + k * es
                hi = min(lo + es, total)
                if lo >= total:
                    break
                r = lo // 16
                x0e = gut + (lo % 16) * cw
                run = (min(hi, (r + 1) * 16) - lo)  # cells of this element on its row
                wpx = run * cw
                if k > 0:
                    e.append(f'<rect x="{x0e}" y="{ruler + r * ch}" width="1.4" '
                             f'height="{ch}" fill="{dark}" fill-opacity="0.55"/>')
                size = min(6.8, max(4.6, (wpx - 5) / (0.5 * max(1, len(lab)))))
                txt = lab
                if 0.5 * len(txt) * size > wpx - 4:
                    txt = txt[: max(2, int((wpx - 6) / (0.5 * size)))] + "…"
                e.append(svg_text(x0e + wpx / 2, ruler + r * ch + ch / 2 + 5.5,
                                  txt, size, fill=dark, anchor="middle",
                                  weight="bold"))
            # field name once, small, along the top of the first row segment
            r0 = f["off"] // 16
            seg_lo = f["off"]
            seg_hi = min(f["off"] + f["size"], (r0 + 1) * 16)
            xn = gut + (seg_lo % 16) * cw + 3
            e.append(svg_text(xn, ruler + r0 * ch + 7.2, f["name"], 5.8,
                              fill=dark))
            continue
        best = None
        for r in range(rows):
            lo = max(f["off"], r * 16)
            hi = min(f["off"] + f["size"], (r + 1) * 16)
            if hi - lo >= 4 and (best is None or hi - lo > best[1] - best[0]):
                best = (lo, hi, r)
        if best:
            lo, hi, r = best
            x = gut + (lo % 16) * cw + (hi - lo) * cw / 2
            y = ruler + r * ch + ch / 2 + 3
            label = f["name"]
            maxch = int((hi - lo) * cw / 5.2)
            if len(label) > maxch:
                label = label[: maxch - 1] + "…"
            e.append(svg_text(x, y, label, 8.6, fill=dark, anchor="middle", weight="bold"))
        idx = index_elements_for(f)
        if idx:
            n, es = idx
            for k in range(n):
                lo = f["off"] + k * es
                if lo >= total:
                    break
                r = lo // 16
                x0e = gut + (lo % 16) * cw
                run = min(es, (r + 1) * 16 - lo, total - lo)
                if k > 0:
                    e.append(f'<rect x="{x0e}" y="{ruler + r * ch}" width="1.2" '
                             f'height="{ch}" fill="{dark}" fill-opacity="0.45"/>')
                e.append(svg_text(x0e + run * cw / 2, ruler + r * ch + ch - 3,
                                  str(k), 4.9, fill=dark, anchor="middle"))
    e.append(f'<rect x="{gut}" y="{ruler}" width="{16 * cw}" '
             f'height="{rows * ch}" fill="none" stroke="{INK}" stroke-width="1.1"/>')
    # mask final partial row edge
    rem = total % 16
    if rem:
        x = gut + rem * cw
        y = ruler + (rows - 1) * ch
        e.append(f'<rect x="{x - 0.5}" y="{y - 0.6}" width="{(16 - rem) * cw + 2}" height="{ch + 1.2}" '
                 f'fill="#FCFBF8" stroke="none"/>')
        e.append(f'<line x1="{x}" y1="{y}" x2="{x}" y2="{y + ch}" stroke="{INK}" stroke-width="1.1"/>')
        e.append(f'<line x1="{gut}" y1="{y + ch}" x2="{x}" y2="{y + ch}" stroke="{INK}" stroke-width="1.1"/>')
        e.append(f'<line x1="{x}" y1="{y}" x2="{gut + 16 * cw}" y2="{y}" stroke="{INK}" stroke-width="1.1"/>')
    e.append("</svg>")
    return "\n".join(e)


def ribbon_svg(st):
    """Proportional layout for variable-size structs."""
    fields = [f for f in st["fields"] if f["name"] or f["size"]]
    weights = []
    fixed = [f["size"] for f in fields if f["size"]]
    varw = (sum(fixed) / max(1, len(fixed))) * 6 if fixed else 100
    for f in fields:
        weights.append(f["size"] if f["size"] else varw)
    W, H, y0, bh = 660, 92, 30, 34
    tw = sum(weights)
    e = [f'<svg viewBox="0 0 {W} {H}" xmlns="http://www.w3.org/2000/svg">']
    x = 2.0
    avail = W - 4
    minw = 58
    px = [max(minw, w / tw * avail) for w in weights]
    scale = avail / sum(px)
    px = [w * scale for w in px]
    for f, w in zip(fields, px):
        dark, light = CAT[f["cat"]]
        e.append(f'<rect x="{x:.1f}" y="{y0}" width="{w:.1f}" height="{bh}" '
                 f'fill="{light}" stroke="{dark}" stroke-width="1.1"/>')
        label = f["name"] or "—"
        size = 9 if len(label) * 5.4 < w else 7.2
        if len(label) * (size * 0.6) > w:
            label = label[: max(3, int(w / (size * 0.6)) - 1)] + "…"
        e.append(svg_text(x + w / 2, y0 + bh / 2 + 3.4, label, size, fill=dark,
                          anchor="middle", weight="bold"))
        ext = f"+0x{f['off']:02X}" if f["size"] else "variable"
        if f["size"]:
            ext += f" · {f['size']}B"
        xt = min(max(x + w / 2, len(ext) * 2.4 + 3), W - len(ext) * 2.4 - 3)
        e.append(svg_text(xt, y0 - 6, ext, 7.6, fill=MUTED, anchor="middle",
                          face=MONO_FACE))
        x += w
    e.append("</svg>")
    return "\n".join(e)


def struct_figure(st, soup):
    plate = ribbon_svg(st) if st["variable"] else byte_plate_svg(st)
    mapped = sum(f["size"] or 0 for f in st["fields"] if f["name"])
    unmapped = sum(f["size"] or 0 for f in st["fields"] if not f["name"])
    if st["variable"]:
        cap = "variable length — proportional layout, true extents above each region"
    else:
        t = st["total"]
        cap = f"{t} bytes (0x{t:X}) · mapped {mapped} · unmapped {t - mapped}"
    note = st["closer"] or st["opener"]
    sub = esc(note) if note else ""
    rows = []
    for f in st["fields"]:
        if f["size"] is None:
            off = f"+0x{f['off']:02X}…"
            width = "var"
        elif f["size"] == 1:
            off, width = f"+0x{f['off']:02X}", "1"
        else:
            off = f"+0x{f['off']:02X}..+0x{f['off'] + f['size'] - 1:02X}"
            width = str(f["size"])
        dark = CAT[f["cat"]][0]
        nm = f["name"] or "—"
        rows.append(
            f'<tr><td class="cmono">{esc(off)}</td><td class="cnum">{width}</td>'
            f'<td class="cmono">{esc(f["ctype"])}</td>'
            f'<td class="cmono" style="color:{dark};font-weight:bold">{esc(nm)}</td>'
            f'<td>{esc(f["note"])}</td></tr>')
    tall = " tall" if (len(rows) > 12 or (st["total"] or 0) > 128) else ""
    fig = (f'<figure class="structplate{tall}">'
           f'<div style="break-inside:avoid"><div class="platehead"><span class="pt">{esc(st["name"])}</span>'
           f'<span class="ps">{sub}</span></div>'
           f'<div class="plate-wrap">{plate}</div>'
           f'<figcaption>{esc(cap)}</figcaption></div>'
           f'<div class="tablewrap"><table class="keytab"><thead><tr><th>Offset</th><th>B</th>'
           f'<th>Type</th><th>Field</th><th>Note</th></tr></thead>'
           f'<tbody>{"".join(rows)}</tbody></table></div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


STRUCT_RE = re.compile(
    r"typedef struct\s*\{([^\n]*)\n(.*?)\n\}\s*(\w+)\s*;([^\n]*)", re.S)


def structs_to_plates(soup):
    n = 0
    for pre in list(soup.find_all("pre")):
        code = pre.find("code")
        if code is None or "typedef struct" not in code.get_text():
            continue
        text = code.get_text()
        pieces = []
        last = 0
        ok = True
        for m in STRUCT_RE.finditer(text):
            st = parse_struct(m.group(2), m.group(3),
                              m.group(4), m.group(1).lstrip(" /"))
            if st is None:
                warn(f"struct {m.group(3)}: unparseable line — left as code")
                ok = False
                break
            leftover = text[last:m.start()].strip()
            if leftover:
                pieces.append(("code", leftover))
            pieces.append(("struct", st))
            last = m.end()
        if not ok or not pieces:
            continue
        tail = text[last:].strip()
        if tail:
            pieces.append(("code", tail))
        frags = []
        for kind, val in pieces:
            if kind == "struct":
                frags.append(struct_figure(val, soup))
                n += 1
                if val["name"] in BITSTRIPS and val["name"] not in _bitstrips_done:
                    _bitstrips_done.add(val["name"])
                    for spec in BITSTRIPS[val["name"]]:
                        frags.append(bit_fig(**spec))
            else:
                p = soup.new_tag("pre")
                c = soup.new_tag("code")
                c.string = val
                p.append(c)
                frags.append(p)
        anchor = pre
        for fr in frags:
            anchor.insert_after(fr)
            anchor = fr
        pre.decompose()
    return n


# --------------------------------------------------------------------------
# 2b. Bit strips (spec 4: visuals.bit_strip) — curated, byte-cited layouts
# --------------------------------------------------------------------------

def bit_strip_svg(groups, nbits=8, perbit=None, perbit_cat="econ"):
    """nbits boxes, high bit left. groups: (hi, lo, label, cat, detail);
    perbit: {bit: label} for masks where every bit has its own meaning."""
    bw = 56 if nbits <= 8 else 38
    bh = 34
    x0 = (660 - nbits * bw) / 2
    y0 = 16
    covered = {}
    for gi, (hi, lo, label, cat, detail) in enumerate(groups):
        for b in range(lo, hi + 1):
            covered[b] = gi
    legend = [(lab, det) for _, _, lab, _, det in groups if det]
    pb_row = 12 if perbit else 0
    br_row = 24 if groups else 4
    H = y0 + bh + pb_row + br_row + len(legend) * 13 + 8
    e = [f'<svg viewBox="0 0 660 {H}" xmlns="http://www.w3.org/2000/svg">']
    wfmt = "0x{:02X}" if nbits <= 8 else "0x{:04X}"
    for b in range(nbits - 1, -1, -1):
        x = x0 + (nbits - 1 - b) * bw
        gi = covered.get(b)
        if gi is not None:
            dark, light = CAT[groups[gi][3]]
        elif perbit and b in perbit:
            dark, light = CAT[perbit_cat]
        else:
            dark, light = CAT["pad"][0], "#F2F3F4"
        e.append(f'<rect x="{x}" y="{y0}" width="{bw}" height="{bh}" '
                 f'fill="{light}" stroke="{INK}" stroke-width="0.8"/>')
        e.append(svg_text(x + bw / 2, y0 - 4, f"{b}", 7.0, fill=FAINT,
                          anchor="middle", face=MONO_FACE))
        active = gi is not None or (perbit and b in perbit)
        e.append(svg_text(x + bw / 2, y0 + bh / 2 + 3, wfmt.format(1 << b),
                          7.6 if nbits > 8 else 8.6,
                          fill=(dark if active else FAINT),
                          anchor="middle", face=MONO_FACE,
                          weight="bold" if active else "normal"))
    yb = y0 + bh + 3
    if perbit:
        dark, _ = CAT[perbit_cat]
        for b, lab in perbit.items():
            x = x0 + (nbits - 1 - b) * bw
            e.append(svg_text(x + bw / 2, yb + 7, lab, 5.2, fill=dark,
                              anchor="middle"))
        yb += pb_row
    for hi, lo, label, cat, detail in groups:
        dark, _ = CAT[cat]
        xl = x0 + (nbits - 1 - hi) * bw + 2
        xr = x0 + (nbits - lo) * bw - 2
        e.append(f'<path d="M {xl} {yb} L {xl} {yb + 4} L {xr} {yb + 4} L {xr} {yb}" '
                 f'fill="none" stroke="{dark}" stroke-width="1.1"/>')
        cx = min(max((xl + xr) / 2, x0 + len(label) * 2.2 + 2),
                 x0 + nbits * bw - len(label) * 2.2 - 2)
        e.append(svg_text(cx, yb + 15, label, 8.2, fill=dark, anchor="middle",
                          weight="bold"))
    yl = yb + br_row + 4
    for lab, det in legend:
        e.append(svg_text(x0, yl, f"{lab} — {det}", 7.6, fill=MUTED))
        yl += 13
    e.append("</svg>")
    return "\n".join(e)


def bit_fig(title, sub, groups, nbits=8, perbit=None, perbit_cat="econ"):
    fig = (f'<figure class="bitstrip"><div style="break-inside:avoid">'
           f'<div class="platehead"><span class="pt">{esc(title)}</span>'
           f'<span class="ps">{esc(sub)}</span></div>'
           f'<div class="plate-wrap">'
           f'{bit_strip_svg(groups, nbits, perbit, perbit_cat)}</div></div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


# dict(title, sub, groups[, nbits, perbit]) per byte/word — every layout below
# is transcribed from the struct's own byte-cited field notes or the section
# text it appears in (sections 3, 9, 11, 12, 15, 19).
def _bs(title, sub, groups, **kw):
    return dict(title=title, sub=sub, groups=groups, **kw)


BITSTRIPS = {
    "MPFile": [
        _bs("Layer 1 — terrain byte", "per tile; ids and overlay bits (section 3)", [
            (4, 0, "terrain id 0..28", "pos", "AND 0x1F fold at 0x620A; 8..23 = forested variants"),
            (5, 5, "mtn/hill", "flag", "with bit 7: set = Mountains (0xA0), clear = Hills (0x20)"),
            (6, 6, "river", "flag", "with bit 7: set = major river (0xC0), clear = minor (0x40)"),
            (7, 7, "modifier", "flag", "qualifies bits 5/6 as above"),
        ]),
        _bs("Layer 2 — feature byte", "per tile; VICEROY discards this layer on load and rebuilds it", [
            (0, 0, "unit", "pos", "unit present (MAPEDIT _is_unit @0x43C8)"),
            (1, 1, "settlement", "pos", "colony/village/city (@0x43F6..)"),
            (2, 2, "prime rsrc", "econ", "prime resource (_resource_at @0x45CF)"),
            (3, 3, "hostile A", "warn", "tested with bit 6 by _is_hostile @0x44D1 (mask 0x48)"),
            (6, 6, "hostile B", "warn", None),
        ]),
        _bs("Layer 3 — continent byte", "per tile", [
            (3, 0, "continent 1..15", "pos", "0 = border/none (_continent_at @0x428B)"),
            (7, 4, "owner", "pos", "0xF = none (_owner_of @0x42C5)"),
        ]),
    ],
    "UnitRecord": [
        _bs("UnitRecord +0x03 — owner byte", "set_unit_owner @0x738E", [
            (3, 0, "power 0..11", "pos", "0..3 European, 4..11 tribes"),
            (7, 4, "state", "flag", "high-nibble unit state"),
        ]),
        _bs("UnitRecord +0x04 — flags byte", "transient per-pass bit register", [
            (7, 7, "draw", "flag", "draw-active / Damaged display pair (set @0x069923; @ARTILLERY @0x05B6F6)"),
            (6, 6, "cargo", "econ", "ship-carrying-cargo (@0x02F37A)"),
            (5, 5, "merch", "pos", "Merchantman tag (@0x04CE44)"),
            (4, 4, "path", "num", "path >= 8 hops (@0x05106E)"),
            (3, 3, "dirty", "flag", "tile-dirty (@0x0481B0)"),
            (2, 2, "class", "pos", "ship-cargo class (@0x04CDDC)"),
            (1, 1, "fortif", "flag", "was-fortifying (@0x04CEC9)"),
        ]),
        _bs("UnitRecord +0x0D..+0x0F — cargo_ids packing",
            "nibble-packed good ids, 2 slots per byte, up to 6 (@0x0B2CB)", [
                (3, 0, "slot 2k", "econ", "even cargo slot — good id 0..15 (@CARGO)"),
                (7, 4, "slot 2k+1", "econ", "odd cargo slot"),
            ]),
        _bs("UnitRecord +0x17 — profession byte on routed units",
            "colonist profession 0x13..0x1C otherwise", [
                (3, 0, "route id", "pos", "trade-route index 0..11"),
                (7, 4, "stop idx", "pos", "current stop 0..3"),
            ]),
    ],
    "NativeSettlement": [
        _bs("NativeSettlement +0x03 — flags", "", [
            (2, 2, "capital", "pos", "set @0x66225; doubles value @0x7DCA"),
            (1, 1, "taught", "num", "already taught (set @0x4A78A)"),
            (0, 0, "w/o", "pad", "write-only bit"),
        ]),
        _bs("NativeSettlement +0x05 — mission byte", "0xFF = no mission", [
            (3, 0, "owning power", "pos", "European power holding the mission"),
            (4, 4, "expert", "econ", "expert-mission doubler (Brebeuf; set @0x48C81, tested @0x57300)"),
        ]),
    ],
    "StopRecord": [
        _bs("StopRecord +0x02 — counts byte",
            "nibble get/set func_0603DA / func_06040A (max 6 each)", [
                (3, 0, "unload count", "econ", "goods unloaded at this stop"),
                (7, 4, "load count", "econ", "goods loaded at this stop"),
            ]),
    ],
    "PowerRecord": [
        _bs("Relations-matrix byte — row base PowerRecord +0x34 (0x883C)",
            "one byte per subject→target pair; accessors func_007F34/96/008000 (section 15.3)", [
                (0, 0, "resolved", "num", "resolved/normalised relationship (set 0x5318F)"),
                (1, 1, "war", "warn", "at war (set 0x58A7B/0x59A61/0x3F0E8; cleared 0x5DE98)"),
                (3, 3, "grievance", "warn", "pending; → bit 0 when +0x40 timer expires and random_int(0,3)==0 (0x53165)"),
                (4, 4, "parley", "num", "parley cooldown 16 turns (stamp 0x58075/0x5914C)"),
                (5, 5, "met", "pos", "met / contacted"),
                (6, 6, "treaty", "pos", "peace treaty in force (set both ways 0x59139)"),
                (7, 7, "privateer", "warn", "hidden attribution — privateer attack sets this, not war (0x3F0A1; revealed 0x58BE1)"),
            ]),
        _bs("boycott_bitmask — PowerRecord +0x20",
            "bit g = good g; set on Tea Party @0x34717; back-tax clear @0x33423; Fugger zeroes the word @0x3BD45",
            [], nbits=16,
            perbit={g: SPR.GOODS[g] for g in range(16)}),
    ],
}
_bitstrips_done = set()


# arrays whose element order is documented in the source (section 9.2 @CARGO;
# @COUNTRY powers 0..3) — labelled per element inside the byte plate
GOODS_FIELDS = {"stockpile", "market_pool", "market_traded", "market_eu_supply",
                "market_base", "boycott_count"}
POWER_FIELDS = {"relations", "treaty_respect", "power_flag", "power_flag2",
                "alarm"}


# section 5.2 legend order (the nine yield columns of the $TERRAIN record)
YIELDS9 = ["Food", "Sugar", "Tobacco", "Cotton", "Furs", "Lumber", "Ore",
           "Silver", "Fish"]
SEMANTIC_ARRAYS = {
    ("yields", 9): YIELDS9,                       # TerrainRecord, section 5.2
    ("nums", 9): [f"c{i}" for i in range(4, 13)],  # MapeditTerrainRec: NAMES cols 4-12
    ("stops", 4): ["stop 0", "stop 1", "stop 2", "stop 3"],  # RouteRecord
    ("cargo_ids", 3): ["slots 0–1", "slots 2–3", "slots 4–5"],  # 2 per byte @0x0B2CB
}


def enum_labels_for(field):
    """(labels, elem_size) when the element order is documented, else None."""
    name = field["name"] or ""
    base = name.split("[")[0]
    if not field["size"]:
        return None
    if base in GOODS_FIELDS and name.endswith("[16]"):
        return SPR.GOODS, field["size"] // 16
    if base in POWER_FIELDS and name.endswith("[4]"):
        return SPR.POWERS, field["size"] // 4
    m = re.match(r"^(\w+)\[(\d+)\]$", name)
    if m and (m.group(1), int(m.group(2))) in SEMANTIC_ARRAYS:
        n = int(m.group(2))
        return SEMANTIC_ARRAYS[(m.group(1), n)], field["size"] // n
    return None


def index_elements_for(field):
    """(count, elem_size) for plain arrays of 2..16 elements — element ticks
    and index labels; no semantic claim, indices only."""
    name = field["name"] or ""
    m = re.match(r"^(\w+)\[(\d+)\]$", name)
    if not m or not field["size"]:
        return None
    base, n = m.group(1), int(m.group(2))
    if not (2 <= n <= 16) or field["size"] % n:
        return None
    if field["ctype"].startswith("char") or base.startswith(("_pad", "unused", "pad")):
        return None
    return n, field["size"] // n


# --------------------------------------------------------------------------
# 3. UI region listings -> wireframes
# --------------------------------------------------------------------------

RNUM = r"(-?\d+|0x[0-9A-Fa-f]+)"
REGION_RE = re.compile(
    rf'\(\s*{RNUM}\s*,\s*{RNUM}\s*,\s*{RNUM}\s*,\s*{RNUM}\s*,\s*"((?:[^"\\]|\\.)*)"\s*,'
    r'\s*"(\w+)"\s*,\s*"((?:[^"\\]|\\.)*)"\s*\)')

KIND_CAT = {"panel": "pos", "hit": "warn", "text": "text", "art": "arr",
            "rect": "flag"}


def wireframe_svg(regions):
    """Draw only fully-determined regions (no -1 coordinate — those are
    runtime-computed and appear in the key table only, never invented)."""
    S = 1.9
    ox, oy = 18, 14
    W = 660
    H = int(200 * S + oy + 22)
    e = [f'<svg viewBox="0 0 {W} {H}" xmlns="http://www.w3.org/2000/svg">']
    fx = ox + (W - 2 * ox - 320 * S) / 2
    e.append(f'<rect x="{fx - 2}" y="{oy - 2}" width="{320 * S + 4}" height="{200 * S + 4}" '
             f'fill="#FFFFFF" stroke="{INK}" stroke-width="1.6"/>')
    drawable = [(i, r) for i, r in enumerate(regions, 1)
                if all(v >= 0 for v in r[:4])]
    for i, (x, y, w, h, label, kind, note) in drawable:
        cat = KIND_CAT.get(kind, "pos")
        dark, light = CAT[cat]
        dash = ' stroke-dasharray="5,3"' if kind == "hit" else ""
        fill = light if kind in ("panel", "art") else "none"
        op = ' fill-opacity="0.45"' if fill != "none" else ""
        e.append(f'<rect x="{fx + x * S:.1f}" y="{oy + y * S:.1f}" width="{w * S:.1f}" '
                 f'height="{h * S:.1f}" fill="{fill}"{op} stroke="{dark}" '
                 f'stroke-width="1.3"{dash}/>')
    for i, (x, y, w, h, label, kind, note) in drawable:
        cat = KIND_CAT.get(kind, "pos")
        dark, _ = CAT[cat]
        cx = fx + x * S + 8
        cy = oy + y * S + 8
        cx = min(max(cx, fx + 8), fx + 320 * S - 8)
        cy = min(max(cy, oy + 8), oy + 200 * S - 8)
        e.append(f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="7.2" fill="{dark}"/>')
        e.append(svg_text(cx, cy + 3.1, str(i), 8.6, fill="#FFFFFF",
                          anchor="middle", weight="bold"))
    # scale note
    e.append(svg_text(fx, oy + 200 * S + 14, "0,0", 7.6, fill=FAINT, face=MONO_FACE))
    e.append(svg_text(fx + 320 * S, oy + 200 * S + 14, "320×200", 7.6,
                      fill=FAINT, anchor="end", face=MONO_FACE))
    e.append("</svg>")
    return "\n".join(e)


def regions_to_wireframes(soup):
    n = 0
    for pre in list(soup.find_all("pre")):
        code = pre.find("code")
        if code is None:
            continue
        text = code.get_text()
        if "regions = [" not in text:
            continue
        regions = [(int(a, 0), int(b, 0), int(c, 0), int(d, 0),
                    lab.replace('\\"', '"'), kind, note.replace('\\"', '"'))
                   for a, b, c, d, lab, kind, note in REGION_RE.findall(text)]
        if not regions:
            warn("region block with no parseable tuples — left as code")
            continue
        nlisted = len([l for l in text.splitlines() if l.strip().startswith("(")])
        if nlisted != len(regions):
            warn(f"region block: {nlisted - len(regions)} of {nlisted} tuples "
                 f"unparsed (kept in table? no — left out); check source")
        # title from nearest previous heading
        hd = pre.find_previous(["h3", "h4", "h2"])
        title = hd.get_text().strip() if hd else "Screen"
        title = re.sub(r"^[\d.§ ]+", "", title)
        tailnote = ""
        tm = re.search(r"\]\s*#\s*320x200 Mode 13h[;,]?\s*(.*)$", text, re.M)
        if tm and tm.group(1).strip():
            tailnote = " · " + tm.group(1).strip()
        rows = []
        for i, (x, y, w, h, lab, kind, note) in enumerate(regions, 1):
            dark = CAT[KIND_CAT.get(kind, "pos")][0]
            fv = lambda v: "·" if v < 0 else str(v)
            bounds = f"({fv(x)},{fv(y)}) {fv(w)}×{fv(h)}"
            if -1 in (x, y, w, h):
                bounds += " ᴿ"  # runtime-computed, not drawn
            rows.append(
                f'<tr><td class="cnum" style="color:{dark};font-weight:bold">{i}</td>'
                f'<td class="cmono">{esc(bounds)}</td>'
                f'<td style="color:{dark}">{esc(kind)}</td>'
                f'<td>{esc(lab)}</td><td>{esc(note)}</td></tr>')
        tall = " tall" if len(rows) > 10 else ""
        fig = (f'<figure class="wireframe{tall}">'
               f'<div style="break-inside:avoid"><div class="platehead"><span class="pt">{esc(title)}</span>'
               f'<span class="ps">320×200 · Mode 13h{esc(tailnote)}</span></div>'
               f'<div class="plate-wrap">{wireframe_svg(regions)}</div></div>'
               f'<div class="tablewrap"><table class="keytab"><thead><tr><th>#</th>'
               f'<th>Bounds</th><th>Kind</th><th>Region</th><th>Note</th></tr></thead>'
               f'<tbody>{"".join(rows)}</tbody></table></div></figure>')
        pre.replace_with(BeautifulSoup(fig, "html.parser"))
        n += 1
    return n


# --------------------------------------------------------------------------
# 4. Remaining code, tables, hex
# --------------------------------------------------------------------------

KEYWORDS = r"\b(typedef|struct|uint8_t|uint16_t|uint32_t|int8_t|int16_t|char|if|else|while|for|return|void)\b"


def highlight_code(soup):
    for pre in soup.find_all("pre"):
        code = pre.find("code")
        node = code if code else pre
        raw = node.get_text()
        out = []
        for line in raw.split("\n"):
            if "//" in line:
                idx = line.index("//")
                body, cmt = line[:idx], line[idx:]
            else:
                body, cmt = line, ""
            body = esc(body)
            body = re.sub(r"\b0x[0-9A-Fa-f]+\b", r'<span class="h">\g<0></span>', body)
            body = re.sub(KEYWORDS, r'<span class="kw">\g<0></span>', body)
            body = re.sub(r"&quot;.*?&quot;", r'<span class="s">\g<0></span>', body)
            if cmt:
                body += f'<span class="cmt">{esc(cmt)}</span>'
            out.append(body)
        new = BeautifulSoup(f"<pre>{'<br/>'.join(out)}</pre>", "html.parser")
        # preserve any classes
        pre.replace_with(new.pre)


NUM_CELL = re.compile(r"^[\s\d,.\-–+%×·/:()]*\d[\s\d,.\-–+%×·/:()]*$")
MONO_CELL = re.compile(r"(0x[0-9A-Fa-f]+|func_\w+|@0x|\$|^[0-9A-F]{2,4}$|\.EXE|\.SS\b|\.PIK|\.MP\b)")


def dress_tables(soup):
    for table in soup.find_all("table"):
        rows = table.find_all("tr")
        if len(rows) > 18:
            table["class"] = table.get("class", []) + ["compact"]
        # column stats
        bodyrows = [r for r in rows if r.find("td")]
        if not bodyrows:
            continue
        ncols = max(len(r.find_all(["td", "th"])) for r in bodyrows)
        for c in range(ncols):
            cells = []
            for r in bodyrows:
                tds = r.find_all(["td", "th"])
                if c < len(tds):
                    cells.append(tds[c].get_text().strip())
            filled = [x for x in cells if x and x not in ("—", "-", "·")]
            if not filled:
                continue
            numish = sum(1 for x in filled if NUM_CELL.match(x))
            monoish = sum(1 for x in filled if MONO_CELL.search(x))
            cls = None
            if numish / len(filled) >= 0.7:
                cls = "cnum"
            elif monoish / len(filled) >= 0.6:
                cls = "cmono"
            if cls:
                for r in rows:
                    tds = r.find_all(["td", "th"])
                    if c < len(tds):
                        tds[c]["class"] = tds[c].get("class", []) + [cls]
        if table.parent and "tablewrap" not in (table.parent.get("class") or []):
            table.wrap(soup.new_tag("div", attrs={"class": "tablewrap"}))


HEX_RE = re.compile(r"\b0x([0-9A-Fa-f]+)\b")


def style_hex_in(soup):
    skip = {"pre", "code", "svg", "script", "style", "text"}
    for node in list(soup.find_all(string=True)):
        if any(p.name in skip for p in node.parents):
            continue
        s = str(node)
        if "0x" not in s:
            continue
        parts = HEX_RE.split(s)
        if len(parts) == 1:
            continue
        frag = []
        for i, piece in enumerate(parts):
            if i % 2 == 0:
                frag.append(esc(piece))
            else:
                frag.append(f'<span class="hex"><span class="pfx">0x</span>{esc(piece)}</span>')
        node.replace_with(BeautifulSoup("".join(frag), "html.parser"))


def comment_blocks_to_prose(soup):
    n = 0
    for pre in list(soup.find_all("pre")):
        text = pre.get_text()
        lines = [l for l in text.split("\n") if l.strip()]
        if not lines:
            continue
        cm = [l for l in lines if l.strip().startswith("//")]
        if len(cm) / len(lines) < 0.85 or len(lines) < 3:
            continue
        items = [re.sub(r"^\s*//\s?", "", l) for l in lines]
        label = ""
        if items and items[0].endswith(":") and len(items[0]) < 60:
            label = items.pop(0).rstrip(":")
        body = "".join(f"<p>{esc(it)}</p>" for it in items)
        lab = f'<div class="alabel">{esc(label)}</div>' if label else ""
        pre.replace_with(BeautifulSoup(f'<div class="annot">{lab}{body}</div>',
                                       "html.parser"))
        n += 1
    return n


# --------------------------------------------------------------------------
# 4b. Sprite enrichment (images only where the frame mapping is documented)
# --------------------------------------------------------------------------

def _spr_td(soup, img, scale=2.0, title=""):
    td = BeautifulSoup(
        f'<td class="sprcell">{SPR.img_tag(SPR.data_uri(img, 3), img.width, img.height, scale, title=title)}</td>'
        if img is not None else '<td class="sprcell">—</td>', "html.parser")
    return td.td


def add_sprite_column(soup, table, header, cell_of_row, after_col=0, scale=2.0):
    """Insert a sprite column after column `after_col`. cell_of_row(cells) ->
    PIL image or None (None -> em-dash)."""
    for tr in table.find_all("tr"):
        ths = tr.find_all("th")
        if ths:
            th = soup.new_tag("th")
            th.string = header
            ths[after_col].insert_after(th)
            continue
        tds = tr.find_all("td")
        if len(tds) <= after_col:
            continue
        try:
            img = cell_of_row([td.get_text().strip() for td in tds])
        except Exception:
            img = None
        tds[after_col].insert_after(_spr_td(soup, img, scale))


def _int0(s):
    try:
        return int(s.strip(), 0)
    except ValueError:
        return None


def enrich_terrain(soup):
    """Section 5: tile image column on every table whose first column is a
    terrain id (5.1 id/hex/Name and the three 5.3 stat tables)."""
    def tile_for(cells):
        tid = _int0(cells[0])
        return SPR.terrain_tile(tid) if tid is not None else None
    n = 0
    for table in soup.find_all("table"):
        head = [th.get_text().strip().lower() for th in table.find_all("th")]
        if head[:1] == ["id"] and ("name" in head or "mv" in head):
            add_sprite_column(soup, table, "tile", tile_for, after_col=0)
            n += 1
    return n


def enrich_units(soup):
    """Section 12.2: sprite from the table's own icon column (engine
    numbering; disk = engine - 1 per section 29.1)."""
    for table in soup.find_all("table"):
        head = [th.get_text().strip().lower() for th in table.find_all("th")]
        if "icon" in head and "unit" in head:
            icon_col = head.index("icon")

            def unit_for(cells, ic=icon_col):
                eng = _int0(cells[ic])
                return SPR.unit_icon(eng) if eng else None
            add_sprite_column(soup, table, "", unit_for,
                              after_col=head.index("unit"))


def goods_plate_fig():
    cells = []
    for g in range(16):
        im = SPR.goods_icon(g)
        cells.append(
            f'<div class="cell">{SPR.img_tag(SPR.data_uri(im, 3), im.width, im.height, 2.6)}'
            f'<span class="fi">{g} · 0x{g:X}</span>'
            f'<span class="fl">{esc(SPR.GOODS[g])}</span></div>')
    fig = (f'<figure><div style="break-inside:avoid">'
           f'<div class="platehead"><span class="pt">The 16 goods — ICONS.SS frames good+0x17</span>'
           f'<span class="ps">NAMES @CARGO order · disk 22–37</span></div>'
           f'<div class="atlas">{"".join(cells)}</div>'
           f'<figcaption>Good id indexes every market array, the stockpile bar and '
           f'the boycott bitmask; icons drawn at colony/Europe bars y=181.</figcaption>'
           f'</div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


def enrich_market(soup):
    for h in soup.find_all("h3"):
        if "Goods" in h.get_text():
            h.insert_after(goods_plate_fig())
            return


def palette_plate_fig():
    import json
    pal = json.load(open(ROOT / "data_extracted/palette.json"))
    cs = 660 / 16
    H = int(16 * 24 + 18)
    e = [f'<svg viewBox="0 0 660 {H}" xmlns="http://www.w3.org/2000/svg">']
    for ent in pal:
        i = ent["index"]
        r, c = divmod(i, 16)
        x, y = c * cs, 14 + r * 24
        e.append(f'<rect x="{x:.1f}" y="{y}" width="{cs:.1f}" height="24" '
                 f'fill="{ent["hex"]}" stroke="#FFFFFF" stroke-width="0.4"/>')
        lum = 0.299 * ent["r"] + 0.587 * ent["g"] + 0.114 * ent["b"]
        ink = "#000000" if lum > 128 else "#FFFFFF"
        e.append(svg_text(x + 2.5, y + 8.5, f"{i:02X}", 5.8, fill=ink,
                          face=MONO_FACE))
    for c in range(16):
        e.append(svg_text(c * cs + cs / 2, 10, f"_{c:X}", 6.4, fill=FAINT,
                          anchor="middle", face=MONO_FACE))
    e.append("</svg>")
    fig = (f'<figure><div style="break-inside:avoid"><div class="platehead">'
           f'<span class="pt">VICEROY.PAL — the 256-colour master palette</span>'
           f'<span class="ps">6-bit VGA, v8 = (v6&lt;&lt;2)|(v6&gt;&gt;4) · row = high nibble</span></div>'
           f'<div class="plate-wrap">{"".join(e)}</div></div>'
           f'<figcaption>Decoded from the shipped VICEROY.PAL. The water ramp, '
           f'indices 54–60 (0x36–0x3C), palette-cycles at run time; 0xFD is the '
           f'.SS sprite-transparent index; 0xFC–0xFE are magenta placeholders '
           f'overridden by per-screen .PIK palettes (§4.4).</figcaption></figure>')
    return BeautifulSoup(fig, "html.parser").figure


def enrich_palette(soup):
    for h in soup.find_all(["h3", "h4"]):
        if "palette" in h.get_text().lower():
            anchor = h.find_next("table")
            anchor = (anchor.parent if anchor and anchor.parent.name == "div"
                      else anchor) or h
            anchor.insert_after(palette_plate_fig())
            return
    soup.append(palette_plate_fig())


def atlas_fig(sheet_name, title, sub, indices, scale=2.0, label_of=None,
              skip_placeholder=True):
    cells = []
    for d in indices:
        im = SPR.frame_image(sheet_name, d)
        if skip_placeholder and im.width <= 2 and im.height <= 2:
            cells.append(f'<div class="cell"><span class="fi">{d}</span>'
                         f'<span class="fl">1×1</span></div>')
            continue
        lab = f'<span class="fl">{esc(label_of(d))}</span>' if label_of else ""
        cells.append(
            f'<div class="cell">{SPR.img_tag(SPR.data_uri(im, 3), im.width, im.height, scale)}'
            f'<span class="fi">{d}</span>{lab}</div>')
    fig = (f'<figure class="tall"><div class="platehead">'
           f'<span class="pt">{esc(title)}</span><span class="ps">{esc(sub)}</span></div>'
           f'<div class="atlas">{"".join(cells)}</div>'
           f'<figcaption>Disk-index numbering (engine frame = disk + 1, '
           f'section 29.1); decoded from the MADSPACK container, transparent '
           f'index 0xFD.</figcaption></figure>')
    return BeautifulSoup(fig, "html.parser").figure


RANGE_RE = re.compile(r"(\d+)(?:[–-](\d+))?")


def parse_disk_ranges(spec):
    out = []
    for m in RANGE_RE.finditer(spec):
        lo = int(m.group(1))
        hi = int(m.group(2)) if m.group(2) else lo
        out.extend(range(lo, hi + 1))
    return out


def enrich_appendix_b(soup):
    """B.1: tile column + atlas. B.2: band strips + atlas. B.3: band strips +
    atlas. B.4: building column + atlas."""
    building_names = {}
    for table in soup.find_all("table"):
        head = [th.get_text().strip().lower() for th in table.find_all("th")]
        if head[:2] == ["disk", "engine"] and head[-1] == "ground":
            add_sprite_column(
                soup, table, "tile",
                lambda c: SPR.frame_image("TERRAIN.SS", _int0(c[0])), 1)
        elif head[:2] == ["disk band", "engine"] or (head[:2] == ["disk", "engine"]
                                                     and "role" in head):
            hd = table.find_previous("h3")
            sheet = "PHYS0.SS" if (hd and "PHYS0" in hd.get_text()) else "ICONS.SS"

            def band_td(cells, sh=sheet):
                disks = parse_disk_ranges(cells[0])[:16]
                imgs = []
                for d in disks:
                    im = SPR.frame_image(sh, d)
                    if im.width <= 2 and im.height <= 2:
                        continue
                    imgs.append(SPR.img_tag(SPR.data_uri(im, 3), im.width,
                                            im.height, 1.6))
                return imgs
            for tr in table.find_all("tr"):
                ths = tr.find_all("th")
                if ths:
                    th = soup.new_tag("th")
                    ths[-1].insert_after(th)
                    continue
                tds = tr.find_all("td")
                if not tds:
                    continue
                try:
                    imgs = band_td([td.get_text().strip() for td in tds])
                except Exception:
                    imgs = []
                td = BeautifulSoup(
                    f'<td class="sprcell" style="text-align:left">{"".join(imgs)}</td>',
                    "html.parser").td
                tds[-1].insert_after(td)
        elif head[:1] == ["disk (=def)"]:
            def bld(cells):
                d = _int0(cells[0])
                im = SPR.building_sprite(d) if d is not None else None
                if im is not None and im.width <= 2:
                    return None
                return im
            add_sprite_column(soup, table, "", bld, after_col=1, scale=1.4)
            for tr in table.find_all("tr"):
                tds = tr.find_all("td")
                if len(tds) >= 4:
                    d = _int0(tds[0].get_text())
                    if d is not None:
                        building_names[d] = tds[3].get_text().strip()
    # full atlases after each subsection's tables
    anchors = {"TERRAIN.SS": ("B.1", atlas_fig(
        "TERRAIN.SS", "TERRAIN.SS — frame atlas", "12 ground frames · 16×16",
        range(12), 2.4)),
        "PHYS0.SS": ("B.2", atlas_fig(
            "PHYS0.SS", "PHYS0.SS — frame atlas",
            "154 overlay frames · rivers, mountains, hills, forest, roads, "
            "detail, halos, coasts", range(154), 1.9)),
        "ICONS.SS": ("B.3", atlas_fig(
            "ICONS.SS", "ICONS.SS — frame atlas",
            "131 HUD frames · markers, ships, cursors, goods, units, pennants",
            range(131), 1.9)),
        "BUILDING.SS": ("B.4", atlas_fig(
            "BUILDING.SS", "BUILDING.SS — frame atlas",
            "48 colony-building frames · disk = def id", range(48), 1.3,
            label_of=lambda d: building_names.get(d, "")))}
    for h in soup.find_all("h3"):
        t = h.get_text()
        for name, (subno, fig) in anchors.items():
            if name.split(".")[0] in t and subno in t:
                nxt = h
                while nxt.next_sibling is not None and getattr(
                        nxt.next_sibling, "name", None) in (
                        None, "p", "table", "div", "ul"):
                    nxt = nxt.next_sibling
                nxt.insert_after(fig)


# --------------------------------------------------------------------------
# 4c. Flow diagrams (spec: flows.flowchart) — hand-transcribed from the
# sections' own byte-cited text; conditions phrased so the main path stays
# on the spine, branches exit right.
# --------------------------------------------------------------------------

def flow_svg(nodes):
    """nodes: dicts —
    {k:'start'|'end', t}                     rounded terminal
    {k:'act',  t, s:[sublines]}              action box
    {k:'dec',  t, side:(branchlabel, [sidelines]), cont:label}  decision
    {k:'gopen', t}  {k:'gclose'}             loop/group enclosure
    """
    MX, MW = 30, 380          # main column
    SX, SW = 435, 222         # side boxes
    e = []
    y = 8
    gstack = []
    boxes = []                # (kind, x, y, w, h, ...) deferred draw
    centers = []              # spine attachment ys
    for nd in nodes:
        k = nd["k"]
        if k == "gopen":
            gstack.append((y, nd["t"]))
            y += 20
            continue
        if k == "gclose":
            gy, gt = gstack.pop()
            boxes.append(("group", MX - 14, gy, MW + 28, y - gy + 8, gt))
            y += 16
            continue
        ind = 14 if gstack else 0
        if k in ("start", "end"):
            h = 24
            boxes.append(("term", MX + ind + 60, y, MW - 120, h, nd["t"]))
            centers.append((y, h))
            y += h + 18
        elif k == "act":
            subs = nd.get("s", [])
            h = 21 + 11 * len(subs)
            boxes.append(("act", MX + ind, y, MW - 2 * ind, h, nd["t"], subs))
            centers.append((y, h))
            y += h + 18
        elif k == "dec":
            h = 30
            boxes.append(("dec", MX + ind, y, MW - 2 * ind, h, nd["t"]))
            blabel, sidelines = nd["side"]
            sh = 16 + 11 * len(sidelines)
            boxes.append(("side", SX, y + h / 2 - sh / 2, SW, sh, sidelines))
            boxes.append(("sarrow", MX + MW - ind, y + h / 2, SX, blabel))
            if nd.get("cont"):
                boxes.append(("clabel", MX + MW / 2 + 6, y + h + 12, nd["cont"]))
            centers.append((y, h))
            y += h + 20
    H = y + 4
    out = [f'<svg viewBox="0 0 660 {H}" xmlns="http://www.w3.org/2000/svg">',
           '<defs><marker id="farr" viewBox="0 0 8 8" refX="7" refY="4" '
           'markerWidth="7" markerHeight="7" orient="auto">'
           f'<path d="M0,0 L8,4 L0,8 z" fill="{MUTED}"/></marker></defs>']
    # spine arrows between consecutive main nodes
    for (y1, h1), (y2, _) in zip(centers, centers[1:]):
        cx = MX + MW / 2
        out.append(f'<line x1="{cx}" y1="{y1 + h1}" x2="{cx}" y2="{y2 - 1.5}" '
                   f'stroke="{MUTED}" stroke-width="1.2" marker-end="url(#farr)"/>')
    for b in boxes:
        if b[0] == "group":
            _, x, gy, w, h, gt = b
            dark, light = CAT["pos"]
            out.append(f'<rect x="{x}" y="{gy}" width="{w}" height="{h}" rx="8" '
                       f'fill="none" stroke="{dark}" stroke-width="1.3" '
                       f'stroke-dasharray="7,4"/>')
            out.append(svg_text(x + 8, gy + 13, gt, 7.6, fill=dark, weight="bold"))
        elif b[0] == "term":
            _, x, ty, w, h, t = b
            out.append(f'<rect x="{x}" y="{ty}" width="{w}" height="{h}" '
                       f'rx="{h / 2}" fill="{INK}" stroke="none"/>')
            out.append(svg_text(x + w / 2, ty + h / 2 + 3, t, 8.4,
                                fill="#FCFBF8", anchor="middle", weight="bold"))
        elif b[0] == "act":
            _, x, ty, w, h, t, subs = b
            dark, light = CAT["num"]
            out.append(f'<rect x="{x}" y="{ty}" width="{w}" height="{h}" '
                       f'fill="{light}" stroke="{dark}" stroke-width="1.2"/>')
            out.append(svg_text(x + w / 2, ty + 13, t, 8.4, fill=INK,
                                anchor="middle", weight="bold"))
            for i, s in enumerate(subs):
                out.append(svg_text(x + w / 2, ty + 24 + 11 * i, s, 7.0,
                                    fill=MUTED, anchor="middle"))
        elif b[0] == "dec":
            _, x, ty, w, h, t = b
            dark, light = CAT["econ"]
            cx, cy = x + w / 2, ty + h / 2
            out.append(f'<path d="M {x} {cy} L {cx} {ty} L {x + w} {cy} '
                       f'L {cx} {ty + h} z" fill="{light}" stroke="{dark}" '
                       f'stroke-width="1.2"/>')
            out.append(svg_text(cx, cy + 3, t, 7.6, fill=INK, anchor="middle",
                                weight="bold"))
        elif b[0] == "side":
            _, x, ty, w, h, lines = b
            dark, light = CAT["arr"]
            out.append(f'<rect x="{x}" y="{ty}" width="{w}" height="{h}" '
                       f'fill="{light}" stroke="{dark}" stroke-width="1.1"/>')
            for i, s in enumerate(lines):
                out.append(svg_text(x + 7, ty + 13 + 11 * i, s, 7.0, fill=INK))
        elif b[0] == "sarrow":
            _, x1, sy, x2, blabel = b
            out.append(f'<line x1="{x1}" y1="{sy}" x2="{x2 - 2}" y2="{sy}" '
                       f'stroke="{MUTED}" stroke-width="1.2" marker-end="url(#farr)"/>')
            out.append(svg_text((x1 + x2) / 2, sy - 4, blabel, 6.8, fill=MUTED,
                                anchor="middle"))
        elif b[0] == "clabel":
            _, x, ty, t = b
            out.append(svg_text(x, ty, t, 6.8, fill=MUTED))
    out.append("</svg>")
    return "\n".join(out)


def flow_fig(title, sub, nodes, caption=""):
    cap = f"<figcaption>{esc(caption)}</figcaption>" if caption else ""
    fig = (f'<figure class="tall"><div style="break-inside:avoid">'
           f'<div class="platehead">'
           f'<span class="pt">{esc(title)}</span><span class="ps">{esc(sub)}</span>'
           f'</div><div class="plate-wrap">{flow_svg(nodes)}</div>{cap}</div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


def enrich_turnflow(soup):
    fig1 = flow_fig(
        "The turn loop", "func_005760 (file 0x5760) — one full pass per turn",
        [
            {"k": "start", "t": "Turn begins"},
            {"k": "gopen",
             "t": "×4 — once per European power, strict index order"},
            {"k": "act", "t": "1  King / mercenary — func_03E664 (call 0x58E2)",
             "s": ["gated [0x5382]&1==0 · peacetime mercenary roll 0x3E707 · King events"]},
            {"k": "act", "t": "2  Orders / movement — func_024A48 (0x58E7)",
             "s": ["per-unit orders pump · REF fund accrual func_03E162 via 0x24B42",
                   "AI moves func_04E2D6; contact evaluator func_059B90 fires diplomacy"]},
            {"k": "act", "t": "3  Production — func_02F052 (0x59EA)",
             "s": ["zero bells/turn +0x0E @0x2F23F · per-colony func_02D658:",
                   "yields, food/starvation/spoilage popups, school, bell accrual (0x2D6A7)"]},
            {"k": "act", "t": "4  Diplomacy — func_052F7E (0x5A37)",
             "s": ["king-action dispatch func_034C24 (tax raises event-driven here) · AI diplomacy"]},
            {"k": "act", "t": "5  Periodic / congress — func_02F3A2 (0x5AE5)",
             "s": ["colony stats func_042138 · congress func_03B2F8 (gate [0x5382]&0x10==0)",
                   "King defeat/victory screens 0x2F552/0x2F6A8"]},
            {"k": "gclose"},
            {"k": "act", "t": "Market drift — func_036574 (@0x757B0, in func_0755CC)",
             "s": ["clear per-power 16-good accumulators (0x3670E)",
                   "4-power loop into func_0305A8: base relaxes by (base + Σ clamped trade)/256"]},
            {"k": "act", "t": "Immigration crosses — func_035D9A",
             "s": ["runs immediately after the price recompute (0x363E2)"]},
            {"k": "act", "t": "Religious-unrest arrivals — @UNREST chain", "s": []},
            {"k": "act", "t": "Year cadence — inc [0x538E] (loop tail 0x5A9D–0x5ACC)",
             "s": ["see the cadence diagram below"]},
            {"k": "act", "t": "Autosave tail (§20.2)", "s": []},
            {"k": "end", "t": "Next turn"},
        ],
        "Natives are not a separate top-level pass — their AI runs inside the "
        "per-power processing.")
    fig2 = flow_fig(
        "Year cadence and end-of-game checks", "loop tail 0x5A9D–0x5ACC",
        [
            {"k": "act", "t": "inc [0x538E] — turn counter", "s": []},
            {"k": "dec", "t": "year < 1600 ?",
             "side": ("yes", ["one turn = one year"]), "cont": "no — from 1600"},
            {"k": "act", "t": "season word [0x538C] toggles Spring / Autumn",
             "s": ["the year steps every second turn · start 1492"]},
            {"k": "dec", "t": "year reaches 1725 ? (0x5BB5)",
             "side": ("yes", ["forced end: [0x82B] = 1",
                              "end-game save fires near 0x5BDB"]),
             "cont": "no"},
            {"k": "end", "t": "continue"},
        ])
    fig3 = flow_fig(
        "The autosave chain", "helper 0x5642; consumers 0x58D7 / 0x5A29",
        [
            {"k": "dec", "t": "Game-Options bit 0x0400 set and [0x826] == 0 ? (gate 0x5AD7)",
             "side": ("no", ["no autosave"]), "cont": "yes"},
            {"k": "act", "t": "rolling autosave → slot 9, every turn",
             "s": ['"most recent save in the last slot"']},
            {"k": "dec", "t": "year divisible by 10 ?",
             "side": ("yes", ["decade autosave → slot 8"]), "cont": "no"},
            {"k": "end", "t": "done"},
        ],
        "Filenames COLONY<slot>.SAV (stem at file 0x1FA82). Manual slots via "
        "the @SAVEGAME dialog.")
    tables = soup.find_all("div", class_="tablewrap")
    if tables:
        tables[0].insert_after(fig1)
    for p in soup.find_all("p"):
        if p.get_text().startswith("Year cadence"):
            p.insert_after(fig2)
            break
    for p in soup.find_all("p"):
        if "rolling autosave" in p.get_text():
            p.insert_after(fig3)
            break


def enrich_events(soup):
    fig = flow_fig(
        "The tax event, end to end", "@KINGTAX → @TAXOPTIONS → @TEAPARTY (§23.4)",
        [
            {"k": "start", "t": "King demands a tax raise"},
            {"k": "act", "t": "@KINGTAX popup (width 190)",
             "s": ['"…raise your tax rate by {%NUMBER0%%}. The tax rate is now {%NUMBER1%%}…"',
                   "options from @TAXOPTIONS"]},
            {"k": "dec", "t": '"Kiss pinky ring."  /  "Hold \'{%STRING3 Party}.\'"',
             "side": ("accept", ["tax applied, hard-clamped to 75",
                                 "at 0x03434F"]),
             "cont": "refuse"},
            {"k": "act", "t": "@TEAPARTY fires",
             "s": ['"Sons of Liberty throw {%NUMBER0} tons of %STRING0 into the sea at %STRING1!"',
                   "boycott bit set: PowerRecord+0x20 |= (1<<good) @0x034717"]},
            {"k": "dec", "t": "lift the boycott ?",
             "side": ("pay back-tax", ["count × 500 gold (count = +0x4C[good]",
                                       "+ base 0x9700+good·9, clamp ≥0)",
                                       "gold → royal fund @0x03340D",
                                       "bit cleared @0x033423"]),
             "cont": "or acquire Jakob Fugger (FF id 1)"},
            {"k": "act", "t": "Fugger clears the whole boycott word",
             "s": ["mov [bx+0x20],0 @0x03BD45"]},
            {"k": "end", "t": "good tradeable again"},
        ],
        "The dashed outcome of refusal — the standing boycott — is what arms "
        "the back-tax and Fugger events later; the good cannot be traded until "
        "one of them fires.")
    for p in soup.find_all("p"):
        if "kiss our royal pinky ring" in p.get_text():
            p.insert_after(fig)
            return
    warn("tax-event anchor not found in section 23")


ENRICHERS = {"4": [enrich_palette], "5": [enrich_terrain],
             "9": [enrich_market], "12": [enrich_units],
             "20": [enrich_turnflow], "23": [enrich_events],
             "B": [enrich_appendix_b]}


# --------------------------------------------------------------------------
# 5. Section shaping
# --------------------------------------------------------------------------

def shape_headings(soup, key, title):
    h2 = soup.new_tag("h2", attrs={"class": "sechead", "id": f"sec-{key}"})
    sn = soup.new_tag("span", attrs={"class": "secno"})
    sn.string = f"§{key}"
    h2.append(sn)
    h2.append(NavigableString(title))
    first = soup.find(True)
    if first:
        first.insert_before(h2)
    else:
        soup.append(h2)
    for h in soup.find_all(["h3", "h4"]):
        t = h.get_text()
        m = re.match(r"^([\dAB]+(?:\.\d+)*)\.?\s+(.*)$", t)
        if m:
            h.clear()
            sp = soup.new_tag("span", attrs={"class": "subno"})
            sp.string = m.group(1)
            h.append(sp)
            h.append(NavigableString(m.group(2)))
    # lede
    p = h2.find_next("p")
    if p and len(p.get_text()) > 120:
        p["class"] = p.get("class", []) + ["lede"]


def build_section(key, title, md_text):
    html = markdown.markdown(md_text, extensions=["tables", "fenced_code"])
    soup = BeautifulSoup(html, "html.parser")
    comment_blocks_to_prose(soup)
    structs_to_plates(soup)
    regions_to_wireframes(soup)
    highlight_code(soup)
    dress_tables(soup)
    for enricher in ENRICHERS.get(key, []):
        try:
            enricher(soup)
        except Exception as e:
            warn(f"enricher {enricher.__name__} failed in section {key}: {e}")
    style_hex_in(soup)
    shape_headings(soup, key, title)
    return str(soup)


# --------------------------------------------------------------------------
# 6. Assembly
# --------------------------------------------------------------------------

def part_divider(roman, ptitle, seclist):
    items = "".join(
        f'<div><span class="sn">§{esc(k)}</span> {esc(t)}</div>'
        for k, t in seclist)
    return (f'<div class="part-divider" id="part-{roman}">'
            f'<div class="pno">Part {roman}</div>'
            f'<div class="ptitle">{esc(ptitle)}</div>'
            f'<div class="plist">{items}</div></div>')


def contents_html(about, entries):
    """entries: list of ('part',roman,title,folio) / ('sec',key,title,folio)."""
    out = ['<div class="contents" id="contents"><h2>Contents</h2>']
    if about:
        out.append(f'<p class="about">{esc(about)}</p>')
    for kind, key, title, folio in entries:
        f = str(folio) if folio else ""
        if kind == "part":
            out.append(f'<div class="cpart"><span>Part {esc(key)} — {esc(title)}</span>'
                       f'<span class="dots"></span><span class="cf">{f}</span></div>')
        else:
            out.append(f'<div class="centry"><span class="cn">§{esc(key)}</span>'
                       f'<span>{esc(title)}</span><span class="dots"></span>'
                       f'<span class="cf">{f}</span></div>')
    out.append("</div>")
    return "".join(out)


def assemble(about, sections, folios=None):
    sec_titles = {s[0]: s[1] for s in sections}
    entries = []
    for roman, ptitle, keys in PARTS:
        entries.append(("part", roman, ptitle,
                        (folios or {}).get(f"part-{roman}")))
        for k in keys:
            entries.append(("sec", k, sec_titles[k], (folios or {}).get(f"sec-{k}")))
    body = [contents_html(about, entries)]
    built = {s[0]: s[3] for s in sections}
    for roman, ptitle, keys in PARTS:
        body.append(part_divider(roman, ptitle, [(k, sec_titles[k]) for k in keys]))
        for k in keys:
            body.append(built[k])
    css = CSS.read_text()
    return (f"<!DOCTYPE html><html><head><meta charset='utf-8'>"
            f"<title>{esc(DOC_TITLE)}</title><style>{css}</style></head>"
            f"<body>{''.join(body)}</body></html>")


# --------------------------------------------------------------------------
# 7. Rendering
# --------------------------------------------------------------------------

def render_pdf(html_path, pdf_path, margins=None, page=None):
    from playwright.sync_api import sync_playwright
    with sync_playwright() as pw:
        b = pw.chromium.launch(executable_path=CHROMIUM)
        pg = b.new_page()
        pg.goto(f"file://{html_path}")
        pg.wait_for_timeout(250)
        kw = dict(path=str(pdf_path), format="Letter", print_background=True,
                  display_header_footer=False)
        if margins:
            kw["margin"] = margins
        if page:
            kw.update(page)
        pg.pdf(**kw)
        b.close()


def measure(pdf_path, sections):
    """Find the printed page of each part divider and section head."""
    import pdfplumber
    import unicodedata

    def norm(s):
        # ligatures (fi/fl) come back composed; spaces are unreliable
        return "".join(unicodedata.normalize("NFKD", s).split())

    marks = {}
    sec_titles = {s[0]: s[1] for s in sections}
    # Chromium writes PDF font sizes at ~0.75x the CSS pt value:
    # 17pt section heads -> ~12.6, 30pt part titles -> ~22.2
    with pdfplumber.open(pdf_path) as pdf:
        for pno, page in enumerate(pdf.pages, 1):
            big = [c for c in page.chars if c.get("size", 0) >= 11.5]
            if not big:
                continue
            txt = "".join(c["text"] for c in sorted(
                big, key=lambda c: (round(c["top"]), c["x0"])))
            flat = norm(txt)
            huge = any(c.get("size", 0) >= 20 for c in big)  # part-divider titles
            for k, t in sec_titles.items():
                sid = f"sec-{k}"
                if sid in marks:
                    continue
                if norm(f"§{k}{t}")[:26] in flat:
                    marks[sid] = pno
            for roman, ptitle, _ in PARTS:
                pid = f"part-{roman}"
                if pid not in marks and huge and norm(ptitle)[:20] in flat:
                    marks[pid] = pno
        npages = len(pdf.pages)
    return marks, npages


def overlay_html(npages, marks, sections):
    """One 11in page per body page carrying running head + folio."""
    sec_titles = {f"sec-{s[0]}": s[1] for s in sections}
    # page -> event
    starts = sorted(((p, mid) for mid, p in marks.items()))
    divider_pages = {p for mid, p in marks.items() if mid.startswith("part-")}
    part_of = {}
    for roman, ptitle, keys in PARTS:
        for k in keys:
            part_of[f"sec-{k}"] = ptitle
    pages = []
    cur = None
    for p in range(1, npages + 1):
        for sp, mid in starts:
            if sp == p and mid.startswith("sec-"):
                cur = mid
        if p in divider_pages:
            head_l = ""
        elif cur is None:
            head_l = "CONTENTS"
        else:
            t = sec_titles[cur]
            head_l = f"§{cur.split('-')[1]} · {t}".upper()
        outer_right = (p % 2 == 1)
        folio_style = ("right:0.75in;text-align:right" if outer_right
                       else "left:0.90in;text-align:left")
        head = ""
        if head_l:
            head = (f'<div style="position:absolute;top:0.40in;left:0.90in;right:0.75in;'
                    f'display:flex;justify-content:space-between;'
                    f'font-family:\'{HEAD_FACE}\';font-size:6.4pt;letter-spacing:0.14em;'
                    f'color:{MUTED}">'
                    f'<span>{esc(head_l)}</span><span>{GAME_TITLE}</span></div>')
        folio = (f'<div style="position:absolute;bottom:0.40in;{folio_style};'
                 f'font-family:\'{HEAD_FACE}\';font-weight:bold;font-size:8.5pt;'
                 f'color:{INK}">{p}</div>')
        pages.append(f'<div class="opage">{head}{folio}</div>')
    css = ("@page{size:Letter;margin:0}"
           "html,body{margin:0;padding:0}"
           ".opage{position:relative;width:8.5in;height:10.97in;"
           "page-break-after:always;overflow:hidden}"
           ".opage:last-child{page-break-after:auto}")
    return (f"<!DOCTYPE html><html><head><meta charset='utf-8'><style>{css}</style>"
            f"</head><body>{''.join(pages)}</body></html>")


def cover_html():
    strip = "".join(
        f'<div style="flex:1;background:{CAT[c][0]}"></div>'
        for c in ("pos", "num", "econ", "flag", "arr", "text", "warn", "pad"))
    return f"""<!DOCTYPE html><html><head><meta charset='utf-8'><style>
@page {{ size: Letter; margin: 0 }}
html, body {{ margin: 0; padding: 0; width: 8.5in; height: 10.97in;
  background: {INK}; color: #FCFBF8;
  -webkit-print-color-adjust: exact; print-color-adjust: exact; }}
.wrap {{ position: relative; width: 8.5in; height: 10.97in; overflow: hidden; }}
</style></head><body><div class="wrap">
<div style="position:absolute;top:1.05in;left:0.95in;right:0.95in;
  border-top:3px solid #FCFBF8;padding-top:0.28in;
  font-family:'{HEAD_FACE}';font-size:11pt;letter-spacing:0.34em;color:#B8BEC6">
  MICROPROSE · 1994 · MS-DOS</div>
<div style="position:absolute;top:1.75in;left:0.95in;right:0.95in;
  font-family:'URW Gothic';font-size:34pt;line-height:1.14">
  Sid Meier's<br>COLONIZATION</div>
<div style="position:absolute;top:3.55in;left:0.95in;right:0.95in;display:flex;height:0.14in">{strip}</div>
<div style="position:absolute;top:3.95in;left:0.95in;right:0.95in;
  font-family:'URW Gothic';font-size:19pt;color:#DCEBEA">Technical Reference</div>
<div style="position:absolute;top:4.75in;left:0.95in;right:2.0in;
  font-family:'Charter RE';font-size:10.5pt;line-height:1.6;color:#C9CDD3">
  The shipped MS-DOS release, documented from its binaries and data files.
  Executables and overlay architecture · asset containers · terrain and the map
  compositor · colonies, market, and the native economy · units, movement, and
  combat · powers, diplomacy, and revolution · events and strings · the UI
  engine, screen by screen · the map editor · data structures.</div>
<div style="position:absolute;bottom:1.0in;left:0.95in;right:0.95in;
  border-top:1px solid #4A505A;padding-top:0.18in;
  font-family:'{HEAD_FACE}';font-size:8.5pt;letter-spacing:0.16em;color:#8A939C">
  RECONSTRUCTED BY DISASSEMBLY OF VICEROY.EXE AND MAPEDIT.EXE · EVERY FIGURE
  TRACED TO A FILE OFFSET, A DATA-FILE FIELD, OR LIVE GAME MEMORY — OR MARKED
  UNMAPPED</div>
</div></body></html>"""


# --------------------------------------------------------------------------
# 8. Merge
# --------------------------------------------------------------------------

def merge(body_pdf, overlay_pdf, cover_pdf, out_pdf, marks, sections):
    from pypdf import PdfReader, PdfWriter
    body = PdfReader(str(body_pdf))
    over = PdfReader(str(overlay_pdf))
    cover = PdfReader(str(cover_pdf))
    w = PdfWriter()
    w.add_page(cover.pages[0])
    for i, page in enumerate(body.pages):
        if i < len(over.pages):
            page.merge_page(over.pages[i])
        w.add_page(page)
    for page in w.pages:  # merge_page leaves content streams uncompressed
        page.compress_content_streams(level=6)
    sec_titles = {s[0]: s[1] for s in sections}
    w.add_outline_item("Contents", 1)
    for roman, ptitle, keys in PARTS:
        pp = marks.get(f"part-{roman}")
        node = w.add_outline_item(f"Part {roman} — {ptitle}", (pp or 1))
        for k in keys:
            sp = marks.get(f"sec-{k}")
            if sp:
                w.add_outline_item(f"§{k}  {sec_titles[k]}", sp, parent=node)
    try:
        w.compress_identical_objects(remove_identicals=True, remove_orphans=True)
    except Exception as e:
        warn(f"object dedup skipped: {e}")
    w.add_metadata({
        "/Title": DOC_TITLE,
        "/Author": "Reconstructed from the shipped 1994 binaries",
        "/Subject": "Byte-verified technical reference for the MS-DOS release",
        "/Creator": "colopy manual pipeline (MANUAL_BUILD_SPEC_1)",
    })
    with open(out_pdf, "wb") as fh:
        w.write(fh)


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------

def main():
    WORK.mkdir(exist_ok=True)
    print("== load + preprocess")
    about, body = load_source()
    raw_sections = split_sections(body)
    print(f"   {len(raw_sections)} sections")
    print("== transform sections")
    sections = []
    for key, title, md_text in raw_sections:
        html = build_section(key, title, md_text)
        sections.append((key, title, md_text, html))
        sys.stdout.write(".")
        sys.stdout.flush()
    print()

    print("== pass 1 render (folio measurement)")
    html1 = assemble(about, sections, folios=None)
    (WORK / "body1.html").write_text(html1)
    render_pdf(WORK / "body1.html", WORK / "body1.pdf", margins=MARGINS)
    marks, npages = measure(WORK / "body1.pdf", sections)
    missing = [f"sec-{k}" for k, _, _, _ in sections if f"sec-{k}" not in marks]
    if missing:
        warn(f"unmeasured section heads: {missing}")
    print(f"   {npages} pages; {len(marks)} marks")

    print("== pass 2 render (real contents)")
    html2 = assemble(about, sections, folios=marks)
    (WORK / "body2.html").write_text(html2)
    render_pdf(WORK / "body2.html", WORK / "body2.pdf", margins=MARGINS)
    marks2, npages2 = measure(WORK / "body2.pdf", sections)
    if npages2 != npages or marks2 != marks:
        print("   pagination shifted; pass 3 with fresh folios")
        html3 = assemble(about, sections, folios=marks2)
        (WORK / "body2.html").write_text(html3)
        render_pdf(WORK / "body2.html", WORK / "body2.pdf", margins=MARGINS)
        marks2, npages2 = measure(WORK / "body2.pdf", sections)
    print(f"   final body: {npages2} pages")

    print("== overlay + cover")
    (WORK / "overlay.html").write_text(overlay_html(npages2, marks2, sections))
    render_pdf(WORK / "overlay.html", WORK / "overlay.pdf",
               margins={"top": "0", "bottom": "0", "left": "0", "right": "0"},
               page={"prefer_css_page_size": True})
    (WORK / "cover.html").write_text(cover_html())
    render_pdf(WORK / "cover.html", WORK / "cover.pdf",
               margins={"top": "0", "bottom": "0", "left": "0", "right": "0"},
               page={"prefer_css_page_size": True})

    print("== merge")
    out = OUTDIR / "Viceroy_Technical_Reference.pdf"
    merge(WORK / "body2.pdf", WORK / "overlay.pdf", WORK / "cover.pdf",
          out, marks2, sections)
    print(f"   wrote {out} ({out.stat().st_size:,} bytes)")
    if WARNINGS:
        print(f"== {len(WARNINGS)} warnings (see stderr)")
    else:
        print("== no warnings")


if __name__ == "__main__":
    main()
