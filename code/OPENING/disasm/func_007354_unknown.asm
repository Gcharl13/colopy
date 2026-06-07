; ============================================================================
; func_007354_unknown
; Region   : load_image
; Bytes    : file 0x007354..0x00736E  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007354  55                    PUSH   bp ; STACK_PUSH
007355  8B EC                 MOV    bp, sp ; MOV
007357  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
00735A  32 FF                 XOR    bh, bh ; LOGIC
00735C  80 3E A8 42 03        CMP    byte ptr [0x42a8], 3 ; CMP
007361  72 03                 JB     0x7366 ; CJUMP
007363  8A 7E 0A              MOV    bh, byte ptr [bp + 0xa] ; LOCAL_LOAD
007366  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
007369  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
00736C  EB 08                 JMP    0x7376 ; JUMP
