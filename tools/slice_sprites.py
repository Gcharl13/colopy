#!/usr/bin/env python3
"""slice_sprites.py -- break the decoded sprite STRIPS into individual, identified sprites.

The atlas decode (tools/sprite_atlas.py) produces horizontal cell strips per sheet
(data_extracted/tileset/{units,buildings,terrain16,phys0}.png). This tool cuts each strip
into one PNG per cell under data_extracted/sprites/<sheet>/<index>_<label>.png and writes a
manifest (data_extracted/sprites/manifest.json) so every sprite can be identified by label --
particularly the ICONS units. Portraits/woodcuts/backgrounds are already one-file-per-sprite.

Run: python3 tools/slice_sprites.py   (needs Pillow; the decoded strips are committed)
"""
import json, os, re
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILESET = os.path.join(ROOT, "data_extracted", "tileset")
OUT = os.path.join(ROOT, "data_extracted", "sprites")


def slug(s):
    return re.sub(r"[^a-z0-9]+", "_", str(s).lower()).strip("_") or "x"


def load(p):
    return json.load(open(os.path.join(ROOT, p)))


def phys0_label(i):
    for band, (lo, hi) in load("data_extracted/tileset/phys0.json")["bands"].items():
        if lo <= i <= hi:
            return f"{band} {i - lo}"
    return f"phys0 frame {i}"


def sheets():
    """Return [(sheet_name, png_path, cell_w, cell_h, [labels])] for each grid strip."""
    out = []
    # ICONS units strip
    u = load("data_extracted/tileset/units.json")
    out.append(("ICONS", "data_extracted/tileset/units.png", u["cell"], u["cell"], u["types"]))
    # BUILDING strip
    b = load("data_extracted/tileset/buildings.json")
    # label buildings from the sprite catalog where we have a name, else "Building N"
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
            # skip the fully-transparent/blank placeholder cells
            bbox = cell.getbbox()
            blank = bbox is None
            fname = f"{i:03d}_{slug(label)}.png"
            cell.save(os.path.join(d, fname))
            manifest.append({"file": f"data_extracted/sprites/{slug(name)}/{fname}",
                             "sheet": name, "index": i, "label": label,
                             "w": cw, "h": ch, "blank": blank})
    os.makedirs(OUT, exist_ok=True)
    json.dump({"_note": "individual sprites sliced from the decoded strips by tools/slice_sprites.py",
               "count": len(manifest), "sprites": manifest},
              open(os.path.join(OUT, "manifest.json"), "w"), indent=1)
    by = {}
    for m in manifest:
        by[m["sheet"]] = by.get(m["sheet"], 0) + 1
    print("sliced", len(manifest), "sprites:", by)
    print("->", os.path.join(OUT, "manifest.json"))


if __name__ == "__main__":
    main()
