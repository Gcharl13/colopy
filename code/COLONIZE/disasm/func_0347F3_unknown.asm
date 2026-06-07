; ============================================================================
; func_0347F3_unknown
; Region   : load_image
; Bytes    : file 0x0347F3..0x034806  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0347F3  55                    PUSH   bp                           ; UNKNOWN
0347F4  8B EC                 MOV    bp, sp                       ; UNKNOWN
0347F6  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0347F9  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0347FB  FF B7 AD 3B           PUSH   word ptr [bx + 0x3bad]       ; UNKNOWN
0347FF  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
034804  C9                    LEAVE                               ; UNKNOWN
034805  CB                    RETF                                ; UNKNOWN
