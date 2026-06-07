; ============================================================================
; func_04F4A2_unknown
; Region   : load_image
; Bytes    : file 0x04F4A2..0x04F506  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F4A2  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04F4A6  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04F4A9  03 06 0C 3E           ADD    ax, word ptr [0x3e0c]        ; UNKNOWN
04F4AD  8B D0                 MOV    dx, ax                       ; UNKNOWN
04F4AF  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
04F4B4  EB 47                 JMP    0x4f4fd                      ; UNKNOWN
04F4B6  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04F4B9  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
04F4BE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04F4C1  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c  ; UNKNOWN
04F4C5  80 BF 96 88 00        CMP    byte ptr [bx - 0x776a], 0    ; UNKNOWN
04F4CA  74 04                 JE     0x4f4d0                      ; UNKNOWN
04F4CC  FE 8F 96 88           DEC    byte ptr [bx - 0x776a]       ; UNKNOWN
04F4D0  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c  ; UNKNOWN
04F4D4  80 BF 96 88 00        CMP    byte ptr [bx - 0x776a], 0    ; UNKNOWN
04F4D9  75 1F                 JNE    0x4f4fa                      ; UNKNOWN
04F4DB  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
04F4DE  03 06 0C 3E           ADD    ax, word ptr [0x3e0c]        ; UNKNOWN
04F4E2  50                    PUSH   ax                           ; UNKNOWN
04F4E3  50                    PUSH   ax                           ; UNKNOWN
04F4E4  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04F4E7  9A 61 03 B7 36        LCALL  0x36b7, 0x361                ; UNKNOWN
04F4EC  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F4EF  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04F4F2  9A 9E 03 B7 36        LCALL  0x36b7, 0x39e                ; UNKNOWN
04F4F7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F4FA  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F4FD  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04F500  0B C0                 OR     ax, ax                       ; UNKNOWN
04F502  7D B2                 JGE    0x4f4b6                      ; UNKNOWN
04F504  C9                    LEAVE                               ; UNKNOWN
04F505  CB                    RETF                                ; UNKNOWN
