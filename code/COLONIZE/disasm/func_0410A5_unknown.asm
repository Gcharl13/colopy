; ============================================================================
; func_0410A5_unknown
; Region   : load_image
; Bytes    : file 0x0410A5..0x0410BE  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0410A5  55                    PUSH   bp                           ; UNKNOWN
0410A6  8B EC                 MOV    bp, sp                       ; UNKNOWN
0410A8  56                    PUSH   si                           ; UNKNOWN
0410A9  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0410AC  56                    PUSH   si                           ; UNKNOWN
0410AD  0E                    PUSH   cs                           ; UNKNOWN
0410AE  E8 13 F1              CALL   0x401c4                      ; UNKNOWN
0410B1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0410B4  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
0410B7  88 87 85 88           MOV    byte ptr [bx - 0x777b], al   ; UNKNOWN
0410BB  5E                    POP    si                           ; UNKNOWN
0410BC  C9                    LEAVE                               ; UNKNOWN
0410BD  CB                    RETF                                ; UNKNOWN
