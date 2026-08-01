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
    import symbols as SYM
except ImportError:
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import sprites as SPR
    import symbols as SYM

# mechanics chapters: named-variable presentation, no byte offsets in body
MECH_SECTIONS = {"5", "8", "9", "10", "11", "12", "13", "14", "15", "16",
                 "17", "18", "19", "20", "21", "23"}

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
    ("VIII", "The editor and appendices", ["28", "29", "A", "B", "C"]),
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
    parts = re.split(r"^## (\d+|[ABC])\. (.+)$", body, flags=re.M)
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


# Illustrative sample values for the struct key tables (decimal/strings only —
# presentational examples consistent with each field's documented semantics).
# Keyed (struct, field-base) with a field-base fallback.
EXAMPLES = {
    ("UnitRecord", "map_x"): "31, 18", ("UnitRecord", "map_y"): "",
    ("UnitRecord", "unit_type"): "13 = Caravel",
    ("UnitRecord", "owner"): "1 = France", ("UnitRecord", "owner_flags"): "1 = France",
    ("UnitRecord", "flags"): "128 = draw-active",
    ("UnitRecord", "scratch_bits"): "8 = tile dirty",
    ("UnitRecord", "moves_spent"): "3 = one step used",
    ("UnitRecord", "timer"): "255 = fresh", ("UnitRecord", "countdown"): "255 = fresh",
    ("UnitRecord", "ai_state"): "'G'", ("UnitRecord", "order"): "5 = Fortify",
    ("UnitRecord", "goto_x"): "40, 22", ("UnitRecord", "goto_y"): "",
    ("UnitRecord", "heading"): "2 = East",
    ("UnitRecord", "cargo_count"): "2 goods aboard",
    ("UnitRecord", "cargo_ids"): "Furs + Tobacco",
    ("UnitRecord", "cargo_qty"): "100, 40",
    ("UnitRecord", "timer_16"): "7", ("UnitRecord", "turn_flag"): "1 = moved",
    ("UnitRecord", "moved_flag"): "1 = moved",
    ("UnitRecord", "tools"): "80 tools",
    ("UnitRecord", "work_counter"): "2 turns in",
    ("UnitRecord", "profession"): "21 = Veteran Soldier",
    ("UnitRecord", "class_prof"): "21 = Veteran Soldier",
    ("UnitRecord", "occ_back"): "record 17", ("UnitRecord", "occ_next"): "record 29",
    ("ColonyRecord", "map_x"): "34, 27", ("ColonyRecord", "map_y"): "",
    ("ColonyRecord", "name"): '"Jamestown"',
    ("ColonyRecord", "owner"): "0 = England",
    ("ColonyRecord", "owner_power"): "0 = England",
    ("ColonyRecord", "population"): "6 colonists",
    ("ColonyRecord", "stockpile"): "Food 120 · Muskets 50",
    ("ColonyRecord", "hammers"): "34 of 52",
    ("ColonyRecord", "hammers_b6"): "34",
    ("ColonyRecord", "warehouse_level"): "1 = Warehouse",
    ("ColonyRecord", "sol_numerator"): "480",
    ("ColonyRecord", "sol_denominator"): "800  (= 60% SoL)",
    ("ColonyRecord", "tile_worker"): "colonist 3 works tile 0",
    ("ColonyRecord", "tile_workers"): "colonist 3 works tile 0",
    ("ColonyRecord", "professions"): "farmer, farmer, carpenter…",
    ("ColonyRecord", "job_skills"): "farmer, farmer, carpenter…",
    ("ColonyRecord", "buildings"): "Stockade + Docks built",
    ("ColonyRecord", "bldg_mask_60"): "Stockade + Docks built",
    ("PowerRecord", "tax_pct"): "12%",
    ("PowerRecord", "rebel_sentiment_pct"): "45%",
    ("PowerRecord", "gold"): "1 500 gold",
    ("PowerRecord", "royal_money"): "936 (→ REF unit at 1 800)",
    ("PowerRecord", "bells_toward_next_ff"): "88 of 129",
    ("PowerRecord", "bells_per_turn"): "14",
    ("PowerRecord", "crosses_per_turn"): "9",
    ("PowerRecord", "boycott_bitmask"): "Tobacco + Rum boycotted",
    ("PowerRecord", "boycott_count"): "Tobacco 3",
    ("PowerRecord", "relations"): "at war with Spain",
    ("PowerRecord", "treaty_respect"): "8 turns left",
    ("PowerRecord", "home_x"): "56, 12", ("PowerRecord", "home_y"): "",
    ("PowerRecord", "artillery_bought"): "2 (price now +200)",
    ("PowerRecord", "acquired_ff_bitmask"): "Franklin + Penn owned",
    ("PowerRecord", "founding_father_count"): "2 fathers",
    ("PowerRecord", "ff_in_progress"): "17 = Thomas Paine",
    ("PowerRecord", "eu_sales_tally"): "12 400",
    ("PowerRecord", "market_pool"): "Food +38",
    ("PowerRecord", "market_traded"): "Food 4 100",
    ("PowerRecord", "market_eu_supply"): "Food 900",
    ("PowerRecord", "market_base"): "Food 812",
    ("NativeSettlement", "map_x"): "23, 41", ("NativeSettlement", "map_y"): "",
    ("NativeSettlement", "owner"): "7 = Iroquois",
    ("NativeSettlement", "flags"): "4 = capital",
    ("NativeSettlement", "population"): "8",
    ("NativeSettlement", "mission"): "255 = no mission",
    ("NativeSettlement", "growth_counter"): "3",
    ("NativeSettlement", "trespass"): "2 incidents",
    ("NativeSettlement", "last_bought"): "2 = Tobacco",
    ("NativeSettlement", "last_sold"): "255",
    ("NativeSettlement", "alarm"): "England 40 · France 12 · Spain 0 · Neth. 5",
    ("StopRecord", "dest"): "colony 3  (999 = Europe)",
    ("StopRecord", "counts"): "load 2 · unload 1",
    ("StopRecord", "load_nib"): "Tools, Muskets",
    ("StopRecord", "unload_nib"): "Furs",
    ("RouteRecord", "name"): '"Fur run"',
    ("RouteRecord", "type"): "1 = sea route",
    ("RouteRecord", "stop_count"): "3 stops",
    ("RouteRecord", "stops"): "Jamestown → Boston → Europe",
    ("TerrainRecord", "name"): "“Prairie” token",
    ("TerrainRecord", "movement"): "1",
    ("TerrainRecord", "defensive"): "0 = open",
    ("TerrainRecord", "improvement"): "3 turns to plow",
    ("TerrainRecord", "value"): "4",
    ("TerrainRecord", "yields"): "Food 2 · Cotton 3",
    ("MPFile", "width"): "58", ("MPFile", "height"): "72",
    ("MPFile", "version"): "4",
    ("MPFile", "terrain"): "3 = Prairie, +64 = river…",
    ("MPFile", "feature"): "0 (unused on disk)",
    ("MPFile", "continent"): "region 2, owner none",
}
RANGE_RE_NOTE = re.compile(r"\b(\d+)\.\.(\d+)\b")


