#!/usr/bin/env python3
"""Colony screen render v2: + title bar via FONTTINY glyphs (the documented shared header)."""
from PIL import Image
import json
A='lab/assets'
FB='viceroy_cpp/build/bundle'
def load(kind,name,base=A):
    img=Image.open(f"{base}/{kind}/{name}.png").convert("RGBA")
    import os.path
    jp=f"{base}/{kind}/{name}.json"
    meta=json.load(open(jp)) if os.path.exists(jp) else None
    return img,meta
def fcrop(img,meta,i):
    f=meta['frames'][i]; 
    if f['w']==0: return None
    return img.crop((f['x'],f['y'],f['x']+f['w'],f['y']+f['h']))
def tile(canvas,img,meta,dx,dy,w,h):
    f=meta['frames'][0]
    t=img if (f['x']+f['w']>img.size[0] or f['y']+f['h']>img.size[1]) else fcrop(img,meta,0)
    tw,th=t.size
    for yy in range(dy,dy+h,th):
        for xx in range(dx,dx+w,tw): canvas.alpha_composite(t,(xx,yy))

# FONTTINY text — proportional; tint glyph to colour
ftI,ftM=load('fonts','FONTTINY',FB)
def text(canvas,s,x,y,rgb=(90,170,60)):
    cx=x
    for ch in s:
        g=fcrop(ftI,ftM,ord(ch)) if ord(ch)<128 else None
        if g is None: cx+=4; continue   # space / missing
        # tint: use glyph alpha as mask, fill rgb
        solid=Image.new('RGBA',g.size,rgb+(255,))
        canvas.paste(solid,(cx,y),g)   # g alpha as mask
        cx+=g.size[0]+1
    return cx

C=Image.new('RGBA',(320,200),(0,0,0,255))
wt,wtm=load('sprites','WOODTILE'); tile(C,wt,wtm,0,0,320,200)
pa,pam=load('sprites','PARCH'); tile(C,pa,pam,4,8,204,120)
col,_=load('backgrounds','COLONY'); C.alpha_composite(col,(0,128))
# building plots — Jamestown's 8 buildings (positions byte-verified DS:0x266)
bld,bldm=load('sprites','BUILDING')
PLOTS=[[56,5],[145,7],[173,10],[8,33],[37,37],[67,46],[96,45],[6,6],[128,45],[10,68],[15,94],[87,3],[66,79],[123,98],[123,47]]
for i in {2,3,4,5,6,10,12,13}:
    x,y=PLOTS[i]; fr=fcrop(bld,bldm,i)
    if fr: C.alpha_composite(fr,(x,y+8))
# stockpile bar
ico,icom=load('sprites','ICONS')
for i in range(16):
    fr=fcrop(ico,icom,0x16+i)
    if fr: C.alpha_composite(fr,(1+i*19,181))
# TITLE bar (documented shared header: colony name + season + year + gold) at top woodgrain strip
text(C,"Jamestown.  Spring, 1504.  Gold: 1000e", 70, 1, (90,170,60))
out=C.resize((960,600),Image.NEAREST).convert('RGB')
out.save('docs/screens/colony_RENDERED_v2.png')
print('wrote colony_RENDERED_v2.png')
