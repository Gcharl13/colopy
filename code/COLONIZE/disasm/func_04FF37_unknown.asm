; ============================================================================
; func_04FF37_unknown
; Region   : load_image
; Bytes    : file 0x04FF37..0x04FF6B  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04FF37  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04FF3B  C7 46 FE 3E 00        MOV    word ptr [bp - 2], 0x3e      ; UNKNOWN
04FF40  EB 1F                 JMP    0x4ff61                      ; UNKNOWN
04FF42  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04FF45  C1 E3 06              SHL    bx, 6                        ; UNKNOWN
04FF48  03 5E FE              ADD    bx, word ptr [bp - 2]        ; UNKNOWN
04FF4B  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
04FF4E  8B 87 28 C7           MOV    ax, word ptr [bx - 0x38d8]   ; UNKNOWN
04FF52  8B 97 2A C7           MOV    dx, word ptr [bx - 0x38d6]   ; UNKNOWN
04FF56  89 87 2C C7           MOV    word ptr [bx - 0x38d4], ax   ; UNKNOWN
04FF5A  89 97 2E C7           MOV    word ptr [bx - 0x38d2], dx   ; UNKNOWN
04FF5E  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
04FF61  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
04FF64  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
04FF67  7D D9                 JGE    0x4ff42                      ; UNKNOWN
04FF69  C9                    LEAVE                               ; UNKNOWN
04FF6A  CB                    RETF                                ; UNKNOWN
