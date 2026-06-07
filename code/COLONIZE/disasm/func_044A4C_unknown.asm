; ============================================================================
; func_044A4C_unknown
; Region   : load_image
; Bytes    : file 0x044A4C..0x044AD0  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044A4C  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
044A50  53                    PUSH   bx                           ; UNKNOWN
044A51  52                    PUSH   dx                           ; UNKNOWN
044A52  50                    PUSH   ax                           ; UNKNOWN
044A53  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
044A58  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
044A5B  EB 55                 JMP    0x44ab2                      ; UNKNOWN
044A5D  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
044A60  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
044A64  75 49                 JNE    0x44aaf                      ; UNKNOWN
044A66  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
044A69  40                    INC    ax                           ; UNKNOWN
044A6A  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
044A6D  7C 40                 JL     0x44aaf                      ; UNKNOWN
044A6F  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
044A72  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
044A75  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
044A7A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
044A7D  3B 46 04              CMP    ax, word ptr [bp + 4]        ; UNKNOWN
044A80  75 DB                 JNE    0x44a5d                      ; UNKNOWN
044A82  0B C0                 OR     ax, ax                       ; UNKNOWN
044A84  74 12                 JE     0x44a98                      ; UNKNOWN
044A86  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
044A89  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
044A8C  9A BC 01 C9 33        LCALL  0x33c9, 0x1bc                ; UNKNOWN
044A91  83 C4 04              ADD    sp, 4                        ; UNKNOWN
044A94  FE C8                 DEC    al                           ; UNKNOWN
044A96  75 C5                 JNE    0x44a5d                      ; UNKNOWN
044A98  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
044A9B  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
044A9E  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
044AA0  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
044AA3  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
044AA6  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
044AA8  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
044AAD  EB AE                 JMP    0x44a5d                      ; UNKNOWN
044AAF  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
044AB2  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
044AB6  75 11                 JNE    0x44ac9                      ; UNKNOWN
044AB8  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
044ABB  40                    INC    ax                           ; UNKNOWN
044ABC  3B 46 FE              CMP    ax, word ptr [bp - 2]        ; UNKNOWN
044ABF  7C 08                 JL     0x44ac9                      ; UNKNOWN
044AC1  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
044AC4  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
044AC7  EB 97                 JMP    0x44a60                      ; UNKNOWN
044AC9  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
044ACC  C9                    LEAVE                               ; UNKNOWN
044ACD  C2 04 00              RET    4                            ; UNKNOWN
