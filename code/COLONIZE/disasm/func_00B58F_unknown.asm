; ============================================================================
; func_00B58F_unknown
; Region   : load_image
; Bytes    : file 0x00B58F..0x00B651  (194 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B58F  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
00B593  57                    PUSH   di                           ; UNKNOWN
00B594  56                    PUSH   si                           ; UNKNOWN
00B595  BF 01 00              MOV    di, 1                        ; UNKNOWN
00B598  83 3E 0A 0B 00        CMP    word ptr [0xb0a], 0          ; UNKNOWN
00B59D  74 03                 JE     0xb5a2                       ; UNKNOWN
00B59F  BF 02 00              MOV    di, 2                        ; UNKNOWN
00B5A2  68 A6 1A              PUSH   0x1aa6                       ; UNKNOWN
00B5A5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00B5A8  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
00B5AD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00B5B0  8B F0                 MOV    si, ax                       ; UNKNOWN
00B5B2  0B F6                 OR     si, si                       ; UNKNOWN
00B5B4  75 03                 JNE    0xb5b9                       ; UNKNOWN
00B5B6  E9 6C 05              JMP    0xbb25                       ; UNKNOWN
00B5B9  8D 1E A9 1A           LEA    bx, [0x1aa9]                 ; UNKNOWN
00B5BD  8B C6                 MOV    ax, si                       ; UNKNOWN
00B5BF  9A 3B 00 34 5B        LCALL  0x5b34, 0x3b                 ; UNKNOWN
00B5C4  A1 30 0A              MOV    ax, word ptr [0xa30]         ; UNKNOWN
00B5C7  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00B5CA  56                    PUSH   si                           ; UNKNOWN
00B5CB  6A 01                 PUSH   1                            ; UNKNOWN
00B5CD  6A 02                 PUSH   2                            ; UNKNOWN
00B5CF  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
00B5D2  50                    PUSH   ax                           ; UNKNOWN
00B5D3  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
00B5D8  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00B5DB  0B C0                 OR     ax, ax                       ; UNKNOWN
00B5DD  75 03                 JNE    0xb5e2                       ; UNKNOWN
00B5DF  E9 43 05              JMP    0xbb25                       ; UNKNOWN
00B5E2  56                    PUSH   si                           ; UNKNOWN
00B5E3  6A 01                 PUSH   1                            ; UNKNOWN
00B5E5  6A 04                 PUSH   4                            ; UNKNOWN
00B5E7  68 88 82              PUSH   0x8288                       ; UNKNOWN
00B5EA  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
00B5EF  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00B5F2  0B C0                 OR     ax, ax                       ; UNKNOWN
00B5F4  75 03                 JNE    0xb5f9                       ; UNKNOWN
00B5F6  E9 2C 05              JMP    0xbb25                       ; UNKNOWN
00B5F9  56                    PUSH   si                           ; UNKNOWN
00B5FA  6A 01                 PUSH   1                            ; UNKNOWN
00B5FC  68 8E 00              PUSH   0x8e                         ; UNKNOWN
00B5FF  68 F8 3D              PUSH   0x3df8                       ; UNKNOWN
00B602  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
00B607  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00B60A  0B C0                 OR     ax, ax                       ; UNKNOWN
00B60C  75 03                 JNE    0xb611                       ; UNKNOWN
00B60E  E9 14 05              JMP    0xbb25                       ; UNKNOWN
00B611  56                    PUSH   si                           ; UNKNOWN
00B612  6A 01                 PUSH   1                            ; UNKNOWN
00B614  68 D0 00              PUSH   0xd0                         ; UNKNOWN
00B617  68 86 C0              PUSH   0xc086                       ; UNKNOWN
00B61A  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
00B61F  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00B622  0B C0                 OR     ax, ax                       ; UNKNOWN
00B624  75 03                 JNE    0xb629                       ; UNKNOWN
00B626  E9 FC 04              JMP    0xbb25                       ; UNKNOWN
00B629  56                    PUSH   si                           ; UNKNOWN
00B62A  6A 01                 PUSH   1                            ; UNKNOWN
00B62C  6A 18                 PUSH   0x18                         ; UNKNOWN
00B62E  68 5A 85              PUSH   0x855a                       ; UNKNOWN
00B631  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
00B636  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00B639  0B C0                 OR     ax, ax                       ; UNKNOWN
00B63B  75 03                 JNE    0xb640                       ; UNKNOWN
00B63D  E9 E5 04              JMP    0xbb25                       ; UNKNOWN
00B640  83 3E 16 3E 00        CMP    word ptr [0x3e16], 0         ; UNKNOWN
00B645  74 1C                 JE     0xb663                       ; UNKNOWN
00B647  56                    PUSH   si                           ; UNKNOWN
00B648  6A 01                 PUSH   1                            ; UNKNOWN
00B64A  69 06 16 3E CA 00     IMUL   ax, word ptr [0x3e16], 0xca  ; UNKNOWN
00B650  50                    PUSH   ax                           ; UNKNOWN
