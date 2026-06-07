; ============================================================================
; func_0252B4_unknown
; Region   : load_image
; Bytes    : file 0x0252B4..0x0252CD  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0252B4  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0252B8  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
0252BB  26 8B 47 54           MOV    ax, word ptr es:[bx + 0x54]  ; UNKNOWN
0252BF  26 8B 57 56           MOV    dx, word ptr es:[bx + 0x56]  ; UNKNOWN
0252C3  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0252C6  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
0252C9  8B C2                 MOV    ax, dx                       ; UNKNOWN
0252CB  0B                    DB     0x0B                         ; UNKNOWN (raw)
0252CC  46                    DB     0x46                         ; UNKNOWN (raw)
