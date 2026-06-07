; ============================================================================
; func_0282A4_unknown
; Region   : load_image
; Bytes    : file 0x0282A4..0x0282BE  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0282A4  55                    PUSH   bp                           ; UNKNOWN
0282A5  8B EC                 MOV    bp, sp                       ; UNKNOWN
0282A7  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0282AA  A3 92 40              MOV    word ptr [0x4092], ax        ; UNKNOWN
0282AD  6B C0 4A              IMUL   ax, ax, 0x4a                 ; UNKNOWN
0282B0  83 C0 00              ADD    ax, 0                        ; UNKNOWN
0282B3  A3 8A 40              MOV    word ptr [0x408a], ax        ; UNKNOWN
0282B6  C7 06 8C 40 BE 62     MOV    word ptr [0x408c], 0x62be    ; UNKNOWN
0282BC  C9                    LEAVE                               ; UNKNOWN
0282BD  CB                    RETF                                ; UNKNOWN
