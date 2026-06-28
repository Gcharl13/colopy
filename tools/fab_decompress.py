def fab_decompress(src, dstsize):
    assert src[:3]==b'FAB'
    shift=src[3]; assert 10<=shift<=13
    ofs_shift=16-shift; ofs_mask=(0xFF<<(shift-8))&0xFF; len_mask=(1<<ofs_shift)-1
    p=6; bitbuf=src[4]|(src[5]<<8); bits=16
    dst=bytearray(dstsize); out=0
    def bit():
        nonlocal bits,bitbuf,p
        bits-=1
        if bits==0:
            bitbuf=(((src[p]|(src[p+1]<<8))<<1)|(bitbuf&1))&0xFFFFFFFF; p+=2; bits=16
        b=bitbuf&1; bitbuf>>=1; return b
    while True:
        if bit():
            dst[out]=src[p]; out+=1; p+=1; continue
        if bit()==0:
            b1=bit(); b0=bit(); clen=((b1<<1)|b0)+2; cofs=src[p]-256; p+=1
        else:
            cofs=((((src[p+1]>>ofs_shift)|ofs_mask)<<8)|src[p])-0x10000
            clen=src[p+1]&len_mask; p+=2
            if clen==0:
                clen=src[p]; p+=1
                if clen==0: break
                if clen==1: continue
                clen+=1
            else: clen+=2
        while clen>0:
            dst[out]=dst[out+cofs]; out+=1; clen-=1
    return bytes(dst[:out])
