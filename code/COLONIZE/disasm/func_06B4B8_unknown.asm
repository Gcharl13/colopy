; ============================================================================
; func_06B4B8_unknown
; Region   : load_image
; Bytes    : file 0x06B4B8..0x06B5C9  (273 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B4B8  55                    PUSH   bp                           ; UNKNOWN
06B4B9  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B4BB  B8 08 00              MOV    ax, 8                        ; UNKNOWN
06B4BE  9A 98 02 65 5F        LCALL  0x5f65, 0x298                ; UNKNOWN
06B4C3  57                    PUSH   di                           ; UNKNOWN
06B4C4  56                    PUSH   si                           ; UNKNOWN
06B4C5  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
06B4C8  B8 5C 00              MOV    ax, 0x5c                     ; UNKNOWN
06B4CB  50                    PUSH   ax                           ; UNKNOWN
06B4CC  56                    PUSH   si                           ; UNKNOWN
06B4CD  9A 54 0D 65 5F        LCALL  0x5f65, 0xd54                ; UNKNOWN
06B4D2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B4D5  8B F8                 MOV    di, ax                       ; UNKNOWN
06B4D7  B8 2F 00              MOV    ax, 0x2f                     ; UNKNOWN
06B4DA  50                    PUSH   ax                           ; UNKNOWN
06B4DB  56                    PUSH   si                           ; UNKNOWN
06B4DC  9A 54 0D 65 5F        LCALL  0x5f65, 0xd54                ; UNKNOWN
06B4E1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B4E4  0B C0                 OR     ax, ax                       ; UNKNOWN
06B4E6  75 08                 JNE    0x6b4f0                      ; UNKNOWN
06B4E8  0B FF                 OR     di, di                       ; UNKNOWN
06B4EA  75 0E                 JNE    0x6b4fa                      ; UNKNOWN
06B4EC  8B FE                 MOV    di, si                       ; UNKNOWN
06B4EE  EB 0A                 JMP    0x6b4fa                      ; UNKNOWN
06B4F0  0B FF                 OR     di, di                       ; UNKNOWN
06B4F2  74 04                 JE     0x6b4f8                      ; UNKNOWN
06B4F4  3B C7                 CMP    ax, di                       ; UNKNOWN
06B4F6  76 02                 JBE    0x6b4fa                      ; UNKNOWN
06B4F8  8B F8                 MOV    di, ax                       ; UNKNOWN
06B4FA  B8 2E 00              MOV    ax, 0x2e                     ; UNKNOWN
06B4FD  50                    PUSH   ax                           ; UNKNOWN
06B4FE  57                    PUSH   di                           ; UNKNOWN
06B4FF  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
06B504  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B507  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
06B50A  0B C0                 OR     ax, ax                       ; UNKNOWN
06B50C  74 24                 JE     0x6b532                      ; UNKNOWN
06B50E  FF 36 84 15           PUSH   word ptr [0x1584]            ; UNKNOWN
06B512  50                    PUSH   ax                           ; UNKNOWN
06B513  9A BA 0C 65 5F        LCALL  0x5f65, 0xcba                ; UNKNOWN
06B518  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B51B  50                    PUSH   ax                           ; UNKNOWN
06B51C  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06B51F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06B522  56                    PUSH   si                           ; UNKNOWN
06B523  9A D4 2C 65 5F        LCALL  0x5f65, 0x2cd4               ; UNKNOWN
06B528  83 C4 08              ADD    sp, 8                        ; UNKNOWN
06B52B  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
06B52E  E9 8F 00              JMP    0x6b5c0                      ; UNKNOWN
06B531  90                    NOP                                 ; UNKNOWN
06B532  56                    PUSH   si                           ; UNKNOWN
06B533  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06B538  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B53B  05 05 00              ADD    ax, 5                        ; UNKNOWN
06B53E  50                    PUSH   ax                           ; UNKNOWN
06B53F  9A 82 23 65 5F        LCALL  0x5f65, 0x2382               ; UNKNOWN
06B544  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B547  8B F8                 MOV    di, ax                       ; UNKNOWN
06B549  0B FF                 OR     di, di                       ; UNKNOWN
06B54B  75 05                 JNE    0x6b552                      ; UNKNOWN
06B54D  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06B550  EB 71                 JMP    0x6b5c3                      ; UNKNOWN
06B552  56                    PUSH   si                           ; UNKNOWN
06B553  57                    PUSH   di                           ; UNKNOWN
06B554  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
06B559  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B55C  56                    PUSH   si                           ; UNKNOWN
06B55D  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06B562  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B565  03 C7                 ADD    ax, di                       ; UNKNOWN
06B567  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
06B56A  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
06B56F  C7 46 F8 02 00        MOV    word ptr [bp - 8], 2         ; UNKNOWN
06B574  EB 03                 JMP    0x6b579                      ; UNKNOWN
06B576  FF 4E F8              DEC    word ptr [bp - 8]            ; UNKNOWN
06B579  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
06B57D  7C 38                 JL     0x6b5b7                      ; UNKNOWN
06B57F  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
06B582  D1 E3                 SHL    bx, 1                        ; UNKNOWN
06B584  FF B7 84 15           PUSH   word ptr [bx + 0x1584]       ; UNKNOWN
06B588  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
06B58B  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
06B590  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B593  2B C0                 SUB    ax, ax                       ; UNKNOWN
06B595  50                    PUSH   ax                           ; UNKNOWN
06B596  57                    PUSH   di                           ; UNKNOWN
06B597  9A D0 0F 65 5F        LCALL  0x5f65, 0xfd0                ; UNKNOWN
06B59C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B59F  40                    INC    ax                           ; UNKNOWN
06B5A0  74 D4                 JE     0x6b576                      ; UNKNOWN
06B5A2  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
06B5A5  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06B5A8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06B5AB  57                    PUSH   di                           ; UNKNOWN
06B5AC  9A D4 2C 65 5F        LCALL  0x5f65, 0x2cd4               ; UNKNOWN
06B5B1  83 C4 08              ADD    sp, 8                        ; UNKNOWN
06B5B4  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
06B5B7  57                    PUSH   di                           ; UNKNOWN
06B5B8  9A A8 2B 65 5F        LCALL  0x5f65, 0x2ba8               ; UNKNOWN
06B5BD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B5C0  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
06B5C3  5E                    POP    si                           ; UNKNOWN
06B5C4  5F                    POP    di                           ; UNKNOWN
06B5C5  8B E5                 MOV    sp, bp                       ; UNKNOWN
06B5C7  5D                    POP    bp                           ; UNKNOWN
06B5C8  CB                    RETF                                ; UNKNOWN
