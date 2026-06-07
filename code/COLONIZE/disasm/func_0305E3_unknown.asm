; ============================================================================
; func_0305E3_unknown
; Region   : load_image
; Bytes    : file 0x0305E3..0x0305F8  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0305E3  55                    PUSH   bp                           ; UNKNOWN
0305E4  8B EC                 MOV    bp, sp                       ; UNKNOWN
0305E6  56                    PUSH   si                           ; UNKNOWN
0305E7  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
0305EA  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c  ; UNKNOWN
0305EE  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0305F1  88 80 90 88           MOV    byte ptr [bx + si - 0x7770], al ; UNKNOWN
0305F5  5E                    POP    si                           ; UNKNOWN
0305F6  C9                    LEAVE                               ; UNKNOWN
0305F7  CB                    RETF                                ; UNKNOWN
