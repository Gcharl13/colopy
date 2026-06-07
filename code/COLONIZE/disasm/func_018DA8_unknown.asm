; ============================================================================
; func_018DA8_unknown
; Region   : load_image
; Bytes    : file 0x018DA8..0x018DE0  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018DA8  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
018DAC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
018DAF  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
018DB4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018DB7  52                    PUSH   dx                           ; UNKNOWN
018DB8  50                    PUSH   ax                           ; UNKNOWN
018DB9  9A 1F 02 13 24        LCALL  0x2413, 0x21f                ; UNKNOWN
018DBE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
018DC1  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
018DC5  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
018DC8  2A E4                 SUB    ah, ah                       ; UNKNOWN
018DCA  48                    DEC    ax                           ; UNKNOWN
018DCB  8B 4E FE              MOV    cx, word ptr [bp - 2]        ; UNKNOWN
018DCE  83 C1 06              ADD    cx, 6                        ; UNKNOWN
018DD1  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
018DD4  89 0F                 MOV    word ptr [bx], cx            ; UNKNOWN
018DD6  83 C0 04              ADD    ax, 4                        ; UNKNOWN
018DD9  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
018DDC  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
018DDE  C9                    LEAVE                               ; UNKNOWN
018DDF  CB                    RETF                                ; UNKNOWN
