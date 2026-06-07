; ============================================================================
; func_006362_unknown
; Region   : load_image
; Bytes    : file 0x006362..0x00637C  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006362  55                    PUSH   bp ; STACK_PUSH
006363  8B EC                 MOV    bp, sp ; MOV
006365  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
006368  32 FF                 XOR    bh, bh ; LOGIC
00636A  80 3E 52 40 03        CMP    byte ptr [0x4052], 3 ; CMP
00636F  72 03                 JB     0x6374 ; CJUMP
006371  8A 7E 0A              MOV    bh, byte ptr [bp + 0xa] ; LOCAL_LOAD
006374  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
006377  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
00637A  EB 08                 JMP    0x6384 ; JUMP
