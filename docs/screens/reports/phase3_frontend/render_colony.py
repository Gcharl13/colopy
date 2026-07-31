#!/usr/bin/env python3
"""Phase-3 render-and-diff: COLONY SCREEN rebuilt from spec/ui/colony_screen.md
+ original assets + RNG-replayed building placement (func_025D34).

Reference: docs/screens/colony_live_1505.png (native 320x200, Jamestown, Spring 1505).

Tier legend used in comments:
  [B]   byte-cited in spec (func @offset)
  [RNG] reproduced by replaying the byte-cited placement RNG (seed fitted, see report)
  [CAP] runtime state reconstructed from the capture (flagged assumption)
  [TBD] runtime content not reproducible from static assets (left unrendered)
"""
import sys, struct
sys.path.insert(0, '/home/user/colopy/tools')
sys.path.insert(0, '/home/user/colopy/docs/screens/reports/phase3_frontend')
from ssdec import load_sheet, madspack_load
from fffont import load_ff, text_mask
import numpy as np
from PIL import Image

SCR = '/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad'
A = SCR + '/assets'

# ---------------- palette (VICEROY.PAL, stride-3, 6bit -> (v<<2)|(v>>4)) [B: DO-NOT-REGRESS 0.6.2]
pal6 = np.frombuffer(open(A+'/VICEROY.PAL','rb').read()[:768], np.uint8).reshape(256,3).astype(int)
pal8 = ((pal6<<2)|(pal6>>4)).astype(np.uint8)

def frames(sheet):
    sh = load_sheet(A+'/'+sheet)
    out=[]
    for (fx,fy,w,h,px) in sh['frames']:
        out.append(np.frombuffer(bytes(px),np.uint8).reshape(h,w))
    return out
IC  = frames('ICONS.SS')
BLD = frames('BUILDING.SS')
WT  = frames('WOODTILE.SS')[0]          # 32x24 wood tile

img = np.zeros((200,320), np.uint8)     # palette-index canvas

def blit(a, x, y):
    h,w = a.shape
    for yy in range(h):
        for xx in range(w):
            v = a[yy,xx]
            if v != 0xFD and 0 <= y+yy < 200 and 0 <= x+xx < 320:
                img[y+yy, x+xx] = v

def find_pal(rgb):
    d = np.abs(pal8.astype(int) - np.array(rgb)).sum(axis=1)
    return int(d.argmin())

# ============ RNG replay of building placement (func_025D34) ============ [B]+[RNG]
COUNT=[7,4,2,1,1]; BASE=[0,7,11,13,14]                      # 0x224/0x22A [B]
CAT_FLAT=[c for c in range(5) for _ in range(COUNT[c])]     # 0x8D62 [B]
class RNG:                                                   # srand@0x103C2 / rand@0x103D4 [B]
    def __init__(s, seed16): s.state = seed16 & 0xFFFF       # srand keeps LOW WORD only [B]
    def rand(s):
        s.state = (s.state*0x343FD + 0x269EC3) & 0xFFFFFFFF
        return (s.state >> 16) & 0x7FFF
    def ri(s, lo, hi): return lo + ((s.rand()*(hi-lo+1)) >> 15)   # func_00C322 [B]
GROUP = {0:0,1:0,2:0,3:1,4:1,5:1,6:2,7:2,8:2,9:3,10:3,11:3,30:3,31:3,
         12:4,13:4,14:4,15:5,16:5,17:5,18:6,19:7,20:7,21:8,22:8,23:8,
         24:9,25:9,26:9,27:10,28:10,29:10,32:11,33:11,34:11,35:12,36:12,
         37:13,38:13,39:14,40:14,41:14}                     # registration block @0x0746BC [B]
COL3  = [3,3,3,1,1,1,4,4,4,2,2,2,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,0,1,1,2,2,0,0,0]
                                                            # NAMES @BUILDING col3 -> 0x8F87 [B]
