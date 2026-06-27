#!/usr/bin/env python3
"""Colony screen render v3 — CORRECT stride-3 VICEROY.PAL applied to all asset index planes."""
from PIL import Image
import json, numpy as np, os
A='lab/assets'
# correct palette
d=open('raw/COLONIZE/VICEROY.PAL','rb').read()
PAL=[]
for i in range(256): r,g,b=d[i*3],d[i*3+1],d[i*3+2]; PAL.append(((r<<2)|(r>>4),(g<<2)|(g>>4),(b<<2)|(b>>4)))
flat=[]; 
for c in PAL: flat+=list(c)
def load_indexed(kind,name):
    """load a mode-P asset PNG, re-apply correct palette, index 0 -> transparent."""
    im=Image.open(f'{A}/{kind}/{name}.png')
    if im.mode!='P': im=im.convert('P')
    trns=im.info.get('transparency')
    idx=np.asarray(im)
    rgb=Image.fromarray(idx,'P'); rgb.putpalette(flat); rgb=rgb.convert('RGB')
    a=(np.where(idx==trns,0,255).astype('uint8') if trns is not None else np.full(idx.shape,255,'uint8'))
    out=Image.merge('RGBA',(*rgb.split(),Image.fromarray(a)))
    return out, (json.load(open(f'{A}/{kind}/{name}.json')) if os.path.exists(f'{A}/{kind}/{name}.json') else None)
def fcrop(img,meta,i):
    f=meta['frames'][i]; 
    return None if f['w']==0 else img.crop((f['x'],f['y'],f['x']+f['w'],f['y']+f['h']))
def tile(C,img,meta,dx,dy,w,h):
    f=meta['frames'][0]
    t=img if (f['x']+f['w']>img.size[0] or f['y']+f['h']>img.size[1]) else fcrop(img,meta,0)
    tw,th=t.size
    for yy in range(dy,dy+h,th):
        for xx in range(dx,dx+w,tw): C.alpha_composite(t,(xx,yy))

C=Image.new('RGBA',(320,200),(0,0,0,255))
wt,wtm=load_indexed('sprites','WOODTILE'); tile(C,wt,wtm,0,0,320,200)
pa,pam=load_indexed('sprites','PARCH'); tile(C,pa,pam,4,8,204,120)
col,_=load_indexed('backgrounds','COLONY'); 
# COLONY background: index0 should NOT be transparent (it's a full bg); paste opaque
colrgb=col.convert('RGB'); C.paste(colrgb,(0,128))
bld,bldm=load_indexed('sprites','BUILDING')
PLOTS=[[56,5],[145,7],[173,10],[8,33],[37,37],[67,46],[96,45],[6,6],[128,45],[10,68],[15,94],[87,3],[66,79],[123,98],[123,47]]
for i in {2,3,4,5,6,10,12,13}:
    x,y=PLOTS[i]; fr=fcrop(bld,bldm,i)
    if fr: C.alpha_composite(fr,(x,y+8))
ico,icom=load_indexed('sprites','ICONS')
for i in range(16):
    fr=fcrop(ico,icom,0x16+i)
    if fr: C.alpha_composite(fr,(1+i*19,181))
# title via FONTTINY (correct palette too)
ft,ftm=load_indexed('fonts','FONTTINY') if os.path.exists(f'{A}/fonts/FONTTINY.png') else (None,None)
if ft is None:
    ft,ftm=load_indexed.__wrapped__ if False else (None,None)
# fallback: load font from viceroy_cpp bundle
if ft is None:
    fim=Image.open('viceroy_cpp/build/bundle/fonts/FONTTINY.png'); 
    idx=np.asarray(fim.convert('P')); rgb=Image.fromarray(idx,'P'); rgb.putpalette(flat)
    a=np.where(idx==0,0,255).astype('uint8'); ft=Image.merge('RGBA',(*rgb.convert('RGB').split(),Image.fromarray(a)))
    ftm=json.load(open('viceroy_cpp/build/bundle/fonts/FONTTINY.json'))
def text(C,s,x,y,rgb=(92,172,60)):
    cx=x
    for ch in s:
        f=ftm['frames'][ord(ch)] if ord(ch)<128 else None
        if not f or f['w']==0: cx+=4; continue
        g=ft.crop((f['x'],f['y'],f['x']+f['w'],f['y']+f['h']))
        solid=Image.new('RGBA',g.size,rgb+(255,)); C.paste(solid,(cx,y),g); cx+=g.size[0]+1
text(C,"Jamestown.  Spring, 1504.  Gold: 1000e",70,1)
C.convert('RGB').save('/tmp/mine3_native.png')
C.resize((960,600),Image.NEAREST).convert('RGB').save('docs/screens/colony_RENDERED_v3.png')
print("wrote colony_RENDERED_v3.png")
