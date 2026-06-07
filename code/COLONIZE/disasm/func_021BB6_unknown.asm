; ============================================================================
; func_021BB6_unknown
; Region   : load_image
; Bytes    : file 0x021BB6..0x021BD7  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021BB6  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
021BBA  56                    PUSH   si                           ; UNKNOWN
021BBB  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
021BBE  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
021BC1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
021BC4  0E                    PUSH   cs                           ; UNKNOWN
021BC5  E8 22 FF              CALL   0x21aea                      ; UNKNOWN
021BC8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
021BCB  8B F0                 MOV    si, ax                       ; UNKNOWN
021BCD  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
021BD1  74 09                 JE     0x21bdc                      ; UNKNOWN
021BD3  8E C2                 MOV    es, dx                       ; UNKNOWN
021BD5  26                    DB     0x26                         ; UNKNOWN (raw)
021BD6  80                    DB     0x80                         ; UNKNOWN (raw)