def group_slots():
    slots={}; ctr=[0]*5
    for gid in range(42):
        g=GROUP[gid]
        if g not in slots:
            c=COL3[gid]; slots[g]=BASE[c]+ctr[c]; ctr[c]+=1
    return slots
GS = group_slots()
HAVE=[32,27,39,24,21,35,9]        # colony building set [CAP: RAM-doc 0x8E82]
SEED = 12002                       # fitted: see RNG-replay report ([0x8D80] term nonzero)
def place(seed16):
    r=RNG(seed16); T=[-1]*15
    for i in range(15):
        cat=CAT_FLAT[i]
        while True:
            p=BASE[cat]+r.ri(0,COUNT[cat]-1)
            if T[p]<0: break
        T[p]=i
    E=[-1]*15
    for gid in range(42):
        if gid in HAVE or gid==0:                 # id==0 forced @0x25E70 [B]
            E[T[GS[GROUP[gid]]]]=gid
    return E
E = place(SEED)
# plot positions: DS:0x266 table values as printed in spec 0.2 [B]
PLOTPOS=[(56,13),(145,15),(173,18),(8,41),(37,45),(67,54),(96,53),(6,14),
         (128,53),(10,76),(15,102),(87,11),(66,87),(123,106),(123,55)]
EMPTY_FRAME={0:44,1:43,2:42,3:None,4:45}          # DS:0x260[cat]-1 [B]

# ================= compose (order per func_028592) =================
# step 4 visible state: full-screen wood pattern = WOODTILE.SS tiled from (0,0)
# [B mechanism (func_02633E) / tile identity+phase pixel-verified this pass]
for y in range(200):
    for x in range(320):
        img[y,x] = WT[y%24, x%32]
# title bar separator row y=7 black + town/panel separator y=128 black [CAP]
BLACK = find_pal((0,0,0))
img[7,:]=BLACK
img[128,:]=BLACK

# town ground (0,8,200,120): sand dither [CAP approximation - runtime scene fill]
sand_cols = [find_pal(c) for c in ((235,219,162),(243,231,182),(231,203,146))]
rs = np.random.RandomState(7)
for y in range(8,128):
    for x in range(0,200):
        img[y,x] = sand_cols[rs.choice(3, p=[.45,.35,.2])]

# ---- buildings loop func_02701C (composer step 12; drawn before we add panel art) ----
# blit anchor = table (x,y) EXACTLY (pixel-verified; spec's "+8" note NOT applied - finding)
for p in range(15):
    x,y = PLOTPOS[p]
    d = E[p]
    if d<0:
        fr = EMPTY_FRAME[CAT_FLAT[p]]
        if fr is None: continue
    elif d==0:
        fr = 16                                   # def0+query0==0 -> 0x11 EXE = disk 16 [B]
    else:
        fr = d                                    # frame=def_id+1 EXE = disk def_id [B]
    blit(BLD[fr], x, y)

# carpenter working overlays [B vs image, spec 0.4]
blit(IC[81], 42, 111)                             # working colonist ICONS 81
GREEN = find_pal((85,255,85))
def rect_outline(x0,y0,x1,y1,c):
    img[y0,x0:x1+1]=c; img[y1,x0:x1+1]=c; img[y0:y1+1,x0]=c; img[y0:y1+1,x1]=c
rect_outline(39,112,50,127,GREEN)                 # selection box [B vs image]
for hx in (15,22,29):                             # 3 hammers under roof, y=104 pitch 7
    blit(IC[54], hx, 104)                         # [CAP fit MSE-0; spec 0.4 said x=15/21/27 y103 - off by 1]

# ---- scene/field-production panel (224,32,72,72) fill @0x0264E9 [B rect] ----
img[31,223:297]=BLACK; img[104,223:297]=BLACK     # 1px frame [CAP]
img[31:105,223]=BLACK; img[31:105,296]=BLACK
water = find_pal((40,56,146))
img[32:104,224:296]=water                         # interior = runtime terrain [TBD, flat fill]
blit(IC[108], 232, 60)                            # worked-tile markers [CAP fit MSE-0]
blit(IC[108], 232, 84)
WHITE = find_pal((255,255,255))
rect_outline(248,56,271,79,WHITE)                 # production box [CAP measured]
for k,cx in enumerate((250,255,260,265)):         # 4-corn strip (0x181F:0x236) [B primitive/CAP fit]
    blit(IC[22], cx, 58)

