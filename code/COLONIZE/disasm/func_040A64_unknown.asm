; ============================================================================
; func_040A64_unknown
; Region   : load_image
; Bytes    : file 0x040A64..0x040A85  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040A64  55                    PUSH   bp                           ; UNKNOWN
040A65  8B EC                 MOV    bp, sp                       ; UNKNOWN
040A67  56                    PUSH   si                           ; UNKNOWN
040A68  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040A6B  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040A6E  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
040A72  2A E4                 SUB    ah, ah                       ; UNKNOWN
040A74  50                    PUSH   ax                           ; UNKNOWN
040A75  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
040A79  50                    PUSH   ax                           ; UNKNOWN
040A7A  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
040A7F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040A82  5E                    POP    si                           ; UNKNOWN
040A83  C9                    LEAVE                               ; UNKNOWN
040A84  CB                    RETF                                ; UNKNOWN
