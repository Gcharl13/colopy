#!/usr/bin/env python3
"""Fog-aware re-render of the capture's 15x12 viewport window + pixel diff.

World state (runtime, inferred from the capture -- the session used a GENERATED map):
  terrain: ocean (0x19) for window cols < LANE_X0, sea-lane (0x1A) for cols >= LANE_X0
  explored: the 3x3 tile block cols 7..9 rows 6..8 (from the capture's fog classification)
Compositor: byte-cited O513/O512 chain incl. the fog path (0x95 + fog-edge composer).
"""
import sys
sys.path.insert(0, '/home/user/colopy/tools')
from ssdec import load_sheet
from PIL import Image
import numpy as np

SCR = '/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad'
pal6 = open(SCR + '/colzip/VICEROY.PAL', 'rb').read()
PAL8 = np.array([((pal6[i] << 2) | (pal6[i] >> 4)) for i in range(768)], dtype=np.uint8).reshape(256, 3)
PAL565 = PAL8.copy()
PAL565[:, 0] &= 0xF8; PAL565[:, 1] &= 0xFC; PAL565[:, 2] &= 0xF8

terr = load_sheet(SCR + '/colzip/TERRAIN.SS')
phys = load_sheet(SCR + '/colzip/PHYS0.SS')
TFRAME = [bytes(f[4]) for f in terr['frames']]
TRANS = 0xFD
WATER = (0x19, 0x1A)

# ---- window model (viewport tile coords 0..14 x 0..11, plus 1-ring border) ----
LANE_X0 = 8
def terrain(i, j):
    return 0x1A if i >= LANE_X0 else 0x19
EXPLORED = {(i, j) for i in range(7, 10) for j in range(6, 9)}
def explored(i, j):
    return (i, j) in EXPLORED

def normalize(t):
    if t in (0x11, 9): return 8
    return t - 0xF if t >= 8 else t

class Tile:
    def __init__(self): self.px = bytearray(256)
    def ground(self, tid): self.px[:] = TFRAME[normalize(tid)]
    def backfill(self, tid):
        f = TFRAME[normalize(tid)]
        for k in range(256):
            if self.px[k] == 0: self.px[k] = f[k]
    def draw_phys(self, engine, ox=0, oy=0):
        fx, fy, w, h, p = phys['frames'][engine - 1]
        for yy in range(h):
            ty = oy + yy
            if ty >= 16: break
            for xx in range(w):
                tx = ox + xx
                if tx >= 16: break
                v = p[yy * w + xx]
                if v != TRANS: self.px[ty * 16 + tx] = v

D4 = [(0, -1), (1, 0), (0, 1), (-1, 0)]  # N,E,S,W

def o512(tile, i, j, cls, hidden, ring_off, arg3):
    cc = cls & 7 if cls < 0x18 else cls
    for d in range(4):
        dx, dy = D4[d]
        ni, nj = i + dx, j + dy
        nb = terrain(ni, nj)
        nbc = nb & 7 if nb < 0x18 else nb
        hid_nb = 0 if explored(ni, nj) else 1
        if hidden and hid_nb:
            continue                      # fog centre: blend only explored nbrs
        if nbc in WATER:
            # ring walk (land centres only; all-water world -> stays water)
            if nbc in WATER and arg3 == 0 and not hidden and not hid_nb:
                continue
        if nbc == cc and not hidden and not hid_nb:
            continue
        tile.draw_phys(0x69 + d)
        tile.backfill(nbc)

def render_window():
    out = np.zeros((192, 240, 3), dtype=np.uint8)
    for j in range(12):
        for i in range(15):
            b = terrain(i, j)
            cls = b & 0x1F
            t = Tile()
            if not explored(i, j):        # hidden path @0x68210
                t.draw_phys(0x95)
                o512(t, i, j, cls, 1, 1 if cls in WATER else 0, 0)
            else:
                # water tile; land count 0 in this all-water window -> open-water path
                t.ground(cls)
                o512(t, i, j, cls, 0, 1, 1)
            a = np.frombuffer(bytes(t.px), dtype=np.uint8).reshape(16, 16)
            out[j*16:(j+1)*16, i*16:(i+1)*16] = PAL565[a]
    return out

ren = render_window()

im = np.asarray(Image.open('/home/user/colopy/docs/screens/06_ingame_map.png'))
native = im[184:584:2, 192:832:2]
vp = native[8:200, 0:240].copy()

eq = (ren == vp).all(axis=2)
print('overall exact-match: %.2f%%' % (eq.mean() * 100))
for j in range(12):
    print(' '.join('%3d' % int(eq[j*16:(j+1)*16, i*16:(i+1)*16].mean() * 100) for i in range(15)))

# diff heat
diff = (np.abs(ren.astype(int) - vp.astype(int)).sum(axis=2)).clip(0, 255).astype(np.uint8)
heat = np.zeros_like(ren); heat[:, :, 0] = diff; heat[:, :, 1] = (eq * 60).astype(np.uint8)
gap = np.full((192, 4, 3), 255, dtype=np.uint8)
sbs = np.concatenate([ren, gap, vp, gap, heat], axis=1)
Image.fromarray(sbs).resize((sbs.shape[1]*2, sbs.shape[0]*2), Image.NEAREST).save(SCR + '/mapview_sidebyside.png')
np.save(SCR + '/eq_mask.npy', eq)
Image.fromarray(ren).save(SCR + '/window_render.png')
print('saved mapview_sidebyside.png')
EOF = None
