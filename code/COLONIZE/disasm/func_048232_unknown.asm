; ============================================================================
; func_048232_unknown
; Region   : load_image
; Bytes    : file 0x048232..0x048249  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048232  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
048236  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04823A  C6 87 88 88 06        MOV    byte ptr [bx - 0x7778], 6    ; UNKNOWN
04823F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
048242  9A 35 15 B7 36        LCALL  0x36b7, 0x1535               ; UNKNOWN
048247  C9                    LEAVE                               ; UNKNOWN
048248  CB                    RETF                                ; UNKNOWN
