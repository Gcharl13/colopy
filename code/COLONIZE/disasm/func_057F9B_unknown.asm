; ============================================================================
; func_057F9B_unknown
; Region   : load_image
; Bytes    : file 0x057F9B..0x057FED  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

057F9B  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
057F9F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
057FA2  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
057FA7  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
057FAA  EB 38                 JMP    0x57fe4                      ; UNKNOWN
057FAC  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
057FB1  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
057FB4  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
057FB7  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
057FBA  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
057FBD  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
057FC0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
057FC3  0E                    PUSH   cs                           ; UNKNOWN
057FC4  E8 6E F4              CALL   0x57435                      ; UNKNOWN
057FC7  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
057FCA  0B C0                 OR     ax, ax                       ; UNKNOWN
057FCC  74 13                 JE     0x57fe1                      ; UNKNOWN
057FCE  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
057FD1  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
057FD4  7E 03                 JLE    0x57fd9                      ; UNKNOWN
057FD6  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
057FD9  39 46 08              CMP    word ptr [bp + 8], ax        ; UNKNOWN
057FDC  7E 03                 JLE    0x57fe1                      ; UNKNOWN
057FDE  FF 4E 08              DEC    word ptr [bp + 8]            ; UNKNOWN
057FE1  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
057FE4  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
057FE7  0B C0                 OR     ax, ax                       ; UNKNOWN
057FE9  7D C1                 JGE    0x57fac                      ; UNKNOWN
057FEB  C9                    LEAVE                               ; UNKNOWN
057FEC  CB                    RETF                                ; UNKNOWN
