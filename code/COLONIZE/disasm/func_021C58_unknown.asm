; ============================================================================
; func_021C58_unknown
; Region   : load_image
; Bytes    : file 0x021C58..0x021C7C  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021C58  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
021C5C  57                    PUSH   di                           ; UNKNOWN
021C5D  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
021C60  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38]  ; UNKNOWN
021C64  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a]  ; UNKNOWN
021C68  8B F8                 MOV    di, ax                       ; UNKNOWN
021C6A  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
021C6D  0B D0                 OR     dx, ax                       ; UNKNOWN
021C6F  74 28                 JE     0x21c99                      ; UNKNOWN
021C71  8E 46 FA              MOV    es, word ptr [bp - 6]        ; UNKNOWN
021C74  26 C5 5D 1E           LDS    bx, ptr es:[di + 0x1e]       ; UNKNOWN
021C78  8C D8                 MOV    ax, ds                       ; UNKNOWN
021C7A  0B C3                 OR     ax, bx                       ; UNKNOWN
