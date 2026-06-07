; ============================================================================
; func_0653A6_unknown
; Region   : load_image
; Bytes    : file 0x0653A6..0x0653BF  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0653A6  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
0653AA  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0653AD  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0653B0  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0653B3  83 E3 0F              AND    bx, 0xf                      ; UNKNOWN
0653B6  A3 8A 0C              MOV    word ptr [0xc8a], ax         ; UNKNOWN
0653B9  89 1E 8C 0C           MOV    word ptr [0xc8c], bx         ; UNKNOWN
0653BD  C9                    LEAVE                               ; UNKNOWN
0653BE  CB                    RETF                                ; UNKNOWN
