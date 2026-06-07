; ============================================================================
; func_03CC7F_unknown
; Region   : load_image
; Bytes    : file 0x03CC7F..0x03CC91  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CC7F  55                    PUSH   bp                           ; UNKNOWN
03CC80  8B EC                 MOV    bp, sp                       ; UNKNOWN
03CC82  6B 5E 06 27           IMUL   bx, word ptr [bp + 6], 0x27  ; UNKNOWN
03CC86  03 5E 08              ADD    bx, word ptr [bp + 8]        ; UNKNOWN
03CC89  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03CC8B  8B 87 0A 80           MOV    ax, word ptr [bx - 0x7ff6]   ; UNKNOWN
03CC8F  C9                    LEAVE                               ; UNKNOWN
03CC90  CB                    RETF                                ; UNKNOWN
