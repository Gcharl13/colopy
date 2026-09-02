#!/usr/bin/env python3
"""Decode the original assets into a web-ready bundle.

Reads the user's local col.zip (never committed) and emits PNGs + JSON into
port/assets/. Format handling reuses the byte-verified codec in tools/ssdec.py
(MADSPACK/FAB); the .PIK layout follows viceroy_cpp/src/pik.cpp:
  section 0 -> h,w (u16le); pixel section = the one sized w*h;
  palette = last section >= 768 bytes, 6-bit (v8 = (v6<<2)|(v6>>4)).
"""
import base64, io, json, sys, zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
import ssdec  # noqa: E402
from PIL import Image  # noqa: E402

OUT = ROOT / "port" / "assets"
TRANSPARENT = 0xFD


def u16(b, o):
    return b[o] | (b[o + 1] << 8)


def load_pik(data):
    secs = [d for _, d in ssdec.madspack_load(data)]
    h, w = u16(secs[0], 0), u16(secs[0], 2)
    npx = w * h
    pix = next(i for i in range(1, len(secs)) if len(secs[i]) == npx)
    pal = None
    for i in range(len(secs)):
        if i != pix and len(secs[i]) >= 768:
            pal = secs[i]
    rgb = None
    if pal is not None:
        rgb = bytes(((v << 2) | (v >> 4)) & 0xFF for v in pal[:768])
    return w, h, secs[pix], rgb


def pik_to_png(data, fallback_pal):
    w, h, idx, pal = load_pik(data)
    im = Image.frombytes("P", (w, h), bytes(idx))
    im.putpalette(list(pal if pal is not None else fallback_pal))
    return im.convert("RGB")


# Sheets whose pixels resolve through the MASTER VICEROY.PAL rather than the
# palette embedded in the .SS. In DOS the VGA palette is global -- a sheet's
# embedded copy is only what happened to be loaded when the artist saved it --
# so the right palette is the one the *screen* streams. TERRAIN is measured, not
# assumed: its embedded palette disagrees with the master on 12 entries, of
# which only 121-126 (the sea-lane sparkle band, manual 29.4/part7) are used by
# any frame, and the live map capture picks the master. Rendering TERRAIN frame
# 11 (Sea Lane) against docs/screens/06_ingame_map.png tile (8,6):
#     sheet palette  50/256 pixels wrong
#     master palette   3/256   -- and those three are the capture's own
#                                 near-duplicate blue, so this is exact.
# Every other sheet either differs from the master on no *used* index (PHYS0,
# ICONS, WOODTILE: 0 pixels) or is a screen-specific palette that must stay
# (WOODFRAM/KING1/the flags/WDCUT: ~100% of pixels).
MASTER_PALETTE_SHEETS = {"TERRAIN"}

# ---- VGA colour cycling (CYCLE.DAT) -------------------------------------
# CYCLE.DAT is `{u16 count; struct {u8 len, phase, start, delay;} band[8];}`.
# The shipped file is count=1, band[0] = {len 8, start 120, delay 35} -- bands
# 1..7 are uninitialised authoring-tool bytes (which is why the tail reads as
# stray x86). cycle_colors (VICEROY file 0x0C51A) rotates the band one step
# toward HIGHER indices, wrapping the last colour into the first, every `delay`
# ticks of the engine's 60.8766 Hz timer. See notes/rulings/RULINGS.md
# 2026-08-05 and docs/PALETTE_AND_CYCLING.md.
CYCLE = {"start": 120, "len": 8, "delay": 35, "hz": 1193182.0 / 1960 / 2 / 5}

# The band rotates in the DAC, so it animates whatever is on screen. These are
# the sheets the map view composites, and all three carry master-palette colours
# in 120..127 (TERRAIN via MASTER_PALETTE_SHEETS; PHYS0 and ICONS because their
# embedded palettes agree with the master across the whole band -- measured, 0
# differing entries). Between them they cover exactly the water: TERRAIN frames
# 7/11 (Ocean, Sea Lane), PHYS0 frames 1..31 (rivers) and 150..153 (clean coast
# edges), ICONS frame 123.
CYCLED_SHEETS = {"TERRAIN", "PHYS0", "PHYS0C", "ICONS"}


