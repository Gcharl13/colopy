; ============================================================================
; func_030BB6_unknown
; Region   : overlay
; Bytes    : file 0x030BB6..0x030BDE  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030BB6  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
030BBA  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
030BBD  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
030BC0  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
030BC3  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
030BC6  2D 14 00              SUB    ax, 0x14 ; ARITH
030BC9  8B D0                 MOV    dx, ax ; MOV
030BCB  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
030BD0  EB 36                 JMP    0x30c08 ; JUMP
030BD2  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c ; ARITH
030BD6  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
030BDA  2A FF                 SUB    bh, bh ; ARITH
030BDC  8B C3                 MOV    ax, bx ; MOV