def example_for(struct_name, field):
    base = (field["name"] or "").split("[")[0]
    if not base or base.startswith(("_pad", "unused", "pad")):
        return "—"
    v = EXAMPLES.get((struct_name, base)) or EXAMPLES.get(
        next((k for k in EXAMPLES if k[1] == base), ("", "")))
    if v is not None and v != "":
        return v
    if v == "":
        return "↑"  # paired with the field above (e.g. x,y)
    if field["ctype"].startswith("char"):
        return '"Jamestown"'
    m = RANGE_RE_NOTE.search(field["note"] or "")
    if m:
        lo, hi = int(m.group(1)), int(m.group(2))
        return str((lo + hi) // 2)
    return {1: "7", 2: "1 200", 4: "64 000"}.get(
        field["size"] if field["size"] in (1, 2, 4) else 0, "…")


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
            f'<td style="color:{CAT["econ"][0]}">{esc(example_for(st["name"], f))}</td>'
            f'<td>{esc(f["note"])}</td></tr>')
    tall = " tall" if (len(rows) > 12 or (st["total"] or 0) > 128) else ""
    fig = (f'<figure class="structplate{tall}">'
           f'<div style="break-inside:avoid"><div class="platehead"><span class="pt">{esc(st["name"])}</span>'
           f'<span class="ps">{sub}</span></div>'
           f'<div class="plate-wrap">{plate}</div>'
           f'<figcaption>{esc(cap)}</figcaption></div>'
           f'<div class="tablewrap"><table class="keytab"><thead><tr><th>Offset</th><th>B</th>'
           f'<th>Type</th><th>Field</th><th>Example</th><th>Note</th></tr></thead>'
           f'<tbody>{"".join(rows)}</tbody></table></div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


STRUCT_RE = re.compile(
    r"typedef struct\s*\{([^\n]*)\n(.*?)\n\}\s*(\w+)\s*;([^\n]*)", re.S)


def struct_vars_figure(st):
    """Mechanics-chapter rendering: a record's fields as named variables —
    no offsets, no byte plate."""
    scope = SYM.FIELD_SCOPES.get(st["name"], st["name"].lower())
    rows = []
    for f in st["fields"]:
        if not f["name"] or f["name"].split("[")[0].startswith(
                ("_pad", "unused", "pad")):
            continue
        base = f["name"].split("[")[0]
        off_key = "0x%02X" % f["off"]
        friendly = SYM.FIELDS.get((st["name"], off_key), base)
        arr = f["name"][len(base):]
        dark = CAT[f["cat"]][0]
        note = re.sub(r"\s*\((?:@?0x[0-9A-Fa-f]{4,6}[^)]*)\)", "",
                      f["note"] or "")
        note = re.sub(r"@?0x[0-9A-Fa-f]{5,6}", "", note).strip(" ;-")
        rows.append(
            '<tr><td class="cmono" style="color:%s;font-weight:bold">%s.%s%s</td>'
            '<td style="color:%s">%s</td><td>%s</td></tr>' % (
                dark, esc(scope), esc(friendly), esc(arr), CAT["econ"][0],
                esc(example_for(st["name"], f)), esc(note)))
    fig = ('<figure class="structplate"><div style="break-inside:avoid">'
           '<div class="platehead"><span class="pt">%s — the record\'s variables'
           '</span><span class="ps">storage layout in Appendix A - binding in '
           'Appendix C</span></div></div>'
           '<div class="tablewrap"><table class="keytab"><thead><tr>'
           '<th>Variable</th><th>Example</th><th>Meaning</th></tr></thead>'
           '<tbody>%s</tbody></table></div></figure>' % (esc(scope), "".join(rows)))
    return BeautifulSoup(fig, "html.parser").figure


def structs_to_plates(soup, mech=False):
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
                frags.append(struct_vars_figure(val) if mech
                             else struct_figure(val, soup))
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
        _bs("unit.owner — packed byte", "low nibble + high nibble", [
            (3, 0, "power 0..11", "pos", "0..3 European, 4..11 tribes"),
            (7, 4, "state", "flag", "high-nibble unit state"),
        ]),
        _bs("unit.flags — transient bit register", "cleared and rebuilt every pass", [
            (7, 7, "draw", "flag", "draw-active / Damaged display pair"),
            (6, 6, "cargo", "econ", "ship-carrying-cargo"),
            (5, 5, "merch", "pos", "Merchantman tag"),
            (4, 4, "path", "num", "path >= 8 hops"),
            (3, 3, "dirty", "flag", "tile-dirty"),
            (2, 2, "class", "pos", "ship-cargo class"),
            (1, 1, "fortif", "flag", "was-fortifying"),
        ]),
        _bs("unit.cargo_ids — nibble packing",
            "good ids, two cargo slots per byte, up to six", [
                (3, 0, "slot 2k", "econ", "even cargo slot — good id 0..15 (@CARGO)"),
                (7, 4, "slot 2k+1", "econ", "odd cargo slot"),
            ]),
        _bs("unit.profession on routed units",
            "otherwise the colonist profession id", [
                (3, 0, "route id", "pos", "trade-route index 0..11"),
                (7, 4, "stop idx", "pos", "current stop 0..3"),
            ]),
    ],
    "NativeSettlement": [
        _bs("settlement.flags", "", [
            (2, 2, "capital", "pos", "set; doubles value"),
            (1, 1, "taught", "num", "already taught"),
            (0, 0, "w/o", "pad", "write-only bit"),
        ]),
        _bs("settlement.mission", "255 = no mission", [
            (3, 0, "owning power", "pos", "European power holding the mission"),
            (4, 4, "expert", "econ", "expert-mission doubler (Brebeuf; set, tested)"),
        ]),
    ],
    "StopRecord": [
        _bs("stop.counts — load/unload nibbles",
            "at most six goods each way", [
                (3, 0, "unload count", "econ", "goods unloaded at this stop"),
                (7, 4, "load count", "econ", "goods loaded at this stop"),
            ]),
    ],
    "PowerRecord": [
        _bs("power.relations — one byte per pair of powers",
            "symmetric set/clear accessors; section 15.3", [
                (0, 0, "resolved", "num", "resolved/normalised relationship"),
                (1, 1, "war", "warn", "at war"),
                (3, 3, "grievance", "warn", "pending; → bit 0 when +0x40 timer expires and random_int(0,3)==0"),
                (4, 4, "parley", "num", "parley cooldown 16 turns (stamp 0x58075/0x5914C)"),
                (5, 5, "met", "pos", "met / contacted"),
                (6, 6, "treaty", "pos", "peace treaty in force (set both ways 0x59139)"),
                (7, 7, "privateer", "warn", "hidden attribution — privateer attack sets this, not war"),
            ]),
        _bs("power.boycotts — one bit per good",
            "set by a Tea Party; cleared by back-tax payment; Fugger clears the whole word",
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

# plain-English names for recurring globals (section 7.7); each entry:
# address -> (name, context keywords that suppress the annotation as redundant)
GLOSSARY = {
    "53D0": ("the revolution meter", ("revolution", "meter", "sol", "sentiment")),
    "53A6": ("difficulty", ("difficulty",)),
    "538A": ("the year", ("year",)),
    "538C": ("the season word", ("season",)),
    "538E": ("the turn counter", ("turn",)),
    "5382": ("the game-state flags", ("flag", "game-state", "options")),
    "53D2": ("the King/REF power id", ("king", "ref power", "power id", "seced")),
    "5398": ("the rebel power id", ("rebel",)),
    "5394": ("the current power", ("current", "power")),
    "9E12": ("the active player index", ("player", "active")),
    "84FC": ("the active-power record", ("power", "record", "pointer")),
    "8542": ("the active-colony record", ("colony", "record", "pointer")),
    "539C": ("the unit count", ("unit", "count")),
    "539E": ("the colony count", ("colony", "count")),
    "539A": ("the settlement count", ("settlement", "count")),
    "53DA": ("REF Regulars", ("regular", "ref")),
    "53DC": ("REF Cavalry", ("cavalry", "ref")),
    "53DE": ("REF Man-O-War", ("man-o-war", "naval", "ref")),
    "53E0": ("REF Artillery", ("artillery", "ref")),
    "543F": ("the AI-controller byte", ("controller", "human")),
    "853A": ("map width", ("width",)),
    "853C": ("map height", ("height",)),
    "0190": ("the map seed", ("seed",)),
    "190": ("the map seed", ("seed",)),
    "894": ("the debug bitfield", ("debug", "cheat")),
    "1F5C": ("the speaker channel", ("speaker", "channel", "portrait")),
}
GLOB_CODE_RE = re.compile(r"\[0x([0-9A-Fa-f]{3,4})\]")


def name_globals(soup):
    """Annotate known global addresses with their plain-English name: after an
    inline-code token containing e.g. [0x53D0], insert '⟨the revolution
    meter⟩' unless the surrounding prose already names it. One annotation per
    address per paragraph."""
    for para in soup.find_all(["p", "li", "td"]):
        seen = set()
        for code in para.find_all("code"):
            if code.find_parent("pre"):
                continue
            m = GLOB_CODE_RE.search(code.get_text())
            if not m:
                continue
            addr = m.group(1).upper().lstrip("0") or "0"
            key = next((k for k in GLOSSARY
                        if k.upper().lstrip("0") == addr), None)
            if key is None or key in seen:
                continue
            name, kws = GLOSSARY[key]
            ctx = para.get_text().lower()
            if any(kw in ctx for kw in kws):
                seen.add(key)
                continue
            seen.add(key)
            tag = soup.new_tag("span", attrs={"class": "gname"})
            tag.string = f" ⟨{name}⟩"
            code.insert_after(tag)


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


def formula_cards(soup):
    """```formula fenced blocks -> styled cards: math line(s) large, lines
    starting with 'example:' as a labelled worked-example row, lines starting
    with '|' as small annotation lines."""
    n = 0
    for pre in list(soup.find_all("pre")):
        code = pre.find("code")
        if code is None or "language-formula" not in (code.get("class") or []):
            continue
        math, notes, examples = [], [], []
        for ln in code.get_text().split("\n"):
            s = ln.rstrip()
            if not s.strip():
                continue
            if s.lstrip().startswith("example:"):
                examples.append(s.lstrip()[8:].strip())
            elif s.lstrip().startswith("|"):
                notes.append(s.lstrip()[1:].strip())
            else:
                math.append(s)
        mh = "<br/>".join(esc(m) for m in math)
        if notes:
            mh += "<br/>" + "<br/>".join(
                f'<span class="fm2">{esc(t)}</span>' for t in notes)
        eh = "".join(f'<div><span class="flab">example</span>{esc(x)}</div>'
                     for x in examples)
        card = BeautifulSoup(
            f'<figure class="fcard"><div class="fmath">{mh}</div>'
            f'{f"<div class={chr(34)}fex{chr(34)}>{eh}</div>" if examples else ""}'
            f'</figure>', "html.parser").figure
        pre.replace_with(card)
        n += 1
    return n


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


def production_walkthrough_fig():
    """Plain-language worked example of the tile-yield calculation:
    Expert Cotton Planter, plowed Prairie, minor river — 3 → 4 → 8 → 12.
    Every number derives from the documented chain in section 5.8; the hex
    lives there, not here."""
    tile = SPR.terrain_tile(3)          # Prairie
    cotton = SPR.goods_icon(3)
    worker = SPR.unit_icon(101)         # Colonists figure
    t_uri = SPR.data_uri(tile, 4)
    c_uri = SPR.data_uri(cotton, 4)
    w_uri = SPR.data_uri(worker, 4)

    stages = [
        ("1", "Start from the terrain table", "pos",
         ["Every terrain has a fixed base for each good.",
          "Prairie grows Cotton at 3."],
         "3", "base"),
        ("2", "Rivers help", "text",
         ["A minor river on the tile adds +1.",
          "A Major river would add +1 more."],
         "4", "+1"),
        ("3", "The expert doubles it", "num",
         ["A Master Cotton Planter working their own good",
          "doubles the yield so far. (Food & Horses get +2",
          "instead.) Expertise also upgrades every improvement",
          "bonus below from +1 to +2."],
         "8", "×2"),
        ("4", "Prime resource — none here", "econ",
         ["A Prime Cotton square would add +6,",
          "doubled to +12 for the expert."],
         "8", "±0"),
        ("5", "Improvements", "arr",
         ["Plowing boosts the crop goods: +2 (the expert tier).",
          "The river is rewarded again here: +2.",
          "(Roads instead boost ore, furs and timber —",
          "they do nothing for crops.)"],
         "12", "+4"),
        ("6", "Liberty has the last word", "warn",
         ["A content colony changes nothing. A colony full",
          "of Tories subtracts at the very end — but the",
          "yield never drops below zero."],
         "12", "±0"),
    ]

    W = 660
    head_h = 66
    row_h = 78
    foot_h = 74
    H = head_h + len(stages) * row_h + foot_h
    e = [f'<svg viewBox="0 0 {W} {H}" xmlns="http://www.w3.org/2000/svg">']

    # ---- header: the scenario, with sprites
    e.append(f'<rect x="2" y="2" width="{W - 4}" height="{head_h - 12}" '
             f'fill="#F4F3EF" stroke="{INK}" stroke-width="1.2"/>')
    e.append(f'<image x="16" y="10" width="36" height="36" href="{t_uri}" '
             f'style="image-rendering:pixelated"/>')
    e.append(f'<image x="60" y="12" width="26" height="32" href="{w_uri}" '
             f'style="image-rendering:pixelated"/>')
    e.append(svg_text(100, 24, "One worked tile, start to finish", 11.5,
                      weight="bold"))
    e.append(svg_text(100, 41, "an Expert Cotton Planter on plowed Prairie "
                      "beside a minor river", 8.6, fill=MUTED))
    e.append(f'<image x="{W - 90}" y="8" width="28" height="38" href="{c_uri}" '
             f'style="image-rendering:pixelated"/>')
    e.append(svg_text(W - 46, 33, "= 12", 15, weight="bold",
                      fill=CAT["econ"][0]))

    # ---- stage cards + running-total rail
    rail_cx = 596
    card_w = 500
    prev = None
    for i, (no, title, cat, lines, total, delta) in enumerate(stages):
        y = head_h + i * row_h
        dark, light = CAT[cat]
        e.append(f'<rect x="10" y="{y}" width="{card_w}" height="{row_h - 12}" '
                 f'fill="{light}" stroke="{dark}" stroke-width="1.3"/>')
        e.append(f'<circle cx="30" cy="{y + 20}" r="11" fill="{dark}"/>')
        e.append(svg_text(30, y + 24, no, 10.5, fill="#FFFFFF",
                          anchor="middle", weight="bold"))
        e.append(svg_text(50, y + 24, title, 10.2, weight="bold"))
        for j, ln in enumerate(lines):
            e.append(svg_text(50, y + 39 + j * 11.5, ln, 7.8, fill="#3A3F47"))
        # rail badge
        by = y + (row_h - 12) / 2
        if prev is not None:
            e.append(f'<line x1="{rail_cx}" y1="{prev + 21}" x2="{rail_cx}" '
                     f'y2="{by - 21}" stroke="{MUTED}" stroke-width="1.4" '
                     f'marker-end="url(#farr)"/>')
        e.append(f'<line x1="{510}" y1="{by}" x2="{rail_cx - 34}" y2="{by}" '
                 f'stroke="{RULE}" stroke-width="1" stroke-dasharray="3,3"/>')
        final = i == len(stages) - 1
        bw2 = 33 if final else 27
        e.append(f'<rect x="{rail_cx - bw2}" y="{by - 20}" width="{bw2 * 2}" '
                 f'height="40" rx="9" fill="{dark if final else light}" '
                 f'stroke="{dark}" stroke-width="{2 if final else 1.4}"/>')
        e.append(svg_text(rail_cx, by + 6, total, 17 if final else 15,
                          fill=("#FFFFFF" if final else dark),
                          anchor="middle", weight="bold", face=MONO_FACE))
        e.append(svg_text(rail_cx + bw2 + 6, by + 4, delta, 8.6, fill=dark,
                          weight="bold"))
        prev = by

    # ---- footer: the non-expert comparison + other movers
    fy = head_h + len(stages) * row_h + 2
    e.append(f'<rect x="10" y="{fy}" width="{W - 20}" height="{foot_h - 10}" '
             f'fill="#F6F5F1" stroke="{RULE}" stroke-width="1"/>')
    e.append(svg_text(22, fy + 16, "The same tile with an ordinary colonist:",
                      8.8, weight="bold"))
    e.append(svg_text(22, fy + 30, "3 base  →  +1 river  →  no doubling  →  "
                      "plow +1 and river +1  →  6 Cotton (the expert isn't "
                      "just double — the bonuses grow too)", 8.2,
                      fill="#3A3F47"))
    e.append(svg_text(22, fy + 48,
                      "Other things that move the number:  coastal crowding "
                      "hurts fish · Lumber always doubles · Hudson doubles "
                      "Furs ·", 7.8, fill=MUTED))
    e.append(svg_text(22, fy + 60,
                      "silver/ore/fish need their building or father past a "
                      "point · the colony centre works itself, no colonist "
                      "needed", 7.8, fill=MUTED))
    e.append("</svg>")

    fig = (f'<figure class="tall"><div style="break-inside:avoid">'
           f'<div class="platehead"><span class="pt">How a tile\'s yield is '
           f'computed — a walkthrough</span>'
           f'<span class="ps">the full byte-cited chain follows below</span></div>'
           f'<div class="plate-wrap">{"".join(e)}</div>'
           f'<figcaption>Order matters: the expert doubles before the '
           f'improvements are added, and the Sons-of-Liberty adjustment lands '
           f'after everything else.</figcaption></div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


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
    _after_h3(soup, "worked-tile production", production_walkthrough_fig())
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


def food_walkthrough_fig():
    """The life of the Food price — every step from section 9's own cited
    text (9.1 display pair, 9.3 drift/init/coupling, 9.4 transactions)."""
    return flow_fig(
        "Walkthrough — the life of the Food price",
        "good 0 · assembled from §9.1 / §9.3 / §9.4",
        [
            {"k": "start", "t": "New game"},
            {"k": "act", "t": "price_seed[Food] = random_int(600, 1000)",
             "s": ["seed_market() fills all 16 entries — no fixed base-price table",
                   "price_seed lives at DS: (word per good)"]},
            {"k": "act", "t": "Europe strip shows the bid/ask pair (16-good loop)",
             "s": ["sell = price_level[Food] − 1 (sell_price(), clamp ≥ 0)",
                   "buy = @CARGO col 1 (Food = 1) + price_level[Food] (buy_price())",
                   "so Food's on-screen spread is the constant 1 + 1 = 2"]},
            {"k": "dec", "t": "you trade Food in Europe",
             "side": ("BUY", ["untaxed: sub [bx+0x2A],ax; sbb …",
                              "EU supply +0xBC −= qty",
                              "accumulator +0xFC −= qty"]),
             "cont": "SELL (sell_goods())"},
            {"k": "act", "t": "SELL: gross = price·qty, tax split ..78",
             "s": ["tax = gross·tax_rate/100 → King fund +0x22",
                   "net = gross − tax → treasury via the [0,999999] clamp",
                   "EU supply +0xBC += qty · accumulator +0xFC += qty"]},
            {"k": "act", "t": "immediate single-good re-drift — drift(Food, 0)",
             "s": ["both handlers call it right after the trade"]},
            {"k": "act", "t": "end of turn — market_day() (in end_of_turn())",
             "s": ["acc = price_seed[Food] + Σ over 4 powers of max(0, accum_FC[Food])",
                   "price_seed[Food] −= acc >> 8 (proportional decay)",
                   "then all per-power accumulators are cleared"]},
            {"k": "dec", "t": "price level steps",
             "side": ("down", ["step-down −= 1, clamp ≥ 0"]),
             "cont": "step-up += 1"},
            {"k": "end", "t": "next turn's bid/ask uses the new level"},
        ],
        "Food is not luxury-coupled. Rum/Cigars/Cloth/Coats additionally share "
        "S_pair = supply[9]+…+supply[12] with target[i] = (S_pair·3)/supply[i] "
        "; raw inputs Sugar/Tobacco/Cotton/Furs use the same"
        "formula against their own supply (Furs halved; +1 if year<1700, "
        "+1 more if year<1600,).")


def enrich_market(soup):
    for h in soup.find_all("h3"):
        if "Goods" in h.get_text():
            h.insert_after(goods_plate_fig())
            break
    for h in soup.find_all("h3"):
        if "Buy/sell" in h.get_text():
            anchor = h.find_next("table")
            anchor = (anchor.parent if anchor and anchor.parent.name == "div"
                      else anchor) or h
            anchor.insert_after(food_walkthrough_fig())
            return


_PAL_CACHE = None


def pal_entry(idx):
    """VICEROY.PAL entry {index,r,g,b,hex} from the committed decode."""
    global _PAL_CACHE
    if _PAL_CACHE is None:
        import json
        _PAL_CACHE = json.load(open(ROOT / "data_extracted/palette.json"))
    return _PAL_CACHE[idx]


def swatch_html(idx):
    """Inline colour chip for a palette index — the index number printed on
    the actual colour it names."""
    ent = pal_entry(idx)
    lum = 0.299 * ent["r"] + 0.587 * ent["g"] + 0.114 * ent["b"]
    ink = "#000000" if lum > 128 else "#FFFFFF"
    return (f'<span class="swatch" style="background:{ent["hex"]};'
            f'color:{ink}">{idx}</span>')


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


def professions_plate_fig():
    cells = []
    for j in range(28):
        im = SPR.frame_image("ICONS.SS", SPR.JOB_FIGURES[j])
        cells.append(
            f'<div class="cell">{SPR.img_tag(SPR.data_uri(im, 3), im.width, im.height, 2.2)}'
            f'<span class="fi">{j}</span>'
            f'<span class="fl">{esc(SPR.JOB_NAMES[j])}</span></div>')
    fig = (f'<figure class="tall"><div style="break-inside:avoid">'
           f'<div class="platehead"><span class="pt">The 28 professions — figure = job id + 81'
           f'</span><span class="ps">@JOB order · Convert is the exception at disk 66</span></div>'
           f'<div class="atlas">{"".join(cells)}</div>'
           f'<figcaption>The figure rule is byte-cited at three Colonizopedia call '
           f'sites (job+0x52 engine); labels pixel-verified against the decoded '
           f'sheet.</figcaption></div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


def b5_galleries():
    figs = []
    # Founding Father portraits — CC-00..CC-24, @FATHERS order
    import json
    try:
        fathers = [ln.split(",")[0].strip() for ln in json.load(
            open(ROOT / "data_extracted/text/NAMES_sections.json"))["@FATHERS"]
            .strip().split("\n")][:25]
    except Exception:
        fathers = [f"Father {i}" for i in range(25)]
    cells = []
    for i in range(25):
        try:
            im = SPR.frame_image(f"CC-{i:02d}.SS", 0)
        except Exception:
            continue
        cells.append(
            f'<div class="cell">{SPR.img_tag(SPR.data_uri(im, 2), im.width, im.height, 0.55)}'
            f'<span class="fi">{i}</span><span class="fl">{esc(fathers[i])}</span></div>')
    figs.append(BeautifulSoup(
        f'<figure class="tall"><div style="break-inside:avoid"><div class="platehead">'
        f'<span class="pt">The 25 Founding Fathers — CC-00..CC-24</span>'
        f'<span class="ps">portrait sheets, NAMES @FATHERS order</span></div>'
        f'<div class="atlas">{"".join(cells)}</div></div></figure>',
        "html.parser").figure)
    # advisors + rivals + king figures
    cells = []
    groups = [(f"MSS{i}.SS", f"advisor {i}") for i in range(6)] +              [(f"MYR{i}.SS", ["England", "France", "Spain", "Netherlands"][i] +
               " leader") for i in range(4)] +              [("KING.SS", "King (speaker)"), ("KING1.SS", "King + dog (audience)"),
              ("KINGLOSE.SS", "king crying — you win"),
              ("KINGWIN.SS", "king triumphant — you lose")]
    for name, lab in groups:
        try:
            im = SPR.frame_image(name, 0)
        except Exception:
            continue
        cells.append(
            f'<div class="cell">{SPR.img_tag(SPR.data_uri(im, 2), im.width, im.height, 0.45)}'
            f'<span class="fi">{esc(name[:-3])}</span><span class="fl">{esc(lab)}</span></div>')
    figs.append(BeautifulSoup(
        f'<figure class="tall"><div style="break-inside:avoid"><div class="platehead">'
        f'<span class="pt">Speakers — advisors, rival leaders, the King</span>'
        f'<span class="ps">popup portrait channels</span></div>'
        f'<div class="atlas">{"".join(cells)}</div></div></figure>',
        "html.parser").figure)
    # chrome
    cells = []
    chrome = [("WOODTILE.SS", 0, "wood fill tile"), ("PARCH.SS", 0, "parchment tile"),
              ("OPENTILE.SS", 0, "boot plaque tile"), ("CURSOR.SS", 0, "pointer"),
              ("CURSOR.SS", 1, "pointer 2"), ("NAMEPLAT.SS", 0, "caption cap L"),
              ("NAMEPLAT.SS", 1, "caption mid"), ("NAMEPLAT.SS", 2, "caption cap R"),
              ("WOODFRAM.SS", 0, "popup/woodcut frame")]
    for name, fi, lab in chrome:
        try:
            im = SPR.frame_image(name, fi)
        except Exception:
            continue
        sc = 0.7 if im.width > 100 else 2.0
        cells.append(
            f'<div class="cell">{SPR.img_tag(SPR.data_uri(im, 2), im.width, im.height, sc)}'
            f'<span class="fi">{esc(name[:-3])}:{fi}</span><span class="fl">{esc(lab)}</span></div>')
    figs.append(BeautifulSoup(
        f'<figure class="tall"><div style="break-inside:avoid"><div class="platehead">'
        f'<span class="pt">Engine chrome — tiles, cursors, caption strip, the frame</span>'
        f'<span class="ps">the small sheets the UI is built from</span></div>'
        f'<div class="atlas">{"".join(cells)}</div></div></figure>',
        "html.parser").figure)
    return figs



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
            "131 HUD frames · '*' = pixel-verified label only; unlabelled = unidentified",
            range(131), 1.9,
            label_of=lambda d: SPR.ICONS_LABELS.get(d, ""))),
        "BUILDING.SS": ("B.4", atlas_fig(
            "BUILDING.SS", "BUILDING.SS — frame atlas",
            "48 colony-building frames · disk = def id", range(48), 1.3,
            label_of=lambda d: building_names.get(d, "")))}
    for h in soup.find_all("h3"):
        if "B.5" in h.get_text():
            anchor = h
            for fig in [professions_plate_fig()] + b5_galleries():
                anchor.insert_after(fig)
                anchor = fig
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


# --------------------------------------------------------------------------
# 4d. Compact diagram primitives (v8 format: bigger text, no side-stretch)
# --------------------------------------------------------------------------

def _wrap(t, width):
    words, lines, cur = t.split(), [], ""
    for w in words:
        if len(cur) + len(w) + 1 > width:
            lines.append(cur)
            cur = w
        else:
            cur = (cur + " " + w).strip()
    if cur:
        lines.append(cur)
    return lines


def dense_flow(title, sub, nodes, caption=""):
    """Compact logic map. nodes:
      {k:'start'|'end', t}
      {k:'act', t, s:[lines]}                      full-width tight card
      {k:'dec', t, yes:(label,[lines]), no:(label,[lines])}  two half cards
    Text 10/9pt, minimal gaps, branches side-by-side beneath the diamond.
    """
    W, MX = 660, 6
    CW = W - 2 * MX
    e, y = [], 6
    centers = []

    def card(x, w, ty, title_t, lines, cat, weight="bold", tsz=10.2):
        dark, light = CAT[cat]
        tlines = _wrap(title_t, int(w / 4.2))[:2]
        wrapped = []
        for ln in lines:
            wrapped += _wrap(ln, int(w / 4.6))
        h = 17 + 12 * (len(tlines) - 1) + 11.5 * len(wrapped) + \
            (4 if wrapped else 2)
        e.append(f'<rect x="{x}" y="{ty}" width="{w}" height="{h:.0f}" rx="3" '
                 f'fill="{light}" stroke="{dark}" stroke-width="1.2"/>')
        for tl_i, tl in enumerate(tlines):
            e.append(svg_text(x + 8, ty + 13 + tl_i * 12, tl, tsz, weight=weight))
        toff = 13 + 12 * len(tlines)
        for i, ln in enumerate(wrapped):
            e.append(svg_text(x + 8, ty + toff + 11.5 * i + 1, ln, 8.8,
                              fill="#2A2F37"))
        return h

    for nd in nodes:
        k = nd["k"]
        if k in ("start", "end"):
            h = 24
            e.append(f'<rect x="{W / 2 - 130}" y="{y}" width="260" height="{h}" '
                     f'rx="12" fill="{INK}"/>')
            tsz = min(9.6, max(6.5, 250 / (0.52 * max(1, len(nd["t"])))))
            e.append(svg_text(W / 2, y + h / 2 + 3.2, nd["t"], tsz,
                              fill="#FCFBF8", anchor="middle", weight="bold"))
            centers.append((y, h))
            y += h + 9
        elif k == "act":
            h = card(MX, CW, y, nd["t"], nd.get("s", []), nd.get("cat", "num"))
            centers.append((y, h))
            y += h + 9
        elif k == "dec":
            dark, light = CAT["econ"]
            dh = 26
            e.append(f'<path d="M {MX} {y + dh / 2} L {W / 2} {y} '
                     f'L {W - MX} {y + dh / 2} L {W / 2} {y + dh} z" '
                     f'fill="{light}" stroke="{dark}" stroke-width="1.2"/>')
            e.append(svg_text(W / 2, y + dh / 2 + 3.4, nd["t"], 10.0,
                              anchor="middle", weight="bold"))
            centers.append((y, dh))
            y += dh + 8
            bw = (CW - 10) / 2
            yl, yr = nd["yes"], nd["no"]
            h1 = card(MX, bw, y, "✔ " + yl[0], yl[1], "arr", tsz=9.6)
            h2 = card(MX + bw + 10, bw, y, "✘ " + yr[0], yr[1], "warn",
                      tsz=9.6)
            hh = max(h1, h2)
            e.append(f'<line x1="{MX + bw / 2}" y1="{y - 8}" x2="{MX + bw / 2}" '
                     f'y2="{y - 1}" stroke="{MUTED}" stroke-width="1.2" '
                     f'marker-end="url(#farr)"/>')
            e.append(f'<line x1="{MX + bw + 10 + bw / 2}" y1="{y - 8}" '
                     f'x2="{MX + bw + 10 + bw / 2}" y2="{y - 1}" '
                     f'stroke="{MUTED}" stroke-width="1.2" '
                     f'marker-end="url(#farr)"/>')
            centers.append((y, hh))
            y += hh + 9
    H = y + 2
    spine = []
    for (y1, h1), (y2, _) in zip(centers, centers[1:]):
        if y2 - (y1 + h1) >= 7:
            spine.append(f'<line x1="{W / 2}" y1="{y1 + h1}" x2="{W / 2}" '
                         f'y2="{y2 - 1.5}" stroke="{MUTED}" stroke-width="1.2" '
                         f'marker-end="url(#farr)"/>')
    svg = (f'<svg viewBox="0 0 {W} {H:.0f}" xmlns="http://www.w3.org/2000/svg">'
           '<defs><marker id="farr" viewBox="0 0 8 8" refX="7" refY="4" '
           'markerWidth="7" markerHeight="7" orient="auto">'
           f'<path d="M0,0 L8,4 L0,8 z" fill="{MUTED}"/></marker></defs>'
           + "".join(spine) + "".join(e) + "</svg>")
    cap = f"<figcaption>{esc(caption)}</figcaption>" if caption else ""
    fig = (f'<figure class="tall"><div style="break-inside:avoid">'
           f'<div class="platehead"><span class="pt">{esc(title)}</span>'
           f'<span class="ps">{esc(sub)}</span></div>'
           f'<div class="plate-wrap">{svg}</div>{cap}</div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


def route_map(title, sub, columns, caption=""):
    """Dialog/route tree: N columns, each {head, img(optional PIL), cards:
    [(label, lines, cat)]}. Column width = 660/N; text 9.5/8.4."""
    W = 660
    n = len(columns)
    cw = (W - 8 * (n + 1)) / n
    e = []
    maxy = 0
    for ci, col in enumerate(columns):
        x = 8 + ci * (cw + 8)
        y = 4
        dark, light = CAT[col.get("cat", "pos")]
        hh = 30
        e.append(f'<rect x="{x}" y="{y}" width="{cw}" height="{hh}" rx="4" '
                 f'fill="{dark}"/>')
        img = col.get("img")
        tx = x + cw / 2
        if img is not None:
            uri = SPR.data_uri(img, 3)
            iw, ih = img.width * 1.4, img.height * 1.4
            e.append(f'<image x="{x + 4}" y="{y + (hh - ih) / 2:.0f}" '
                     f'width="{iw:.0f}" height="{ih:.0f}" href="{uri}" '
                     f'style="image-rendering:pixelated"/>')
            tx = x + (cw + iw) / 2
        hsz = min(10.5, max(7.0, (cw - (img.width * 1.4 + 10 if img is not None else 8)) /
                            (0.52 * max(1, len(col["head"])))))
        e.append(svg_text(tx, y + hh / 2 + 3.4, col["head"], hsz,
                          fill="#FFFFFF", anchor="middle", weight="bold"))
        y += hh + 7
        for label, lines, cat in col["cards"]:
            d2, l2 = CAT[cat]
            tw = _wrap(label, int(cw / 4.4))[:2]
            body = []
            for ln in lines:
                body += _wrap(ln, int(cw / 3.9))
            ch = 8 + 11 * len(tw) + 9.6 * len(body) + 5
            e.append(f'<line x1="{x + cw / 2}" y1="{y - 7}" x2="{x + cw / 2}" '
                     f'y2="{y - 1}" stroke="{MUTED}" stroke-width="1.1"/>')
            e.append(f'<rect x="{x}" y="{y}" width="{cw}" height="{ch:.0f}" '
                     f'rx="3" fill="{l2}" stroke="{d2}" stroke-width="1.1"/>')
            yy = y + 11
            for tl in tw:
                e.append(svg_text(x + 5, yy, tl, 9.2, weight="bold"))
                yy += 11
            for ln in body:
                e.append(svg_text(x + 5, yy, ln, 8.2, fill="#2A2F37"))
                yy += 9.6
            y += ch + 7
        maxy = max(maxy, y)
    svg = (f'<svg viewBox="0 0 {W} {maxy + 2:.0f}" '
           f'xmlns="http://www.w3.org/2000/svg">' + "".join(e) + "</svg>")
    cap = f"<figcaption>{esc(caption)}</figcaption>" if caption else ""
    fig = (f'<figure class="tall"><div style="break-inside:avoid">'
           f'<div class="platehead"><span class="pt">{esc(title)}</span>'
           f'<span class="ps">{esc(sub)}</span></div>'
           f'<div class="plate-wrap">{svg}</div>{cap}</div></figure>')
    return BeautifulSoup(fig, "html.parser").figure


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
            boxes.append(("side", SX, max(2, y + h / 2 - sh / 2), SW, sh,
                          sidelines))
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
            tsz = min(8.4, max(5.6, (w - 20) / (0.52 * max(1, len(t)))))
            out.append(svg_text(x + w / 2, ty + h / 2 + 3, t, tsz,
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


def formula_fig(title, sub, formula, factors, caption=""):
    """Formula plate: the expression set large, one keyed row per factor.
    factors: (symbol, meaning, cite)."""
    lines = formula if isinstance(formula, list) else [formula]
    H = 18 + 24 * len(lines) + 10
    e = [f'<svg viewBox="0 0 660 {H}" xmlns="http://www.w3.org/2000/svg">']
    e.append(f'<rect x="2" y="4" width="656" height="{H - 8}" fill="#F4F3EF" '
             f'stroke="{CAT["num"][0]}" stroke-width="1.4"/>')
    for i, ln in enumerate(lines):
        e.append(svg_text(330, 26 + 24 * i, ln, 12.5, fill=INK, anchor="middle",
                          face=MONO_FACE, weight="bold"))
    e.append("</svg>")
    rows = "".join(
        f'<tr><td class="cmono" style="color:{CAT["num"][0]};font-weight:bold">'
        f'{esc(sym)}</td><td>{esc(mean)}</td><td class="cmono">{esc(cite)}</td></tr>'
        for sym, mean, cite in factors)
    cap = f"<figcaption>{esc(caption)}</figcaption>" if caption else ""
    fig = (f'<figure><div style="break-inside:avoid"><div class="platehead">'
           f'<span class="pt">{esc(title)}</span><span class="ps">{esc(sub)}</span></div>'
           f'<div class="plate-wrap">{"".join(e)}</div></div>'
           f'<div class="tablewrap"><table class="keytab"><thead><tr><th>Term</th>'
           f'<th>Meaning</th><th>Site</th></tr></thead><tbody>{rows}</tbody>'
           f'</table></div>{cap}</figure>')
    return BeautifulSoup(fig, "html.parser").figure


def enrich_turnflow(soup):
    fig1 = flow_fig(
        "The turn loop", "turn_loop() — one full pass per turn",
        [
            {"k": "start", "t": "Turn begins"},
            {"k": "gopen",
             "t": "×4 — once per European power, strict index order"},
            {"k": "act", "t": "1 King / mercenary — king_phase()",
             "s": ["gated game.flags&1==0 · peacetime mercenary roll · King events"]},
            {"k": "act", "t": "2 Orders / movement — orders_phase()",
             "s": ["per-unit orders pump · REF fund accrual grow_royal_fund() via",
                   "AI moves a helper; contact evaluator evaluate_contact() fires diplomacy"]},
            {"k": "act", "t": "3 Production — production_phase()",
             "s": ["zero bells/turn +0x0E · per-colony update_colony():",
                   "yields, food/starvation/spoilage popups, school, bell accrual"]},
            {"k": "act", "t": "4 Diplomacy — diplomacy_phase()",
             "s": ["king-action dispatch next_immigrant_class() (tax raises event-driven here) · AI diplomacy"]},
            {"k": "act", "t": "5 Periodic / congress — periodic_phase()",
             "s": ["colony stats a helper · congress a helper (gate game.flags&0x10==0)",
                   "King defeat/victory screens /"]},
            {"k": "gclose"},
            {"k": "act", "t": "Market drift — market_day())",
             "s": ["clear per-power 16-good accumulators",
                   "4-power loop into drift_prices(): base relaxes by (base + Σ clamped trade)/256"]},
            {"k": "act", "t": "Immigration crosses — immigration_threshold()",
             "s": ["runs immediately after the price recompute"]},
            {"k": "act", "t": "Religious-unrest arrivals — @UNREST chain", "s": []},
            {"k": "act", "t": "Year cadence — inc game.turn",
             "s": ["see the cadence diagram below"]},
            {"k": "act", "t": "Autosave tail (§20.2)", "s": []},
            {"k": "end", "t": "Next turn"},
        ],
        "Natives are not a separate top-level pass — their AI runs inside the "
        "per-power processing.")
    fig2 = flow_fig(
        "Year cadence and end-of-game checks", "loop tail –",
        [
            {"k": "act", "t": "inc game.turn — turn counter", "s": []},
            {"k": "dec", "t": "year < 1600 ?",
             "side": ("yes", ["one turn = one year"]), "cont": "no — from 1600"},
            {"k": "act", "t": "season word game.season toggles Spring / Autumn",
             "s": ["the year steps every second turn · start 1492"]},
            {"k": "dec", "t": "year reaches 1725 ?",
             "side": ("yes", ["forced end: game.forced_end = 1",
                              "end-game save fires near"]),
             "cont": "no"},
            {"k": "end", "t": "continue"},
        ])
    fig3 = flow_fig(
        "The autosave chain", "helper; consumers /",
        [
            {"k": "dec", "t": "Autosave option on, and not suppressed ?",
             "side": ("no", ["no autosave"]), "cont": "yes"},
            {"k": "act", "t": "rolling autosave → slot 9, every turn",
             "s": ['"most recent save in the last slot"']},
            {"k": "dec", "t": "year divisible by 10 ?",
             "side": ("yes", ["decade autosave → slot 8"]), "cont": "no"},
            {"k": "end", "t": "done"},
        ],
        "Filenames COLONY<slot>.SAV (stem at file). Manual slots via"
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
                                 "at"]),
             "cont": "refuse"},
            {"k": "act", "t": "@TEAPARTY fires",
             "s": ['"Sons of Liberty throw {%NUMBER0} tons of %STRING0 into the sea at %STRING1!"',
                   "boycott bit set: PowerRecord+0x20 |= (1<<good)"]},
            {"k": "dec", "t": "lift the boycott ?",
             "side": ("pay back-tax", ["count × 500 gold (count = +0x4C[good]",
                                       "+ base +good·9, clamp ≥0)",
                                       "gold → royal fund",
                                       "bit cleared"]),
             "cont": "or acquire Jakob Fugger (FF id 1)"},
            {"k": "act", "t": "Fugger clears the whole boycott word",
             "s": ["mov [bx+0x20],0"]},
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


def _after_h3(soup, substr, fig):
    for h in soup.find_all("h3"):
        if substr in h.get_text():
            h.insert_after(fig)
            return True
    warn(f"anchor '{substr}' not found for figure")
    return False


def enrich_sol(soup):
    _after_h3(soup, "Sons of Liberty — the full pipeline", formula_fig(
        "The Sons-of-Liberty percent", "sons_of_liberty_percent()",
        "SoL% = min(100,  (sol_numerator · 100) / sol_denominator  [+20])",
        [("sol_numerator", "rebel bell pool, ColonyRecord +0xC2 — decays >>6, += bells/turn, clamped to the cap", ""),
         ("sol_denominator", "bell cap, +0xC6 — decays >>6, floors 1, += 2·population", ""),
         ("+20", "human European owner with FF op 0x12 only", ""),
         ("min(100)", "final clamp; A ≤ B also enforced structurally", " /")],
        "Derived steady state: SoL% → min(100, 50·bells/pop); unanimity needs "
        "bells ≥ 2·population."))


def enrich_loot(soup):
    for h in soup.find_all("h3"):
        if "Loot — razing" in h.get_text():
            fig2 = formula_fig(
                "Colony capture plunder", "resolve_attack() · math at",
                "loot = (pop · victim_gold) / max(Σ victim colony pops, 1)",
                [("pop", "captured colony's population, ColonyRecord +0x1F", ""),
                 ("victim_gold", "the victim power's whole treasury, PowerRecord +0x2A", ""),
                 ("Σ pops", "all the victim's colonies, summed; clamp ≥ 1", ""),
                 ("transfer", "victim −loot, attacker +loot (32-bit)", " /")],
                "Gated OFF during the War of Independence (test game.flags,1)."
                "Message @CAPTURED; no Crown cut on this path.")
            h.insert_after(fig2)
            fig1 = formula_fig(
                "Indian raze gold", "@CHIEFKILL path · raze_settlement()",
                "gold = ( r₁ + r₂ + r₃ ) · random_int(1,6) · 4 · (size + 1)",
                [("r₁..r₃", "three rolls of random_int(1, 10 − difficulty)", ""),
                 ("×random_int(1,6)", "the volatility factor", ""),
                 ("×4", "constant", ""),
                 ("size+1", "settlement size factor (documented conflict: TribeData +0x02 trace vs the 2026-05-30 ruling = NativeSettlement +0x04 population)", ""),
                 ("payout", "credited to attacker treasury +0x2A; no ×100, no Treasure unit", "")],
                "Ceilings at size factor 21: 15,120 / 13,608 / 12,096 / 10,584 / "
                "9,072 by difficulty. Capitals exceed this — bonus unmapped (TBD).")
            h.insert_after(fig1)
            return


def enrich_king(soup):
    _after_h3(soup, "tax petition", flow_fig(
        "The tax petition — three outcomes", "tax_petition()",
        [
            {"k": "start", "t": "king-action case 4"},
            {"k": "dec", "t": "tax_pct ≤ 1 ?",
             "side": ("yes", ["return — nothing to ease"]), "cont": "no"},
            {"k": "act", "t": "candidate = (((diff&0xFE)<<1)+4) · (turn/400 + 1)",
             "s": ["delta · turn factor"]},
            {"k": "dec", "t": "candidate + 5 ≥ tax_pct ?",
             "side": ("yes", ["@KINGRAISE — punitive raise",
                              "amount = random_int(diff,1) · 2",
                              "carries @TAXOPTIONS → can Tea Party (§23.4)"]),
             "cont": "no"},
            {"k": "dec", "t": "tax_pct ≤ candidate ?",
             "side": ("yes", ['@KINGNOTHING — "…kiss our royal',
                              'pinky ring." (0x034B33, no options)']),
             "cont": "no"},
            {"k": "dec", "t": "random_int(1, diff+1) == 1 ?",
             "side": ("no", ["return — no change this time"]),
             "cont": "yes — probability 1/(diff+1)"},
            {"k": "act", "t": "@KINGLOWER — the Crown eases",
             "s": ["amount = random_int(5−diff, 1), shown negated",
                   "tax write clamp 75 at apply_tax_change()"]},
            {"k": "end", "t": "announce via :0xAE0"},
        ],
        "No player-facing 'request lower taxes' control is documented; the "
        "announce overlay's internal tax write is untraced (TBD)."))
    _after_h3(soup, "The King's mercenaries", flow_fig(
        "The mercenary offer", "peacetime king_phase() · wartime offer_wartime_mercenaries()",
        [
            {"k": "dec", "t": "war of independence declared ? (game.flags&1)",
             "side": ("no — peacetime", ["1-in-21 gate: random_int(0,0x14)==0",
                                         "offering power must hold treaty bit 0x40",
                                         "count = random_int(1,3) + coin flips",
                                         "fee/unit = ((diff+4)·2 + rand(0,6))·100"]),
             "cont": "yes — wartime"},
            {"k": "act", "t": "one-shot arm: PowerRecord bit 0x08",
             "s": ["no offer on the first eligible call — only from the second on"]},
            {"k": "act", "t": "1-in-3 gate, then compose",
             "s": ["count = random_int(2, (4−diff)/2 + 2)",
                   "plus exactly one: Cont. Cavalry or Artillery"]},
            {"k": "act", "t": "fee/unit = ((diff+3)·2 + random_int(0,6)) · 100",
             "s": ["price = fee · (count + 2)",
                   "shown only if price ≤ treasury +0x2A; debit"]},
            {"k": "act", "t": "landing — land_intervention_force()",
             "s": ["population-weighted coastal colony pick",
                   "Man-O-War carrier at best beach; all land units Veteran"]},
            {"k": "end", "t": "@MERCS — force arrives"},
        ]))
    _after_h3(soup, "Royal Expeditionary Force schedule", flow_fig(
        "REF growth — one purchase", "grow_royal_fund(), pre-independence each turn",
        [
            {"k": "act", "t": "fund += (8·diff + 10), doubled at 1600/1700/1750",
             "s": ["PowerRecord +0x22; sale tax feeds the fund"]},
            {"k": "dec", "t": "fund ≥ 1800 ?",
             "side": ("no", ["wait — accrue again next turn"]), "cont": "yes"},
            {"k": "dec", "t": "(reg+2)/3 > cavalry ?",
             "side": ("yes", ["buy Cavalry ref.cavalry"]), "cont": "no"},
            {"k": "dec", "t": "reg/4 > artillery ?",
             "side": ("yes", ["buy Artillery ref.artillery"]), "cont": "no"},
            {"k": "dec", "t": "(reg+cav+art+5)/10 > ships ?",
             "side": ("yes", ["buy Man-O-War ref.man_o_war"]), "cont": "no"},
            {"k": "act", "t": "buy Regulars ref.regulars (default)",
             "s": ["inc at · fund −= 1800",
                   "post-declaration: announced as @KINGBUY instead"]},
            {"k": "end", "t": "army stays in ratio ~ 3:1 cav, 4:1 art, 10:1 naval"},
        ]))
    _after_h3(soup, "Spanish Succession merge", flow_fig(
        "The Succession merge", "spanish_succession() · event id 0x68",
        [
            {"k": "dec", "t": "revolution meter below 75 · no power has seceded yet · single-player ?",
             "side": ("no", ["meter ≥ 75 → the revolution",
                             "handlers fire instead"]),
             "cont": "yes (meter game.revolution_meter, REF id game.king_power; gate)"},
            {"k": "act", "t": "rank powers: 3·[+p] + 2·[+p] + [+p]",
             "s": [", sort — weakest AI cedes, strongest gains"]},
            {"k": "act", "t": "@SUCCESSION popup",
             "s": ['"…Treaty of Utrecht specifies that all {%STRING3} possessions…"']},
            {"k": "act", "t": "rewrite every owner", "s": [
                "map-tile owner nibbles",
                "unit owners · colony owners +0x1A",
                "third owner-nibble table"]},
            {"k": "end", "t": "ceding power eliminated — controller:=2"},
        ],
        "The enqueue gate for event 0x68 is an unresolved residual; the handler"
        "is also reachable from cheat @FORCED stage (a)."))


def enrich_movement(soup):
    _after_h3(soup, "short-range path-step finder", flow_fig(
        "One step's movement cost", "find_path_step() cost rules, in priority order",
        [
            {"k": "dec", "t": "unit's stored moves ≤ 3 ? (one-move unit,)",
             "side": ("yes", ["every step costs a flat 3"]),
             "cont": "no"},
            {"k": "dec", "t": "road/plow bits 0x0A at BOTH ends ?",
             "side": ("yes", ["cost = 1  (a third of a stored point ×3)"]),
             "cont": "no"},
            {"k": "dec", "t": "river bit 0x40, cardinal step ?",
             "side": ("yes", ["cost = 1"]), "cont": "no"},
            {"k": "act", "t": "cost = terrain Movement × 3",
             "s": ["byte[terrain·16 + ]·3",
                   "NAMES values: open land 1 · forests/Hills/Arctic 2 · Mountains 3 · water 1"]},
            {"k": "act", "t": "occupancy rules", "s": [
                "tile's power must be −1 or the mover; foreign/AI +8",
                "natives (type ≥ 19) reject rumor tiles",
                "ships (types 13..18): water = Ocean/Sea Lane only; mismatch only at endpoints"]},
            {"k": "end", "t": "16×16-window BFS · cache DS: · budget ×3"},
        ]))


def enrich_persistence(soup):
    _after_h3(soup, "music scheduler", flow_fig(
        "The background-music rotation", "rotate_music() — runs from the input-idle loops",
        [
            {"k": "dec", "t": "background music [0xA2] on (or one-shot [0x9E]) ?",
             "side": ("no", ["skip"]), "cont": "yes"},
            {"k": "dec", "t": "driver still playing ? (poll id 8)",
             "side": ("yes", ["wait"]), "cont": "no — pick next"},
            {"k": "dec", "t": "forced-next tune [0x94] set ?",
             "side": ("yes", ["honor it"]), "cont": "no"},
            {"k": "act", "t": "seed RNG from tick clock internal state, roll in the state window",
             "s": ["PEACE (game.flags&1 clear): folk 1–12, 1-in-9 excursion into 13–23",
                   "WAR OF INDEPENDENCE: tunes 13–18, 1-in-5 excursion back to folk",
                   "re-roll avoids repeating the current tune [0x96]"]},
            {"k": "act", "t": "event classes preempt via [0x9A]",
             "s": ["war fanfare, native themes 0x33/0x35/0x36, …; index→id map tune_id()"]},
            {"k": "end", "t": "play"},
        ]))
    # save-file layout ribbon (principal blocks of the 43; section 20.3 table)
    segs = [("magic", '"COLONIZE"+0x1A', 9, "text"),
            ("ver", "2B", 2, "pos"), ("w,h", "4B", 4, "pos"),
            ("globals", "0x5380 · 0x8E", 0x8E, "flag"),
            ("AIPers ×4", "0x540E · 0xD0", 0xD0, "num"),
            ("colonies", "0x5D46 · n·0xCA", 500, "econ"),
            ("units", "0x3144 · n·0x1C", 400, "arr"),
            ("powers ×4", "0x8808 · 0x4F0", 0x4F0, "num"),
            ("natives", "0x54EC · n·0x12", 300, "pos"),
            ("TribeData", "0x5AD6 · 0x270", 0x270, "pos"),
            ("word tables + view", "blocks 13..43", 120, "pad")]
    tw = sum(s[2] for s in segs)
    W, y0, bh = 660, 30, 34
    e = [f'<svg viewBox="0 0 {W} 96" xmlns="http://www.w3.org/2000/svg">']
    x = 2.0
    px = [max(46, s[2] / tw * 656) for s in segs]
    scale = 656 / sum(px)
    for (label, ext, _, cat), w in zip(segs, [p * scale for p in px]):
        dark, light = CAT[cat]
        e.append(f'<rect x="{x:.1f}" y="{y0}" width="{w:.1f}" height="{bh}" '
                 f'fill="{light}" stroke="{dark}" stroke-width="1.1"/>')
        size = 8.4 if len(label) * 4.6 < w else 6.4
        lx = min(max(x + w / 2, len(label) * size * 0.26 + 3),
                 W - len(label) * size * 0.26 - 3)
        e.append(svg_text(lx, y0 + bh / 2 + 3, label, size, fill=dark,
                          anchor="middle", weight="bold"))
        xt = min(max(x + w / 2, len(ext) * 2.2 + 4), W - len(ext) * 2.2 - 4)
        e.append(svg_text(xt, y0 - 6 - (10 if len(ext) > 12 and x > 60 else 0),
                          ext, 6.8, fill=MUTED, anchor="middle", face=MONO_FACE))
        x += w
    e.append("</svg>")
    fig = BeautifulSoup(
        f'<figure><div style="break-inside:avoid"><div class="platehead">'
        f'<span class="pt">COLONY&lt;slot&gt;.SAV — the save file</span>'
        f'<span class="ps">serializer func_0734F8 · 43 raw DGROUP blocks, no compression</span></div>'
        f'<div class="plate-wrap">{"".join(e)}</div>'
        f'<figcaption>Principal blocks shown; on-disk offset = sum of preceding '
        f'sizes; within a block the layout is the runtime struct (loader is a '
        f'1:1 mirror of 43 freads). Variable arrays scale with live counts.'
        f'</figcaption></div></figure>', "html.parser").figure
    _after_h3(soup, "The save file", fig)


def enrich_combat(soup):
    _after_h3(soup, "After the roll", flow_fig(
        "The loser's fate", "func_05B2C2 · 0x5B2C2..0x5BE2C",
        [
            {"k": "start", "t": "roll resolved — random_int(1, ATK+DEF) ≤ ATK ? (0x05D188)"},
            {"k": "dec", "t": "loser is a ship ?",
             "side": ("yes", ["raw roll random_int(1, guns+hull) (0x05B844)",
                              "@SHIPDAMAGE (0x05BC79) or @SHIPSUNK (0x05BD0F)",
                              "cargo bit 0x40 → 6-slot scatter loop (0x05BD28)"]),
             "cont": "no — land unit"},
            {"k": "dec", "t": "capture-eligible ? (Colonists / Treasure / Wagon, 0x5B31D)",
             "side": ("yes", ["European owner < 4 · ship winner needs room (0x5B410)",
                              "changes hands intact — set_unit_owner (0x5B4C7)",
                              "@LOOTCAPTURE / @WAGONCAPTURE / @COLONISTCAPTURE"]),
             "cont": "no"},
            {"k": "dec", "t": "demotion ladder has a rung ? (0x5B5AA..0x5B61F)",
             "side": ("yes", ["Dragoons→Soldiers→Colonists · Cavalry→Regulars",
                              "Cont.Cav→Cont.Army→Colonists · @DEMOTE (0x05B679)",
                              "Missionary profession → Missionaries unit (0x5B60E)"]),
             "cont": "no — destroyed"},
            {"k": "act", "t": "Artillery special: flip to Damaged (+0x04|=0x80, 0x05B6F6)",
             "s": ["display pair +2/−2 (0x069B39) · damaged loses again → @ARTILLERY2 (0x05B740)"]},
            {"k": "dec", "t": "winner promotes ? random_int(1,S) ≤ strength (0x5C764)",
             "side": ("Washington", ["FF 11 (0x5C758): roll skipped —",
                                     "promotion automatic"]),
             "cont": "S = atk+def ±difficulty − class penalty"},
            {"k": "end", "t": "@VETERAN / @VALOR · Soldier ceiling → Continental Army (0x5C7C3)"},
        ]))


def enrich_congress(soup):
    _after_h3(soup, "Crosses and immigration", flow_fig(
        "The immigration pipeline", "func_035D9A threshold · func_0363A2 arrival",
        [
            {"k": "act", "t": "threshold = f(empire size)",
             "s": ["accum = Σ colony pops + 1/unit (0x035DB0/0x035DD8)",
                   "×2 if < 4000, +8, clamp 4000 (0x035E35..0x035E44)",
                   "×(8−d)/8 human (0x035E5D) · England ×2/3 (0x035E75)"]},
            {"k": "dec", "t": "crosses +0x2E > threshold +0x30 ? (0x036404)",
             "side": ("no", ["keep accruing (accrual site itself",
                             "unidentified in repo — TBD)"]),
             "cont": "yes — @UNREST"},
            {"k": "act", "t": "pick dock slot random_int(0,2) (0x036462) — colonist emigrates",
             "s": ["dock pool = PowerRecord +0x02..+0x04"]},
            {"k": "dec", "t": "refill roll — 3-tier ladder, threshold (lvl+3)>>1",
             "side": ("Brewster", ["FF 0x14: criminal/servant results",
                                   "upgrade to Free Colonists (0x34C79)",
                                   "+ player may choose the emigrant (0x36437)"]),
             "cont": "rand(1,15)→Criminal · rand(1,10)→Servant · rand(1,8)→Free"},
            {"k": "end", "t": "every 4th turn: professional types from per-power counters"},
        ],
        "Harder difficulty raises the tier threshold — more criminals and "
        "servants. A larger empire raises the cross threshold — slower "
        "immigration."))


def enrich_scoring(soup):
    _after_h3(soup, "Scoring and the Hall of Fame", formula_fig(
        "The final score", "func_039EE2 components · func_03A9C0 scaler",
        ["score = (mult · Σ7 terms) / 100  >>  1",
         "mult = d+4 (+1 if d≥3) (+1 if d≥4)  =  4 / 5 / 6 / 8 / 10"],
        [("population", "+1 criminal/servant/convert · +2 Free Colonist · +4 specialist", "0x3A0BE..0x3A113"),
         ("fathers", "+5 per Founding Father", "0x03A2BE"),
         ("sentiment", "+ national SoL meter [0x53D0]", "0x03A561"),
         ("razes", "razed-settlement count × −(1+d)", "0x03A4B1..0x03A4C5"),
         ("gold", "+ treasury / 1000", "0x3A3F2"),
         ("bells", "+ bells/100, only after foreign intervention", "0x3A704..0x3A724"),
         ("revolution", "+ (1780 − declaration year)·2 if independence won", "0x3A5F5..0x3A609"),
         ("rank", "largest n with n²/3 < score, cap 23", "0x3AA41..0x3AA79")],
        "The retail manual's ×2.0/×1.5 revolution multiplier is byte-refuted — "
        "the bonus is additive."))


def enrich_raids(soup):
    _after_h3(soup, "Alarm, tension, and raids", flow_fig(
        "The raid dispatch", "native_raid_outcome_dispatch — func_05BE84",
        [
            {"k": "dec", "t": "random_int(1,12) − 1 [+(d−2) vs human] ≥ 3·K+1 ?",
             "side": ("no", ["no raid this pass (0x5BEFD/0x5BF1A/0x5BEE5)"]),
             "cont": "yes"},
            {"k": "act", "t": "outcome = random_int(1,4) (0x5BF35)",
             "s": ["downgraded while turn < 40·(2−d) (0x5BF44)",
                   "per-outcome availability gates (0x181F:0x9FC)"]},
            {"k": "dec", "t": "5-way dispatch (0x5C026)",
             "side": ("0", ["@RAIDNOTHING — raiding party",
                            "wiped out (0x5C637)"]),
             "cont": "1..4"},
            {"k": "act", "t": "1 @RAIDSTORES — goods stolen (0x5C3CC)",
             "s": ["settlement raid budget +0x08 and wealth +0x0A bumped (0x5C3E1/0x5C3E4)"]},
            {"k": "act", "t": "2 @RAIDWREAK · 3 @RAIDGOLD · 4 @RAIDBURN / @RAIDSHIP",
             "s": ["0x5C1DE · 0x5C5F7 · 0x5C50B / 0x5C57B — payloads beyond the messages unmapped (TBD)"]},
            {"k": "end", "t": "tension halved for France / Pocahontas on every positive delta"},
        ]))


def enrich_lcr(soup):
    fig = flow_fig(
        "The Lost City Rumor cascade", "func_061454 · 0x061454..0x061C9C",
        [
            {"k": "start", "t": "unit enters a rumor tile (procedural hash vs seed [0x190])"},
            {"k": "act", "t": "scout bonus s = 0..3",
             "s": ["+1 Scout type 5 (0x0614A6) · +1 Seasoned class 0x16 (0x0614BB)",
                   "+1 De Soto (FF 7) — also arms no-bad-luck (0x0614C6..0x0614E3)"]},
            {"k": "act", "t": "outcome n = max(floor, random_int(1,9)) (0x0614F6..0x06151A)",
             "s": ["anti-streak floor rises per reroll, cap 3 (0x061508..0x061514)",
                   "quality roll q = random_int(1,100) + s·10 (0x06151D)"]},
            {"k": "dec", "t": "bad outcome (5 or 8) ?",
             "side": ("escape", ["random_int(1, s+1) roll (0x061551)",
                                 "De Soto: reroll instead — bad luck",
                                 "never lands (0x061563/0x06158C)"]),
             "cont": "gates"},
            {"k": "act", "t": "special gates", "s": [
                "Fountain of Youth (1): forest terrain band + early-session only (0x061594)",
                "Cibola (2): Mountains/Hills/desert band; De Soto rescue 1-in-3 (0x0615E7..0x06162D)",
                "Cibola sub-band on q: ≤10 → 5 · ≥25 → 6 · else 8 (0x061646..0x061662)"]},
            {"k": "dec", "t": "outcome table",
             "side": ("rewards", ["ruins gold = 10·(3d8), ×(s+2)/2 scouted (0x061776)",
                                  "chief's gift = 2·(4d10) (0x0617C6)",
                                  "Cibola treasure = 100·(10·(s+2)+1d20) (0x06166A)",
                                  "burial: @BURIAL1 0 · @BURIAL2 10·(3d8) ·",
                                  "@BURIAL3 200·(1d8+2s+10) (0x0619F2..0x061A73)"]),
             "cont": "1 FoY: 8 immigrants · 5 vanish · 6 fizzle · 9 survivors"},
            {"k": "act", "t": "@SCREWED — desecrating a hostile tribe's grounds",
             "s": ["tension +100 vs the tribe (0x61B84) — instant war footing; the unit dies"]},
            {"k": "end", "t": "gold → treasury +0x2A (0x061C4C); treasure spawns type 0xA, value/100 in class byte"},
        ],
        "In-repo conflicts flagged: floor per-rumor vs per-call; the one-shot "
        "per-power bit glossed both FoY and burial; the pre-2026 weight table "
        "was fabricated and is refuted.")
    for h in soup.find_all("h3"):
        if "Lost City" in h.get_text() or "LOSTCITY" in h.get_text():
            h.insert_after(fig)
            return
    for p in soup.find_all("p"):
        if "LOSTCITY0" in p.get_text() or "Lost City rumour" in p.get_text():
            p.insert_after(fig)
            return
    warn("LCR anchor not found in section 23")


ENRICHERS = {"4": [enrich_palette], "5": [enrich_terrain],
             "8": [enrich_sol], "9": [enrich_market], "12": [enrich_units],
             "13": [enrich_movement], "14": [enrich_combat],
             "17": [enrich_congress],
             "18": [enrich_king, enrich_scoring],
             "19": [enrich_loot, enrich_raids],
             "20": [enrich_turnflow, enrich_persistence],
             "23": [enrich_events, enrich_lcr],
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
    formula_cards(soup)
    comment_blocks_to_prose(soup)
    structs_to_plates(soup, mech=key in MECH_SECTIONS)
    regions_to_wireframes(soup)
    highlight_code(soup)
    dress_tables(soup)
    for enricher in ENRICHERS.get(key, []):
        try:
            enricher(soup)
        except Exception as e:
            warn(f"enricher {enricher.__name__} failed in section {key}: {e}")
    if key not in MECH_SECTIONS:
        name_globals(soup)
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
    only = None
    if "--only" in sys.argv:
        only = set(sys.argv[sys.argv.index("--only") + 1].split(","))
    WORK.mkdir(exist_ok=True)
    print("== load + preprocess")
    about, body = load_source()
    raw_sections = split_sections(body)
    if only:
        raw_sections = [s for s in raw_sections if s[0] in only]
        print(f"   --only {sorted(only)} -> {len(raw_sections)} section(s)")
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
    out = OUTDIR / ("Viceroy_Technical_Reference.pdf" if not only else
                    "Viceroy_TR_sec" + "_".join(sorted(only)) + ".pdf")
    merge(WORK / "body2.pdf", WORK / "overlay.pdf", WORK / "cover.pdf",
          out, marks2, sections)
    print(f"   wrote {out} ({out.stat().st_size:,} bytes)")
    if WARNINGS:
        print(f"== {len(WARNINGS)} warnings (see stderr)")
    else:
        print("== no warnings")


if __name__ == "__main__":
    main()
