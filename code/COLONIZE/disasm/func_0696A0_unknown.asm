; ============================================================================
; func_0696A0_unknown
; Region   : load_image
; Bytes    : file 0x0696A0..0x0696B5  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0696A0  55                    PUSH   bp                           ; UNKNOWN
0696A1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0696A3  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0696A6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0696A9  2B C0                 SUB    ax, ax                       ; UNKNOWN
0696AB  50                    PUSH   ax                           ; UNKNOWN
0696AC  9A 66 10 65 5F        LCALL  0x5f65, 0x1066               ; UNKNOWN
0696B1  8B E5                 MOV    sp, bp                       ; UNKNOWN
0696B3  5D                    POP    bp                           ; UNKNOWN
0696B4  CB                    RETF                                ; UNKNOWN
