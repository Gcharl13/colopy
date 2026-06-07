; ============================================================================
; func_04F9A6_unknown
; Region   : load_image
; Bytes    : file 0x04F9A6..0x04F9D2  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F9A6  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04F9AA  FF 4E 06              DEC    word ptr [bp + 6]            ; UNKNOWN
04F9AD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04F9B0  C1 F8 03              SAR    ax, 3                        ; UNKNOWN
04F9B3  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04F9B6  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
04F9B9  80 E1 07              AND    cl, 7                        ; UNKNOWN
04F9BC  BA 01 00              MOV    dx, 1                        ; UNKNOWN
04F9BF  D3 E2                 SHL    dx, cl                       ; UNKNOWN
04F9C1  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
04F9C4  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
04F9C8  74 08                 JE     0x4f9d2                      ; UNKNOWN
04F9CA  8B D8                 MOV    bx, ax                       ; UNKNOWN
04F9CC  08 97 82 3E           OR     byte ptr [bx + 0x3e82], dl   ; UNKNOWN
04F9D0  C9                    LEAVE                               ; UNKNOWN
04F9D1  CB                    RETF                                ; UNKNOWN
