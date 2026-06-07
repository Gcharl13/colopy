; ============================================================================
; func_02D1FD_unknown
; Region   : load_image
; Bytes    : file 0x02D1FD..0x02D20D  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D1FD  55                    PUSH   bp                           ; UNKNOWN
02D1FE  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D200  68 32 1E              PUSH   0x1e32                       ; UNKNOWN
02D203  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D206  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02D20B  C9                    LEAVE                               ; UNKNOWN
02D20C  CB                    RETF                                ; UNKNOWN
