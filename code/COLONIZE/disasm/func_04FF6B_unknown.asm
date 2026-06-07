; ============================================================================
; func_04FF6B_unknown
; Region   : load_image
; Bytes    : file 0x04FF6B..0x04FF86  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04FF6B  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04FF6F  C7 46 FE 0E 00        MOV    word ptr [bp - 2], 0xe       ; UNKNOWN
04FF74  EB 1F                 JMP    0x4ff95                      ; UNKNOWN
04FF76  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04FF79  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
04FF7C  03 5E FE              ADD    bx, word ptr [bp - 2]        ; UNKNOWN
04FF7F  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
04FF82  8B 87 3A CB           MOV    ax, word ptr [bx - 0x34c6]   ; UNKNOWN
