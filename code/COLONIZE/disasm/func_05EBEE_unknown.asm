; ============================================================================
; func_05EBEE_unknown
; Region   : load_image
; Bytes    : file 0x05EBEE..0x05EC00  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05EBEE  55                    PUSH   bp                           ; UNKNOWN
05EBEF  8B EC                 MOV    bp, sp                       ; UNKNOWN
05EBF1  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05EBF5  80 67 1C 7F           AND    byte ptr [bx + 0x1c], 0x7f   ; UNKNOWN
05EBF9  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
05EBFC  04 1F                 ADD    al, 0x1f                     ; UNKNOWN
05EBFE  C9                    LEAVE                               ; UNKNOWN
05EBFF  CB                    RETF                                ; UNKNOWN
