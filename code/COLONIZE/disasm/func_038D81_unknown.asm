; ============================================================================
; func_038D81_unknown
; Region   : load_image
; Bytes    : file 0x038D81..0x038FBA  (569 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038D81  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
038D85  56                    PUSH   si                           ; UNKNOWN
038D86  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
038D8A  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
038D8F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038D92  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
038D97  E9 A7 01              JMP    0x38f41                      ; UNKNOWN
038D9A  80 3E 1E 3E 01        CMP    byte ptr [0x3e1e], 1         ; UNKNOWN
038D9F  75 0C                 JNE    0x38dad                      ; UNKNOWN
038DA1  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038DA5  C7 47 2A 2C 01        MOV    word ptr [bx + 0x2a], 0x12c  ; UNKNOWN
038DAA  89 47 2C              MOV    word ptr [bx + 0x2c], ax     ; UNKNOWN
038DAD  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038DB1  C6 47 14 00           MOV    byte ptr [bx + 0x14], 0      ; UNKNOWN
038DB5  C7 47 12 FF FF        MOV    word ptr [bx + 0x12], 0xffff ; UNKNOWN
038DBA  6A 04                 PUSH   4                            ; UNKNOWN
038DBC  89 47 0C              MOV    word ptr [bx + 0xc], ax      ; UNKNOWN
038DBF  89 47 0E              MOV    word ptr [bx + 0xe], ax      ; UNKNOWN
038DC2  89 47 10              MOV    word ptr [bx + 0x10], ax     ; UNKNOWN
038DC5  50                    PUSH   ax                           ; UNKNOWN
038DC6  8D 47 07              LEA    ax, [bx + 7]                 ; UNKNOWN
038DC9  50                    PUSH   ax                           ; UNKNOWN
038DCA  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
038DCF  83 C4 06              ADD    sp, 6                        ; UNKNOWN
038DD2  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038DD6  C7 47 2E 00 00        MOV    word ptr [bx + 0x2e], 0      ; UNKNOWN
038DDB  C7 47 4A 00 00        MOV    word ptr [bx + 0x4a], 0      ; UNKNOWN
038DE0  2A C0                 SUB    al, al                       ; UNKNOWN
038DE2  88 47 49              MOV    byte ptr [bx + 0x49], al     ; UNKNOWN
038DE5  88 47 48              MOV    byte ptr [bx + 0x48], al     ; UNKNOWN
038DE8  6A 20                 PUSH   0x20                         ; UNKNOWN
038DEA  6A 01                 PUSH   1                            ; UNKNOWN
038DEC  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
038DF1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038DF4  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038DF8  88 47 44              MOV    byte ptr [bx + 0x44], al     ; UNKNOWN
038DFB  6A 1F                 PUSH   0x1f                         ; UNKNOWN
038DFD  6A 00                 PUSH   0                            ; UNKNOWN
038DFF  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
038E04  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038E07  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038E0B  88 47 45              MOV    byte ptr [bx + 0x45], al     ; UNKNOWN
038E0E  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038E12  C6 47 18 00           MOV    byte ptr [bx + 0x18], 0      ; UNKNOWN
038E16  6A 02                 PUSH   2                            ; UNKNOWN
038E18  2B C0                 SUB    ax, ax                       ; UNKNOWN
038E1A  89 47 46              MOV    word ptr [bx + 0x46], ax     ; UNKNOWN
038E1D  50                    PUSH   ax                           ; UNKNOWN
038E1E  8D 47 1B              LEA    ax, [bx + 0x1b]              ; UNKNOWN
038E21  50                    PUSH   ax                           ; UNKNOWN
038E22  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
038E27  83 C4 06              ADD    sp, 6                        ; UNKNOWN
038E2A  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038E2E  C7 47 20 00 00        MOV    word ptr [bx + 0x20], 0      ; UNKNOWN
038E33  2A C0                 SUB    al, al                       ; UNKNOWN
038E35  88 47 19              MOV    byte ptr [bx + 0x19], al     ; UNKNOWN
038E38  88 47 1A              MOV    byte ptr [bx + 0x1a], al     ; UNKNOWN
038E3B  C7 47 1E 00 00        MOV    word ptr [bx + 0x1e], 0      ; UNKNOWN
038E40  88 47 01              MOV    byte ptr [bx + 1], al        ; UNKNOWN
038E43  80 3E 1E 3E 04        CMP    byte ptr [0x3e1e], 4         ; UNKNOWN
038E48  72 04                 JB     0x38e4e                      ; UNKNOWN
038E4A  B0 1A                 MOV    al, 0x1a                     ; UNKNOWN
038E4C  EB 02                 JMP    0x38e50                      ; UNKNOWN
038E4E  B0 19                 MOV    al, 0x19                     ; UNKNOWN
038E50  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038E54  88 47 02              MOV    byte ptr [bx + 2], al        ; UNKNOWN
038E57  80 3E 1E 3E 03        CMP    byte ptr [0x3e1e], 3         ; UNKNOWN
038E5C  73 05                 JAE    0x38e63                      ; UNKNOWN
038E5E  B8 01 00              MOV    ax, 1                        ; UNKNOWN
038E61  EB 02                 JMP    0x38e65                      ; UNKNOWN
038E63  2B C0                 SUB    ax, ax                       ; UNKNOWN
038E65  50                    PUSH   ax                           ; UNKNOWN
038E66  0E                    PUSH   cs                           ; UNKNOWN
038E67  E8 0C E6              CALL   0x37476                      ; UNKNOWN
038E6A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038E6D  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038E71  88 47 03              MOV    byte ptr [bx + 3], al        ; UNKNOWN
038E74  6A 01                 PUSH   1                            ; UNKNOWN
038E76  0E                    PUSH   cs                           ; UNKNOWN
038E77  E8 FC E5              CALL   0x37476                      ; UNKNOWN
038E7A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038E7D  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038E81  88 47 04              MOV    byte ptr [bx + 4], al        ; UNKNOWN
038E84  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
038E89  7D 30                 JGE    0x38ebb                      ; UNKNOWN
038E8B  6B 1E 9A 79 34        IMUL   bx, word ptr [0x799a], 0x34  ; UNKNOWN
038E90  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
038E95  75 24                 JNE    0x38ebb                      ; UNKNOWN
038E97  80 3E 1E 3E 00        CMP    byte ptr [0x3e1e], 0         ; UNKNOWN
038E9C  75 0A                 JNE    0x38ea8                      ; UNKNOWN
038E9E  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038EA2  C6 47 02 0D           MOV    byte ptr [bx + 2], 0xd       ; UNKNOWN
038EA6  EB 0B                 JMP    0x38eb3                      ; UNKNOWN
038EA8  80 3E 1E 3E 01        CMP    byte ptr [0x3e1e], 1         ; UNKNOWN
038EAD  75 0C                 JNE    0x38ebb                      ; UNKNOWN
038EAF  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038EB3  C6 47 03 00           MOV    byte ptr [bx + 3], 0         ; UNKNOWN
038EB7  C6 47 04 16           MOV    byte ptr [bx + 4], 0x16      ; UNKNOWN
038EBB  83 3E 9A 79 02        CMP    word ptr [0x799a], 2         ; UNKNOWN
038EC0  75 08                 JNE    0x38eca                      ; UNKNOWN
038EC2  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038EC6  C6 47 02 18           MOV    byte ptr [bx + 2], 0x18      ; UNKNOWN
038ECA  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038ECE  2B C0                 SUB    ax, ax                       ; UNKNOWN
038ED0  89 47 24              MOV    word ptr [bx + 0x24], ax     ; UNKNOWN
038ED3  89 47 22              MOV    word ptr [bx + 0x22], ax     ; UNKNOWN
038ED6  89 47 28              MOV    word ptr [bx + 0x28], ax     ; UNKNOWN
038ED9  89 47 26              MOV    word ptr [bx + 0x26], ax     ; UNKNOWN
038EDC  2A C0                 SUB    al, al                       ; UNKNOWN
038EDE  88 47 05              MOV    byte ptr [bx + 5], al        ; UNKNOWN
038EE1  88 47 06              MOV    byte ptr [bx + 6], al        ; UNKNOWN
038EE4  2B C0                 SUB    ax, ax                       ; UNKNOWN
038EE6  89 47 16              MOV    word ptr [bx + 0x16], ax     ; UNKNOWN
038EE9  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
038EEC  EB 31                 JMP    0x38f1f                      ; UNKNOWN
038EEE  8B 76 F6              MOV    si, word ptr [bp - 0xa]      ; UNKNOWN
038EF1  D1 E6                 SHL    si, 1                        ; UNKNOWN
038EF3  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038EF7  C7 40 5C 00 00        MOV    word ptr [bx + si + 0x5c], 0 ; UNKNOWN
038EFC  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
038EFF  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
038F02  03 D8                 ADD    bx, ax                       ; UNKNOWN
038F04  2B C0                 SUB    ax, ax                       ; UNKNOWN
038F06  89 47 7E              MOV    word ptr [bx + 0x7e], ax     ; UNKNOWN
038F09  89 47 7C              MOV    word ptr [bx + 0x7c], ax     ; UNKNOWN
038F0C  89 87 BE 00           MOV    word ptr [bx + 0xbe], ax     ; UNKNOWN
038F10  89 87 BC 00           MOV    word ptr [bx + 0xbc], ax     ; UNKNOWN
038F14  89 87 FE 00           MOV    word ptr [bx + 0xfe], ax     ; UNKNOWN
038F18  89 87 FC 00           MOV    word ptr [bx + 0xfc], ax     ; UNKNOWN
038F1C  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
038F1F  83 7E F6 10           CMP    word ptr [bp - 0xa], 0x10    ; UNKNOWN
038F23  7C C9                 JL     0x38eee                      ; UNKNOWN
038F25  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
038F28  EB 0E                 JMP    0x38f38                      ; UNKNOWN
038F2A  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038F2E  8B 76 F8              MOV    si, word ptr [bp - 8]        ; UNKNOWN
038F31  C6 40 40 00           MOV    byte ptr [bx + si + 0x40], 0 ; UNKNOWN
038F35  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
038F38  83 7E F8 04           CMP    word ptr [bp - 8], 4         ; UNKNOWN
038F3C  7C EC                 JL     0x38f2a                      ; UNKNOWN
038F3E  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
038F41  83 7E FA 04           CMP    word ptr [bp - 6], 4         ; UNKNOWN
038F45  7D 44                 JGE    0x38f8b                      ; UNKNOWN
038F47  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
038F4A  0E                    PUSH   cs                           ; UNKNOWN
038F4B  E8 D6 9E              CALL   0x32e24                      ; UNKNOWN
038F4E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038F51  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038F55  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
038F58  2B C0                 SUB    ax, ax                       ; UNKNOWN
038F5A  89 47 2C              MOV    word ptr [bx + 0x2c], ax     ; UNKNOWN
038F5D  89 47 2A              MOV    word ptr [bx + 0x2a], ax     ; UNKNOWN
038F60  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
038F65  7C 03                 JL     0x38f6a                      ; UNKNOWN
038F67  E9 43 FE              JMP    0x38dad                      ; UNKNOWN
038F6A  6B 36 9A 79 34        IMUL   si, word ptr [0x799a], 0x34  ; UNKNOWN
038F6F  80 BC B7 C0 00        CMP    byte ptr [si - 0x3f49], 0    ; UNKNOWN
038F74  74 03                 JE     0x38f79                      ; UNKNOWN
038F76  E9 34 FE              JMP    0x38dad                      ; UNKNOWN
038F79  80 3E 1E 3E 00        CMP    byte ptr [0x3e1e], 0         ; UNKNOWN
038F7E  74 03                 JE     0x38f83                      ; UNKNOWN
038F80  E9 17 FE              JMP    0x38d9a                      ; UNKNOWN
038F83  C7 47 2A E8 03        MOV    word ptr [bx + 0x2a], 0x3e8  ; UNKNOWN
038F88  E9 1F FE              JMP    0x38daa                      ; UNKNOWN
038F8B  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
038F90  EB 1D                 JMP    0x38faf                      ; UNKNOWN
038F92  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
038F95  83 7E FA 04           CMP    word ptr [bp - 6], 4         ; UNKNOWN
038F99  7D 11                 JGE    0x38fac                      ; UNKNOWN
038F9B  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
038F9E  69 76 FA 3C 01        IMUL   si, word ptr [bp - 6], 0x13c ; UNKNOWN
038FA3  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
038FA6  88 80 F6 74           MOV    byte ptr [bx + si + 0x74f6], al ; UNKNOWN
038FAA  EB E6                 JMP    0x38f92                      ; UNKNOWN
038FAC  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
038FAF  83 7E F6 10           CMP    word ptr [bp - 0xa], 0x10    ; UNKNOWN
038FB3  7D 3A                 JGE    0x38fef                      ; UNKNOWN
038FB5  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
038FB8  8B C3                 MOV    ax, bx                       ; UNKNOWN
