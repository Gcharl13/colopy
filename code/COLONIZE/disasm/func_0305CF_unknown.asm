; ============================================================================
; func_0305CF_unknown
; Region   : load_image
; Bytes    : file 0x0305CF..0x0305E3  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0305CF  55                    PUSH   bp                           ; UNKNOWN
0305D0  8B EC                 MOV    bp, sp                       ; UNKNOWN
0305D2  56                    PUSH   si                           ; UNKNOWN
0305D3  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c  ; UNKNOWN
0305D7  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0305DA  8A 80 90 88           MOV    al, byte ptr [bx + si - 0x7770] ; UNKNOWN
0305DE  2A E4                 SUB    ah, ah                       ; UNKNOWN
0305E0  5E                    POP    si                           ; UNKNOWN
0305E1  C9                    LEAVE                               ; UNKNOWN
0305E2  CB                    RETF                                ; UNKNOWN
