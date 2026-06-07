; ============================================================================
; func_024D6C_unknown
; Region   : load_image
; Bytes    : file 0x024D6C..0x024D94  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024D6C  C8 50 00 00           ENTER  0x50, 0                      ; UNKNOWN
024D70  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
024D74  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
024D77  50                    PUSH   ax                           ; UNKNOWN
024D78  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
024D7B  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
024D7E  9A 41 01 49 22        LCALL  0x2249, 0x141                ; UNKNOWN
024D83  83 C4 06              ADD    sp, 6                        ; UNKNOWN
024D86  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
024D89  16                    PUSH   ss                           ; UNKNOWN
024D8A  50                    PUSH   ax                           ; UNKNOWN
024D8B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
024D8E  0E                    PUSH   cs                           ; UNKNOWN
024D8F  E8 A7 FF              CALL   0x24d39                      ; UNKNOWN
024D92  C9                    LEAVE                               ; UNKNOWN
024D93  CB                    RETF                                ; UNKNOWN
