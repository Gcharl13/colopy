; ============================================================================
; func_06575F_unknown
; Region   : load_image
; Bytes    : file 0x06575F..0x065778  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06575F  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
065763  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
065766  89 1E B4 0C           MOV    word ptr [0xcb4], bx         ; UNKNOWN
06576A  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
06576D  A3 B6 0C              MOV    word ptr [0xcb6], ax         ; UNKNOWN
065770  8B 16 AA 0C           MOV    dx, word ptr [0xcaa]         ; UNKNOWN
065774  F7 E2                 MUL    dx                           ; UNKNOWN
065776  03 C3                 ADD    ax, bx                       ; UNKNOWN
