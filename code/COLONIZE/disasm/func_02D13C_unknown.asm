; ============================================================================
; func_02D13C_unknown
; Region   : load_image
; Bytes    : file 0x02D13C..0x02D14C  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D13C  55                    PUSH   bp                           ; UNKNOWN
02D13D  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D13F  68 1A 1E              PUSH   0x1e1a                       ; UNKNOWN
02D142  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D145  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02D14A  C9                    LEAVE                               ; UNKNOWN
02D14B  CB                    RETF                                ; UNKNOWN
