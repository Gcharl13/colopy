#!/usr/bin/env python3
"""Sprite extraction for the manual PDF.

Decodes the shipped MADSPACK sheets (from col.zip) with the byte-verified
tools/ssdec.py codec and serves frames as data-URI PNGs for embedding.
Every frame->id mapping used here is the one documented in the manual:
  TERRAIN.SS  frame = ground id                  (Appendix B.1)
  PHYS0.SS    overlay bands                      (Appendix B.2)
  ICONS.SS    goods = disk 22+g (@CARGO order),  (Appendix B.3, section 9.2)
              units = @UNIT icon column - 1      (section 12.2)
  BUILDING.SS disk frame = building def id       (Appendix B.4)
"""
import base64
import io
import sys
import zipfile
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
import ssdec  # noqa: E402

WORK = Path(__file__).resolve().parent / "_work" / "assets"
TRANSPARENT = 0xFD

_sheets = {}


def sheet(name):
    if name not in _sheets:
        WORK.mkdir(parents=True, exist_ok=True)
        path = WORK / name
        if not path.exists():
            with zipfile.ZipFile(ROOT / "col.zip") as z:
                path.write_bytes(z.read(name))
        _sheets[name] = ssdec.load_sheet(str(path))
    return _sheets[name]


def frame_image(sheet_name, disk_idx):
    """One frame as RGBA (index 0xFD transparent), native resolution."""
    sh = sheet(sheet_name)
    x, y, w, h, pix = sh["frames"][disk_idx]
    pal = sh["pal"]
    img = Image.new("RGBA", (w, h))
    px = img.load()
    for j in range(h):
        for i in range(w):
            v = pix[j * w + i]
            if v == TRANSPARENT:
                px[i, j] = (0, 0, 0, 0)
            else:
                px[i, j] = (pal[v * 3], pal[v * 3 + 1], pal[v * 3 + 2], 255)
    return img


def composite(base, *overlays):
    out = base.copy()
    for ov in overlays:
        out.alpha_composite(ov)
    return out


def data_uri(img, scale=3):
    if scale != 1:
        img = img.resize((img.width * scale, img.height * scale),
                         Image.NEAREST)
    buf = io.BytesIO()
    img.save(buf, format="PNG", optimize=True)
    return "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode()


def img_tag(uri, native_w, native_h, scale=2.0, cls="sprite", title=""):
    """Render at `scale` CSS-px per game px (crisp via pixelated)."""
    t = f' title="{title}"' if title else ""
    return (f'<img class="{cls}" src="{uri}" width="{native_w * scale:.0f}" '
            f'height="{native_h * scale:.0f}"{t} alt=""/>')


# ---- documented id -> frame mappings -------------------------------------

# Appendix B.1: TERRAIN.SS frame = ground id; fold per 0x6204 / _tile_id:
# bases 0..7 direct; forested 8..15 -> base & 7 EXCEPT forested Desert -> 8
# (scrub floor); Arctic 9, Ocean 10, Sea Lane 11.
def ground_frame(tid):
    tid &= 0x1F
    if 16 <= tid <= 23:
        tid = (tid & 7) | 8
    if tid <= 7:
        return tid
    if 8 <= tid <= 15:
        return 8 if tid == 9 else tid & 7
    return {24: 9, 25: 10, 26: 11}.get(tid)


PHYS_FOREST_ISOLATED = 64    # B.2: forest band 64-79, adjacency mask 0 = disk 64
PHYS_MOUNTAIN_ISOLATED = 32  # B.2: mountains band 32-47
PHYS_HILL_ISOLATED = 48      # B.2: hills band 48-63


def terrain_tile(tid):
    """Composited tile per the section-6 compositor: ground under overlay.
    Forested variants get the isolated (adjacency-mask 0) forest frame;
    Mountains/Hills (pseudo-ids 27/28) are shown as their isolated PHYS0
    overlay alone -- they have no ground of their own."""
    if tid in (27, 28):
        d = PHYS_MOUNTAIN_ISOLATED if tid == 27 else PHYS_HILL_ISOLATED
        return frame_image("PHYS0.SS", d)
    g = ground_frame(tid)
    if g is None:
        return None
    base = frame_image("TERRAIN.SS", g)
    t = tid & 0x1F
    if 16 <= t <= 23:
        t = (t & 7) | 8
    if 8 <= t <= 15:
        return composite(base, frame_image("PHYS0.SS", PHYS_FOREST_ISOLATED))
    return base


GOODS = ["Food", "Sugar", "Tobacco", "Cotton", "Furs", "Lumber", "Ore",
         "Silver", "Horses", "Rum", "Cigars", "Cloth", "Coats",
         "Trade Goods", "Tools", "Muskets"]  # NAMES @CARGO order, section 9.2
POWERS = ["England", "France", "Spain", "Netherlands"]  # NAMES @COUNTRY order


def goods_icon(good):
    """ICONS engine frame good+0x17 => disk 22+good (B.3 / section 9.2)."""
    return frame_image("ICONS.SS", 22 + good)


def unit_icon(engine_frame):
    """@UNIT icon column is engine numbering; disk = engine - 1 (section 29.1)."""
    return frame_image("ICONS.SS", engine_frame - 1)


def building_sprite(def_id):
    """BUILDING.SS disk frame = def id (B.4)."""
    return frame_image("BUILDING.SS", def_id)
