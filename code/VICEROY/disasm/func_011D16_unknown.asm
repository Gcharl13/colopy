; ============================================================================
; func_011D16_unknown
; Region   : load_image
; Bytes    : file 0x011D16..0x011D30  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011D16  55                    PUSH   bp ; STACK_PUSH
011D17  8B EC                 MOV    bp, sp ; MOV
011D19  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
011D1C  32 FF                 XOR    bh, bh ; LOGIC
011D1E  80 3E B4 27 03        CMP    byte ptr [0x27b4], 3 ; CMP
011D23  72 03                 JB     0x11d28 ; CJUMP
011D25  8A 7E 0A              MOV    bh, byte ptr [bp + 0xa] ; LOCAL_LOAD
011D28  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
011D2B  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
011D2E  EB 08                 JMP    0x11d38 ; JUMP
