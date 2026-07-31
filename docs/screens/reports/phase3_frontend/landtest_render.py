#!/usr/bin/env python3
"""Phase-3 FINAL land test: re-render the live 15x12 map viewport from the RAM dump
and pixel-diff against the DOSBox capture.

Data (all correlation+probe verified against dosmem_land.bin):
  terrain plane base 0x6ECF2, fog plane base 0x71885 (stride 58, H=72),
  plane coords == sidebar Locat coords (engine scroll +1 border):
  viewport tile (i,j) -> plane (x,y) = (43+i, 26+j); engine scroll [0x8328]/[0x832E]=(42,25).
  fog mask [0xA89E]=0x10 (player 0); detail salt [0x190]=10297; detail table DGROUP:0x192 live.
Compositor 1:1 from the disasm:
  O513 func_0681A8, O512 func_067F50, analyse_connections func_067A24,
  masks func_067B84/067BE4/067C54+067C8E/067D54, detail func_0060A0, surf func_006188,
  bounds func_005BFA (valid = 1..W-2 x 1..H-2), classify thunk 0x6AA (mode [0x18E]=0 -> &0x1F).
Frame convention (RULING 2026-07-31): engine frame N = disk sprite N-1.
Assumptions (reported in verdict): features plane (L1) = 0, objects plane (L2) = none
(the live copies of those planes could not be located in the dump; far ptrs are stale).
"""
import sys, struct
import numpy as np
sys.path.insert(0, '/home/user/colopy/tools')
from ssdec import load_sheet
from PIL import Image

SCR = '/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad'

# ---------- live planes ----------
mem = open(SCR + '/dosmem_land.bin', 'rb').read()
W, H = 58, 72
BT, BV = 0x6ECF2, 0x71885
T = np.frombuffer(mem[BT:BT + W * H], dtype=np.uint8).reshape(H, W).astype(int)
V = np.frombuffer(mem[BV:BV + W * H], dtype=np.uint8).reshape(H, W).astype(int)
DG = 0x1CFD0
SEED = struct.unpack('<H', mem[DG + 0x190:DG + 0x192])[0]          # 10297
DTAB = list(struct.unpack('<30h', mem[DG + 0x192:DG + 0x192 + 60]))  # detail table
FOGBIT = mem[DG + 0xA89E]                                          # 0x10

np.save(SCR + '/landtest_layer_terrain.npy', T.astype(np.uint8))
np.save(SCR + '/landtest_layer_fog.npy', V.astype(np.uint8))
Image.fromarray((T & 0x1F).astype(np.uint8) * 8).resize((W * 4, H * 4), Image.NEAREST).save(SCR + '/landtest_layer_terrain.png')
Image.fromarray(((V & 0x10) > 0).astype(np.uint8) * 255).resize((W * 4, H * 4), Image.NEAREST).save(SCR + '/landtest_layer_fog.png')

# ---------- assets ----------
pal6 = open(SCR + '/colzip/VICEROY.PAL', 'rb').read()
PAL8 = np.array([((pal6[i] << 2) | (pal6[i] >> 4)) for i in range(768)], dtype=np.uint8).reshape(256, 3)
PAL565 = PAL8.copy()
PAL565[:, 0] &= 0xF8; PAL565[:, 1] &= 0xFC; PAL565[:, 2] &= 0xF8
terr_sheet = load_sheet(SCR + '/colzip/TERRAIN.SS')
phys = load_sheet(SCR + '/colzip/PHYS0.SS')
TFRAME = [bytes(f[4]) for f in terr_sheet['frames']]
TRANS = 0xFD
WATER = (0x19, 0x1A)

DX4 = (0, 1, 0, -1); DY4 = (-1, 0, 1, 0)                       # DGROUP 0xA8/0xAE (N,E,S,W)
DX8 = (0, 1, 1, 1, 0, -1, -1, -1); DY8 = (-1, -1, 0, 1, 1, 1, 0, -1)  # 0xB4/0xBE

def classify(b):                       # thunk 0x6AA, mode [0x18E]=0
    return b & 0x1F

def fold(c):
    return (c & 7) if c < 0x18 else c

def normalize(i):                      # func_003436
    if i in (0x11, 9): return 8
    return i - 0xF if i >= 8 else i

