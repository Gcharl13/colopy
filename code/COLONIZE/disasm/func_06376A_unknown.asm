; ============================================================================
; func_06376A_unknown
; Region   : load_image
; Bytes    : file 0x06376A..0x063791  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06376A  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
06376E  53                    PUSH   bx                           ; UNKNOWN
06376F  52                    PUSH   dx                           ; UNKNOWN
063770  50                    PUSH   ax                           ; UNKNOWN
063771  57                    PUSH   di                           ; UNKNOWN
063772  0B DB                 OR     bx, bx                       ; UNKNOWN
063774  7C 59                 JL     0x637cf                      ; UNKNOWN
063776  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
063779  3B D8                 CMP    bx, ax                       ; UNKNOWN
06377B  7D 52                 JGE    0x637cf                      ; UNKNOWN
06377D  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
063780  0B C0                 OR     ax, ax                       ; UNKNOWN
063782  7D 02                 JGE    0x63786                      ; UNKNOWN
063784  2B C0                 SUB    ax, ax                       ; UNKNOWN
063786  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
063789  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
06378C  48                    DEC    ax                           ; UNKNOWN
06378D  3B C2                 CMP    ax, dx                       ; UNKNOWN
06378F  7E 02                 JLE    0x63793                      ; UNKNOWN
