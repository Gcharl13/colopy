#!/usr/bin/env python3
"""Render the Jamestown colony screen from RAW assets + a committed RAM fixture, and
measure it against the byte-matched live capture docs/screens/colony_live_1505.png.

Data source: data_extracted/colony_jamestown_fixture.bin — a 36 KB DGROUP slice
(base 0x200) captured live from a freshly-founded pop-1 Jamestown (RAM byte-equivalent to
the original colony_jamestown.bin; see RULINGS 2026-06-27). Decoders are the byte-verified
ssdec.py (.SS) + FAB (.PIK) with the corrected VICEROY.PAL stride-3 palette.

Frame rules (empirically MSE-0 verified against the matched screenshot; ssdec frame K =
game frame K+1):
  * building plot: ssdec frame = def_id (byte[0x8E82+i]); def_id 0 -> frame 16
  * empty plot:    ssdec frame = table[cat]-1, table=DS:0x260, cat=byte[0x8D62+i], skip if 0
  * both blit at (plotX=word[0x266+i*4], plotY=word[0x268+i*4] + 8)
"""
import sys, struct, numpy as np
sys.path.insert(0, 'tools')
from ssdec import load_sheet, madspack_load
from PIL import Image

RAW = 'raw/COLONIZE'
pd = open(f'{RAW}/VICEROY.PAL', 'rb').read()
GPAL = np.array([[((pd[i*3+c] << 2) | (pd[i*3+c] >> 4)) for c in range(3)] for i in range(256)], np.uint8)

# ---- committed RAM fixture (base-offset header + DGROUP slice) ----
fx = open('data_extracted/colony_jamestown_fixture.bin', 'rb').read()
FXBASE = struct.unpack_from('<I', fx, 0)[0]
DG = fx[4:]
def b(o):  return DG[o - FXBASE]
def u16(o): return struct.unpack_from('<H', DG, o - FXBASE)[0]
def s8(o):  v = b(o); return v - 256 if v >= 128 else v
CP = u16(0x8542)                                   # active colony record offset
def cu16(o): return struct.unpack_from('<H', DG, CP + o - FXBASE)[0]

plots = [(u16(0x266+i*4), u16(0x268+i*4), s8(0x8E82+i)) for i in range(15)]
cat   = [b(0x8D62+i) for i in range(15)]
tframe = [b(0x260+i) for i in range(6)]            # cat -> terrain frame table
stock = [cu16(0x9A + i*2) for i in range(16)]
cname = DG[CP-FXBASE+2: DG.find(b'\x00', CP-FXBASE+2)].decode('latin1')
cpop  = b(CP + 0x1F)

# ---- sprite helpers ----
def sheet_frame_rgba(sheet, k):
    if k < 0 or k >= sheet['nframes']: return None
    x, y, w, h, pix = sheet['frames'][k]
    if w == 0 or h == 0: return None
    a = np.frombuffer(bytes(pix), np.uint8).reshape(h, w)
    out = np.zeros((h, w, 4), np.uint8)
    m = a != 0xFD
    out[..., :3][m] = GPAL[a[m]]
    out[..., 3][m] = 255
    return Image.fromarray(out, 'RGBA')

def pik_rgb(name):
    d = open(f'{RAW}/{name}.PIK', 'rb').read()
    secs = madspack_load(d)
    pix = max(secs, key=lambda s: len(s[1]))[1]
    arr = np.frombuffer(pix, np.uint8)
    h = len(arr) // 320
    arr = arr[:h*320].reshape(h, 320)
    return Image.fromarray(GPAL[arr], 'RGB')

C = Image.new('RGBA', (320, 200), (0, 0, 0, 255))

# woodgrain chrome (whole screen)
wood = load_sheet(f'{RAW}/WOODTILE.SS'); wt = sheet_frame_rgba(wood, 0)
for yy in range(0, 200, wt.height):
    for xx in range(0, 320, wt.width): C.alpha_composite(wt, (xx, yy))

# parchment scene background (tiled), scene rect x0..200 y8..127
par = load_sheet(f'{RAW}/PARCH.SS'); pt = sheet_frame_rgba(par, 0)
for yy in range(8, 128, pt.height):
    for xx in range(0, 201, pt.width): C.alpha_composite(pt, (xx, yy))

# plot grid: buildings + empty-plot terrain (frames verified MSE-0)
bld = load_sheet(f'{RAW}/BUILDING.SS')
for i, (x, y, d) in enumerate(plots):
    if d < 0:
        f = tframe[cat[i]] - 1
        if tframe[cat[i]] == 0 or f < 0: continue
    else:
        f = 16 if d == 0 else d
    fr = sheet_frame_rgba(bld, f)
    if fr: C.alpha_composite(fr, (x, y + 8))

# COLONY.PIK bottom band (SoL/colonist/warehouse + stockpile bg) at y=128
C.paste(pik_rgb('COLONY'), (0, 128))

# stockpile commodity icons: ICONS.SS frame 0x17+good, x = 1 + i*19, icon y = 181
icons = load_sheet(f'{RAW}/ICONS.SS')
for i in range(16):
    fr = sheet_frame_rgba(icons, 0x17 + i)
    if fr:
        cx = 1 + i*19 + (18 - fr.width)//2
        C.alpha_composite(fr, (cx, 181))

# title (FONTTINY from the cpp bundle)
import json
def tfont():
    im = Image.open('viceroy_cpp/build/bundle/fonts/FONTTINY.png')
    idx = np.asarray(im.convert('P'))
    rgb = Image.fromarray(idx, 'P'); rgb.putpalette(list(GPAL.flatten())); rgb = rgb.convert('RGBA')
    a = np.where(idx == im.info.get('transparency', 253), 0, 255).astype('uint8')
    rgb.putalpha(Image.fromarray(a))
    return rgb, json.load(open('viceroy_cpp/build/bundle/fonts/FONTTINY.json'))
fimg, fmeta = tfont()
def text(s, x, y, rgb=(92, 172, 60)):
    cx = x
    for ch in s:
        f = fmeta['frames'][ord(ch)] if ord(ch) < 128 else None
        if not f or f['w'] == 0: cx += 4; continue
        g = fimg.crop((f['x'], f['y'], f['x']+f['w'], f['y']+f['h']))
        solid = Image.new('RGBA', g.size, rgb + (255,)); C.paste(solid, (cx, y), g)
        cx += g.size[0] + 1
text(f"{cname}.  (pop {cpop})", 70, 1)

C.convert('RGB').save('/tmp/mine_final.png')
C.resize((960, 600), Image.NEAREST).convert('RGB').save('docs/screens/colony_RENDERED.png')

# ---- measure vs the byte-matched live capture ----
ref = np.asarray(Image.open('docs/screens/colony_live_1505.png').convert('RGB'))
mine = np.asarray(C.convert('RGB'))
full = ((ref.astype(int) - mine.astype(int))**2).mean()
print(f"full-screen MSE vs colony_live_1505.png = {full:.0f}")
for nm, (y0, y1) in [("title 0-8", (0, 8)), ("scene 8-128", (8, 128)),
                     ("colonypik 128-181", (128, 181)), ("stockpile 181-200", (181, 200))]:
    print(f"  {nm}: {((ref[y0:y1].astype(int)-mine[y0:y1].astype(int))**2).mean():.0f}")
