#!/usr/bin/env python3
"""Phase-3 live test: render the map-view compositor 1:1 from the disasm over the
CRAFTED test map's live planes, and pixel-diff against the DOSBox captures.

Chain: O513 func_0681A8 / O512 func_067F50 / analyse_connections func_067A24 /
masks func_067B84(river,terr plane,&bit)/067BE4(relief,==byte&0xA0)/067C54+067C8E
(forest)/067D54(8-dir feature plane; roads ax=0x0A)/detail func_0060A0/surf
func_006188 -- detail+surf gates NEWLY re-disassembled this session
(detail_helpers.asm): village gate func_005F82 (feat bit1 & cont-owner>=4),
surf owner gate func_005DF0 (cont high nibble != 0xF suppresses), feature bit2
(0x04) suppresses detail unless tv==12 (then 0x5A+0).
Frame convention: engine frame N = PHYS0 disk sprite N-1 (RULING 2026-07-31).
Fog: complete-map reveal -> [0xA89E]=0 and O513 arg0=0 -> nothing hidden.
"""
import sys, struct, json
import numpy as np
sys.path.insert(0, '/home/user/colopy/tools')
from ssdec import load_sheet
from PIL import Image

SCR = '/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad'
W, H = 58, 72
DGP = 0x1CFD0
BT, B1, B2 = 0x6E770, 0x6F7E0, 0x70850   # live terrain / feature / continent planes

pal6 = open(SCR + '/colzip/VICEROY.PAL', 'rb').read()
PAL8 = np.array([((pal6[i] << 2) | (pal6[i] >> 4)) for i in range(768)], dtype=np.uint8).reshape(256, 3)
PAL565 = PAL8.copy()
PAL565[:, 0] &= 0xF8; PAL565[:, 1] &= 0xFC; PAL565[:, 2] &= 0xF8
terr_sheet = load_sheet(SCR + '/colzip/TERRAIN.SS')
phys = load_sheet(SCR + '/colzip/PHYS0.SS')
TFRAME = [bytes(f[4]) for f in terr_sheet['frames']]
TRANS = 0xFD
WATER = (0x19, 0x1A)
DX4 = (0, 1, 0, -1); DY4 = (-1, 0, 1, 0)
DX8 = (0, 1, 1, 1, 0, -1, -1, -1); DY8 = (-1, -1, 0, 1, 1, 1, 0, -1)


class World:
    def __init__(self, dump):
        self.mem = open(dump, 'rb').read()
        rd = lambda o: struct.unpack('<h', self.mem[DGP + o:DGP + o + 2])[0]
        self.salt = rd(0x190)
        self.dtab = [rd(0x192 + 2 * i) for i in range(29)]
        self.scroll = (rd(0x8328), rd(0x832E))
        self.cursor = (rd(0x8540), rd(0x853E))

    def t(self, x, y):   # raw terrain-plane read, engine-style unclamped
        return self.mem[BT + y * W + x]

    def f(self, x, y):
        return self.mem[B1 + y * W + x]

    def c(self, x, y):
        return self.mem[B2 + y * W + x]


def classify(b):                 # thunk 0x6AA, [0x18E]=0
    return b & 0x1F


def classify34(b):
    """Thunk 0x3E4:0x3A = read+decode terrain id incl. relief bits
    (func_0624E: bit5 -> 27 (bit7 set) / 28 (clear)); [0x18E]=0 keeps raw id
    for the rest (16..23 NOT folded -- DTAB carries duplicate entries for them).
    Pixel-proven this session: mountain/hill tiles draw detail 0x5A+DTAB[27/28]
    (gold-ore 0x66 / rock 0x67), not the base-terrain variant."""
    if b & 0x20:
        return 27 if b & 0x80 else 28
    return b & 0x1F


def normalize(i):                # ground-frame map func_003436
    if i in (0x11, 9): return 8
    return i - 0xF if i >= 8 else i


def valid(x, y):                 # O512 bounds thunk 0x181F:0x302, engine coords (= plane-1)
    # Lower bound CORRECTED this session: engine coord 0 (plane 1) IS in bounds --
    # pixel-proven by capA left lane column: engine skips the N/S water-neighbour
    # blend there (no stencil dots), which requires hid==0 for plane x==1 tiles.
    # Upper bound: engine W-2 (plane 57) valid per the 2026-07-31 landtest.
    return 0 <= x - 1 <= W - 2 and 0 <= y - 1 <= H - 2