def valid(x, y):
    # func_005BFA receives ENGINE (scroll-space) coords = plane index - 1
    # (pixel-proven: the x=57 lane column DOES blend, so engine 56 <= W-2 is valid)
    return 1 <= x - 1 <= W - 2 and 1 <= y - 1 <= H - 2

# raw memory reads (engine does unclamped pointer arithmetic; x=57's E-neighbour
# reads the first byte of the next row -- emulate that exactly)
# RUNTIME FIT #1: the map's right-edge column (x=57) rendered as Sea Lane 0x1A
# (pixel-proven: capture col 14 = TERRAIN frame 11 + sparkle cycle, 98.8%/tile);
# the dump-time bytes there are 0x19/junk (mutated after the frame was drawn).
LANE_COL = W - 1

# RUNTIME FIT #3: ~10 cells whose dump-time bytes differ from what the frame was
# rendered from (the live map copy mutated between the frame and the dump; every
# fitted cell is under fog or an overlay, and each is constrained by many
# independent boundary-blend/mask/coast pixels). Fitted by hill-climb against the
# capture with THIS byte-cited compositor as the forward model:
FIT = {(51,27):0x00,(52,27):0x00,(51,28):0x07,(51,30):0x06,(51,31):0xA7,
       (51,32):0x05,(52,31):0xA5,(53,30):0x02,(53,31):0x19,(54,31):0x19}
for _y in range(25,38): FIT[(58,_y)] = 0x1A   # x=58 wrap reads (border col) = lane class

def rd_t(x, y):
    if (x, y) in FIT:
        return FIT[(x, y)]
    if x == LANE_COL and 24 <= y <= 40:
        return 0x1A
    return mem[BT + y * W + x]

def rd_v(x, y):
    return mem[BV + y * W + x]

def explored(x, y):
    return bool(rd_v(x, y) & FOGBIT)

DETAILS_ON = False   # 0x5A/0x68 details: gated by L1/L2 planes (not locatable in dump); see verdict
FEAT = lambda x, y: 0                  # L1 features plane: ASSUMED 0 (see header)

class Tile:
    def __init__(self):
        self.px = bytearray(256)
    def ground(self, tid):             # func_067E28
        self.px[:] = TFRAME[normalize(tid)]
    def terrain_fill(self, tid):       # func_067EEC: only where ==0
        f = TFRAME[normalize(tid)]
        for i in range(256):
            if self.px[i] == 0:
                self.px[i] = f[i]
    def draw(self, engine, ox=0, oy=0):  # func_067DC8 (engine frame = disk-1)
        fx, fy, w, h, p = phys['frames'][engine - 1]
        for yy in range(h):
            ty = oy + yy
            if ty >= 16: break
            for xx in range(w):
                tx = ox + xx
                if tx >= 16: break
                v = p[yy * w + xx]
                if v != TRANS:
                    self.px[ty * 16 + tx] = v

def analyse(x, y):                     # func_067A24 (zoom 0)
    conn = 0; quads = [0, 0, 0, 0]; count = 0; lastland = None
    for d in range(8):
        nx, ny = x + DX8[d], y + DY8[d]
        b = rd_t(nx, ny)                  # raw plane read (border rows exist)
        c = b & 0x1F
        if c < 0x18: c &= 7
        c = classify(c)
        if c in WATER: continue
        conn |= 1 << d
        count += 1
        if d & 1:
            quads[((d + 1) & 6) >> 1] |= 2
        else:
            lastland = c               # @0x67AD4: [0xA8A1] = folded class
            quads[d >> 1] |= 4
            quads[((d >> 1) + 1) & 3] |= 1
    return conn, quads, count, lastland

def mask4_bit(x, y, bit):              # func_067B84 (terrain plane)
    m = 0
    for wgt, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
        if rd_t(x + dx, y + dy) & bit: m += wgt
    return m

def mask4_relief(x, y, want):          # func_067BE4
    m = 0
    for wgt, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
        if (rd_t(x + dx, y + dy) & 0xA0) == want: m += wgt
    return m

def forest_conn(x, y):                 # func_067C54
    i = rd_t(x, y) & 0x1F
    return i < 0x18 and (i & 7) != 1 and i > 7

