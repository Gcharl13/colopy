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


# ICONS.SS disk-frame labels (byte-cited or pixel-verified; '*' = pixel-label only,
# unlisted frames are unidentified — see the v7 sprite fact-pack)
ICONS_LABELS = {0: 'colony marker', 1: 'colony marker', 2: 'colony marker', 3: 'colony marker', 4: '(1×1)', 5: 'Caravel', 6: 'Merchantman', 7: 'Galleon', 8: 'Wagon Train', 9: 'Artillery', 14: 'Privateer', 15: 'Frigate', 16: 'Treasure', 17: 'capital star *', 18: 'cursor', 19: 'cursor', 20: 'cursor', 21: 'cursor', 38: 'full cargo stack', 54: 'Hammers', 55: 'red X (empty)', 56: 'Cross (filled)', 57: 'Fish', 58: 'pioneer, no tools *', 59: 'soldier, no muskets *', 60: 'scout, no horses *', 62: 'Liberty Bell', 63: 'placeholder', 64: 'placeholder', 65: 'damaged artillery', 66: 'Indian Convert', 67: 'flag plaque', 68: 'flag plaque', 69: 'flag plaque', 73: 'colonist + tools *', 74: 'colonist + muskets *', 75: 'colonist + horses *', 76: 'missionary *', 81: 'Farmer', 82: 'Sugar Planter', 83: 'Tobacco Planter', 84: 'Cotton Planter', 85: 'Fur Trapper', 86: 'Lumberjack', 87: 'Ore Miner', 88: 'Silver Miner', 89: 'Fisherman', 90: 'Distiller', 91: 'Tobacconist', 92: 'Weaver', 93: 'Fur Trader', 94: 'Carpenter', 95: 'Blacksmith', 96: 'Gunsmith', 97: 'Preacher', 98: 'Statesman', 99: 'Teacher', 100: 'Free Colonist', 101: 'Hardy Pioneer', 102: 'Veteran Soldier', 103: 'Seasoned Scout', 104: 'Veteran Dragoon', 105: 'Jesuit Missionary', 106: 'Indentured Servant', 107: 'Petty Criminal', 108: 'unit-on-tile marker', 109: 'Brave', 110: 'Armed Brave', 111: 'Mounted Brave', 112: 'Mounted Warrior', 118: 'pennant', 119: 'pennant', 120: 'pennant', 121: 'pennant', 122: 'cargo crate', 123: 'rebel flag', 124: 'Tory crown', 125: 'REF Regular', 126: 'REF Cavalry', 127: 'Man-O-War', 128: 'Continental Army', 129: 'Continental Cavalry', 130: 'rebel colony flag', 22: 'Food', 23: 'Sugar', 24: 'Tobacco', 25: 'Cotton', 26: 'Furs', 27: 'Lumber', 28: 'Ore', 29: 'Silver', 30: 'Horses', 31: 'Rum', 32: 'Cigars', 33: 'Cloth', 34: 'Coats', 35: 'Trade Goods', 36: 'Tools', 37: 'Muskets'}

JOB_FIGURES = {j: 81 + j for j in range(27)}
JOB_FIGURES[27] = 66  # Convert exception
JOB_NAMES = ["Farmer","Sugar Planter","Tobacco Planter","Cotton Planter","Fur Trapper",
  "Lumberjack","Ore Miner","Silver Miner","Fisherman","Distiller","Tobacconist","Weaver",
  "Fur Trader","Carpenter","Blacksmith","Gunsmith","Preacher","Statesman","Teacher",
  "Colonist","Pioneer","Soldier","Scout","Dragoon","Missionary","Ind. Servant",
  "Criminal","Convert"]