def sheet_to_png(path, pal, zero_transparent=False):
    """One .SS -> a single-row atlas PNG + frame rects + a cycle mask.

    `pal` overrides the sheet's embedded palette; pass None to keep it.

    The coast bands are drawn over a substituted ground and punch water through
    their index-0 holes, so those frames need index 0 treated as transparent
    (manual 6.7); every other sheet keeps 0 as black.

    The mask is a same-geometry RGBA image carrying the source palette index in
    R (opaque) wherever a pixel falls in the cycled band, transparent elsewhere;
    it is None when the sheet has no band pixels at all.
    """
    sh = ssdec.load_sheet(str(path))
    frames = sh["frames"]
    p = sh["pal"] if pal is None else pal
    lo, hi = CYCLE["start"], CYCLE["start"] + CYCLE["len"] - 1
    pad = 1
    W = sum(f[2] + pad for f in frames) + pad
    H = max(f[3] for f in frames) + 2 * pad
    atlas = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    mask = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    banded = False
    recs, x = [], pad
    for (hx, hy, w, h, pixels) in frames:
        img = Image.new("RGBA", (w, h))
        msk = Image.new("RGBA", (w, h))
        px, mx = img.load(), msk.load()
        for j in range(h):
            for i in range(w):
                v = pixels[j * w + i]
                clear = (v == TRANSPARENT) or (zero_transparent and v == 0)
                px[i, j] = (0, 0, 0, 0) if clear else (
                    p[v * 3], p[v * 3 + 1], p[v * 3 + 2], 255)
                if not clear and lo <= v <= hi:
                    mx[i, j] = (v, 0, 0, 255)
                    banded = True
        atlas.paste(img, (x, pad))
        mask.paste(msk, (x, pad))
        recs.append({"x": x, "y": pad, "w": w, "h": h, "hx": hx, "hy": hy})
        x += w + pad
    return atlas, recs, (mask if banded else None)



