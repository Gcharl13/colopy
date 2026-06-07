; ============================================================================
; func_021BE5_unknown
; Region   : load_image
; Bytes    : file 0x021BE5..0x021C09  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021BE5  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
021BE9  57                    PUSH   di                           ; UNKNOWN
021BEA  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
021BED  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38]  ; UNKNOWN
021BF1  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a]  ; UNKNOWN
021BF5  8B F8                 MOV    di, ax                       ; UNKNOWN
021BF7  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
021BFA  0B D0                 OR     dx, ax                       ; UNKNOWN
021BFC  74 28                 JE     0x21c26                      ; UNKNOWN
021BFE  8E 46 FA              MOV    es, word ptr [bp - 6]        ; UNKNOWN
021C01  26 C5 5D 1E           LDS    bx, ptr es:[di + 0x1e]       ; UNKNOWN
021C05  8C D8                 MOV    ax, ds                       ; UNKNOWN
021C07  0B C3                 OR     ax, bx                       ; UNKNOWN
