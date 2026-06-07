; ============================================================================
; func_0410F0_unknown
; Region   : load_image
; Bytes    : file 0x0410F0..0x041119  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0410F0  55                    PUSH   bp                           ; UNKNOWN
0410F1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0410F3  FF 36 8E 0B           PUSH   word ptr [0xb8e]             ; UNKNOWN
0410F7  FF 36 8C 0B           PUSH   word ptr [0xb8c]             ; UNKNOWN
0410FB  FF 36 8A 0B           PUSH   word ptr [0xb8a]             ; UNKNOWN
0410FF  FF 36 88 0B           PUSH   word ptr [0xb88]             ; UNKNOWN
041103  6A 01                 PUSH   1                            ; UNKNOWN
041105  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
041108  50                    PUSH   ax                           ; UNKNOWN
041109  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04110C  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
04110F  BB 01 00              MOV    bx, 1                        ; UNKNOWN
041112  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
041117  C9                    LEAVE                               ; UNKNOWN
041118  CB                    RETF                                ; UNKNOWN
