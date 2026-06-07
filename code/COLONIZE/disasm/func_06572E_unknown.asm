; ============================================================================
; func_06572E_unknown
; Region   : load_image
; Bytes    : file 0x06572E..0x06575F  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06572E  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
065732  06                    PUSH   es                           ; UNKNOWN
065733  57                    PUSH   di                           ; UNKNOWN
065734  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
065737  89 0E AC 0C           MOV    word ptr [0xcac], cx         ; UNKNOWN
06573B  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
06573E  89 16 B0 0C           MOV    word ptr [0xcb0], dx         ; UNKNOWN
065742  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
065745  A3 AE 0C              MOV    word ptr [0xcae], ax         ; UNKNOWN
065748  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
06574B  A3 B2 0C              MOV    word ptr [0xcb2], ax         ; UNKNOWN
06574E  9A 0A 00 45 5F        LCALL  0x5f45, 0xa                  ; UNKNOWN
065753  89 3E BC 0C           MOV    word ptr [0xcbc], di         ; UNKNOWN
065757  89 0E BE 0C           MOV    word ptr [0xcbe], cx         ; UNKNOWN
06575B  5F                    POP    di                           ; UNKNOWN
06575C  07                    POP    es                           ; UNKNOWN
06575D  C9                    LEAVE                               ; UNKNOWN
06575E  CB                    RETF                                ; UNKNOWN
