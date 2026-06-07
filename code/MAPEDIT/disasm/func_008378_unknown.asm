; ============================================================================
; func_008378_unknown
; Region   : load_image
; Bytes    : file 0x008378..0x00838B  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008378  55                    PUSH   bp ; STACK_PUSH
008379  8B EC                 MOV    bp, sp ; MOV
00837B  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
00837E  26 8A 1F              MOV    bl, byte ptr es:[bx] ; MOV
008381  2A FF                 SUB    bh, bh ; ARITH
008383  83 FB 06              CMP    bx, 6 ; CMP
008386  75 01                 JNE    0x8389 ; CJUMP
008388  4B                    DEC    bx ; ARITH
008389  8B C3                 MOV    ax, bx ; MOV
