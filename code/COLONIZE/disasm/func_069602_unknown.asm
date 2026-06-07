; ============================================================================
; func_069602_unknown
; Region   : load_image
; Bytes    : file 0x069602..0x06961F  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069602  55                    PUSH   bp                           ; UNKNOWN
069603  8B EC                 MOV    bp, sp                       ; UNKNOWN
069605  33 C0                 XOR    ax, ax                       ; UNKNOWN
069607  9A 98 02 65 5F        LCALL  0x5f65, 0x298                ; UNKNOWN
06960C  FF 36 5F 12           PUSH   word ptr [0x125f]            ; UNKNOWN
069610  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
069613  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
069616  9A 18 28 65 5F        LCALL  0x5f65, 0x2818               ; UNKNOWN
06961B  8B E5                 MOV    sp, bp                       ; UNKNOWN
06961D  5D                    POP    bp                           ; UNKNOWN
06961E  CB                    RETF                                ; UNKNOWN
