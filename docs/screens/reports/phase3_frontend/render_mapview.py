#!/usr/bin/env python3
"""Phase-3 render-and-diff: rebuild the in-game map view from the byte-cited spec.

Compositor rules implemented 1:1 from:
  spec/systems/map_system.md  (O513/O512 chain)
  disasm: func_0681A8 (O513), func_067F50 (O512), func_067A24 (analyse_connections),
          func_067B84/067BE4/067C8E+067C54 (masks), func_003436 (terrain_id_normalize),
          func_003460/0034C4 (ground copy / ==0 backfill), func_006204 (classify).
Frame convention (RULING 2026-07-31): engine frame N = disk sprite N-1.
"""
import struct, sys
sys.path.insert(0, '/home/user/colopy/tools')
from ssdec import load_sheet
from PIL import Image

SCR = '/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad'
COL = SCR + '/colzip'

# ---------- assets ----------
pal6 = open(COL + '/VICEROY.PAL', 'rb').read()
assert len(pal6) >= 768
PAL = [((pal6[i] << 2) | (pal6[i] >> 4)) for i in range(768)]

terr = load_sheet(COL + '/TERRAIN.SS')
phys = load_sheet(COL + '/PHYS0.SS')
assert terr['nframes'] == 12 and phys['nframes'] == 154

# TERRAIN flat 12-tile array: slot k = disk frame k, 16x16 each (func_072B9A boot build)
TFRAME = []
for (x, y, w, h, px) in terr['frames']:
    assert (w, h) == (16, 16), (w, h)
    TFRAME.append(bytes(px))

# ---------- map ----------
mp = open('/home/user/colopy/raw/COLONIZE/AMER2.MP', 'rb').read()
W, H, VER = struct.unpack_from('<HHH', mp, 0)
assert (W, H, VER) == (58, 72, 4)
T = mp[6:6 + W * H]                      # terrain layer, row-major

def raw(x, y):
    if 0 <= x < W and 0 <= y < H:
        return T[y * W + x]
    return None

WATER = (0x19, 0x1A)

def classify(b):                          # func_006204, mode [0x18E]=0 (assumption)
    return b & 0x1F

def fold(c):                              # <0x18 -> &7 (O512 @0x67FD4 etc.)
    return (c & 7) if c < 0x18 else c

def normalize(i):                         # func_003436 terrain_id_normalize_to_8
    if i in (0x11, 9):
        return 8
    if i >= 8:
        return i - 0xF
    return i

# dir tables
D4 = [(0, -1), (1, 0), (0, 1), (-1, 0)]                  # DGROUP 0xA8/0xAE: N,E,S,W
D8 = [(0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1)]  # 0xB4/0xBE

def analyse_connections(x, y):
    """func_067A24: 8-dir land bitmap + per-quadrant code table + land count."""
    conn = 0
    quad = [0, 0, 0, 0]
    count = 0
    for d in range(8):
        dx, dy = D8[d]
        b = raw(x + dx, y + dy)
        if b is None:
            continue                       # off-map: treated as no-land (assumption)
        c = b & 0x1F
        c = fold(c)
        c = classify(c)
        if c in WATER:
            continue
        conn |= (1 << d)
        count += 1
        if d & 1:                          # diagonal -> quadrant ((d+1)&6)>>1 |= 2
            quad[((d + 1) & 6) >> 1] |= 2
        else:                              # cardinal: q(d/2) |= 4 ; q((d/2+1)&3) |= 1
            quad[d >> 1] |= 4
            quad[((d >> 1) + 1) & 3] |= 1
    return conn, quad, count

def nmask4_range_bit(x, y, bit):          # func_067B84: N8/S4/W2/E1, test byte&bit
    m = 0
    for w8, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
        b = raw(x + dx, y + dy)
        if b is not None and (b & bit):
            m += w8
    return m

def nmask4_relief(x, y, want):            # func_067BE4: (byte&0xA0)==want
    m = 0
    for w8, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
        b = raw(x + dx, y + dy)
        if b is not None and (b & 0xA0) == want:
            m += w8
    return m

def nmask4_forest(x, y):                  # func_067C8E + 067C54
    m = 0
    for w8, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
        b = raw(x + dx, y + dy)
        if b is None:
            continue
        i = b & 0x1F
        if i < 0x18 and (i & 7) != 1 and i > 7:
            m += w8
    return m

TRANS = 0xFD

