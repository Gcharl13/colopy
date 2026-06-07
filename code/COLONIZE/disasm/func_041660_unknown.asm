; ============================================================================
; func_041660_unknown
; Region   : load_image
; Bytes    : file 0x041660..0x041674  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041660  55                    PUSH   bp                           ; UNKNOWN
041661  8B EC                 MOV    bp, sp                       ; UNKNOWN
041663  56                    PUSH   si                           ; UNKNOWN
041664  6A 01                 PUSH   1                            ; UNKNOWN
041666  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
04166B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04166E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
041672  8B C3                 MOV    ax, bx                       ; UNKNOWN
