import struct, numpy as np
from importlib import util
_spec=util.spec_from_file_location('ssdec','/home/user/colopy/tools/ssdec.py'); ssdec=util.module_from_spec(_spec); _spec.loader.exec_module(ssdec)

def load_ff(path):
    pay=ssdec.madspack_load(open(path,'rb').read())[0][1]
    H=pay[0]
    widths=list(pay[2:130])
    offs=list(struct.unpack_from('<128H',pay,130))
    glyphs={}
    for ch in range(1,129):
        j=ch-1; w=widths[j]
        if w==0: continue
        rowb=(w*2+7)//8
        off=offs[j]
        bmp=np.zeros((H,w),np.uint8)
        for r in range(H):
            for c in range(w):
                b=pay[off+r*rowb+(c*2)//8]
                bmp[r,c]=(b>>(6-((c*2)%8)))&3
        glyphs[chr(ch)]=bmp
    return H,widths,glyphs

def text_mask(s,widths,glyphs,H,extra=0):
    w=sum(widths[ord(c)-1]+extra for c in s)
    out=np.zeros((H,w),np.uint8)
    x=0
    for c in s:
        cw=widths[ord(c)-1]
        g=glyphs.get(c)
        if g is not None: out[:,x:x+cw]=np.maximum(out[:,x:x+cw],g)
        x+=cw+extra
    return out