def load_font(data):
    """.FF -> (cell_height, glyphs). Per data_extracted/fonts/ff_metrics.json:
    glyph slot t holds ASCII char t+1; widths at payload[2..130); u16le offset
    table at payload[130..386); bitmap is 2bpp MSB-first, level 0 transparent."""
    secs = [d for _, d in ssdec.madspack_load(data)]
    p = secs[0]
    H = p[0]
    glyphs = {}
    for t in range(127):
        ch = t + 1
        w = p[2 + t]
        o0 = u16(p, 130 + 2 * t)
        o1 = u16(p, 130 + 2 * (t + 1))
        rows = []
        if w > 0 and o1 > o0 and o1 <= len(p):
            rb = (w * 2 + 7) // 8
            for r in range(H):
                base = o0 + r * rb
                row = []
                for x in range(w):
                    byte = p[base + x // 4] if base + x // 4 < len(p) else 0
                    row.append((byte >> ((3 - (x % 4)) * 2)) & 3)
                rows.append(row)
        glyphs[ch] = {"w": w, "rows": rows}
    return H, glyphs


def font_to_atlas(data):
    """One atlas per 2bpp ink level.

    The engine maps levels 1..3 through a 3-entry palette LUT (level 0 is
    transparent) -- e.g. the pickers use level1=254 / level2=253 / level3=0,
    so level 1 is the MAIN ink and level 3 the dark core. Encoding the level
    as alpha would invert that, so each level gets its own white mask and the
    renderer tints and stacks them.
    """
    H, glyphs = load_font(data)
    order = [c for c in range(32, 127) if glyphs.get(c, {}).get("w", 0) > 0]
    pad = 1
    W = sum(glyphs[c]["w"] + pad for c in order) + pad
    layers = {lvl: Image.new("RGBA", (max(W, 1), H + 2 * pad), (0, 0, 0, 0))
              for lvl in (1, 2, 3)}
    px = {lvl: layers[lvl].load() for lvl in layers}
    meta, x = {}, pad
    for c in order:
        g = glyphs[c]
        for r, row in enumerate(g["rows"]):
            for i, v in enumerate(row):
                if v:
                    px[v][x + i, pad + r] = (255, 255, 255, 255)
        meta[c] = {"x": x, "w": g["w"]}
        x += g["w"] + pad
    widths = {c: glyphs[c]["w"] for c in glyphs if glyphs[c]["w"] > 0}
    return layers, {"h": H, "y": pad, "glyphs": meta, "widths": widths}


def data_uri(img, fmt="PNG"):
    buf = io.BytesIO()
    img.save(buf, format=fmt, optimize=True)
    return "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode()


# Part E (docs/REMAINING_WORK.md) -- the screens' own assets, each with a
# byte-cited consumer in VICEROY.EXE (tools/gen_sd_pack.py PART_E block
# carries the same list and the per-board pak gate):
#   CC-00..24 + CCBKGD   the Continental Congress portrait page,
#                        func_03BB4A @0x03BB4A / func_03BAA6 @0x03BAA6
#   DEC-UPPA..Z / DEC-LOWA..Z / DEC-SQIG + DECOIND   the Declaration signing,
#                        func_03DA2A @0x03DA2A (DECLARAT.PIK is an orphan)
DEC_SS = [f"DEC-UPP{c}" for c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"] + \
    [f"DEC-LOW{c}" for c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"] + ["DEC-SQIG"]
#   SCORE01..24          the end-game score plate, func_03A9C0 @0x03A9C0
#                        (over WOODPAN2.PIK, already packed, drawn through
#                        the PLATE's palette -- @0x3AB46..0x3AB84)
SCORE_SS = [f"SCORE{i:02d}" for i in range(1, 25)]
PART_E_SS = [f"CC-{i:02d}" for i in range(25)] + DEC_SS + SCORE_SS
PART_E_PIK = ["CCBKGD", "DECOIND"]
# Sheets whose pixels the running game resolves through a PIK's palette,
# not their own embedded copy (the same VGA-is-global rule as
# MASTER_PALETTE_SHEETS): the portrait page uploads CCBKGD's table
# (func_03BB4A @0x3BB87) and blits the CC sheets through it.  Backgrounds
# in BAKE_MERGED_PIK are themselves baked through the table the screen
# streams -- the PIK's palette AFTER the game.js usePalette merge (magenta
# placeholders from the master, then OPENMENU; an unauthored EGA-stub
# low-16 row from the master), which is exactly rd_use_palette's DAC.
# CCBKGD's low-16 IS the EGA stub and its art uses indices 5 and 12.
SHEET_PALETTE_FROM_PIK = {f"CC-{i:02d}": "CCBKGD" for i in range(25)}
# the DEC sheets blit over DECOIND's DAC (func_03DA2A @0x3DA6A); their own
# tables differ from it only at 252..255, which the art never uses
SHEET_PALETTE_FROM_PIK.update({n: "DECOIND" for n in DEC_SS})
BAKE_MERGED_PIK = {"CCBKGD", "DECOIND"}
EGA_STUB = [0, 0, 0, 0, 0, 170, 0, 170, 0, 0, 170, 170, 170, 0, 0, 170, 0, 170,
            170, 85, 0, 170, 170, 170, 85, 85, 85, 85, 85, 255, 85, 255, 85,
            85, 255, 255, 255, 85, 85, 255, 85, 255, 255, 255, 85, 255, 255, 255]


def is_placeholder(c):
    return c[0] > 240 and c[1] < 110 and c[2] > 240


def merged_palette(pal, master, ui):
    """game.js usePalette (line 36) over three flat 768-entry tables."""
    out = list(pal)
    for i in range(256):
        c = pal[i * 3:i * 3 + 3]
        if not is_placeholder(c):
            continue
        m = master[i * 3:i * 3 + 3]
        src = m if not is_placeholder(m) else ui[i * 3:i * 3 + 3]
        out[i * 3:i * 3 + 3] = src
    if list(pal[:48]) == EGA_STUB:
        out[:48] = master[:48]
    return out
# Backgrounds a screen draws through a palette that is NOT the PIK's own
# (the way the C port always does: indices through the current DAC).  The
# JS gets the raw index plane for these so it can re-table at runtime:
# WOODPAN2 shows through whichever SCORE plate's palette the score screen
# uploads (24 distinct tables, func_03A9C0 @0x3AB46..0x3AB84).
INDEX_PLANE_PIK = ["WOODPAN2"]
# Sheets whose embedded palette the JS renderer must be able to ADOPT
# (usePalette on a sheet name): the woodcut frame, the map chrome, and the
# 24 score plates (each is the DAC for its own screen).
EXPORT_SHEET_PAL = {"WOODFRAM", "WOODTILE"} | set(SCORE_SS)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    pal_json = json.load(open(ROOT / "data_extracted/palette.json"))
    fallback = []
    for e in pal_json:
        fallback += [e["r"], e["g"], e["b"]]

    want_pik = ["OPENMENU", "NATIONS", "DIFFICUL", "WOODPANL", "WOODPAN2",
                "KINGLSS1", "KINGLSS2", "COLONY", "EUROPE"] + \
        [f"REPORT{i}" for i in range(1, 10)] + \
        [f"LEVN{i:04d}" for i in range(1, 11)] + \
        PART_E_PIK
    want_ss = ["TERRAIN", "PHYS0", "ICONS", "NAMEPLAT", "OPENTILE", "WOODTILE", "KING", "KING1",
               "ENGLND1", "FRANCE1", "SPAIN1", "DUTCH1",
               # Woodcut event plates: the frame plus every plate with a live
               # byte-cited caller (spec/ui/woodcuts_and_intro.md §1) --
               # 01 landfall, 02 first colony, 03/04/05 tribe first contact,
               # 07 first village, 08 fountain of youth, 09 first cargo home,
               # 10 meeting Europeans, 11 colony burning, 13 indian raid.
               # 00/06/12/14-16 are caller-less and stay out.
               "WOODFRAM", "WDCUT01", "WDCUT02", "WDCUT03", "WDCUT04",
               "WDCUT05", "WDCUT07", "WDCUT08", "WDCUT09", "WDCUT10",
               "WDCUT11", "WDCUT13", "BUILDING",
               # Advisor portraits: speaker channel [0x1F5E] 0..5; MYR0..3 are
               # the missionary/conversation channel [0x1F60] (the European
               # meeting-flow portraits).
               "MSS0", "MSS1", "MSS2", "MSS3", "MSS4", "MSS5",
               "MYR0", "MYR1", "MYR2", "MYR3"] + \
              [f"IND{t}A{a}" for t in range(8) for a in range(4)] + \
              PART_E_SS
    want_ff = ["FONTINTR", "FONTKING", "FONT-NP", "FONTTINY", "FONTSMAL"]

    tmp = OUT / "_tmp"
    tmp.mkdir(exist_ok=True)
    bundle = {"backgrounds": {}, "sheets": {}}
    with zipfile.ZipFile(ROOT / "col.zip") as z:
        names = {n.split("/")[-1].upper(): n for n in z.namelist()
                 if not n.startswith("__MACOSX")}
        for nm in want_pik:
            key = nm + ".PIK"
            if key not in names:
                print("  MISSING", key); continue
            raw = z.read(names[key])
            img = pik_to_png(raw, fallback)
            _, _, _, own = load_pik(raw)
            pal = list(own) if own is not None else list(fallback)
            if nm in BAKE_MERGED_PIK:
                uip = bundle["backgrounds"]["OPENMENU"]["pal"]
                merged = merged_palette(pal, fallback,
                                        [c for rgb in uip for c in rgb])
                w0, h0, idx0, _ = load_pik(raw)
                im2 = Image.frombytes("P", (w0, h0), bytes(idx0))
                im2.putpalette(merged)
                img = im2.convert("RGB")
            img.save(OUT / f"{nm}.png")
            bundle["backgrounds"][nm] = {
                "w": img.width, "h": img.height,
                "pal": [[pal[i * 3], pal[i * 3 + 1], pal[i * 3 + 2]]
                        for i in range(256)],
            }
            if nm in INDEX_PLANE_PIK:
                _, _, idx, _ = load_pik(raw)
                bundle["backgrounds"][nm]["idx"] = \
                    base64.b64encode(bytes(idx)).decode()
            print(f"  {nm}.PIK -> {img.width}x{img.height}")
        for nm in want_ss:
            key = nm + ".SS"
            if key not in names:
                print("  MISSING", key); continue
            p = tmp / key
            p.write_bytes(z.read(names[key]))
            override = fallback if nm in MASTER_PALETTE_SHEETS else None
            if nm in SHEET_PALETTE_FROM_PIK:
                bgp = bundle["backgrounds"][SHEET_PALETTE_FROM_PIK[nm]]["pal"]
                uip = bundle["backgrounds"]["OPENMENU"]["pal"]
                override = merged_palette([c for rgb in bgp for c in rgb],
                                          fallback,
                                          [c for rgb in uip for c in rgb])
            atlas, recs, mask = sheet_to_png(p, override)
            atlas.save(OUT / f"{nm}.png")
            bundle["sheets"][nm] = {"atlas": f"{nm}.png", "frames": recs}
            if mask is not None and nm in CYCLED_SHEETS:
                mask.save(OUT / f"{nm}.cycle.png")
                bundle["sheets"][nm]["cycle"] = f"{nm}.cycle.png"
                print(f"  {nm}.SS -> cycle mask (band "
                      f"{CYCLE['start']}..{CYCLE['start'] + CYCLE['len'] - 1})")
            # Text drawn *over* a sheet resolves through that sheet's palette,
            # so the woodcut screen -- whose FONT-NP caption ink is quoted as
            # palette indices 0x5C/0x5D/0x5E -- needs the table exported. (Both
            # of these keep their embedded palette; see MASTER_PALETTE_SHEETS
            # for the one sheet that does not.)
            if nm in EXPORT_SHEET_PAL:
                sp = ssdec.load_sheet(str(p))["pal"]
                bundle["sheets"][nm]["pal"] = [[sp[i * 3], sp[i * 3 + 1], sp[i * 3 + 2]]
                                               for i in range(256)]
            print(f"  {nm}.SS -> {len(recs)} frames, atlas {atlas.width}x{atlas.height}")
            if nm == "PHYS0":
                a2, r2, m2 = sheet_to_png(p, override, zero_transparent=True)
                a2.save(OUT / "PHYS0C.png")
                bundle["sheets"]["PHYS0C"] = {"atlas": "PHYS0C.png", "frames": r2}
                if m2 is not None:
                    m2.save(OUT / "PHYS0C.cycle.png")
                    bundle["sheets"]["PHYS0C"]["cycle"] = "PHYS0C.cycle.png"
                print("  PHYS0.SS -> PHYS0C (index-0 transparent, coast bands)")
        bundle["fonts"] = {}
        for nm in want_ff:
            key = nm + ".FF"
            if key not in names:
                print("  MISSING", key); continue
            layers, meta = font_to_atlas(z.read(names[key]))
            for lvl, img in layers.items():
                img.save(OUT / f"FONT_{nm}_L{lvl}.png")
            bundle["fonts"][nm] = meta
            print(f"  {nm}.FF -> h={meta['h']}, {len(meta['glyphs'])} glyphs, 3 levels")
    bundle["cycle"] = CYCLE
    json.dump(bundle, open(OUT / "manifest.json", "w"), indent=1)
    print("wrote", OUT / "manifest.json")


if __name__ == "__main__":
    main()
