; ============================================================================
; func_03CE4C_unknown
; Region   : load_image
; Bytes    : file 0x03CE4C..0x03CE5D  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CE4C  55                    PUSH   bp                           ; UNKNOWN
03CE4D  8B EC                 MOV    bp, sp                       ; UNKNOWN
03CE4F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CE52  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CE55  0E                    PUSH   cs                           ; UNKNOWN
03CE56  E8 D6 FF              CALL   0x3ce2f                      ; UNKNOWN
03CE59  24 0F                 AND    al, 0xf                      ; UNKNOWN
03CE5B  C9                    LEAVE                               ; UNKNOWN
03CE5C  CB                    RETF                                ; UNKNOWN
