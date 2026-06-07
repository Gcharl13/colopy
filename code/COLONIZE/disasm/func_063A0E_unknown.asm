; ============================================================================
; func_063A0E_unknown
; Region   : load_image
; Bytes    : file 0x063A0E..0x063ACB  (189 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063A0E  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
063A12  53                    PUSH   bx                           ; UNKNOWN
063A13  57                    PUSH   di                           ; UNKNOWN
063A14  56                    PUSH   si                           ; UNKNOWN
063A15  8B F0                 MOV    si, ax                       ; UNKNOWN
063A17  BF FD FF              MOV    di, 0xfffd                   ; UNKNOWN
063A1A  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
063A1D  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
063A20  50                    PUSH   ax                           ; UNKNOWN
063A21  8D 46 06              LEA    ax, [bp + 6]                 ; UNKNOWN
063A24  50                    PUSH   ax                           ; UNKNOWN
063A25  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
063A28  8D 46 0C              LEA    ax, [bp + 0xc]               ; UNKNOWN
063A2B  8D 56 0A              LEA    dx, [bp + 0xa]               ; UNKNOWN
063A2E  9A 14 00 97 5A        LCALL  0x5a97, 0x14                 ; UNKNOWN
063A33  0B C0                 OR     ax, ax                       ; UNKNOWN
063A35  74 03                 JE     0x63a3a                      ; UNKNOWN
063A37  E9 81 00              JMP    0x63abb                      ; UNKNOWN
063A3A  83 FE F8              CMP    si, -8                       ; UNKNOWN
063A3D  75 55                 JNE    0x63a94                      ; UNKNOWN
063A3F  68 8E 30              PUSH   0x308e                       ; UNKNOWN
063A42  8D 1E F4 CD           LEA    bx, [0xcdf4]                 ; UNKNOWN
063A46  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
063A49  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
063A4C  9A 40 00 3F 5A        LCALL  0x5a3f, 0x40                 ; UNKNOWN
063A51  A1 FA CD              MOV    ax, word ptr [0xcdfa]        ; UNKNOWN
063A54  0B 06 F8 CD           OR     ax, word ptr [0xcdf8]        ; UNKNOWN
063A58  74 3A                 JE     0x63a94                      ; UNKNOWN
063A5A  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
063A5D  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
063A60  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
063A63  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
063A66  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
063A68  FF 36 FA CD           PUSH   word ptr [0xcdfa]            ; UNKNOWN
063A6C  FF 36 F8 CD           PUSH   word ptr [0xcdf8]            ; UNKNOWN
063A70  FF 36 F6 CD           PUSH   word ptr [0xcdf6]            ; UNKNOWN
063A74  FF 36 F4 CD           PUSH   word ptr [0xcdf4]            ; UNKNOWN
063A78  6A 00                 PUSH   0                            ; UNKNOWN
063A7A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063A7D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063A80  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
063A83  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
063A86  2B DB                 SUB    bx, bx                       ; UNKNOWN
063A88  9A 04 00 64 5A        LCALL  0x5a64, 4                    ; UNKNOWN
063A8D  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
063A92  EB 27                 JMP    0x63abb                      ; UNKNOWN
063A94  83 FE FE              CMP    si, -2                       ; UNKNOWN
063A97  74 27                 JE     0x63ac0                      ; UNKNOWN
063A99  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063A9C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063A9F  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
063AA2  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
063AA5  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
063AA8  9A 06 00 79 5E        LCALL  0x5e79, 6                    ; UNKNOWN
063AAD  8B F0                 MOV    si, ax                       ; UNKNOWN
063AAF  0B F6                 OR     si, si                       ; UNKNOWN
063AB1  7C 0D                 JL     0x63ac0                      ; UNKNOWN
063AB3  BF F6 FF              MOV    di, 0xfff6                   ; UNKNOWN
063AB6  2B FE                 SUB    di, si                       ; UNKNOWN
063AB8  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
063ABB  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
063ABE  EB 03                 JMP    0x63ac3                      ; UNKNOWN
063AC0  BE FD FF              MOV    si, 0xfffd                   ; UNKNOWN
063AC3  8B C6                 MOV    ax, si                       ; UNKNOWN
063AC5  5E                    POP    si                           ; UNKNOWN
063AC6  5F                    POP    di                           ; UNKNOWN
063AC7  C9                    LEAVE                               ; UNKNOWN
063AC8  CA 08 00              RETF   8                            ; UNKNOWN
