; ============================================================================
; func_041519_unknown
; Region   : load_image
; Bytes    : file 0x041519..0x04153B  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041519  55                    PUSH   bp                           ; UNKNOWN
04151A  8B EC                 MOV    bp, sp                       ; UNKNOWN
04151C  6A 01                 PUSH   1                            ; UNKNOWN
04151E  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
041523  8B E5                 MOV    sp, bp                       ; UNKNOWN
041525  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041528  0E                    PUSH   cs                           ; UNKNOWN
041529  E8 DA FF              CALL   0x41506                      ; UNKNOWN
04152C  8B E5                 MOV    sp, bp                       ; UNKNOWN
04152E  6A 00                 PUSH   0                            ; UNKNOWN
041530  6A 78                 PUSH   0x78                         ; UNKNOWN
041532  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
041535  0E                    PUSH   cs                           ; UNKNOWN
041536  E8 AD FF              CALL   0x414e6                      ; UNKNOWN
041539  C9                    LEAVE                               ; UNKNOWN
04153A  CB                    RETF                                ; UNKNOWN
