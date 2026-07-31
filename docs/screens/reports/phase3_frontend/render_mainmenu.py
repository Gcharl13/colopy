import numpy as np, struct
from PIL import Image
from fffont import load_ff, ssdec

# ---------- assets ----------
secs=ssdec.madspack_load(open('assets/OPENMENU.PIK','rb').read())
_,pix,pal6=[s for _,s in secs]
bg_idx=np.frombuffer(pix,dtype=np.uint8).reshape(200,320).copy()
p6=np.array(list(pal6),dtype=np.int32).reshape(256,3)
PAL=(p6<<2).astype(np.uint8)          # 6-bit -> 8-bit, <<2 (matches capture pipeline)

H,widths,glyphs=load_ff('assets/FONTTINY.FF')

def sheet_tile(path):
    sh=ssdec.load_sheet(path)
    x,y,w,h,px=sh['frames'][0]
    return np.frombuffer(bytes(px),dtype=np.uint8).reshape(h,w)
WOODTILE=sheet_tile('assets/WOODTILE.SS')
OPENTILE=sheet_tile('assets/OPENTILE.SS')

def nearest(rgb):
    d=((p6*4-np.array(rgb))**2).sum(axis=1)
    return int(np.argmin(d))
GREEN=nearest((82,138,49))    # 0xFE per mr_color_for scan
GOLD_SPEC=nearest((227,170,40))   # 0x54 per spec
BAR=nearest((56,32,16))       # 0x37
OUTLINE_SPEC=nearest((20,12,6))   # 0xF3
GOLD_OBS=0xFC                 # observed title gold (finding)
print('resolved idx: green',hex(GREEN),'gold',hex(GOLD_SPEC),'bar',hex(BAR),'outline',hex(OUTLINE_SPEC))

TITLE="{COLONIZATION} Version 3.0 -- 7-Feb-95"   # GAME.TXT line 35 + EXE strings @0x1E1BC
ITEMS=["Start a Game in NEW WORLD","Start a Game in AMERICA","CUSTOMIZE New World","LOAD Game","View Hall of Fame"]

def draw_text(img,s,x,y,color,gold=None):
    cx=x
    seg_gold=False
    for ch in s:
        if ch=='{': seg_gold=True; continue
        if ch=='}': seg_gold=False; continue
        w=widths[ord(ch)-1]
        g=glyphs.get(ch)
        if g is not None:
            col=gold if (seg_gold and gold is not None) else color
            for r in range(H):
                for c in range(w):
                    if g[r,c]:
                        yy,xx=y+r,cx+c
                        if 0<=yy<200 and 0<=xx<320: img[yy,xx]=col
        cx+=w
    return cx

def base_bg():
    idx=bg_idx.copy()
    # byte-cited color remaps @0x075B8E/@0x075BB0/@0x075BD2 (find->replace)
    idx[idx==7]=6; idx[idx==8]=9; idx[idx==15]=14
    return idx

def tile_fill(img,tile,x0,y0,x1,y1,ax,ay):
    th,tw=tile.shape
    ys=np.arange(y0,y1); xs=np.arange(x0,x1)
    img[y0:y1,x0:x1]=tile[(ys[:,None]-ay)%th,(xs[None,:]-ax)%tw]

def render_strict():
    img=base_bg()
    X,Y,W,Hh=75,91,170,64          # W per dialog spec formula 160+2*3+4; H assumption (pitch model)
    img[Y:Y+Hh,X:X+W]=0
    tile_fill(img,WOODTILE,X+1,Y+1,X+W-1,Y+Hh-1,X,Y)   # menus.md §3: WOODTILE tiled
    # outline 1px (thickness assumption) color (20,12,6)->nearest
    img[Y,X:X+W]=OUTLINE_SPEC; img[Y+Hh-1,X:X+W]=OUTLINE_SPEC
    img[Y:Y+Hh,X]=OUTLINE_SPEC; img[Y:Y+Hh,X+W-1]=OUTLINE_SPEC
    tx,ty=X+3+2,Y+3+2              # border+inset
    draw_text(img,TITLE,tx,ty,GREEN,gold=GOLD_SPEC)
    pitch=H+3                      # dialog spec row pitch = glyph_height+border = 9
    # selection bar on item 0 (selected), then gold text per menus.md §3
    bar_y=ty+pitch-1
    img[bar_y:bar_y+pitch-1, X+3:X+3+160]=BAR
    for i,it in enumerate(ITEMS):
        yy=ty+pitch*(i+1)
        draw_text(img,it,tx,yy,GOLD_SPEC if i==0 else GREEN)
    return img

