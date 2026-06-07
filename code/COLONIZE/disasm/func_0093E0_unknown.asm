; ============================================================================
; func_0093E0_unknown
; Region   : load_image
; Bytes    : file 0x0093E0..0x0093F4  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0093E0  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0093E4  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
0093E7  50                    PUSH   ax                           ; UNKNOWN
0093E8  E8 DB FF              CALL   0x93c6                       ; UNKNOWN
0093EB  0B C0                 OR     ax, ax                       ; UNKNOWN
0093ED  74 05                 JE     0x93f4                       ; UNKNOWN
0093EF  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0093F2  C9                    LEAVE                               ; UNKNOWN
0093F3  CB                    RETF                                ; UNKNOWN
