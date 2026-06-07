; ============================================================================
; func_051D56_unknown
; Region   : overlay
; Bytes    : file 0x051D56..0x051D73  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

051D56  55                    PUSH   bp ; STACK_PUSH
051D57  8B EC                 MOV    bp, sp ; MOV
051D59  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
051D5D  80 BF 49 31 00        CMP    byte ptr [bx + 0x3149], 0 ; CMP
051D62  74 59                 JE     0x51dbd ; CJUMP
051D64  80 BF 4C 31 0B        CMP    byte ptr [bx + 0x314c], 0xb ; CMP
051D69  75 52                 JNE    0x51dbd ; CJUMP
051D6B  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
051D6F  2A FF                 SUB    bh, bh ; ARITH
051D71  8B C3                 MOV    ax, bx ; MOV