def render_corrected():
    img=base_bg()
    X,Y,W,Hh=77,91,166,58          # W=@width+2*border (measured); Y=@y=91
    img[Y:Y+Hh,X:X+W]=0            # outline drawn black (observed; spec RGB refuted)
    tile_fill(img,OPENTILE,X+1,Y+1,X+W-1,Y+Hh-1,X,Y)   # OPENTILE anchored at box origin
    draw_text(img,TITLE,X+5,Y+6,GREEN,gold=GOLD_OBS)
    img[106:113,79:239]=BAR        # measured bar rect
    for i,it in enumerate(ITEMS):
        draw_text(img,it,X+9,107+8*i,GREEN)
    return img

strict=render_strict(); corr=render_corrected()
Image.fromarray(PAL[strict]).save('mainmenu_render_strict.png')
Image.fromarray(PAL[corr]).save('mainmenu_render.png')

# ---------- diff vs reference ----------
ref=np.array(Image.open('reference_320.png').convert('RGB')).astype(int)
def diff(rimg):
    rgb=PAL[rimg].astype(int)
    d=np.abs(rgb-ref).max(axis=2)
    return rgb,d
srgb,sd=diff(strict); crgb,cd=diff(corr)
TOL=6   # absorbs the capture's fade/truncation palette artifact (max -4 per channel)
cursor=np.zeros((200,320),bool); cursor[94:118,150:172]=True
print('strict: within-tol %.2f%%  (excl cursor %.2f%%)'%(100*(sd<=TOL).mean(),100*(sd[~cursor]<=TOL).mean()))
print('corr  : within-tol %.2f%%  (excl cursor %.2f%%)'%(100*(cd<=TOL).mean(),100*(cd[~cursor]<=TOL).mean()))

# per-element rects (corrected-frame coordinates)
els={
 'background (outside box)': (0,0,320,200,'outside'),
 'box outline top/bottom/sides': None,
 'wood fill strip y92-96': (78,92,242,97,None),
 'wood fill strip y113-122 (between rows)': (78,113,242,123,None),
 'wood fill bottom y144-147': (78,144,242,148,None),
 'title row y96-102': (78,96,242,103,None),
 'selection bar y106-112': (79,106,239,113,None),
 'item1 text y107-112': (86,107,178,113,None),
 'item2 text y115-120': (86,115,170,121,None),
 'item3 text y123-128': (86,123,162,129,None),
 'item4 text y131-136': (86,131,122,137,None),
 'item5 text y139-144': (86,139,146,145,None),
}
print('\nper-element (corrected render): % pixels within tol (cursor excluded)')
box=np.zeros((200,320),bool); box[91:149,77:243]=True
for name,spec in els.items():
    if name.startswith('background'):
        mask=(~box)&(~cursor)
    elif spec is None:
        mask=np.zeros((200,320),bool)
        mask[91,77:243]=True; mask[148,77:243]=True; mask[91:149,77]=True; mask[91:149,242]=True
        mask&=~cursor
    else:
        x0,y0,x1,y1,_=spec
        mask=np.zeros((200,320),bool); mask[y0:y1,x0:x1]=True; mask&=~cursor
    print(f'  {name:42s} {100*(cd[mask]<=TOL).mean():6.2f}%   n={mask.sum()}')

# side-by-side: strict | corrected | reference | heat(corr)
heat=np.zeros((200,320,3),np.uint8)
hv=np.clip(cd*4,0,255).astype(np.uint8)
heat[:,:,0]=hv; heat[:,:,2]=np.where(cursor,128,0)
sep=np.full((200,4,3),255,np.uint8)
panel=np.concatenate([PAL[strict],sep,PAL[corr],sep,ref.astype(np.uint8),sep,heat],axis=1)
panel=np.kron(panel,np.ones((2,2,1),np.uint8))
Image.fromarray(panel).save('mainmenu_sidebyside.png')
