#!/usr/bin/env python3
"""slice_sprites.py -- break the decoded sprite STRIPS + the ICONS.SS atlas into individual,
identified sprites.

Grid strips (tools/extract_*.py output under data_extracted/tileset/): BUILDING (48 cells =
@BUILDING def_id, 0-based), TERRAIN (12), PHYS0 (154 overlays), UNITS (the 24 per-unit-type
crops packed from ICONS.SS). Each strip cell becomes one PNG under
data_extracted/sprites/<sheet>/<index>_<label>.png.

ICONS.SS (the full sheet, 131 frames): sliced straight from the committed contact sheet
docs/atlas/sprites/atlas_ICONS.png (928x546, black = transparency key): 16 columns at 58 px
pitch, row bands separated at SEPS, a "N/0xHH" label strip at the top of each band
(LABEL_SKIP clears it), sprite = the tight non-black bbox HALVED to native (the atlas draws at 2x;
native sizes vary: goods ~8x15, foot units ~6-8x14, ships 13-21 wide -- no uniform cell).
Frame identities are labeled ONLY where verified:
  - goods icons = frames 22..37 = 0x16 + good (spec/ui/colony_screen.md section 0.3: the EXE
    literal is good+0x17; the ssdec decode is off-by-one, png = EXE id - 1) -> @CARGO names;
  - hammer = 54, working colonist = 81 (colony_screen.md section 0.4);
  - unit icons per data_extracted/tileset/units.json (its "frames" map, @UNIT sprite col - 1);
  - US flag 123 and the face/head block ~113..117 are visually identified only -> "(unverified)";
  - everything else = literal "icon N (0xHH)" -- the authoritative catalog
    (notes/SPRITE_CATALOG.md) is absent from this repo; identities are NOT invented.
Also packs all 131 native-size frames into a horizontal strip data_extracted/tileset/icons.png
with per-frame rects in icons.json, so renderers can address any ICONS.SS frame by index.

Writes data_extracted/sprites/manifest.json covering everything. Run AFTER tools/build_sprites.py
(labels for BUILDING come from the catalog); re-run build_sprites.py afterwards to fold the 131
icon entries back into the catalog (it reads icons.json).

Run: python3 tools/slice_sprites.py   (needs Pillow; the decoded strips + atlas are committed)
"""
import json, os, re
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILESET = os.path.join(ROOT, "data_extracted", "tileset")
OUT = os.path.join(ROOT, "data_extracted", "sprites")

# atlas_ICONS.png geometry (measured; same family as the other contact sheets)
ICONS_ATLAS = os.path.join(ROOT, "docs", "atlas", "sprites", "atlas_ICONS.png")
ICONS_COLS = 16
ICONS_PITCH = 58
ICONS_SEPS = [24, 81, 139, 197, 255, 313, 371, 429, 487, 546]   # row-band tops, last = H
ICONS_LABEL_SKIP = 15    # the "N/0xHH" label strip at the top of each band
ICONS_COUNT = 131


def slug(s):
    return re.sub(r"[^a-z0-9]+", "_", str(s).lower()).strip("_") or "x"


def load(p):
    return json.load(open(os.path.join(ROOT, p)))


def phys0_label(i):
    for band, (lo, hi) in load("data_extracted/tileset/phys0.json")["bands"].items():
        if lo <= i <= hi:
            return f"{band} {i - lo}"
    return f"phys0 frame {i}"


