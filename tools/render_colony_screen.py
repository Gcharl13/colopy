#!/usr/bin/env python3
"""Render the Jamestown colony screen from RAW assets (ssdec) + the live snapshot data.
Uses the byte-verified decoders (ssdec.load_sheet for .SS, FAB for .PIK) and VICEROY.PAL
stride-3, NOT the mis-extracted lab/assets. Compares to docs/screens/11_colony_screen.png."""
import sys, struct, numpy as np
sys.path.insert(0,'tools')
from ssdec import load_sheet, madspack_load, fab_decompress
from PIL import Image, ImageDraw

RAW='raw/COLONIZE'
# global palette (stride-3 RGB, 6-bit->8-bit)
pd=open(f'{RAW}/VICEROY.PAL','rb').read()
GPAL=[((pd[i*3+c]<<2)|(pd[i*3+c]>>4)) for i in range(256) for c in range(3)]

def ss_frame(sheet, k, pal=None):
    pal=pal or sheet['pal']
    x,y,w,h,pix=sheet['frames'][k]
    if w==0 or h==0: return None
    arr=np.frombuffer(bytes(pix),np.uint8).reshape(h,w)
    out=np.zeros((h,w,4),np.uint8)
    for i in range(256):
        if i==0xFD: continue
        out[arr==i]=[pal[i*3],pal[i*3+1],pal[i*3+2],255]
    return Image.fromarray(out)

def pik(name):  # full-screen or band PIK -> RGB (uses its own palette if present, else global)
    d=open(f'{RAW}/{name}.PIK','rb').read()
    secs=madspack_load(d)
    # find pixel section (== w*h) and palette section (>=768)
    # header section 0 has dims; simplest: last big section is pixels
    pixsec=max(secs,key=lambda s:len(s[1]))[1]
    # COLONY.PIK is 320x72
    palsec=[s for s in secs if len(s[1])>=768 and s is not max(secs,key=lambda s:len(s[1]))]
    pal=GPAL
    arr=np.frombuffer(pixsec,np.uint8)
    h=len(arr)//320; arr=arr[:h*320].reshape(h,320)
    rgb=np.zeros((h,320,3),np.uint8)
    for i in range(256): rgb[arr==i]=[pal[i*3],pal[i*3+1],pal[i*3+2]]
    return Image.fromarray(rgb)

# --- Jamestown data from snapshot ---
snap=open('/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad/dbx/colony_jamestown.bin','rb').read()
dg=snap.find(b'UNIT\x00ORDERS\x00ACTIONS\x00')-0x2258
u16=lambda o: struct.unpack_from('<H',snap,dg+o)[0]
s8 =lambda o: snap[dg+o]-256 if snap[dg+o]>=128 else snap[dg+o]
plots=[(u16(0x266+i*4),u16(0x268+i*4),s8(0x8E82+i)) for i in range(15)]
cat =[snap[dg+0x8D62+i] for i in range(15)]                 # per-plot category (func_02701C @0x027095)
featframe=[snap[dg+0x260+i] for i in range(6)]              # DS:0x260 cat->terrain-frame table (func_026FF2)
cp=u16(0x8542); stock=[struct.unpack_from('<H',snap,dg+cp+0x9a+i*2)[0] for i in range(16)]

C=Image.new('RGBA',(320,200),(0,0,0,255))
# woodgrain chrome
wood=load_sheet(f'{RAW}/WOODTILE.SS'); wt=ss_frame(wood,0)
for yy in range(0,200,wt.height):
    for xx in range(0,320,wt.width): C.alpha_composite(wt,(xx,yy))
# parchment scene inset (measured x0..198, y8..127)
par=load_sheet(f'{RAW}/PARCH.SS'); pt=ss_frame(par,0)
for yy in range(8,128,pt.height):
    for xx in range(0,200,pt.width): C.alpha_composite(pt,(xx,yy))
# plot grid (func_02701C): empty plots draw a terrain decoration from the DS:0x260[cat]
# frame table (func_026FF2, skip when 0); occupied plots draw the building (func_026DD4).
# Both blit BUILDING.SS frames at (plotX, plotY+8).
bld=load_sheet(f'{RAW}/BUILDING.SS')
for i,(x,y,defid) in enumerate(plots):
    if defid<0:
        f=featframe[cat[i]]                    # empty plot: terrain frame = table[category]
        if f and f<bld['nframes']:
            fr=ss_frame(bld,f)
            if fr: C.alpha_composite(fr,(x,y+8))
    elif defid<bld['nframes']:                  # occupied plot: building
        fr=ss_frame(bld,defid)
        if fr: C.alpha_composite(fr,(x,y+8))
# COLONY.PIK bottom band at y=128
C.paste(pik('COLONY'),(0,128))
# stockpile icons: ICONS.SS frame good+0x17 at x=1+i*19; + numbers
icons=load_sheet(f'{RAW}/ICONS.SS')
ft=load_sheet(f'{RAW}/FONTTINY.FF') if False else None
def tfont():
    # FONTTINY is .FF not .SS; fall back to bundle png glyphs
    import json
    im=Image.open('viceroy_cpp/build/bundle/fonts/FONTTINY.png'); idx=np.asarray(im.convert('P'))
    rgb=Image.fromarray(idx,'P'); rgb.putpalette(GPAL); rgb=rgb.convert('RGBA')
    a=np.where(idx==im.info.get('transparency',253),0,255).astype('uint8'); rgb.putalpha(Image.fromarray(a))
    return rgb, json.load(open('viceroy_cpp/build/bundle/fonts/FONTTINY.json'))
fimg,fmeta=tfont()
def text(s,x,y,rgb=(92,172,60)):
    cx=x
    for ch in s:
        f=fmeta['frames'][ord(ch)] if ord(ch)<128 else None
        if not f or f['w']==0: cx+=4; continue
        g=fimg.crop((f['x'],f['y'],f['x']+f['w'],f['y']+f['h']))
        solid=Image.new('RGBA',g.size,rgb+(255,)); C.paste(solid,(cx,y),g); cx+=g.size[0]+1
for i in range(16):
    fr=ss_frame(icons,0x17+i)
    if fr:
        cx=1+i*19+(18-fr.width)//2; C.alpha_composite(fr,(cx,181))
    # quantity number under icon (y~? the real shows number below icon). draw qty
    text(str(stock[i]),1+i*19+2,191,(255,255,255))
# Title from the SNAPSHOT (not hardcoded): colony name @ record+0x02, pop @ +0x1F.
# NOTE: this snapshot is a freshly-founded pop-1 colony (SoL 0%), which is NOT the same
# game-state as docs/screens/11_colony_screen.png (a developed colony, SoL "100% (I)").
cname=snap[dg+cp+0x02:snap.find(b'\x00',dg+cp+0x02)].decode('latin1','replace')
cpop=snap[dg+cp+0x1f]
text(f"{cname}  (pop {cpop}, founding snapshot)",70,1)
C.convert('RGB').save('/tmp/mine_final.png')
C.resize((960,600),Image.NEAREST).convert('RGB').save('docs/screens/colony_RENDERED.png')
print("wrote colony_RENDERED.png")
