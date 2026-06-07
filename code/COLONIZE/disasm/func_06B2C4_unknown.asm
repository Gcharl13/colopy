; ============================================================================
; func_06B2C4_unknown
; Region   : load_image
; Bytes    : file 0x06B2C4..0x06B31B  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B2C4  55                    PUSH   bp                           ; UNKNOWN
06B2C5  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B2C7  57                    PUSH   di                           ; UNKNOWN
06B2C8  56                    PUSH   si                           ; UNKNOWN
06B2C9  8B 36 5F 12           MOV    si, word ptr [0x125f]        ; UNKNOWN
06B2CD  0B F6                 OR     si, si                       ; UNKNOWN
06B2CF  74 4A                 JE     0x6b31b                      ; UNKNOWN
06B2D1  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
06B2D5  74 44                 JE     0x6b31b                      ; UNKNOWN
06B2D7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06B2DA  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06B2DF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B2E2  8B F8                 MOV    di, ax                       ; UNKNOWN
06B2E4  EB 30                 JMP    0x6b316                      ; UNKNOWN
06B2E6  FF 34                 PUSH   word ptr [si]                ; UNKNOWN
06B2E8  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06B2ED  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B2F0  3B C7                 CMP    ax, di                       ; UNKNOWN
06B2F2  7E 20                 JLE    0x6b314                      ; UNKNOWN
06B2F4  8B 1C                 MOV    bx, word ptr [si]            ; UNKNOWN
06B2F6  80 39 3D              CMP    byte ptr [bx + di], 0x3d     ; UNKNOWN
06B2F9  75 19                 JNE    0x6b314                      ; UNKNOWN
06B2FB  57                    PUSH   di                           ; UNKNOWN
06B2FC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06B2FF  53                    PUSH   bx                           ; UNKNOWN
06B300  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
06B305  83 C4 06              ADD    sp, 6                        ; UNKNOWN
06B308  0B C0                 OR     ax, ax                       ; UNKNOWN
06B30A  75 08                 JNE    0x6b314                      ; UNKNOWN
06B30C  8B 04                 MOV    ax, word ptr [si]            ; UNKNOWN
06B30E  03 C7                 ADD    ax, di                       ; UNKNOWN
06B310  40                    INC    ax                           ; UNKNOWN
06B311  EB 0A                 JMP    0x6b31d                      ; UNKNOWN
06B313  90                    NOP                                 ; UNKNOWN
06B314  46                    INC    si                           ; UNKNOWN
06B315  46                    INC    si                           ; UNKNOWN
06B316  83 3C 00              CMP    word ptr [si], 0             ; UNKNOWN
06B319  75 CB                 JNE    0x6b2e6                      ; UNKNOWN
