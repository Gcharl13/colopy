; ============================================================================
; func_06B1FE_unknown
; Region   : load_image
; Bytes    : file 0x06B1FE..0x06B21F  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B1FE  55                    PUSH   bp                           ; UNKNOWN
06B1FF  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B201  56                    PUSH   si                           ; UNKNOWN
06B202  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
06B205  BE 04 12              MOV    si, 0x1204                   ; UNKNOWN
06B208  39 5C 06              CMP    word ptr [si + 6], bx        ; UNKNOWN
06B20B  73 0D                 JAE    0x6b21a                      ; UNKNOWN
06B20D  4B                    DEC    bx                           ; UNKNOWN
06B20E  4B                    DEC    bx                           ; UNKNOWN
06B20F  80 0F 01              OR     byte ptr [bx], 1             ; UNKNOWN
06B212  39 5C 08              CMP    word ptr [si + 8], bx        ; UNKNOWN
06B215  76 03                 JBE    0x6b21a                      ; UNKNOWN
06B217  89 5C 08              MOV    word ptr [si + 8], bx        ; UNKNOWN
06B21A  5E                    POP    si                           ; UNKNOWN
06B21B  8B E5                 MOV    sp, bp                       ; UNKNOWN
06B21D  5D                    POP    bp                           ; UNKNOWN
06B21E  CB                    RETF                                ; UNKNOWN