class Tile:
    __slots__ = ('px',)
    def __init__(self):
        self.px = bytearray(256)
    def ground(self, tid):       # func_067E28
        self.px[:] = TFRAME[normalize(tid)]
    def terrain_fill(self, tid):  # func_067EEC masked blit through 0-holes
        f = TFRAME[normalize(tid)]
        for i in range(256):
            if self.px[i] == 0:
                self.px[i] = f[i]
    def draw(self, engine, ox=0, oy=0):  # func_067DC8, engine frame = disk-1
        fx, fy, w, h, p = phys['frames'][engine - 1]
        for yy in range(h):
            ty = oy + yy
            if ty >= 16: break
            row = yy * w
            for xx in range(w):
                tx = ox + xx
                if tx >= 16: break
                v = p[row + xx]
                if v != TRANS:
                    self.px[ty * 16 + tx] = v


class Renderer:
    def __init__(self, world):
        self.w = world

    # ---- neighbour masks ----
    def analyse(self, x, y):      # func_067A24 zoom0
        w = self.w
        conn = 0; quads = [0, 0, 0, 0]; count = 0; lastland = None
        for d in range(8):
            b = w.t(x + DX8[d], y + DY8[d])
            c = b & 0x1F
            if c < 0x18: c &= 7
            if c in WATER: continue
            conn |= 1 << d
            count += 1
            if d & 1:
                quads[((d + 1) & 6) >> 1] |= 2
            else:
                lastland = c          # @0x67AD4 last cardinal land (W wins)
                quads[d >> 1] |= 4
                quads[((d >> 1) + 1) & 3] |= 1
        return conn, quads, count, lastland

    def mask4_bit(self, x, y, bit):   # func_067B84 (terrain plane)
        w = self.w; m = 0
        for wgt, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
            if w.t(x + dx, y + dy) & bit: m += wgt
        return m

    def mask4_relief(self, x, y, want):  # func_067BE4 equal-(byte&0xA0)
        w = self.w; m = 0
        for wgt, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
            if (w.t(x + dx, y + dy) & 0xA0) == want: m += wgt
        return m

    def forest_conn(self, x, y):  # func_067C54
        i = self.w.t(x, y) & 0x1F
        return i < 0x18 and (i & 7) != 1 and i > 7

    def mask4_forest(self, x, y):  # func_067C8E
        m = 0
        for wgt, (dx, dy) in ((8, (0, -1)), (4, (0, 1)), (2, (-1, 0)), (1, (1, 0))):
            if self.forest_conn(x + dx, y + dy): m += wgt
        return m

    def mask8_feat(self, x, y, bits):  # func_067D54 (feature plane, 8-dir)
        m = 0
        for d in range(8):
            if self.w.f(x + DX8[d], y + DY8[d]) & bits:
                m |= 1 << d
        return m

    # ---- procedural detail / surf (func_0060A0 / func_006188, full gates) ----
    def village_owner(self, x, y):  # func_005F82
        if not (1 <= x <= W - 2 and 1 <= y <= H - 2):  # func_005BFA plane-coord guess; border never queried in-view
            return -1
        if self.w.f(x, y) & 2:
            own = self.w.c(x, y) >> 4
            if own == 0xF: own = -1
            if own >= 4:
                return own
        return -1

    def detail(self, x, y):       # func_0060A0
        w = self.w
        if w.salt == 0: return -1
        if self.village_owner(x, y) >= 0: return -1
        t = w.t(x, y) & 0x3F
        forest = 1 if 8 <= t < 0x18 else 0
        v = ((x & 3) << 2) + (y & 3)
        h = ((y >> 2) * 3 + (x >> 2) - forest + w.salt) & 0xF
        if h != v and (h ^ 0xA) != v: return -1
        cls = classify34(w.t(x, y))        # thunk 0x3E4:0x3A (relief -> 27/28)
        tv = w.dtab[cls]
        if tv == 0: tv = 6
        if w.f(x, y) & 4:                  # feature bit2: suppress unless tv==12
            return 0 if tv == 0xC else -1
        return tv

    def surf(self, x, y):         # func_006188
        w = self.w
        if w.salt == 0: return False
        cls = classify34(w.t(x, y))
        if cls in (0x18, 0x19, 0x1A): return False
        own = w.c(x, y) >> 4               # func_005DF0: >=0 (i.e. != 0xF) suppresses
        if own != 0xF: return False
        a = y & 3
        cx = (((y >> 2) * 0x13 + (x >> 2) * 0x11 + w.salt + 8) & 0x1F) - ((x & 3) << 2)
        return cx == a

    # ---- O512 dither-blend composer func_067F50 (all-explored) ----
    def o512(self, tile, x, y, cc, arg1, arg2, arg3):
        w = self.w
        for d in range(4):
            nx, ny = x + DX4[d], y + DY4[d]
            hid = not valid(nx, ny)        # explored everywhere after reveal
            b = w.t(nx, ny)
            c = b & 0x1F
            if c < 0x18: c &= 7
            nbc = classify(c)
            if arg1 and hid: continue
            if nbc in WATER:
                if arg2 == 0:
                    cnt = 7                # ring-walk W->S->E->N, first land wins
                    while nbc in WATER and cnt >= 0:
                        if not (cnt & 1):
                            ex, ey = nx + DX8[cnt], ny + DY8[cnt]
                            if 0 <= ex < W and 0 <= ey < H:
                                c2 = w.t(ex, ey) & 0x1F
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

    # ---- O513 func_0681A8, zoom 0, visible path ----
    def render_tile(self, x, y):
        w = self.w
        tile = Tile()
        terr = w.t(x, y)
        feat = w.f(x, y)
        a8a1 = terr
        a8a2 = classify(terr)
        feat_c0 = terr & 0xC0              # [bp-0x12] mouth gate @0x68206
        water = 0; ground = 0x19; count = 0; conn = 0; quads = [0] * 4
        if a8a2 in WATER:
            ground = a8a2
            conn, quads, count, lastland = self.analyse(x, y)
            if lastland is not None:       # beach-halo ground substitution
                a8a1 = lastland
                a8a2 = classify(lastland)
            water = 1
        if water and count == 0:           # open-water early path @0x68274
            tile.ground(ground)
            dv = self.detail(x, y)         # site 1 @0x682B2 ([0x18A]==0)
            if dv >= 0: tile.draw(0x5A + dv)
            self.o512(tile, x, y, a8a2, 0, 1, 1)
            return tile
        c = a8a2
        folded = (c & 7) if c < 0x18 else c
        g = 0x11 if (folded == 1 and 8 <= c < 0x18) else folded
        tile.ground(g)
        self.o512(tile, x, y, a8a2, 0, water, 0)   # @0x68315
        if folded != 1 and 8 <= c < 0x18:          # forest overlay @0x6833D
            tile.draw(0x41 + self.mask4_forest(x, y))
        if feat & 0x40:                            # shore hatch @0x6834F
            tile.draw(0x96)
        if (a8a1 & 0x20) and not water:            # relief @0x6835C
            m = self.mask4_relief(x, y, a8a1 & 0xA0)
            tile.draw((0x21 if a8a1 & 0x80 else 0x31) + m)
        if (a8a1 & 0x40) and not water:            # rivers @0x6838A
            base = 0x01 if a8a1 & 0x80 else 0x11
            m = self.mask4_bit(x, y, 0x40)
            if m == 0: m = 0xF                     # isolated @0x683BB
            tile.draw(base + m)
        if not water:
            dv = self.detail(x, y)                 # site 2 @0x683F7
            if dv >= 0: tile.draw(0x5A + dv)
            if self.surf(x, y):                    # @0x68405..0x68414
                tile.draw(0x68)
            if feat & 0x0A:                        # roads @0x68417
                m = self.mask8_feat(x, y, 0x0A)
                if m == 0:
                    tile.draw(0x51)
                else:
                    for d in range(8):
                        if m & (1 << d):
                            tile.draw(0x52 + d)
            return tile
        # water coast path @0x68474
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
                ox = 8 if (q2 & 0x3E) else 0
                oy = 8 if (q & 0xFE) else 0
                tile.draw(0x6D + quads[q] * 4 + q, ox, oy)
        tile.terrain_fill(ground)                  # backfill through 0-holes
        if feat_c0:                                # river mouths @0x68524
            base = 0x8D if terr & 0x80 else 0x91
            for d in range(4):
                nb = w.t(x + DX4[d], y + DY4[d])
                if (nb & 0x40) and classify(nb) not in WATER:
                    tile.draw(base + d)
        dv = self.detail(x, y)                     # site 3 @0x685D6
        if dv >= 0: tile.draw(0x5A + dv)
        return tile


