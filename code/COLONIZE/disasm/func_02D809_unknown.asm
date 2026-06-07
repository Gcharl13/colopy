; ============================================================================
; func_02D809_unknown
; Region   : load_image
; Bytes    : file 0x02D809..0x02D81C  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D809  55                    PUSH   bp                           ; UNKNOWN
02D80A  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D80C  83 7E 06 1C           CMP    word ptr [bp + 6], 0x1c      ; UNKNOWN
02D810  75 05                 JNE    0x2d817                      ; UNKNOWN
02D812  C7 46 06 13 00        MOV    word ptr [bp + 6], 0x13      ; UNKNOWN
02D817  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02D81A  C9                    LEAVE                               ; UNKNOWN
02D81B  CB                    RETF                                ; UNKNOWN
