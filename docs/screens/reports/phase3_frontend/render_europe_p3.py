#!/usr/bin/env python3
"""Phase-3 render-and-diff: Europe screen rebuilt from byte-cited spec + assets.

Spec: spec/ui/europe_screen.md (composer func_031E4C @0x031E4C draw order),
docs/EUROPE_SCREEN_VICEROY_DECODE.md.  Assets from col.zip (EUROPE.PIK,
ICONS.SS, WOODTILE.SS, FONTTINY.FF).  Reference: docs/screens/10_europe_screen.png
(native 320x200 = capture[29:429:2, 9:649:2], RGB565-normalized).

Everything is composed in PALETTE-INDEX space, then converted to RGB via the
EUROPE.PIK section-2 palette ((p<<2)|(p>>4), then 565 mask).
"""
import sys
sys.path.insert(0, '/home/user/colopy/tools')
sys.path.insert(0, '/home/user/colopy/docs/screens/reports/phase3_frontend')
from ssdec import madspack_load, load_sheet
from fffont import load_ff
import numpy as np
from PIL import Image

SCR = '/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad'
CZ = SCR + '/colzip'
TR = 0xFD  # sprite transparent index

# ---------------- assets ----------------
secs = madspack_load(open(CZ + '/EUROPE.PIK', 'rb').read())
img = np.frombuffer(secs[1][1], np.uint8).reshape(200, 320).copy()   # index canvas
pal6 = np.frombuffer(secs[2][1], np.uint8).reshape(256, 3).astype(int)
PAL = ((pal6 << 2) | (pal6 >> 4))
PAL565 = PAL.copy(); PAL565[:, 0] &= 0xF8; PAL565[:, 1] &= 0xFC; PAL565[:, 2] &= 0xF8

icons = load_sheet(CZ + '/ICONS.SS')['frames']
wood = load_sheet(CZ + '/WOODTILE.SS')['frames'][0]
FT_H, FT_W, FT_G = load_ff(CZ + '/FONTTINY.FF')

def blit_sprite(frame, x0, y0):
    _, _, w, h, p = frame
    a = np.frombuffer(bytes(p), np.uint8).reshape(h, w)
    for yy in range(h):
        for xx in range(w):
            v = a[yy, xx]
            if v != TR and 0 <= y0+yy < 200 and 0 <= x0+xx < 320:
                img[y0+yy, x0+xx] = v

def text_w(s):
    return sum(FT_W[ord(c)-1] for c in s)

def draw_text(s, x, y, ink, ink_first=None):
    cx = x
    for k, c in enumerate(s):
        w = FT_W[ord(c)-1]
        g = FT_G.get(c)
        col = ink_first if (k == 0 and ink_first is not None) else ink
        if g is not None:
            for r in range(FT_H):
                for cc in range(w):
                    if g[r, cc] == 1 and 0 <= y+r < 200 and 0 <= cx+cc < 320:
                        img[y+r, cx+cc] = col
        cx += w
    return cx

# ---------------- composer steps ----------------
# step 1 (@0x031E4C): play-area = EUROPE.PIK backdrop (0,8,320,192) -- already the PIK.

# header band: WOODTILE rows 0..6 tiled every 32px + black rule y=7
# (menu-bar chrome; measured A -- tile fit (ox,oy)=(0,0), 100% pixel match)
tw_, th_ = wood[2], wood[3]
wa = np.frombuffer(bytes(wood[4]), np.uint8).reshape(th_, tw_)
for x in range(0, 320):
    for y in range(0, 7):
        img[y, x] = wa[y % th_, x % tw_]
img[7, :] = 0   # black separator

# step 4 (@0x031E6B func_030F76): title banner, FONTTINY ink 68 (green),
# center-justified in set_text_box(320,7,0,0) band -> x = 160 - W/2, y = 1.
# STRING = live state read from the capture (London/England, Spring 1500,
# tax 0, gold 1000 + FONTTINY '$' gold glyph).  Segment kerning as fitted:
# 'Tax:'+'0%' adjacent (no space); 'Gold:' then number at +2 not +4.
hdr_segments = [('London, England. Spring, 1500. Tax:', None),   # then 0% etc appended manually
                ]