def render_window(world, x0, y0):
    r = Renderer(world)
    idx = np.zeros((192, 240), dtype=np.uint8)
    for j in range(12):
        for i in range(15):
            t = r.render_tile(x0 + i, y0 + j)
            idx[j*16:(j+1)*16, i*16:(i+1)*16] = np.frombuffer(bytes(t.px), dtype=np.uint8).reshape(16, 16)
    return idx


def capture_vp(png):
    im = np.asarray(Image.open(png).convert('RGB'))
    native = im[184:584:2, 192:832:2]
    return native[8:200, 0:240].copy()


def phase_tables():
    tabs = []
    for ph in range(8):
        cyc = np.arange(256, dtype=np.uint8)
        band = (cyc >= 120) & (cyc <= 127)
        cyc[band] = 120 + ((cyc[band] - 120 + ph) & 7)
        tabs.append(cyc)
    return tabs


PHASES = phase_tables()


def overlay_mask(world, x0, y0):
    """Mask tiles that carry engine overlays outside the tile compositor:
    units (L1 bit0), settlements (L1 bit1), the view cursor."""
    M = np.zeros((192, 240), dtype=bool)
    info = []
    for j in range(12):
        for i in range(15):
            x, y = x0 + i, y0 + j
            fb = world.f(x, y)
            why = []
            if fb & 1: why.append('unit')
            if fb & 2: why.append('village')
            if (x, y) == world.cursor: why.append('cursor')
            if why:
                y0p, y1p = j*16, (j+1)*16
                x0p, x1p = i*16, (i+1)*16
                if 'village' in why or 'unit' in why:
                    x1p = min(240, x1p + 2)      # sprite overhangs up to 2px east (flag edge)
                if 'cursor' in why:              # white box straddles tile edges
                    y0p = max(0, y0p - 2); y1p = min(192, y1p + 2)
                    x0p = max(0, x0p - 2); x1p = min(240, x1p + 2)
                M[y0p:y1p, x0p:x1p] = True
                info.append(((x, y), '+'.join(why)))
    return M, info


