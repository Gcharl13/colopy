; ============================================================================
; func_005BE2_unknown
; Region   : load_image
; Bytes    : file 0x005BE2..0x005BFF  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005BE2  55                    PUSH   bp ; STACK_PUSH
005BE3  8B EC                 MOV    bp, sp ; MOV
005BE5  33 C0                 XOR    ax, ax ; LOGIC
005BE7  9A DC 03 52 04        LCALL  0x452, 0x3dc ; LCALL
005BEC  FF 36 C7 42           PUSH   word ptr [0x42c7] ; PUSH_GLOBAL
005BF0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005BF3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005BF6  9A 90 1F 52 04        LCALL  0x452, 0x1f90 ; LCALL
005BFB  8B E5                 MOV    sp, bp ; MOV
005BFD  5D                    POP    bp ; STACK_POP
005BFE  CB                    RETF ; RETURN
