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


def sheet_to_png(path, pal, zero_transparent=False):
    """One .SS -> a single-row atlas PNG + frame rects.

    `pal` overrides the sheet's embedded palette; pass None to keep it.

    The coast bands are drawn over a substituted ground and punch water through
    their index-0 holes, so those frames need index 0 treated as transparent
    (manual 6.7); every other sheet keeps 0 as black.
    """
    sh = ssdec.load_sheet(str(path))
    frames = sh["frames"]
    p = sh["pal"] if pal is None else pal
    pad = 1
    W = sum(f[2] + pad for f in frames) + pad
    H = max(f[3] for f in frames) + 2 * pad
    atlas = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    recs, x = [], pad
    for (hx, hy, w, h, pixels) in frames:
        img = Image.new("RGBA", (w, h))
        px = img.load()
        for j in range(h):
            for i in range(w):
                v = pixels[j * w + i]
                clear = (v == TRANSPARENT) or (zero_transparent and v == 0)
                px[i, j] = (0, 0, 0, 0) if clear else (
                    p[v * 3], p[v * 3 + 1], p[v * 3 + 2], 255)
        atlas.paste(img, (x, pad))
        recs.append({"x": x, "y": pad, "w": w, "h": h, "hx": hx, "hy": hy})
        x += w + pad
    return atlas, recs



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


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    pal_json = json.load(open(ROOT / "data_extracted/palette.json"))
    fallback = []
    for e in pal_json:
        fallback += [e["r"], e["g"], e["b"]]

    want_pik = ["OPENMENU", "NATIONS", "DIFFICUL", "WOODPANL", "WOODPAN2",
                "KINGLSS1", "KINGLSS2", "COLONY", "EUROPE"] + \
        [f"REPORT{i}" for i in range(1, 10)] + \
        [f"LEVN{i:04d}" for i in range(1, 11)]
    want_ss = ["TERRAIN", "PHYS0", "ICONS", "NAMEPLAT", "OPENTILE", "WOODTILE", "KING", "KING1",
               "ENGLND1", "FRANCE1", "SPAIN1", "DUTCH1",
               # Woodcut event plates: the frame, plus WDCUT01 (first landfall).
               "WOODFRAM", "WDCUT01", "WDCUT02", "WDCUT10", "BUILDING",
               # Advisor portraits: speaker channel [0x1F5E] 0..5.
               "MSS0", "MSS1", "MSS2", "MSS3", "MSS4", "MSS5"] + \
              [f"IND{t}A{a}" for t in range(8) for a in range(4)]
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
            img.save(OUT / f"{nm}.png")
            _, _, _, own = load_pik(raw)
            pal = list(own) if own is not None else list(fallback)
            bundle["backgrounds"][nm] = {
                "w": img.width, "h": img.height,
                "pal": [[pal[i * 3], pal[i * 3 + 1], pal[i * 3 + 2]]
                        for i in range(256)],
            }
            print(f"  {nm}.PIK -> {img.width}x{img.height}")
        for nm in want_ss:
            key = nm + ".SS"
            if key not in names:
                print("  MISSING", key); continue
            p = tmp / key
            p.write_bytes(z.read(names[key]))
            override = fallback if nm in MASTER_PALETTE_SHEETS else None
            atlas, recs = sheet_to_png(p, override)
            atlas.save(OUT / f"{nm}.png")
            bundle["sheets"][nm] = {"atlas": f"{nm}.png", "frames": recs}
            # Text drawn *over* a sheet resolves through that sheet's palette,
            # so the woodcut screen -- whose FONT-NP caption ink is quoted as
            # palette indices 0x5C/0x5D/0x5E -- needs the table exported. (Both
            # of these keep their embedded palette; see MASTER_PALETTE_SHEETS
            # for the one sheet that does not.)
            if nm in ("WOODFRAM", "WOODTILE"):
                sp = ssdec.load_sheet(str(p))["pal"]
                bundle["sheets"][nm]["pal"] = [[sp[i * 3], sp[i * 3 + 1], sp[i * 3 + 2]]
                                               for i in range(256)]
            print(f"  {nm}.SS -> {len(recs)} frames, atlas {atlas.width}x{atlas.height}")
            if nm == "PHYS0":
                a2, r2 = sheet_to_png(p, override, zero_transparent=True)
                a2.save(OUT / "PHYS0C.png")
                bundle["sheets"]["PHYS0C"] = {"atlas": "PHYS0C.png", "frames": r2}
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
    json.dump(bundle, open(OUT / "manifest.json", "w"), indent=1)
    print("wrote", OUT / "manifest.json")


if __name__ == "__main__":
    main()
