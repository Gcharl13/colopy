; ============================================================================
; func_02956D_unknown
; Region   : overlay
; Bytes    : file 0x02956D..0x029597  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02956D  C8 FE 00 00           ENTER  0xfe, 0 ; PROLOGUE
029571  EB 73                 JMP    0x295e6 ; JUMP
029573  90                    NOP ; NOP
029574  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
029577  50                    PUSH   ax ; STACK_PUSH
029578  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
02957D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029580  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
029583  50                    PUSH   ax ; STACK_PUSH
029584  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
029589  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02958C  8B B6 C8 FE           MOV    si, word ptr [bp - 0x138] ; LOCAL_LOAD
029590  D1 E6                 SHL    si, 1 ; LOGIC
029592  8B B2 C2 FE           MOV    si, word ptr [bp + si - 0x13e] ; LOCAL_LOAD
029596  8A                    DB     0x8A ; DATA_BYTE
