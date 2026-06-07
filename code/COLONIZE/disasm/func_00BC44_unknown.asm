; ============================================================================
; func_00BC44_unknown
; Region   : load_image
; Bytes    : file 0x00BC44..0x00BDB2  (366 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BC44  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
00BC48  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1      ; UNKNOWN
00BC4D  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0      ; UNKNOWN
00BC52  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0      ; UNKNOWN
00BC57  83 3E 0A 0B 00        CMP    word ptr [0xb0a], 0          ; UNKNOWN
00BC5C  74 05                 JE     0xbc63                       ; UNKNOWN
00BC5E  C7 46 AA 05 00        MOV    word ptr [bp - 0x56], 5      ; UNKNOWN
00BC63  68 B5 1A              PUSH   0x1ab5                       ; UNKNOWN
00BC66  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00BC69  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
00BC6E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00BC71  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
00BC74  0B C0                 OR     ax, ax                       ; UNKNOWN
00BC76  75 03                 JNE    0xbc7b                       ; UNKNOWN
00BC78  E9 E5 06              JMP    0xc360                       ; UNKNOWN
00BC7B  8D 5E B0              LEA    bx, [bp - 0x50]              ; UNKNOWN
00BC7E  8B 46 9C              MOV    ax, word ptr [bp - 0x64]     ; UNKNOWN
00BC81  9A 00 00 34 5B        LCALL  0x5b34, 0                    ; UNKNOWN
00BC86  0B C0                 OR     ax, ax                       ; UNKNOWN
00BC88  75 03                 JNE    0xbc8d                       ; UNKNOWN
00BC8A  E9 D3 06              JMP    0xc360                       ; UNKNOWN
00BC8D  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00BC90  50                    PUSH   ax                           ; UNKNOWN
00BC91  68 A9 1A              PUSH   0x1aa9                       ; UNKNOWN
00BC94  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
00BC99  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00BC9C  0B C0                 OR     ax, ax                       ; UNKNOWN
00BC9E  74 08                 JE     0xbca8                       ; UNKNOWN
00BCA0  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2      ; UNKNOWN
00BCA5  E9 B8 06              JMP    0xc360                       ; UNKNOWN
00BCA8  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00BCAB  6A 01                 PUSH   1                            ; UNKNOWN
00BCAD  6A 02                 PUSH   2                            ; UNKNOWN
00BCAF  8D 46 A2              LEA    ax, [bp - 0x5e]              ; UNKNOWN
00BCB2  50                    PUSH   ax                           ; UNKNOWN
00BCB3  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BCB8  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BCBB  0B C0                 OR     ax, ax                       ; UNKNOWN
00BCBD  75 03                 JNE    0xbcc2                       ; UNKNOWN
00BCBF  E9 9E 06              JMP    0xc360                       ; UNKNOWN
00BCC2  A1 30 0A              MOV    ax, word ptr [0xa30]         ; UNKNOWN
00BCC5  39 46 A2              CMP    word ptr [bp - 0x5e], ax     ; UNKNOWN
00BCC8  7F D6                 JG     0xbca0                       ; UNKNOWN
00BCCA  7D 08                 JGE    0xbcd4                       ; UNKNOWN
00BCCC  C7 46 AA 03 00        MOV    word ptr [bp - 0x56], 3      ; UNKNOWN
00BCD1  E9 8C 06              JMP    0xc360                       ; UNKNOWN
00BCD4  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00BCD7  6A 01                 PUSH   1                            ; UNKNOWN
00BCD9  6A 04                 PUSH   4                            ; UNKNOWN
00BCDB  8D 46 A6              LEA    ax, [bp - 0x5a]              ; UNKNOWN
00BCDE  50                    PUSH   ax                           ; UNKNOWN
00BCDF  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BCE4  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BCE7  0B C0                 OR     ax, ax                       ; UNKNOWN
00BCE9  75 03                 JNE    0xbcee                       ; UNKNOWN
00BCEB  E9 72 06              JMP    0xc360                       ; UNKNOWN
00BCEE  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
00BCF1  F7 6E A6              IMUL   word ptr [bp - 0x5a]         ; UNKNOWN
00BCF4  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
00BCF7  89 56 AE              MOV    word ptr [bp - 0x52], dx     ; UNKNOWN
00BCFA  8B 0E 32 0B           MOV    cx, word ptr [0xb32]         ; UNKNOWN
00BCFE  0B 0E 30 0B           OR     cx, word ptr [0xb30]         ; UNKNOWN
00BD02  74 14                 JE     0xbd18                       ; UNKNOWN
00BD04  3B 06 30 0B           CMP    ax, word ptr [0xb30]         ; UNKNOWN
00BD08  75 06                 JNE    0xbd10                       ; UNKNOWN
00BD0A  3B 16 32 0B           CMP    dx, word ptr [0xb32]         ; UNKNOWN
00BD0E  74 31                 JE     0xbd41                       ; UNKNOWN
00BD10  C7 46 AA 04 00        MOV    word ptr [bp - 0x56], 4      ; UNKNOWN
00BD15  E9 48 06              JMP    0xc360                       ; UNKNOWN
00BD18  6A 04                 PUSH   4                            ; UNKNOWN
00BD1A  8D 46 A6              LEA    ax, [bp - 0x5a]              ; UNKNOWN
00BD1D  50                    PUSH   ax                           ; UNKNOWN
00BD1E  68 88 82              PUSH   0x8288                       ; UNKNOWN
00BD21  9A BC 0D 65 5F        LCALL  0x5f65, 0xdbc                ; UNKNOWN
00BD26  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00BD29  2B C0                 SUB    ax, ax                       ; UNKNOWN
00BD2B  9A 59 00 E5 17        LCALL  0x17e5, 0x59                 ; UNKNOWN
00BD30  0B C0                 OR     ax, ax                       ; UNKNOWN
00BD32  74 08                 JE     0xbd3c                       ; UNKNOWN
00BD34  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1      ; UNKNOWN
00BD39  E9 24 06              JMP    0xc360                       ; UNKNOWN
00BD3C  C7 46 A4 01 00        MOV    word ptr [bp - 0x5c], 1      ; UNKNOWN
00BD41  6A 04                 PUSH   4                            ; UNKNOWN
00BD43  8D 46 A6              LEA    ax, [bp - 0x5a]              ; UNKNOWN
00BD46  50                    PUSH   ax                           ; UNKNOWN
00BD47  68 88 82              PUSH   0x8288                       ; UNKNOWN
00BD4A  9A BC 0D 65 5F        LCALL  0x5f65, 0xdbc                ; UNKNOWN
00BD4F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00BD52  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00BD55  6A 01                 PUSH   1                            ; UNKNOWN
00BD57  68 8E 00              PUSH   0x8e                         ; UNKNOWN
00BD5A  68 F8 3D              PUSH   0x3df8                       ; UNKNOWN
00BD5D  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BD62  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BD65  0B C0                 OR     ax, ax                       ; UNKNOWN
00BD67  75 03                 JNE    0xbd6c                       ; UNKNOWN
00BD69  E9 F4 05              JMP    0xc360                       ; UNKNOWN
00BD6C  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00BD6F  6A 01                 PUSH   1                            ; UNKNOWN
00BD71  68 D0 00              PUSH   0xd0                         ; UNKNOWN
00BD74  68 86 C0              PUSH   0xc086                       ; UNKNOWN
00BD77  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BD7C  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BD7F  0B C0                 OR     ax, ax                       ; UNKNOWN
00BD81  75 03                 JNE    0xbd86                       ; UNKNOWN
00BD83  E9 DA 05              JMP    0xc360                       ; UNKNOWN
00BD86  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00BD89  6A 01                 PUSH   1                            ; UNKNOWN
00BD8B  6A 18                 PUSH   0x18                         ; UNKNOWN
00BD8D  68 5A 85              PUSH   0x855a                       ; UNKNOWN
00BD90  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00BD95  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00BD98  0B C0                 OR     ax, ax                       ; UNKNOWN
00BD9A  75 03                 JNE    0xbd9f                       ; UNKNOWN
00BD9C  E9 C1 05              JMP    0xc360                       ; UNKNOWN
00BD9F  83 3E 16 3E 00        CMP    word ptr [0x3e16], 0         ; UNKNOWN
00BDA4  74 1E                 JE     0xbdc4                       ; UNKNOWN
00BDA6  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00BDA9  6A 01                 PUSH   1                            ; UNKNOWN
00BDAB  69 06 16 3E CA 00     IMUL   ax, word ptr [0x3e16], 0xca  ; UNKNOWN
00BDB1  50                    PUSH   ax                           ; UNKNOWN
