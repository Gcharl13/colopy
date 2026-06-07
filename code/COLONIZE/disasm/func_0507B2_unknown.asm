; ============================================================================
; func_0507B2_unknown
; Region   : load_image
; Bytes    : file 0x0507B2..0x0507D0  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0507B2  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
0507B6  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0507B9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0507BC  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
0507C1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0507C4  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0507C7  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
0507CA  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
0507CD  A3 38 CB              MOV    word ptr [0xcb38], ax        ; UNKNOWN