def icons_labels():
    """Frame -> verified identity (see module docstring for citations); unknowns stay literal."""
    lab = {i: f"icon {i} (0x{i:02X})" for i in range(ICONS_COUNT)}
    # goods icons: frame = 0x16 + good (colony_screen.md 0.3), names from @CARGO
    cargo = load("data_extracted/tables/names_tables.json")["@CARGO"]["rows"]
    for good in range(16):
        lab[22 + good] = cargo[good]["name"]
    # unit icons: units.json maps UnitType -> ICONS frame (@UNIT sprite col - 1)
    u = load("data_extracted/tileset/units.json")
    for t, fr in enumerate(u["frames"]):
        if fr >= 0 and u["types"][t] != "(unused)":
            lab[fr] = u["types"][t]
    lab[54] = "Hammers (production)"        # colony_screen.md 0.4
    lab[81] = "Working colonist"            # colony_screen.md 0.4
    lab[123] = "US flag (unverified)"       # visual only
    for i in range(113, 118):
        lab[i] = f"face {i - 113} (unverified)"   # visual only (sentiment-head block)
    return lab


def slice_icons(manifest):
    """Slice all 131 ICONS.SS frames from the atlas at native size; pack a strip + rects."""
    img = Image.open(ICONS_ATLAS).convert("RGB")
    lab = icons_labels()
    d = os.path.join(OUT, "icons")
    os.makedirs(d, exist_ok=True)
    frames = []
    crops = []
    for fr in range(ICONS_COUNT):
        col, row = fr % ICONS_COLS, fr // ICONS_COLS
        x0 = col * ICONS_PITCH + 1
        x1 = col * ICONS_PITCH + ICONS_PITCH - 1
        y0 = ICONS_SEPS[row] + ICONS_LABEL_SKIP
        y1 = ICONS_SEPS[row + 1] - 1
        cell = img.crop((x0, y0, x1, y1))
        # black is the baked transparency key: alpha out near-black, then tight-bbox
        rgba = cell.convert("RGBA")
        px = rgba.load()
        for y in range(rgba.height):
            for x in range(rgba.width):
                r, g, b, _ = px[x, y]
                if r + g + b <= 24:
                    px[x, y] = (0, 0, 0, 0)
        bbox = rgba.getbbox()
        if bbox is None:                      # a genuinely blank frame
            sprite = Image.new("RGBA", (1, 1), (0, 0, 0, 0))
        else:
            # atlas_ICONS is a clean 2x pixel-double (parity blockiness 1.000
            # measured on frame 6 at bbox parity (0,0), 2026-07-04). A plain
            # PIL half-resize point-samples on the WRONG parity and mushes the
            # sprite; instead find the 2x-grid parity that maximizes 2x2-block
            # uniformity and take every second pixel from there.
            bx0, by0, bx1, by1 = bbox
            cpx = rgba.load()
            best, bdx, bdy = -1.0, 0, 0
            for dy in (0, 1):
                for dx in (0, 1):
                    ok = tot = 0
                    for y in range(by0 + dy, by1 - 1, 2):
                        for x in range(bx0 + dx, bx1 - 1, 2):
                            a = cpx[x, y]
                            tot += 3
                            ok += ((cpx[x + 1, y] == a) + (cpx[x, y + 1] == a)
                                   + (cpx[x + 1, y + 1] == a))
                    score = ok / tot if tot else 0.0
                    if score > best:
                        best, bdx, bdy = score, dx, dy
            nw = max(1, (bx1 - (bx0 + bdx) + 1) // 2)
            nh = max(1, (by1 - (by0 + bdy) + 1) // 2)
            sprite = Image.new("RGBA", (nw, nh), (0, 0, 0, 0))
            spx = sprite.load()
            for j in range(nh):
                for i in range(nw):
                    spx[i, j] = cpx[bx0 + bdx + 2 * i, by0 + bdy + 2 * j]
        label = lab[fr]
        fname = f"{fr:03d}_{slug(label)}.png"
        sprite.save(os.path.join(d, fname))
        manifest.append({"file": f"data_extracted/sprites/icons/{fname}",
                         "sheet": "ICONS", "index": fr, "label": label,
                         "w": sprite.width, "h": sprite.height, "blank": bbox is None})
        crops.append(sprite)
        frames.append({"frame": fr, "label": label, "w": sprite.width, "h": sprite.height})
    # pack the horizontal strip (native widths, top-aligned) + per-frame rects
    H = max(c.height for c in crops)
    W = sum(c.width for c in crops)
    strip = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    x = 0
    for f, c in zip(frames, crops):
        strip.paste(c, (x, 0))
        f["x"] = x
        x += c.width
    strip.save(os.path.join(TILESET, "icons.png"))
    json.dump({"_note": "all 131 ICONS.SS frames at native size, sliced from atlas_ICONS.png by "
                        "tools/slice_sprites.py; frame = ssdec/png index (= EXE sprite id - 1). "
                        "Labels only where verified (see slice_sprites.py docstring); unknowns "
                        "are literal 'icon N (0xHH)'. x/w/h = the frame's rect in icons.png.",
               "count": len(frames), "height": H, "frames": frames},
              open(os.path.join(TILESET, "icons.json"), "w"), indent=1)
    print(f"icons: sliced {len(frames)} ICONS.SS frames -> {d} + tileset/icons.png ({W}x{H})")


def sheets():
    """[(sheet_name, png_path, cell_w, cell_h, [labels])] for each uniform grid strip."""
    out = []
    # the 24 per-unit-type crops (32x32 cells packed from ICONS.SS by extract_unitset.py)
    u = load("data_extracted/tileset/units.json")
    out.append(("UNITS", "data_extracted/tileset/units.png", u["cell"], u["cell"], u["types"]))
    # BUILDING strip: cell N = @BUILDING def_id N (0-based; catalog labels match)
    b = load("data_extracted/tileset/buildings.json")
    cat = {s["frame"]: s["label"] for s in load("data_extracted/engine/sprites.json")["sprites"]
           if s.get("sheet") == "BUILDING" and "frame" in s}
    blabels = [cat.get(i, f"Building {i}") for i in range(b["count"])]
    out.append(("BUILDING", "data_extracted/tileset/buildings.png", b["cell_w"], b["cell_h"], blabels))
    # TERRAIN strip
    t = load("data_extracted/tileset/terrain16.json")
    out.append(("TERRAIN", "data_extracted/tileset/terrain16.png", t["tile"], t["tile"], t["names"]))
    # PHYS0 overlays
    p = load("data_extracted/tileset/phys0.json")
    out.append(("PHYS0", "data_extracted/tileset/phys0.png", p["frame"], p["frame"],
                [phys0_label(i) for i in range(p["count"])]))
    return out


def main():
    manifest = []
    for name, png, cw, ch, labels in sheets():
        img = Image.open(os.path.join(ROOT, png)).convert("RGBA")
        n = img.width // cw
        d = os.path.join(OUT, slug(name))
        os.makedirs(d, exist_ok=True)
        for i in range(n):
            label = labels[i] if i < len(labels) else f"{name} {i}"
            cell = img.crop((i * cw, 0, i * cw + cw, ch))
            bbox = cell.getbbox()
            blank = bbox is None
            fname = f"{i:03d}_{slug(label)}.png"
            cell.save(os.path.join(d, fname))
            manifest.append({"file": f"data_extracted/sprites/{slug(name)}/{fname}",
                             "sheet": name, "index": i, "label": label,
                             "w": cw, "h": ch, "blank": blank})
    slice_icons(manifest)
    os.makedirs(OUT, exist_ok=True)
    json.dump({"_note": "individual sprites sliced from the decoded strips + the ICONS.SS atlas "
                        "by tools/slice_sprites.py",
               "count": len(manifest), "sprites": manifest},
              open(os.path.join(OUT, "manifest.json"), "w"), indent=1)
    by = {}
    for m in manifest:
        by[m["sheet"]] = by.get(m["sheet"], 0) + 1
    print("sliced", len(manifest), "sprites:", by)
    print("->", os.path.join(OUT, "manifest.json"))


if __name__ == "__main__":
    main()
