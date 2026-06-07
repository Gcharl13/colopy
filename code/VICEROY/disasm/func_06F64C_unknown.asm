; ============================================================================
; func_06F64C_unknown
; Region   : overlay
; Bytes    : file 0x06F64C..0x06F697  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F64C  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
06F650  C7 06 08 20 01 00     MOV    word ptr [0x2008], 1 ; GLOBAL_LOAD
06F656  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
06F659  89 0E B6 A5           MOV    word ptr [0xa5b6], cx ; GLOBAL_LOAD
06F65D  89 16 B4 A5           MOV    word ptr [0xa5b4], dx ; GLOBAL_LOAD
06F661  2B D2                 SUB    dx, dx ; ARITH
06F663  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
06F666  0E                    PUSH   cs ; STACK_PUSH
06F667  E8 99 01              CALL   0x6f803 ; CALL_NEAR
06F66A  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06F66D  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
06F670  0B D0                 OR     dx, ax ; LOGIC
06F672  74 16                 JE     0x6f68a ; CJUMP
06F674  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F677  50                    PUSH   ax ; STACK_PUSH
06F678  0E                    PUSH   cs ; STACK_PUSH
06F679  E8 7D 01              CALL   0x6f7f9 ; CALL_NEAR
06F67C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06F67F  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F682  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
06F685  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
06F68A  C7 06 08 20 00 00     MOV    word ptr [0x2008], 0 ; GLOBAL_LOAD
06F690  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
06F693  C9                    LEAVE ; EPILOGUE
06F694  CA 02 00              RETF   2 ; RETURN
