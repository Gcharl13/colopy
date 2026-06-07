; ============================================================================
; func_030B4C_unknown
; Region   : overlay
; Bytes    : file 0x030B4C..0x030B70  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030B4C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
030B50  2B C0                 SUB    ax, ax ; ARITH
030B52  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
030B55  8B 5E 04              MOV    bx, word ptr [bp + 4] ; LOCAL_LOAD
030B58  89 07                 MOV    word ptr [bx], ax ; MOV
030B5A  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
030B5D  2D 14 00              SUB    ax, 0x14 ; ARITH
030B60  8B D0                 MOV    dx, ax ; MOV
030B62  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
030B67  EB 40                 JMP    0x30ba9 ; JUMP
030B69  90                    NOP ; NOP
030B6A  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c ; ARITH
030B6E  8B C3                 MOV    ax, bx ; MOV