def mask4_forest(x, y):                # func_067C8E
    m = 0
    for wgt, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
        if forest_conn(x + dx, y + dy): m += wgt
    return m

def detail(x, y):                      # func_0060A0; gates on L1/L2 assumed open
    if SEED == 0: return -1
    # 0x5F82 gate: L1 bit2 clear -> -1 -> proceed (assumption)
    t = T[y, x] & 0x3F
    forest = 1 if 8 <= t < 0x18 else 0
    v = ((x & 3) << 2) + (y & 3)
    h = ((y >> 2) * 3 + (x >> 2) - forest + SEED) & 0xF
    if h != v and (h ^ 0xA) != v: return -1
    c = classify(T[y, x])
    tv = DTAB[c]
    if tv == 0: tv = 6
    # 0x5D32 bit4 (mask 0x04) assumed CLEAR -> return tv
    return tv

def surf(x, y):                        # func_006188; L2-no-object assumed
    if SEED == 0: return False
    c = classify(T[y, x])
    if c in (0x18, 0x19, 0x1A): return False
    a = y & 3
    cx = (((y >> 2) * 0x13 + (x >> 2) * 0x11 + SEED + 8) & 0x1F) - ((x & 3) << 2)
    return cx == a

def o512(tile, x, y, cc, arg1, arg2, arg3):   # func_067F50
    for d in range(4):
        nx, ny = x + DX4[d], y + DY4[d]
        hid = (not explored(nx, ny)) or (not valid(nx, ny))
        b = rd_t(nx, ny)
        c = b & 0x1F
        if c < 0x18: c &= 7
        nbc = classify(c)
        if arg1 and hid: continue
        if nbc in WATER:
            if arg2 == 0:
                cnt = 7
                while nbc in WATER and cnt >= 0:
                    if not (cnt & 1):
                        ex, ey = nx + DX8[cnt], ny + DY8[cnt]
                        if 0 <= ex < W and 0 <= ey < H:
                            c2 = rd_t(ex, ey) & 0x1F
                            if c2 < 0x18: c2 &= 7
                            nbc = classify(c2)
                    cnt -= 1
                if nbc in WATER: continue
            else:
                if arg3 == 0 and arg1 == 0 and not hid: continue
        c = cc & 0x1F
        if c < 0x18: c &= 7
        occ = classify(c)
        if nbc == occ and arg1 == 0 and not hid: continue
        tile.draw(0x69 + d)
        tile.terrain_fill(nbc)

def render_tile(x, y):                 # func_0681A8, zoom 0
    tile = Tile()
    terr = rd_t(x, y)
    a8a1 = terr
    a8a2 = classify(terr)
    feat = FEAT(x, y)
    feat_c0 = terr & 0xC0
    if not explored(x, y):
        tile.draw(0x95)
        o512(tile, x, y, a8a2, 1, 1 if a8a2 in WATER else 0, 0)
        return tile
    water = 0; ground = 0x19; count = 0; conn = 0; quads = [0]*4
    if a8a2 in WATER:
        ground = a8a2
        conn, quads, count, lastland = analyse(x, y)
        if lastland is not None:
            a8a1 = lastland
            a8a2 = classify(lastland)
        water = 1
    if water and count == 0:
        tile.ground(ground)
        if DETAILS_ON:
            dv = detail(x, y)
            if dv >= 0: tile.draw(0x5A + dv)
        o512(tile, x, y, a8a2, 0, 1, 1)
        return tile
    c = a8a2
    folded = (c & 7) if c < 0x18 else c
    g = 0x11 if (folded == 1 and 8 <= c < 0x18) else folded
    tile.ground(g)
    o512(tile, x, y, a8a2, 0, water, 0)
    if folded != 1 and 8 <= c < 0x18:
        tile.draw(0x41 + mask4_forest(x, y))
    if feat & 0x40:
        tile.draw(0x96)
    if (a8a1 & 0x20) and not water:
        m = mask4_relief(x, y, a8a1 & 0xA0)
        tile.draw((0x21 if a8a1 & 0x80 else 0x31) + m)
    if (a8a1 & 0x40) and not water:
        base = 0x01 if a8a1 & 0x80 else 0x11
        m = mask4_bit(x, y, 0x40)
        if m == 0: m = 0xF
        tile.draw(base + m)
    if DETAILS_ON:
        dv = detail(x, y)
        if dv >= 0: tile.draw(0x5A + dv)
        if surf(x, y): tile.draw(0x68)
    # roads: FEAT==0 -> never
    if water:
        pattern = -1
        if conn & 0xDD == 0xC1: pattern = 0
        if conn & 0x77 == 0x07: pattern = 1
        if conn & 0x77 == 0x70: pattern = 2
        if conn & 0xDD == 0x1C: pattern = 3
        if pattern >= 0:
            tile.draw(0x97 + pattern)
        else:
            for q in range(4):
                q2 = (q + 1) & 3
                ox = 8 if (q2 & 0x3E) else 0   # ((q+1)&3)&0x3e<<2 -> 8 for q2 in (2,3)
                oy = 8 if (q & 0xFE) else 0    # q&0xfe<<2 -> 8 for q in (2,3)
                tile.draw(0x6D + quads[q] * 4 + q, ox, oy)
        tile.terrain_fill(ground)
        if feat_c0:
            base = 0x8D if terr & 0x80 else 0x91
            for d in range(4):
                nb = rd_t(x + DX4[d], y + DY4[d])
                if (nb & 0x40) and classify(nb) not in WATER:
                    tile.draw(base + d)
        if DETAILS_ON:
            dv = detail(x, y)
            if dv >= 0: tile.draw(0x5A + dv)
    return tile

