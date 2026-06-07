; ============================================================================
; func_04247C_unknown
; Region   : load_image
; Bytes    : file 0x04247C..0x0424A4  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04247C  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
042480  2B C0                 SUB    ax, ax                       ; UNKNOWN
042482  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
042485  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
042488  EB 2C                 JMP    0x424b6                      ; UNKNOWN
04248A  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04248D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042490  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
042495  83 C4 04              ADD    sp, 4                        ; UNKNOWN
042498  0B C0                 OR     ax, ax                       ; UNKNOWN
04249A  74 17                 JE     0x424b3                      ; UNKNOWN
04249C  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
04249F  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
0424A2  8B CB                 MOV    cx, bx                       ; UNKNOWN
