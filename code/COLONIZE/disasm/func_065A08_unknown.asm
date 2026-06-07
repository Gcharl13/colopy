; ============================================================================
; func_065A08_unknown
; Region   : load_image
; Bytes    : file 0x065A08..0x065A22  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065A08  55                    PUSH   bp                           ; UNKNOWN
065A09  8B EC                 MOV    bp, sp                       ; UNKNOWN
065A0B  0B D2                 OR     dx, dx                       ; UNKNOWN
065A0D  74 11                 JE     0x65a20                      ; UNKNOWN
065A0F  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
065A14  3B 06 F6 0E           CMP    ax, word ptr [0xef6]         ; UNKNOWN
065A18  75 06                 JNE    0x65a20                      ; UNKNOWN
065A1A  3B 16 F8 0E           CMP    dx, word ptr [0xef8]         ; UNKNOWN
065A1E  74 EF                 JE     0x65a0f                      ; UNKNOWN
065A20  C9                    LEAVE                               ; UNKNOWN
065A21  CB                    RETF                                ; UNKNOWN
