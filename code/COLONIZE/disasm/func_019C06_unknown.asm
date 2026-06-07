; ============================================================================
; func_019C06_unknown
; Region   : load_image
; Bytes    : file 0x019C06..0x019C29  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019C06  55                    PUSH   bp                           ; UNKNOWN
019C07  8B EC                 MOV    bp, sp                       ; UNKNOWN
019C09  6A 01                 PUSH   1                            ; UNKNOWN
019C0B  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
019C10  8B E5                 MOV    sp, bp                       ; UNKNOWN
019C12  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
019C15  0E                    PUSH   cs                           ; UNKNOWN
019C16  E8 DA FF              CALL   0x19bf3                      ; UNKNOWN
019C19  8B E5                 MOV    sp, bp                       ; UNKNOWN
019C1B  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
019C1E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
019C21  6A 03                 PUSH   3                            ; UNKNOWN
019C23  0E                    PUSH   cs                           ; UNKNOWN
019C24  E8 AC FF              CALL   0x19bd3                      ; UNKNOWN
019C27  C9                    LEAVE                               ; UNKNOWN
019C28  CB                    RETF                                ; UNKNOWN
