; ============================================================================
; func_01CB31_unknown
; Region   : load_image
; Bytes    : file 0x01CB31..0x01CCB3  (386 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01CB31  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
01CB35  57                    PUSH   di                           ; UNKNOWN
01CB36  56                    PUSH   si                           ; UNKNOWN
01CB37  8D 46 EE              LEA    ax, [bp - 0x12]              ; UNKNOWN
01CB3A  50                    PUSH   ax                           ; UNKNOWN
01CB3B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CB3F  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
01CB43  98                    CWDE                                ; UNKNOWN
01CB44  50                    PUSH   ax                           ; UNKNOWN
01CB45  9A 92 32 5F 24        LCALL  0x245f, 0x3292               ; UNKNOWN
01CB4A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01CB4D  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01CB50  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
01CB53  50                    PUSH   ax                           ; UNKNOWN
01CB54  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CB58  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
01CB5C  98                    CWDE                                ; UNKNOWN
01CB5D  50                    PUSH   ax                           ; UNKNOWN
01CB5E  9A 42 33 5F 24        LCALL  0x245f, 0x3342               ; UNKNOWN
01CB63  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01CB66  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01CB69  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
01CB6C  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CB70  2B 87 B6 00           SUB    ax, word ptr [bx + 0xb6]     ; UNKNOWN
01CB74  79 02                 JNS    0x1cb78                      ; UNKNOWN
01CB76  2B C0                 SUB    ax, ax                       ; UNKNOWN
01CB78  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
01CB7B  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
01CB7F  75 03                 JNE    0x1cb84                      ; UNKNOWN
01CB81  E9 2B 01              JMP    0x1ccaf                      ; UNKNOWN
01CB84  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
01CB87  2B 87 92 00           SUB    ax, word ptr [bx + 0x92]     ; UNKNOWN
01CB8B  79 02                 JNS    0x1cb8f                      ; UNKNOWN
01CB8D  2B C0                 SUB    ax, ax                       ; UNKNOWN
01CB8F  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01CB92  0B C0                 OR     ax, ax                       ; UNKNOWN
01CB94  7F 09                 JG     0x1cb9f                      ; UNKNOWN
01CB96  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
01CB9A  75 03                 JNE    0x1cb9f                      ; UNKNOWN
01CB9C  E9 10 01              JMP    0x1ccaf                      ; UNKNOWN
01CB9F  8B C8                 MOV    cx, ax                       ; UNKNOWN
01CBA1  D1 E0                 SHL    ax, 1                        ; UNKNOWN
01CBA3  03 C1                 ADD    ax, cx                       ; UNKNOWN
01CBA5  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
01CBA8  03 C1                 ADD    ax, cx                       ; UNKNOWN
01CBAA  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01CBAD  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
01CBB1  74 1A                 JE     0x1cbcd                      ; UNKNOWN
01CBB3  8A 4F 1A              MOV    cl, byte ptr [bx + 0x1a]     ; UNKNOWN
01CBB6  2A ED                 SUB    ch, ch                       ; UNKNOWN
01CBB8  69 D9 3C 01           IMUL   bx, cx, 0x13c                ; UNKNOWN
01CBBC  8A 87 04 75           MOV    al, byte ptr [bx + 0x7504]   ; UNKNOWN
01CBC0  98                    CWDE                                ; UNKNOWN
01CBC1  83 C0 04              ADD    ax, 4                        ; UNKNOWN
01CBC4  F7 6E F0              IMUL   word ptr [bp - 0x10]         ; UNKNOWN
01CBC7  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
01CBCA  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01CBCD  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CBD1  83 BF 92 00 00        CMP    word ptr [bx + 0x92], 0      ; UNKNOWN
01CBD6  75 03                 JNE    0x1cbdb                      ; UNKNOWN
01CBD8  D1 66 F8              SHL    word ptr [bp - 8], 1         ; UNKNOWN
01CBDB  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
01CBDF  98                    CWDE                                ; UNKNOWN
01CBE0  50                    PUSH   ax                           ; UNKNOWN
01CBE1  9A E4 32 5F 24        LCALL  0x245f, 0x32e4               ; UNKNOWN
01CBE6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01CBE9  52                    PUSH   dx                           ; UNKNOWN
01CBEA  50                    PUSH   ax                           ; UNKNOWN
01CBEB  1E                    PUSH   ds                           ; UNKNOWN
01CBEC  68 40 3F              PUSH   0x3f40                       ; UNKNOWN
01CBEF  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
01CBF4  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01CBF7  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
01CBFA  99                    CDQ                                 ; UNKNOWN
01CBFB  A3 2A 3F              MOV    word ptr [0x3f2a], ax        ; UNKNOWN
01CBFE  89 16 2C 3F           MOV    word ptr [0x3f2c], dx        ; UNKNOWN
01CC02  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CC06  8A 4F 1A              MOV    cl, byte ptr [bx + 0x1a]     ; UNKNOWN
01CC09  2A ED                 SUB    ch, ch                       ; UNKNOWN
01CC0B  51                    PUSH   cx                           ; UNKNOWN
01CC0C  8B F0                 MOV    si, ax                       ; UNKNOWN
01CC0E  8B FA                 MOV    di, dx                       ; UNKNOWN
01CC10  9A 39 05 5F 24        LCALL  0x245f, 0x539                ; UNKNOWN
01CC15  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01CC18  A3 2E 3F              MOV    word ptr [0x3f2e], ax        ; UNKNOWN
01CC1B  89 16 30 3F           MOV    word ptr [0x3f30], dx        ; UNKNOWN
01CC1F  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CC23  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
01CC26  2A E4                 SUB    ah, ah                       ; UNKNOWN
01CC28  50                    PUSH   ax                           ; UNKNOWN
01CC29  9A 39 05 5F 24        LCALL  0x245f, 0x539                ; UNKNOWN
01CC2E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01CC31  3B D7                 CMP    dx, di                       ; UNKNOWN
01CC33  7C 18                 JL     0x1cc4d                      ; UNKNOWN
01CC35  7F 04                 JG     0x1cc3b                      ; UNKNOWN
01CC37  3B C6                 CMP    ax, si                       ; UNKNOWN
01CC39  72 12                 JB     0x1cc4d                      ; UNKNOWN
01CC3B  6A 05                 PUSH   5                            ; UNKNOWN
01CC3D  68 42 17              PUSH   0x1742                       ; UNKNOWN
01CC40  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01CC45  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01CC48  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01CC4B  EB 12                 JMP    0x1cc5f                      ; UNKNOWN
01CC4D  6A 05                 PUSH   5                            ; UNKNOWN
01CC4F  68 49 17              PUSH   0x1749                       ; UNKNOWN
01CC52  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01CC57  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01CC5A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
01CC5F  83 7E FC 02           CMP    word ptr [bp - 4], 2         ; UNKNOWN
01CC63  75 4A                 JNE    0x1ccaf                      ; UNKNOWN
01CC65  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
01CC68  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CC6C  2B 87 92 00           SUB    ax, word ptr [bx + 0x92]     ; UNKNOWN
01CC70  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01CC73  0B C0                 OR     ax, ax                       ; UNKNOWN
01CC75  7E 04                 JLE    0x1cc7b                      ; UNKNOWN
01CC77  01 87 98 00           ADD    word ptr [bx + 0x98], ax     ; UNKNOWN
01CC7B  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
01CC7E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CC82  89 87 92 00           MOV    word ptr [bx + 0x92], ax     ; UNKNOWN
01CC86  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
01CC89  99                    CDQ                                 ; UNKNOWN
01CC8A  52                    PUSH   dx                           ; UNKNOWN
01CC8B  50                    PUSH   ax                           ; UNKNOWN
01CC8C  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
01CC8F  2A E4                 SUB    ah, ah                       ; UNKNOWN
01CC91  50                    PUSH   ax                           ; UNKNOWN
01CC92  9A 8A 05 5F 24        LCALL  0x245f, 0x58a                ; UNKNOWN
01CC97  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01CC9A  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01CC9E  74 0B                 JE     0x1ccab                      ; UNKNOWN
01CCA0  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
01CCA3  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CCA7  01 87 B6 00           ADD    word ptr [bx + 0xb6], ax     ; UNKNOWN
01CCAB  0E                    PUSH   cs                           ; UNKNOWN
01CCAC  E8 BC CE              CALL   0x19b6b                      ; UNKNOWN
01CCAF  5E                    POP    si                           ; UNKNOWN
01CCB0  5F                    POP    di                           ; UNKNOWN
01CCB1  C9                    LEAVE                               ; UNKNOWN
01CCB2  CB                    RETF                                ; UNKNOWN
