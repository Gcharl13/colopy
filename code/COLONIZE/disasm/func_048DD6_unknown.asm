; ============================================================================
; func_048DD6_unknown
; Region   : load_image
; Bytes    : file 0x048DD6..0x048E3D  (103 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048DD6  55                    PUSH   bp                           ; UNKNOWN
048DD7  8B EC                 MOV    bp, sp                       ; UNKNOWN
048DD9  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
048DDD  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
048DE1  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
048DE5  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
048DE9  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
048DED  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
048DF1  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
048DF5  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
048DF9  68 C8 00              PUSH   0xc8                         ; UNKNOWN
048DFC  2B C0                 SUB    ax, ax                       ; UNKNOWN
048DFE  99                    CDQ                                 ; UNKNOWN
048DFF  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
048E02  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
048E07  9A 93 37 97 1B        LCALL  0x1b97, 0x3793               ; UNKNOWN
048E0C  80 0E FE 09 20        OR     byte ptr [0x9fe], 0x20       ; UNKNOWN
048E11  A1 B4 09              MOV    ax, word ptr [0x9b4]         ; UNKNOWN
048E14  8B 16 B6 09           MOV    dx, word ptr [0x9b6]         ; UNKNOWN
048E18  A3 1C 0A              MOV    word ptr [0xa1c], ax         ; UNKNOWN
048E1B  89 16 1E 0A           MOV    word ptr [0xa1e], dx         ; UNKNOWN
048E1F  8D 1E 50 29           LEA    bx, [0x2950]                 ; UNKNOWN
048E23  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
048E26  2B D2                 SUB    dx, dx                       ; UNKNOWN
048E28  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
048E2D  A1 20 0C              MOV    ax, word ptr [0xc20]         ; UNKNOWN
048E30  8B 16 22 0C           MOV    dx, word ptr [0xc22]         ; UNKNOWN
048E34  A3 1C 0A              MOV    word ptr [0xa1c], ax         ; UNKNOWN
048E37  89 16 1E 0A           MOV    word ptr [0xa1e], dx         ; UNKNOWN
048E3B  C9                    LEAVE                               ; UNKNOWN
048E3C  CB                    RETF                                ; UNKNOWN