# compose with measured gaps: fitted absolute positions
segs = [('London, England.', 69), ('Spring, 1500.', 133), ('Tax:', 185),
        ('0%', 201), ('Gold:', 213), ('1000', 233), ('$', 249)]
W_total = 252 - 69  # ink span; center check: 160 - 183/2 = 68.5 -> 69
for s, x in segs:
    draw_text(s, x, 1, 68)

# step 3 (@0x031E63 func_0310B4): market bar.
# Bar fill/grid: already painted in EUROPE.PIK (byte rect (0,179,320,21)).
# 16 icons: engine frame good+0x17 = DISK sprite good+0x16 (RULING 2026-07-31),
# x = 1+19*i + (19-w)//2 (B stride/base; centering fitted 100%), y=181 (A).
for i in range(16):
    fr = icons[0x16 + i]
    w = fr[2]
    blit_sprite(fr, 1 + 19*i + (19 - w)//2, 181)
# prices: FONTTINY ink 0x2F=47 (B), y=194 (B, 0xC2), cell-centered (B mechanism)
prices = ['0/8','5/7','4/6','4/6','4/6','1/6','5/8','19/20',
          '2/3','9/10','10/11','11/12','14/15','1/2','1/2','2/3']  # capture state
for i, p in enumerate(prices):
    x0 = 1 + 19*i
    tw = text_w(p)
    draw_text(p, x0 + (19 - tw)//2, 194, 47)   # floor centering (fitted IoU 1.0 all 16)
# selected-good highlight (runtime state [0x9E12]=0 food): yellow idx14 1px
# outline around cell 0 (0,179)-(19,199)  [A, measured]
img[179, 0:20] = 14; img[199, 0:20] = 14
img[179:200, 0] = 14; img[179:200, 19] = 14

# Exit caption: white idx15 'Exit' at (306,179) [A measured; red E button is PIK art]
draw_text('Exit', 306, 179, 15)

# step 5 (@0x031E73 func_0314DC): dock.  6 slot sprites ICONS engine 0x7B ->
# disk 0x7A at x=147+12*slot, y=165, 10x12 (B func_0314AE)
for s in range(6):
    blit_sprite(icons[0x7A], 147 + 12*s, 165)
# dock caption 'Loading: Caravel' (state) centered in dock rect (143,118,81,60):
# x = 143 + ceil((81-60)/2) = 154, y=120, ink 69
draw_text('Loading:  Caravel', 154, 120, 69)   # two spaces; slide-fit IoU 1.0 @x154

# steps 6/7 (@0x031E7C/@0x031E85 func_0317CC/func_0318D2): the two left dock
# panels, captions centered in (1,118,70,51) and (72,118,70,51), ink 69.
# Caption literals = live sail-state text read from the capture (heap strings).
for s, x, y in [('Expected Soon', 12, 120),   # box_x+(bw-tw+2)//2 rule, fit IoU 1.0
                ('Bound For',     91, 120),
                ('New England',   87, 127)]:
    draw_text(s, x, y, 69)

# step 8 (@0x031E8D func_031DC8): RECRUIT/PURCHASE/TRAIN panel (281,89,37,32) B.
# Per-row box 37x9 at y=89+11*row (pitch 11 measured; spec glyphH+2),
# bevel: top+left idx57, bottom+right idx48, NO fill (transparent interior) [A],
# text FONTTINY centered (B @0x031C40), white idx15 + yellow idx14 accelerator [A].
for r, label in enumerate(['RECRUIT', 'PURCHASE', 'TRAIN']):
    bx, by, bw, bh = 281, 89 + 11*r, 37, 9
    img[by, bx:bx+bw] = 57          # top
    img[by:by+bh, bx] = 57          # left
    img[by+bh-1, bx+1:bx+bw] = 48   # bottom
    img[by+1:by+bh, bx+bw-1] = 48   # right
    tw = text_w(label)
    draw_text(label, bx + -(-(bw - tw)//2), by + 2, 15, ink_first=14)

# ---------------- output + diff ----------------
rgb = PAL565[img].astype(np.uint8)
Image.fromarray(rgb).save(SCR + '/europe_render_p3.png')

ref = np.asarray(Image.open(SCR + '/ref_europe_native.png')).astype(int)
d = np.abs(rgb.astype(int) - ref).sum(axis=2)

# dynamic-content masks (runtime state we intentionally do NOT render):
dyn = np.zeros((200, 320), bool)
dyn[52:66, 140:165] = True        # mouse cursor
dyn[130:170, 140:167] = True      # Caravel sprite + green selection box
dyn[135:179, 224:320] = True      # pier colonists, crates, green boxes (right)
dyn[150:179, 143:224] = True      # dock crates / planks overdraw area
water = np.zeros((200, 320), bool)
water[148:179, 0:320] = True      # animated water rows (wave sprites + cycle)

full_mae = d.mean()
struct = d.copy(); struct[dyn] = 0
print('MAE(sumRGB) full: %.2f   dynamic-masked: %.2f' % (full_mae, struct.mean()))
print('exact-match full: %.2f%%  dynamic-masked: %.2f%%  dyn+water-masked: %.2f%%'
      % ((d == 0).mean()*100, ((d == 0) | dyn).mean()*100,
         ((d == 0) | dyn | water).mean()*100))

# palette-cycle correction (capture-derived, runtime): observed displayed colors
# for the water/bar ramp indices in this frame
# NOTE idx 49 (bar grid lines) is NOT in the cycled range -- it matches the file
# palette exactly; only the water ramp 54..60 is animated in this frame.
cyc = {54: (104,136,192), 55: (88,120,184), 56: (72,100,168),
       57: (64,88,160), 58: (48,72,152), 59: (40,56,144), 60: (32,44,136)}
PALC = PAL565.copy()
for i, c in cyc.items(): PALC[i] = c
rgbc = PALC[img].astype(np.uint8)
dc = np.abs(rgbc.astype(int) - ref).sum(axis=2)
sc = dc.copy(); sc[dyn] = 0
print('with capture-observed palette-cycle state: MAE masked: %.2f  exact: %.2f%%  +water-masked: %.2f%%'
      % (sc.mean(), (((dc == 0) | dyn).mean())*100,
         (((dc == 0) | dyn | water).mean())*100))

# per-element report (on cycle-corrected, dynamic-masked diff)
elements = {
 'header band (0,0,320,8)':        (0, 0, 320, 8),
 'title text (69,1,183,6)':        (69, 1, 183, 6),
 'market icons row (0,181,320,12)':(0, 181, 320, 12),
 'price row (0,194,320,6)':        (0, 194, 320, 6),
 'sel-cell outline (0,179,20,21)': (0, 179, 20, 21),
 'buttons panel (281,89,37,32)':   (281, 89, 37, 32),
 'captions row1 (1,120,222,7)':    (1, 120, 222, 7),
 'caption row2 (72,127,70,7)':     (72, 127, 70, 7),
 'dock slots (147,165,72,12)':     (147, 165, 72, 12),
 'exit text (306,179,14,7)':       (306, 179, 14, 7),
 'sky/backdrop (0,8,320,110)':     (0, 8, 320, 110),
 'buildings (168,110,152,40)':     (168, 110, 152, 40),
}
print('%-34s %-18s %8s %8s %8s' % ('element', 'rect', 'MAE', 'ident%', 'max'))
for name, (x, y, w, h) in elements.items():
    sub = dc[y:y+h, x:x+w].copy()
    m = dyn[y:y+h, x:x+w]
    sub[m] = 0
    print('%-34s (%3d,%3d,%3d,%3d) %8.2f %7.1f%% %8d'
          % (name, x, y, w, h, sub.mean(), ((sub == 0).mean())*100, sub.max()))

# side-by-side: render | reference | heat (cycle-corrected diff, dyn in blue)
heat = np.zeros((200, 320, 3), np.uint8)
hv = np.clip(dc, 0, 255).astype(np.uint8)
heat[..., 0] = hv
heat[dyn] = [40, 40, 160]
gap = np.full((200, 4, 3), 255, np.uint8)
sbs = np.concatenate([rgb, gap, ref.astype(np.uint8), gap, heat], axis=1)
Image.fromarray(sbs).resize((sbs.shape[1]*2, 400), Image.NEAREST).save(SCR + '/europe_sidebyside.png')
print('saved europe_render_p3.png / europe_sidebyside.png')
