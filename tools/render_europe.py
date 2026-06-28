#!/usr/bin/env python3
"""Composite the Europe screen from EUROPE.png + extracted sprites + FONTTINY,
per the byte-cited layout in spec/ui/europe_screen.md. Standalone (lab is gone)."""
from PIL import Image
import json, os
B='/home/user/colopy/viceroy_cpp/build/bundle'

def load_sheet(kind,name):
    img=Image.open(f'{B}/{kind}/{name}.png').convert('RGBA')
    meta=json.load(open(f'{B}/{kind}/{name}.json'))
    return img,meta['frames']
def frame_img(img,frames,i):
    f=frames[i]; ax,ay=f.get('ax',f['x']),f.get('ay',f['y'])
    return img.crop((ax,ay,ax+f['w'],ay+f['h'])), f['w'], f['h']
def blit(canvas,img,frames,i,x,y):
    fr,w,h=frame_img(img,frames,i)
    canvas.alpha_composite(fr,(x,y))

# FONTTINY: ASCII-indexed, gray glyphs; tint to color via source-in
fimg,fframes=load_sheet('fonts','FONTTINY')
def text(canvas,s,x,y,color,gap=0):
    cx=x
    for ch in s:
        c=ord(ch)
        if c>=len(fframes): cx+=4; continue
        f=fframes[c]
        if f['w']<=0: cx+=3; continue
        ax,ay=f.get('ax',f['x']),f.get('ay',f['y'])
        g=fimg.crop((ax,ay,ax+f['w'],ay+f['h']))
        # tint: keep alpha, replace rgb with color
        px=g.load()
        for yy in range(f['h']):
            for xx in range(f['w']):
                r,gg,b,a=px[xx,yy]
                if a>40: px[xx,yy]=(color[0],color[1],color[2],255)
                else: px[xx,yy]=(0,0,0,0)
        canvas.alpha_composite(g,(cx,y))
        cx+=f['w']+gap
    return cx

C=Image.open(f'{B}/backgrounds/EUROPE.png').convert('RGBA')   # 320x200 static harbor (blue sky)

GREEN=(90,152,56); WHITE=(235,235,235); RED=(200,40,40); PRICE=(40,40,40); YELLOW=(228,200,40)
BTN_FILL=(150,178,214); BTN_HI=(198,214,236); BTN_LO=(78,100,142)

# --- woodgrain MENU BAR at top: only 7px tall (y0..6) + black separator at y7 ---
wt,wframes=load_sheet('sprites','WOODTILE')
wf,ww,wh=frame_img(wt,wframes,0)
strip=wf.crop((0,0,ww,7))                       # clip tile to the 7px bar height
for x in range(0,320,ww): C.alpha_composite(strip,(x,0))
C.alpha_composite(Image.new('RGBA',(320,1),(0,0,0,255)),(0,7))   # black separator
text(C,'London, England.  Spring, 1500.  Tax: 0%  Gold: 1000e',71,1,GREEN)

# --- market bar (no extra background): 16 ICONS good+0x16 on the harbor bg + bid/ask prices ---
iimg,iframes=load_sheet('sprites','ICONS')
prices=['0/8','5/7','4/6','4/6','4/6','1/6','5/8','9/20','2/3','9/10','10/11','12/14','14/15','1/2','1/2','2/3']
for i in range(16):
    cellx=1+i*19
    fr,w,h=frame_img(iimg,iframes,0x16+i)          # bundle frame = good+0x16 (ssdec off-by-one of EXE good+0x17)
    C.alpha_composite(fr,(cellx+(19-w)//2,180))
    p=prices[i]; pw=len(p)*4
    text(C,p,cellx+(19-pw)//2,194,(0,0,0))
text(C,'Exit',306,179,WHITE); text(C,'E',308,187,RED)

# --- RECRUIT / PURCHASE / TRAIN beveled buttons (panel 281,89,37,32) ---
def button(label,x,y,w=38,h=10):
    box=Image.new('RGBA',(w,h),(*BTN_FILL,255))
    px=box.load()
    # INVERTED bevel: shadow on top-left, highlight on bottom-right (inset look)
    for i in range(w): px[i,0]=(*BTN_LO,255); px[i,h-1]=(*BTN_HI,255)
    for j in range(h): px[0,j]=(*BTN_LO,255); px[w-1,j]=(*BTN_HI,255)
    C.alpha_composite(box,(x,y))
    cx=text(C,label[0],x+3,y+2,YELLOW)            # accelerator first letter (yellow)
    text(C,label[1:],cx,y+2,WHITE)
for r,label in enumerate(['RECRUIT','PURCHASE','TRAIN']):
    button(label,280,88+r*11)

# --- dock-status captions (green) at y120 (measured from the live capture) ---
text(C,'Expected Soon',16,120,GREEN)
text(C,'Bound For',87,120,GREEN); text(C,'New England',87,127,GREEN)
text(C,'Loading:',150,120,GREEN); text(C,'Caravel',186,120,GREEN)

C.save('/tmp/claude-0/-home-user-colopy/0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad/europe_render.png')
print('saved europe_render.png')
# MSE vs live (resized to 320x200)
live=Image.open('/home/user/colopy/docs/screens/10_europe_screen.png').convert('RGB').resize((320,200),Image.NEAREST)
lab=C.convert('RGB')
d=sum(sum((a-b)**2 for a,b in zip(live.getpixel((x,y)),lab.getpixel((x,y)))) for y in range(200) for x in range(320))
print('MSE vs live', round(d/(320*200*3),1))
