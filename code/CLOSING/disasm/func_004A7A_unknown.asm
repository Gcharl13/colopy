; ============================================================================
; func_004A7A_unknown
; Region   : load_image
; Bytes    : file 0x004A7A..0x004A94  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004A7A  55                    PUSH   bp ; STACK_PUSH
004A7B  8B EC                 MOV    bp, sp ; MOV
004A7D  2B C0                 SUB    ax, ax ; ARITH
004A7F  50                    PUSH   ax ; STACK_PUSH
004A80  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
004A83  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
004A86  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
004A88  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004A8B  9A 2A 08 7D 03        LCALL  0x37d, 0x82a ; LCALL
004A90  8B E5                 MOV    sp, bp ; MOV
004A92  5D                    POP    bp ; STACK_POP
004A93  CB                    RETF ; RETURN
