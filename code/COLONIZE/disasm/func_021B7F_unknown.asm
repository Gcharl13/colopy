; ============================================================================
; func_021B7F_unknown
; Region   : load_image
; Bytes    : file 0x021B7F..0x021BAE  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021B7F  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
021B83  56                    PUSH   si                           ; UNKNOWN
021B84  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
021B87  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
021B8A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
021B8D  0E                    PUSH   cs                           ; UNKNOWN
021B8E  E8 15 FF              CALL   0x21aa6                      ; UNKNOWN
021B91  83 C4 06              ADD    sp, 6                        ; UNKNOWN
021B94  8B F0                 MOV    si, ax                       ; UNKNOWN
021B96  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
021B99  0B D0                 OR     dx, ax                       ; UNKNOWN
021B9B  74 16                 JE     0x21bb3                      ; UNKNOWN
021B9D  8E 46 FE              MOV    es, word ptr [bp - 2]        ; UNKNOWN
021BA0  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
021BA4  74 08                 JE     0x21bae                      ; UNKNOWN
021BA6  26 80 4C 0C 01        OR     byte ptr es:[si + 0xc], 1    ; UNKNOWN
021BAB  5E                    POP    si                           ; UNKNOWN
021BAC  C9                    LEAVE                               ; UNKNOWN
021BAD  CB                    RETF                                ; UNKNOWN
