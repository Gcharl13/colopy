; ============================================================================
; func_04746E_unknown
; Region   : load_image
; Bytes    : file 0x04746E..0x04748E  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04746E  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
047472  6A 0A                 PUSH   0xa                          ; UNKNOWN
047474  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
047477  50                    PUSH   ax                           ; UNKNOWN
047478  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04747B  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
047480  83 C4 06              ADD    sp, 6                        ; UNKNOWN
047483  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
047486  16                    PUSH   ss                           ; UNKNOWN
047487  50                    PUSH   ax                           ; UNKNOWN
047488  0E                    PUSH   cs                           ; UNKNOWN
047489  E8 AA FF              CALL   0x47436                      ; UNKNOWN
04748C  C9                    LEAVE                               ; UNKNOWN
04748D  CB                    RETF                                ; UNKNOWN
