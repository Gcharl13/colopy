; ============================================================================
; func_021C29_unknown
; Region   : load_image
; Bytes    : file 0x021C29..0x021C4A  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021C29  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
021C2D  56                    PUSH   si                           ; UNKNOWN
021C2E  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
021C31  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
021C34  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
021C37  0E                    PUSH   cs                           ; UNKNOWN
021C38  E8 AF FE              CALL   0x21aea                      ; UNKNOWN
021C3B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
021C3E  8B F0                 MOV    si, ax                       ; UNKNOWN
021C40  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
021C44  74 09                 JE     0x21c4f                      ; UNKNOWN
021C46  8E C2                 MOV    es, dx                       ; UNKNOWN
021C48  26                    DB     0x26                         ; UNKNOWN (raw)
021C49  80                    DB     0x80                         ; UNKNOWN (raw)
