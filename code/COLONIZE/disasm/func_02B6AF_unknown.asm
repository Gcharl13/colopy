; ============================================================================
; func_02B6AF_unknown
; Region   : load_image
; Bytes    : file 0x02B6AF..0x02B6BD  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B6AF  55                    PUSH   bp                           ; UNKNOWN
02B6B0  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B6B2  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
02B6B6  7C 11                 JL     0x2b6c9                      ; UNKNOWN
02B6B8  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02B6BB  8B C3                 MOV    ax, bx                       ; UNKNOWN