# ---- COLONY.PIK strip at (0,128) [B asset; y pixel-verified 128, PIK row0 is the black rule] ----
pik = np.frombuffer(madspack_load(open(A+'/COLONY.PIK','rb').read())[1][1], np.uint8).reshape(72,320)
img[128:200,:] = pik[:72,:]
img[128,:] = BLACK    # 1px black rule over PIK row0 (capture; town/band separator) [CAP]

# ---- plaza-row / SoL band contents (left panel) [B vs image / CAP positions] ----
blit(IC[81], 2, 142)                              # colonist
blit(IC[102], 16, 142)                            # soldier
rect_outline(1,143,10,158,GREEN)                  # unit selection box [CAP]
for cx in (2,10,21,29):                           # 4-corn production strip [CAP fit MSE-0]
    blit(IC[22], cx, 163)
blit(IC[56], 40, 163)                             # cross
blit(IC[62], 52, 163)                             # liberty bell
blit(IC[124], 104, 132)                           # SoL crown

# ---- middle (dock) panel: 6 cargo crates = ICONS 0x7B EXE = disk 122 [B sprite id] ----
for k in range(6):
    blit(IC[122], 127+12*k, 165)

# ---- right panel goods [B vs image / CAP positions] ----
blit(IC[23], 213, 134); blit(IC[23], 222, 134)    # 2 warehouse-top goods (sugar)
for gx in (213,224,235):                          # lumber shortage + red X [B sprites]
    blit(IC[27], gx, 162); blit(IC[55], gx, 162)
for gx in (249,258,267):                          # hammer shortage + red X
    blit(IC[54], gx, 162); blit(IC[55], gx, 162)

# ---- flag/tool-button panel (303,132,17,45) [B rect] ----
navy = find_pal((65,89,166)); dnavy = find_pal((8,8,109))
for k,(yk, icf, ix, iy) in enumerate(((132,67,304,133),(147,68,303,147),(162,69,303,162))):
    img[yk:yk+15, 303:319]=navy                   # per-button navy pad [CAP approx]
    img[yk,303:317]=dnavy                         # dark accent top [CAP approx]
    blit(IC[icf], ix, iy)                         # button face [CAP fit MSE-0]

# ---- panel outlines: lightened 1px frames (0x181F:0xE2 frame sprite) [B mechanism/CAP pixels]
def lighten(v):
    r,g,b = pal8[v].astype(int)
    return find_pal((min(255,int(r*1.35)+25), min(255,int(g*1.28)+20), min(255,int(b*1.15)+15)))
def light_rect(x0,y0,x1,y1):
    for x in range(x0,x1+1):
        img[y0,x]=lighten(img[y0,x]); img[y1,x]=lighten(img[y1,x])
    for y in range(y0,y1+1):
        img[y,x0]=lighten(img[y,x0]); img[y,x1]=lighten(img[y,x1])
light_rect(0,130,119,177)                         # left panel (0,130,120,48) [B]
light_rect(121,130,205,177)                       # middle panel (121,130,84,48) [B]
light_rect(207,130,301,177)                       # right panel (measured 207; spec says 211) [CAP]

# ---- stockpile bar contents (func_0281D6) ----
# icons y=181, 16 cells pitch 19 (0x13) [B]; measured centered x per icon width
ICON_X=[7,25,44,62,82,100,119,138,156,178,196,215,234,253,272,292]
for g in range(16):
    blit(IC[22+g], ICON_X[g], 181)