def run_capture(tag, png, dump):
    w = World(dump)
    sx, sy = w.scroll
    vp = capture_vp(png)
    best = None
    for dy in (-1, 0, 1, 2):
        for dx in (-1, 0, 1, 2):
            x0, y0 = sx + dx, sy + dy
            if x0 < 0 or y0 < 0 or x0 + 15 > W or y0 + 12 > H: continue
            idx = render_window(w, x0, y0)
            for ph in range(8):
                ren = PAL565[PHASES[ph][idx]]
                sc = (ren == vp).all(axis=2).mean()
                if best is None or sc > best[0]:
                    best = (sc, x0, y0, ph, idx)
    sc, x0, y0, ph, idx = best
    ren = PAL565[PHASES[ph][idx]]
    eq = (ren == vp).all(axis=2)
    M, minfo = overlay_mask(w, x0, y0)
    nm = eq[~M].mean() if (~M).any() else 0.0
    print(f'[{tag}] scroll=({sx},{sy}) fit origin=({x0},{y0}) phase={ph} '
          f'raw={eq.mean()*100:.4f}% non-overlay={nm*100:.4f}% masked_tiles={len(minfo)}')
    # outputs
    diff = np.abs(ren.astype(int) - vp.astype(int)).sum(axis=2).clip(0, 255).astype(np.uint8)
    heat = np.zeros_like(ren); heat[:, :, 0] = diff; heat[:, :, 1] = (eq * 60).astype(np.uint8)
    hm = M.copy()
    heat[hm] = (heat[hm] * 0.3 + np.array([0, 0, 120]) * 0.7).astype(np.uint8)
    gap = np.full((192, 4, 3), 255, dtype=np.uint8)
    sbs = np.concatenate([ren, gap, vp, gap, heat], axis=1)
    Image.fromarray(ren).save(f'{SCR}/p3_render_{tag}.png')
    Image.fromarray(sbs).resize((sbs.shape[1]*3, sbs.shape[0]*3), Image.NEAREST).save(f'{SCR}/p3_sidebyside_{tag}.png')
    # per-tile match table
    pt = np.zeros((12, 15))
    for j in range(12):
        for i in range(15):
            pt[j, i] = eq[j*16:(j+1)*16, i*16:(i+1)*16].mean()
    return dict(tag=tag, scroll=(sx, sy), origin=(x0, y0), phase=ph,
                raw=float(eq.mean()), nonoverlay=float(nm),
                masked=[( list(k), v) for k, v in minfo],
                pertile=pt.tolist(), eq=eq, mask=M, world=w)


if __name__ == '__main__':
    caps = [('A', 'p3_capA_hills.png', 'dosmem_capA.bin'),
            ('B', 'p3_capB_rivers.png', 'dosmem_capB.bin'),
            ('C', 'p3_capC3_terrains.png', 'dosmem_capC3.bin'),
            ('D', 'p3_capD_features.png', 'dosmem_capD.bin'),
            ('E', 'p3_capE_majriver.png', 'dosmem_capE.bin')]
    res = []
    for tag, png, dump in caps:
        res.append(run_capture(tag, f'{SCR}/{png}', f'{SCR}/{dump}'))
    for r in res:
        print(f'--- {r["tag"]} per-tile % ---')
        for row in r['pertile']:
            print(' '.join(f'{int(round(v*100)):3d}' for v in row))
    json.dump([{k: v for k, v in r.items() if k in ('tag','scroll','origin','phase','raw','nonoverlay','masked')}
               for r in res], open(f'{SCR}/p3_fit_results.json', 'w'), indent=1)
