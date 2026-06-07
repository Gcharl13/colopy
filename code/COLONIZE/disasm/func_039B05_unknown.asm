; ============================================================================
; func_039B05_unknown
; Region   : load_image
; Bytes    : file 0x039B05..0x039B31  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039B05  55                    PUSH   bp                           ; UNKNOWN
039B06  8B EC                 MOV    bp, sp                       ; UNKNOWN
039B08  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
039B0B  9A F0 08 5F 24        LCALL  0x245f, 0x8f0                ; UNKNOWN
039B10  8B E5                 MOV    sp, bp                       ; UNKNOWN
039B12  0B C0                 OR     ax, ax                       ; UNKNOWN
039B14  7C 07                 JL     0x39b1d                      ; UNKNOWN
039B16  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
039B19  C7 07 01 00           MOV    word ptr [bx], 1             ; UNKNOWN
039B1D  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
039B21  80 BF 82 88 02        CMP    byte ptr [bx - 0x777e], 2    ; UNKNOWN
039B26  75 07                 JNE    0x39b2f                      ; UNKNOWN
039B28  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
039B2B  C7 07 01 00           MOV    word ptr [bx], 1             ; UNKNOWN
039B2F  C9                    LEAVE                               ; UNKNOWN
039B30  CB                    RETF                                ; UNKNOWN