class Tile:
    def __init__(self):
        self.px = bytearray(256)          # composite buffer 0x839E model

    def ground(self, tid):                # emit_ground (func_003460): raw 16x16 copy
        self.px[:] = TFRAME[normalize(tid)]

    def backfill(self, tid):              # emit_terrain (func_0034C4): only where ==0
        f = TFRAME[normalize(tid)]
        for i in range(256):
            if self.px[i] == 0:
                self.px[i] = f[i]

    def draw_phys(self, engine, ox=0, oy=0):   # draw_subcell: PHYS0, 0xFD transparent
        fx, fy, w, h, p = phys['frames'][engine - 1]
        for yy in range(h):
            ty = oy + yy
            if ty >= 16:
                break
            for xx in range(w):
                tx = ox + xx
                if tx >= 16:
                    break
                v = p[yy * w + xx]
                if v != TRANS:
                    self.px[ty * 16 + tx] = v

def o512(tile, x, y, cls, hidden, ring_off, arg3):
    """func_067F50 dithered-edge composer (fully-explored assumption: no fog)."""
    cc = classify(fold(cls & 0x1F))
    for d in range(4):
        dx, dy = D4[d]
        nb = raw(x + dx, y + dy)
        if nb is None:
            continue                       # off-map neighbour: skipped (assumption)
        nbc = classify(fold(nb & 0x1F))
        if nbc in WATER:
            if not ring_off:
                # ring walk on the water neighbour, countdown 7..0, cardinals only
                # -> visit order W(6), S(4), E(2), N(0); stop when class non-water
                for d8 in (6, 4, 2, 0):
                    if nbc not in WATER:
                        break
                    ddx, ddy = D8[d8]
                    b2 = raw(x + dx + ddx, y + dy + ddy)
                    if b2 is not None:
                        nbc = classify(fold(b2 & 0x1F))
            if nbc in WATER and arg3 == 0:
                continue
        if nbc == cc:
            continue
        tile.draw_phys(0x69 + d)           # dither stencil (writes index-0 dots)
        tile.backfill(nbc)                 # neighbour terrain through the holes

def render_tile(x, y):
    b = T[y * W + x]
    cls = classify(b)
    tile = Tile()
    water = cls in WATER
    conn = quad = None
    count = 0
    if water:
        conn, quad, count = analyse_connections(x, y)
    if water and count == 0:               # open water fast path @0x68274
        tile.ground(cls)
        o512(tile, x, y, cls, 0, 1, 1)
        return tile
    # main path @0x682C0
    foldc = fold(cls)
    if foldc == 1 and 8 <= cls < 0x18:
        gid = 0x11                         # desert-forest -> Scrub tile
    else:
        gid = foldc if cls < 0x18 else cls
    tile.ground(gid)
    o512(tile, x, y, cls, 0, 1 if water else 0, 0)
    if foldc != 1 and 8 <= cls < 0x18:     # forest overlay
        tile.draw_phys(0x41 + nmask4_forest(x, y))
    # feature 0x96: layer-2 all zero in AMER2 -> never
    if (b & 0x20) and not water:           # relief
        m = nmask4_relief(x, y, b & 0xA0)
        tile.draw_phys((0x21 if b & 0x80 else 0x31) + m)
    if (b & 0x40) and not water:           # river
        base = 0x01 if b & 0x80 else 0x11
        m = nmask4_range_bit(x, y, 0x40)
        if m == 0:
            m = 0xF
        tile.draw_phys(base + m)
    # roads (feature&0x0A) + surf/lost-city + 0x5A resource variant: runtime/empty -> skip
    if water:                              # coast block @0x68474
        conn8 = conn
        pattern = -1
        if conn8 & 0xDD == 0xC1: pattern = 0
        if conn8 & 0x77 == 0x07: pattern = 1
        if conn8 & 0x77 == 0x70: pattern = 2
        if conn8 & 0xDD == 0x1C: pattern = 3
        if pattern >= 0:
            tile.draw_phys(0x97 + pattern)
        else:
            for q in range(4):
                ox = 8 if q in (1, 2) else 0
                oy = 8 if q in (2, 3) else 0
                tile.draw_phys(0x6D + quad[q] * 4 + q, ox, oy)
        tile.backfill(cls)
        if b & 0xC0:                       # river mouths @0x68524
            base = 0x8D if b & 0x80 else 0x91
            for d in range(4):
                dx, dy = D4[d]
                nb = raw(x + dx, y + dy)
                if nb is not None and (nb & 0x40) and classify(nb) not in WATER:
                    tile.draw_phys(base + d)
    return tile

def main():
    img = Image.new('RGB', (W * 16, H * 16))
    put = img.putpixel
    for y in range(H):
        for x in range(W):
            t = render_tile(x, y)
            for yy in range(16):
                for xx in range(16):
                    v = t.px[yy * 16 + xx]
                    put((x * 16 + xx, y * 16 + yy),
                        (PAL[v * 3], PAL[v * 3 + 1], PAL[v * 3 + 2]))
    img.save(SCR + '/mapfull_render.png')
    print('saved', img.size)

if __name__ == '__main__':
    main()