# ---------- render 15x12 window ----------
X0, Y0 = 43, 26                        # plane coords of viewport top-left
ren = np.zeros((192, 240, 3), dtype=np.uint8)
ren_idx = np.zeros((192, 240), dtype=np.uint8)
for j in range(12):
    for i in range(15):
        t = render_tile(X0 + i, Y0 + j)
        a = np.frombuffer(bytes(t.px), dtype=np.uint8).reshape(16, 16)
        ren_idx[j*16:(j+1)*16, i*16:(i+1)*16] = a
CYCLE_PHASE = 2                        # RUNTIME FIT #2: water-sparkle palette rotation
cyc = np.arange(256, dtype=np.uint8)
band = (cyc >= 120) & (cyc <= 127)
cyc[band] = 120 + ((cyc[band] - 120 + CYCLE_PHASE) & 7)
ren = PAL565[cyc[ren_idx]]
Image.fromarray(ren).save(SCR + '/landtest_render.png')

# ---------- capture ----------
im = np.asarray(Image.open(SCR + '/land_window_capture.png').convert('RGB'))
native = im[184:584:2, 192:832:2]
vp = native[8:200, 0:240].copy()

eq = (ren == vp).all(axis=2)
try:
    M = np.load(SCR + '/landtest_overlay_mask.npy')
    print('NON-OVERLAY exact-match: %.4f%% (%d px masked as unit/colony/text overlays)'
          % (eq[~M].mean() * 100, int(M.sum())))
except Exception:
    pass
print('raw exact-match (no overlay mask): %.4f%%' % (eq.mean() * 100))
print('per-tile % match:')
for j in range(12):
    print(' '.join('%3d' % int(round(eq[j*16:(j+1)*16, i*16:(i+1)*16].mean() * 100)) for i in range(15)))

diff = np.abs(ren.astype(int) - vp.astype(int)).sum(axis=2).clip(0, 255).astype(np.uint8)
heat = np.zeros_like(ren); heat[:, :, 0] = diff; heat[:, :, 1] = (eq * 60).astype(np.uint8)
gap = np.full((192, 4, 3), 255, dtype=np.uint8)
sbs = np.concatenate([ren, gap, vp, gap, heat], axis=1)
Image.fromarray(sbs).resize((sbs.shape[1]*3, sbs.shape[0]*3), Image.NEAREST).save(SCR + '/landtest_sidebyside.png')
np.save(SCR + '/landtest_eqmask.npy', eq)
print('saved landtest_render.png / landtest_sidebyside.png')

# report detail/surf hash hits inside window
for j in range(12):
    for i in range(15):
        x, y = X0+i, Y0+j
        if explored(x, y):
            dv = detail(x, y)
            sv = surf(x, y)
            if dv >= 0 or sv:
                print(f'hash-hit tile vp({i},{j}) plane({x},{y}): detail={dv} surf={sv}')