# qty digits '0' centered, dark navy [CAP colour; spec 0.3]
FT_H, FT_W, FT_G = load_ff(A+'/FONTTINY.FF')
NAVY = find_pal((24,28,125))
def draw_text(s, x, y, ink, shadow=None):
    m = text_mask(s, FT_W, FT_G, FT_H)
    h,w = m.shape
    for yy in range(h):
        for xx in range(w):
            v = m[yy,xx]
            if v==0: continue
            c = ink if v==1 else (shadow if shadow is not None else None)
            if c is None: continue
            if 0<=y+yy<200 and 0<=x+xx<320:
                img[y+yy,x+xx]=c
for i in range(16):
    draw_text('0', 9+19*i, 194, NAVY)
rect_outline(0,179,19,199,GREEN)                  # selected-cell box [CAP]
draw_text('Exit', 306, 179, WHITE, find_pal((28,109,16)))  # (306,179) [B pos; text per capture]

# ---- texts ----
TGREEN = find_pal((85,150,52))
for s,x in [('Jamestown.',90),('Spring,',139),('1505.',167),('Gold:',191),('1000',211),('$',227)]:
    draw_text(s, x, 1, TGREEN)                    # title FONTTINY green [B chain; origin CAP]
                                                  # '$' = money-formatter currency glyph (fit IoU 1.0)
draw_text('100% (1)', 74, 133, WHITE, find_pal((12,12,12)))  # [B vs image]
DKBLUE = find_pal((65,89,166))
draw_text('No Ships In Port', 136, 132, DKBLUE)   # centered caption [B string; pos fit]

# ================= output & diff =================
rgb = pal8[img]
Image.fromarray(rgb).save(SCR+'/colony_render.png')
ref = np.asarray(Image.open('/home/user/colopy/docs/screens/colony_live_1505.png')).astype(int)
d = np.abs(rgb.astype(int)-ref).sum(axis=2)
print('GLOBAL: identical %.2f%%  MAE %.2f' % ((d==0).mean()*100, d.mean()))

ELEMENTS = {
 'title strip (0,0,320,8)':            (0,0,320,8),
 'wood fill sample (200,8,23,120)':    (200,8,23,120),
 'town buildings bbox (0,8,200,120)':  (0,8,200,120),
 'scene panel (223,31,74,74)':         (223,31,74,74),
 'bottom band PIK (0,129,320,71)':     (0,129,320,71),
 'left panel (0,130,120,48)':          (0,130,120,48),
 'middle panel (121,130,84,48)':       (121,130,84,48),
 'right panel (207,130,95,48)':        (207,130,95,48),
 'button panel (302,131,18,47)':       (302,131,18,47),
 'stockpile bar (0,179,320,21)':       (0,179,320,21),
}
for name,(x,y,w,h) in ELEMENTS.items():
    sub = d[y:y+h, x:x+w]
    print('  %-38s ident %5.1f%%  MAE %6.2f' % (name,(sub==0).mean()*100,sub.mean()))
# per-plot building check
bld_sh = load_sheet(A+'/BUILDING.SS')
for p in range(15):
    x,y = PLOTPOS[p]
    dd = E[p]
    fr = 16 if dd==0 else (dd if dd>0 else EMPTY_FRAME[CAT_FLAT[p]])
    if fr is None: continue
    h,w = BLD[fr].shape
    m = BLD[fr]!=0xFD
    sub = d[y:y+h, x:x+w]
    if sub.shape != m.shape: m = m[:sub.shape[0],:sub.shape[1]]
    print('  plot %2d frame %2d at (%3d,%3d): ident-on-sprite %5.1f%%' %
          (p, fr, x, y, (sub[m]==0).mean()*100))

# side-by-side
heat = np.zeros((200,320,3), np.uint8)
hv = np.clip(d,0,255).astype(np.uint8)
heat[...,0]=hv; heat[...,1]=hv//4
gap = np.full((200,4,3),255,np.uint8)
sbs = np.concatenate([rgb, gap, ref.astype(np.uint8), gap, heat], axis=1)
Image.fromarray(sbs).resize((sbs.shape[1]*2, 400), Image.NEAREST).save(SCR+'/colony_sidebyside.png')
print('saved colony_render.png / colony_sidebyside.png')
