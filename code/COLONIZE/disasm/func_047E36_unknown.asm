; ============================================================================
; func_047E36_unknown
; Region   : load_image
; Bytes    : file 0x047E36..0x048039  (515 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

047E36  C8 66 00 00           ENTER  0x66, 0                      ; UNKNOWN
047E3A  56                    PUSH   si                           ; UNKNOWN
047E3B  2B C0                 SUB    ax, ax                       ; UNKNOWN
047E3D  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
047E40  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
047E43  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
047E46  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
047E4A  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
047E4E  2A E4                 SUB    ah, ah                       ; UNKNOWN
047E50  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
047E53  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
047E57  2A ED                 SUB    ch, ch                       ; UNKNOWN
047E59  89 4E A2              MOV    word ptr [bp - 0x5e], cx     ; UNKNOWN
047E5C  51                    PUSH   cx                           ; UNKNOWN
047E5D  50                    PUSH   ax                           ; UNKNOWN
047E5E  8B F3                 MOV    si, bx                       ; UNKNOWN
047E60  9A EC 00 C9 33        LCALL  0x33c9, 0xec                 ; UNKNOWN
047E65  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047E68  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
047E6B  89 56 9C              MOV    word ptr [bp - 0x64], dx     ; UNKNOWN
047E6E  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
047E71  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
047E74  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
047E79  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047E7C  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
047E7F  C7 46 9E 01 00        MOV    word ptr [bp - 0x62], 1      ; UNKNOWN
047E84  2A C0                 SUB    al, al                       ; UNKNOWN
047E86  88 84 96 88           MOV    byte ptr [si - 0x776a], al   ; UNKNOWN
047E8A  88 84 88 88           MOV    byte ptr [si - 0x7778], al   ; UNKNOWN
047E8E  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
047E91  39 06 0C 3E           CMP    word ptr [0x3e0c], ax        ; UNKNOWN
047E95  74 1C                 JE     0x47eb3                      ; UNKNOWN
047E97  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
047E9C  74 2B                 JE     0x47ec9                      ; UNKNOWN
047E9E  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
047EA3  7C 05                 JL     0x47eaa                      ; UNKNOWN
047EA5  B8 00 80              MOV    ax, 0x8000                   ; UNKNOWN
047EA8  EB 03                 JMP    0x47ead                      ; UNKNOWN
047EAA  B8 00 40              MOV    ax, 0x4000                   ; UNKNOWN
047EAD  85 06 FA 3D           TEST   word ptr [0x3dfa], ax        ; UNKNOWN
047EB1  74 16                 JE     0x47ec9                      ; UNKNOWN
047EB3  6A 01                 PUSH   1                            ; UNKNOWN
047EB5  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
047EB8  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
047EBB  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
047EBE  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
047EC1  9A F9 02 0B 38        LCALL  0x380b, 0x2f9                ; UNKNOWN
047EC6  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
047EC9  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
047ECC  50                    PUSH   ax                           ; UNKNOWN
047ECD  FF 36 0C 3E           PUSH   word ptr [0x3e0c]            ; UNKNOWN
047ED1  0E                    PUSH   cs                           ; UNKNOWN
047ED2  E8 FF F7              CALL   0x476d4                      ; UNKNOWN
047ED5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047ED8  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
047EDD  7D 31                 JGE    0x47f10                      ; UNKNOWN
047EDF  6B 1E 0C 3E 34        IMUL   bx, word ptr [0x3e0c], 0x34  ; UNKNOWN
047EE4  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
047EE9  75 25                 JNE    0x47f10                      ; UNKNOWN
047EEB  C7 06 06 0A 05 00     MOV    word ptr [0xa06], 5          ; UNKNOWN
047EF1  6A 17                 PUSH   0x17                         ; UNKNOWN
047EF3  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
047EF7  8D 06 25 29           LEA    ax, [0x2925]                 ; UNKNOWN
047EFB  8D 56 AE              LEA    dx, [bp - 0x52]              ; UNKNOWN
047EFE  9A 99 37 97 1B        LCALL  0x1b97, 0x3799               ; UNKNOWN
047F03  0B C0                 OR     ax, ax                       ; UNKNOWN
047F05  74 03                 JE     0x47f0a                      ; UNKNOWN
047F07  E9 2C 01              JMP    0x48036                      ; UNKNOWN
047F0A  C7 06 06 0A FF FF     MOV    word ptr [0xa06], 0xffff     ; UNKNOWN
047F10  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
047F13  9A 35 15 B7 36        LCALL  0x36b7, 0x1535               ; UNKNOWN
047F18  83 C4 02              ADD    sp, 2                        ; UNKNOWN
047F1B  A1 06 3E              MOV    ax, word ptr [0x3e06]        ; UNKNOWN
047F1E  69 1E 0C 3E 3C 01     IMUL   bx, word ptr [0x3e0c], 0x13c ; UNKNOWN
047F24  89 87 F0 74           MOV    word ptr [bx + 0x74f0], ax   ; UNKNOWN
047F28  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
047F2B  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
047F2E  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
047F31  FF 36 0C 3E           PUSH   word ptr [0x3e0c]            ; UNKNOWN
047F35  9A 8D 1B ED 27        LCALL  0x27ed, 0x1b8d               ; UNKNOWN
047F3A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
047F3D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
047F40  0B C0                 OR     ax, ax                       ; UNKNOWN
047F42  7D 03                 JGE    0x47f47                      ; UNKNOWN
047F44  E9 EF 00              JMP    0x48036                      ; UNKNOWN
047F47  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
047F4C  7D 0C                 JGE    0x47f5a                      ; UNKNOWN
047F4E  6B 1E 0C 3E 34        IMUL   bx, word ptr [0x3e0c], 0x34  ; UNKNOWN
047F53  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
047F58  74 12                 JE     0x47f6c                      ; UNKNOWN
047F5A  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
047F5D  50                    PUSH   ax                           ; UNKNOWN
047F5E  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
047F61  40                    INC    ax                           ; UNKNOWN
047F62  40                    INC    ax                           ; UNKNOWN
047F63  50                    PUSH   ax                           ; UNKNOWN
047F64  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
047F69  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047F6C  6A 01                 PUSH   1                            ; UNKNOWN
047F6E  6A 20                 PUSH   0x20                         ; UNKNOWN
047F70  9A 06 10 5F 24        LCALL  0x245f, 0x1006               ; UNKNOWN
047F75  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047F78  6A 01                 PUSH   1                            ; UNKNOWN
047F7A  6A 18                 PUSH   0x18                         ; UNKNOWN
047F7C  9A 06 10 5F 24        LCALL  0x245f, 0x1006               ; UNKNOWN
047F81  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047F84  6A 01                 PUSH   1                            ; UNKNOWN
047F86  6A 15                 PUSH   0x15                         ; UNKNOWN
047F88  9A 06 10 5F 24        LCALL  0x245f, 0x1006               ; UNKNOWN
047F8D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047F90  6A 01                 PUSH   1                            ; UNKNOWN
047F92  6A 1B                 PUSH   0x1b                         ; UNKNOWN
047F94  9A 06 10 5F 24        LCALL  0x245f, 0x1006               ; UNKNOWN
047F99  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047F9C  6A 01                 PUSH   1                            ; UNKNOWN
047F9E  6A 27                 PUSH   0x27                         ; UNKNOWN
047FA0  9A 06 10 5F 24        LCALL  0x245f, 0x1006               ; UNKNOWN
047FA5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047FA8  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
047FAD  7D 1D                 JGE    0x47fcc                      ; UNKNOWN
047FAF  6B 1E 0C 3E 34        IMUL   bx, word ptr [0x3e0c], 0x34  ; UNKNOWN
047FB4  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
047FB9  75 11                 JNE    0x47fcc                      ; UNKNOWN
047FBB  68 DA 3E              PUSH   0x3eda                       ; UNKNOWN
047FBE  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
047FC1  40                    INC    ax                           ; UNKNOWN
047FC2  40                    INC    ax                           ; UNKNOWN
047FC3  50                    PUSH   ax                           ; UNKNOWN
047FC4  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
047FC9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047FCC  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
047FCF  39 06 0C 3E           CMP    word ptr [0x3e0c], ax        ; UNKNOWN
047FD3  74 1C                 JE     0x47ff1                      ; UNKNOWN
047FD5  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
047FDA  74 1F                 JE     0x47ffb                      ; UNKNOWN
047FDC  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
047FE1  7C 05                 JL     0x47fe8                      ; UNKNOWN
047FE3  B8 00 80              MOV    ax, 0x8000                   ; UNKNOWN
047FE6  EB 03                 JMP    0x47feb                      ; UNKNOWN
047FE8  B8 00 40              MOV    ax, 0x4000                   ; UNKNOWN
047FEB  85 06 FA 3D           TEST   word ptr [0x3dfa], ax        ; UNKNOWN
047FEF  74 0A                 JE     0x47ffb                      ; UNKNOWN
047FF1  6A 01                 PUSH   1                            ; UNKNOWN
047FF3  9A C6 00 E4 35        LCALL  0x35e4, 0xc6                 ; UNKNOWN
047FF8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
047FFB  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
048000  7D 34                 JGE    0x48036                      ; UNKNOWN
048002  6B 1E 0C 3E 34        IMUL   bx, word ptr [0x3e0c], 0x34  ; UNKNOWN
048007  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
04800C  75 28                 JNE    0x48036                      ; UNKNOWN
04800E  B8 54 00              MOV    ax, 0x54                     ; UNKNOWN
048011  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
048016  6A 02                 PUSH   2                            ; UNKNOWN
048018  9A 64 00 9A 46        LCALL  0x469a, 0x64                 ; UNKNOWN
04801D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
048020  C6 06 04 09 00        MOV    byte ptr [0x904], 0          ; UNKNOWN
048025  C7 06 0E 09 00 00     MOV    word ptr [0x90e], 0          ; UNKNOWN
04802B  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04802E  9A 99 6D BF 0D        LCALL  0xdbf, 0x6d99                ; UNKNOWN
048033  83 C4 02              ADD    sp, 2                        ; UNKNOWN
048036  5E                    POP    si                           ; UNKNOWN
048037  C9                    LEAVE                               ; UNKNOWN
048038  CB                    RETF                                ; UNKNOWN
