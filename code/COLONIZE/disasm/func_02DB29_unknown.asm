; ============================================================================
; func_02DB29_unknown
; Region   : load_image
; Bytes    : file 0x02DB29..0x02DB3B  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DB29  55                    PUSH   bp                           ; UNKNOWN
02DB2A  8B EC                 MOV    bp, sp                       ; UNKNOWN
02DB2C  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; UNKNOWN
02DB31  8B 87 D4 74           MOV    ax, word ptr [bx + 0x74d4]   ; UNKNOWN
02DB35  8B 97 D6 74           MOV    dx, word ptr [bx + 0x74d6]   ; UNKNOWN
02DB39  C9                    LEAVE                               ; UNKNOWN
02DB3A  CB                    RETF                                ; UNKNOWN
