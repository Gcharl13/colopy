; ============================================================================
; func_02B624_unknown
; Region   : load_image
; Bytes    : file 0x02B624..0x02B632  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B624  55                    PUSH   bp                           ; UNKNOWN
02B625  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B627  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
02B62B  7C 11                 JL     0x2b63e                      ; UNKNOWN
02B62D  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02B630  8B C3                 MOV    ax, bx                       ; UNKNOWN
