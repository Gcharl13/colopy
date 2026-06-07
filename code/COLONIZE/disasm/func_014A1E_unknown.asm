; ============================================================================
; func_014A1E_unknown
; Region   : load_image
; Bytes    : file 0x014A1E..0x014C8F  (625 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

014A1E  C8 BA 00 00           ENTER  0xba, 0                      ; UNKNOWN
014A22  56                    PUSH   si                           ; UNKNOWN
014A23  C7 46 A8 01 00        MOV    word ptr [bp - 0x58], 1      ; UNKNOWN
014A28  C7 46 A2 00 00        MOV    word ptr [bp - 0x5e], 0      ; UNKNOWN
014A2D  2B C0                 SUB    ax, ax                       ; UNKNOWN
014A2F  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
014A32  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
014A35  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
014A38  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
014A3B  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
014A3E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
014A41  9A 03 03 D2 14        LCALL  0x14d2, 0x303                ; UNKNOWN
014A46  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014A49  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
014A4C  50                    PUSH   ax                           ; UNKNOWN
014A4D  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
014A52  83 C4 02              ADD    sp, 2                        ; UNKNOWN
014A55  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
014A59  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
014A5D  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
014A60  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
014A63  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
014A67  8A 4F 02              MOV    cl, byte ptr [bx + 2]        ; UNKNOWN
014A6A  2A ED                 SUB    ch, ch                       ; UNKNOWN
014A6C  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
014A6F  83 E9 04              SUB    cx, 4                        ; UNKNOWN
014A72  89 4E A0              MOV    word ptr [bp - 0x60], cx     ; UNKNOWN
014A75  50                    PUSH   ax                           ; UNKNOWN
014A76  51                    PUSH   cx                           ; UNKNOWN
014A77  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
014A7C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014A7F  89 86 46 FF           MOV    word ptr [bp - 0xba], ax     ; UNKNOWN
014A83  8B 76 98              MOV    si, word ptr [bp - 0x68]     ; UNKNOWN
014A86  D1 E6                 SHL    si, 1                        ; UNKNOWN
014A88  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
014A8C  8B 40 0A              MOV    ax, word ptr [bx + si + 0xa] ; UNKNOWN
014A8F  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
014A92  83 7E 98 04           CMP    word ptr [bp - 0x68], 4      ; UNKNOWN
014A96  7D 32                 JGE    0x14aca                      ; UNKNOWN
014A98  6B 5E 98 34           IMUL   bx, word ptr [bp - 0x68], 0x34 ; UNKNOWN
014A9C  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
014AA1  75 27                 JNE    0x14aca                      ; UNKNOWN
014AA3  83 3E 1C 0F 00        CMP    word ptr [0xf1c], 0          ; UNKNOWN
014AA8  75 20                 JNE    0x14aca                      ; UNKNOWN
014AAA  83 3E 3A 82 00        CMP    word ptr [0x823a], 0         ; UNKNOWN
014AAF  75 04                 JNE    0x14ab5                      ; UNKNOWN
014AB1  6A 07                 PUSH   7                            ; UNKNOWN
014AB3  EB 0D                 JMP    0x14ac2                      ; UNKNOWN
014AB5  83 3E 3A 82 01        CMP    word ptr [0x823a], 1         ; UNKNOWN
014ABA  75 04                 JNE    0x14ac0                      ; UNKNOWN
014ABC  6A 06                 PUSH   6                            ; UNKNOWN
014ABE  EB 02                 JMP    0x14ac2                      ; UNKNOWN
014AC0  6A 05                 PUSH   5                            ; UNKNOWN
014AC2  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
014AC7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
014ACA  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
014ACE  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
014AD3  72 5A                 JB     0x14b2f                      ; UNKNOWN
014AD5  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
014ADA  77 53                 JA     0x14b2f                      ; UNKNOWN
014ADC  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
014ADF  FF 76 98              PUSH   word ptr [bp - 0x68]         ; UNKNOWN
014AE2  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
014AE7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014AEA  A8 20                 TEST   al, 0x20                     ; UNKNOWN
014AEC  75 0C                 JNE    0x14afa                      ; UNKNOWN
014AEE  8D 1E E0 26           LEA    bx, [0x26e0]                 ; UNKNOWN
014AF2  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
014AF7  E9 DF 05              JMP    0x150d9                      ; UNKNOWN
014AFA  83 BE 46 FF 4B        CMP    word ptr [bp - 0xba], 0x4b   ; UNKNOWN
014AFF  7D 06                 JGE    0x14b07                      ; UNKNOWN
014B01  83 7E 9C 40           CMP    word ptr [bp - 0x64], 0x40   ; UNKNOWN
014B05  7C 28                 JL     0x14b2f                      ; UNKNOWN
014B07  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
014B0A  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
014B0F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
014B12  50                    PUSH   ax                           ; UNKNOWN
014B13  6A 00                 PUSH   0                            ; UNKNOWN
014B15  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
014B1A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014B1D  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
014B21  68 EE 26              PUSH   0x26ee                       ; UNKNOWN
014B24  9A 00 37 97 1B        LCALL  0x1b97, 0x3700               ; UNKNOWN
014B29  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014B2C  E9 AA 05              JMP    0x150d9                      ; UNKNOWN
014B2F  83 7E 98 04           CMP    word ptr [bp - 0x68], 4      ; UNKNOWN
014B33  7D 0E                 JGE    0x14b43                      ; UNKNOWN
014B35  6B 5E 98 34           IMUL   bx, word ptr [bp - 0x68], 0x34 ; UNKNOWN
014B39  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
014B3E  75 03                 JNE    0x14b43                      ; UNKNOWN
014B40  E9 37 01              JMP    0x14c7a                      ; UNKNOWN
014B43  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
014B47  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
014B4B  2A E4                 SUB    ah, ah                       ; UNKNOWN
014B4D  E9 04 01              JMP    0x14c54                      ; UNKNOWN
014B50  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
014B54  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
014B58  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
014B5D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014B60  83 F8 4B              CMP    ax, 0x4b                     ; UNKNOWN
014B63  7D 5B                 JGE    0x14bc0                      ; UNKNOWN
014B65  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
014B68  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
014B6C  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
014B71  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014B74  A8 20                 TEST   al, 0x20                     ; UNKNOWN
014B76  74 48                 JE     0x14bc0                      ; UNKNOWN
014B78  8B 1E 10 3E           MOV    bx, word ptr [0x3e10]        ; UNKNOWN
014B7C  8A 87 E4 CD           MOV    al, byte ptr [bx - 0x321c]   ; UNKNOWN
014B80  8B 5E 98              MOV    bx, word ptr [bp - 0x68]     ; UNKNOWN
014B83  38 87 E4 CD           CMP    byte ptr [bx - 0x321c], al   ; UNKNOWN
014B87  73 37                 JAE    0x14bc0                      ; UNKNOWN
014B89  69 DB 3C 01           IMUL   bx, bx, 0x13c                ; UNKNOWN
014B8D  83 BF D6 74 00        CMP    word ptr [bx + 0x74d6], 0    ; UNKNOWN
014B92  7C 2C                 JL     0x14bc0                      ; UNKNOWN
014B94  7F 08                 JG     0x14b9e                      ; UNKNOWN
014B96  81 BF D4 74 DC 05     CMP    word ptr [bx + 0x74d4], 0x5dc ; UNKNOWN
014B9C  72 22                 JB     0x14bc0                      ; UNKNOWN
014B9E  6A 04                 PUSH   4                            ; UNKNOWN
014BA0  6A 00                 PUSH   0                            ; UNKNOWN
014BA2  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
014BA7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014BAA  0B C0                 OR     ax, ax                       ; UNKNOWN
014BAC  75 0A                 JNE    0x14bb8                      ; UNKNOWN
014BAE  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
014BB2  80 7F 05 00           CMP    byte ptr [bx + 5], 0         ; UNKNOWN
014BB6  7C 08                 JL     0x14bc0                      ; UNKNOWN
014BB8  C7 46 AC 07 00        MOV    word ptr [bp - 0x54], 7      ; UNKNOWN
014BBD  E9 3B 04              JMP    0x14ffb                      ; UNKNOWN
014BC0  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
014BC4  80 7F 05 00           CMP    byte ptr [bx + 5], 0         ; UNKNOWN
014BC8  7D 08                 JGE    0x14bd2                      ; UNKNOWN
014BCA  C7 46 AC 03 00        MOV    word ptr [bp - 0x54], 3      ; UNKNOWN
014BCF  E9 29 04              JMP    0x14ffb                      ; UNKNOWN
014BD2  8A 47 05              MOV    al, byte ptr [bx + 5]        ; UNKNOWN
014BD5  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
014BD8  3B 46 98              CMP    ax, word ptr [bp - 0x68]     ; UNKNOWN
014BDB  75 03                 JNE    0x14be0                      ; UNKNOWN
014BDD  E9 F9 04              JMP    0x150d9                      ; UNKNOWN
014BE0  C7 46 AC 04 00        MOV    word ptr [bp - 0x54], 4      ; UNKNOWN
014BE5  E9 13 04              JMP    0x14ffb                      ; UNKNOWN
014BE8  C7 46 AC 01 00        MOV    word ptr [bp - 0x54], 1      ; UNKNOWN
014BED  E9 0B 04              JMP    0x14ffb                      ; UNKNOWN
014BF0  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
014BF4  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
014BF8  2A E4                 SUB    ah, ah                       ; UNKNOWN
014BFA  50                    PUSH   ax                           ; UNKNOWN
014BFB  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
014BFF  50                    PUSH   ax                           ; UNKNOWN
014C00  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
014C05  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014C08  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
014C0B  C7 46 AC 09 00        MOV    word ptr [bp - 0x54], 9      ; UNKNOWN
014C10  E9 E8 03              JMP    0x14ffb                      ; UNKNOWN
014C13  C7 46 AC 06 00        MOV    word ptr [bp - 0x54], 6      ; UNKNOWN
014C18  E9 E0 03              JMP    0x14ffb                      ; UNKNOWN
014C1B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
014C1E  9A F0 08 5F 24        LCALL  0x245f, 0x8f0                ; UNKNOWN
014C23  83 C4 02              ADD    sp, 2                        ; UNKNOWN
014C26  0B C0                 OR     ax, ax                       ; UNKNOWN
014C28  7D 03                 JGE    0x14c2d                      ; UNKNOWN
014C2A  E9 AC 04              JMP    0x150d9                      ; UNKNOWN
014C2D  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
014C31  80 BF 97 88 1C        CMP    byte ptr [bx - 0x7769], 0x1c ; UNKNOWN
014C36  74 0A                 JE     0x14c42                      ; UNKNOWN
014C38  80 BF 97 88 19        CMP    byte ptr [bx - 0x7769], 0x19 ; UNKNOWN
014C3D  74 03                 JE     0x14c42                      ; UNKNOWN
014C3F  E9 97 04              JMP    0x150d9                      ; UNKNOWN
014C42  83 BE 46 FF 4B        CMP    word ptr [bp - 0xba], 0x4b   ; UNKNOWN
014C47  7C 03                 JL     0x14c4c                      ; UNKNOWN
014C49  E9 8D 04              JMP    0x150d9                      ; UNKNOWN
014C4C  C7 46 AC 05 00        MOV    word ptr [bp - 0x54], 5      ; UNKNOWN
014C51  E9 A7 03              JMP    0x14ffb                      ; UNKNOWN
014C54  48                    DEC    ax                           ; UNKNOWN
014C55  83 F8 0B              CMP    ax, 0xb                      ; UNKNOWN
014C58  77 C1                 JA     0x14c1b                      ; UNKNOWN
014C5A  D1 E0                 SHL    ax, 1                        ; UNKNOWN
014C5C  93                    XCHG   bx, ax                       ; UNKNOWN
014C5D  2E FF A7 A2 51        JMP    word ptr cs:[bx + 0x51a2]    ; UNKNOWN
014C62  30 51 5B              XOR    byte ptr [bx + di + 0x5b], dl ; UNKNOWN
014C65  51                    PUSH   cx                           ; UNKNOWN
014C66  90                    NOP                                 ; UNKNOWN
014C67  50                    PUSH   ax                           ; UNKNOWN
014C68  30 51 53              XOR    byte ptr [bx + di + 0x53], dl ; UNKNOWN
014C6B  51                    PUSH   cx                           ; UNKNOWN
014C6C  5B                    POP    bx                           ; UNKNOWN
014C6D  51                    PUSH   cx                           ; UNKNOWN
014C6E  5B                    POP    bx                           ; UNKNOWN
014C6F  51                    PUSH   cx                           ; UNKNOWN
014C70  5B                    POP    bx                           ; UNKNOWN
014C71  51                    PUSH   cx                           ; UNKNOWN
014C72  5B                    POP    bx                           ; UNKNOWN
014C73  51                    PUSH   cx                           ; UNKNOWN
014C74  5B                    POP    bx                           ; UNKNOWN
014C75  51                    PUSH   cx                           ; UNKNOWN
014C76  30 51 28              XOR    byte ptr [bx + di + 0x28], dl ; UNKNOWN
014C79  51                    PUSH   cx                           ; UNKNOWN
014C7A  6A 07                 PUSH   7                            ; UNKNOWN
014C7C  9A 64 00 9A 46        LCALL  0x469a, 0x64                 ; UNKNOWN
014C81  83 C4 02              ADD    sp, 2                        ; UNKNOWN
014C84  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
014C88  8A 5F 02              MOV    bl, byte ptr [bx + 2]        ; UNKNOWN
014C8B  2A FF                 SUB    bh, bh                       ; UNKNOWN
014C8D  8B C3                 MOV    ax, bx                       ; UNKNOWN
