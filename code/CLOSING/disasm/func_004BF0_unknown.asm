; ============================================================================
; func_004BF0_unknown
; Region   : load_image
; Bytes    : file 0x004BF0..0x004C0D  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004BF0  55                    PUSH   bp ; STACK_PUSH
004BF1  8B EC                 MOV    bp, sp ; MOV
004BF3  33 C0                 XOR    ax, ax ; LOGIC
004BF5  9A D0 03 7D 03        LCALL  0x37d, 0x3d0 ; LCALL
004BFA  FF 36 71 40           PUSH   word ptr [0x4071] ; PUSH_GLOBAL
004BFE  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
004C01  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004C04  9A E0 1E 7D 03        LCALL  0x37d, 0x1ee0 ; LCALL
004C09  8B E5                 MOV    sp, bp ; MOV
004C0B  5D                    POP    bp ; STACK_POP
004C0C  CB                    RETF ; RETURN
