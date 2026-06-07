; ============================================================================
; func_047BEF_unknown
; Region   : load_image
; Bytes    : file 0x047BEF..0x047E2A  (571 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

047BEF  C8 1C 00 00           ENTER  0x1c, 0                      ; UNKNOWN
047BF3  56                    PUSH   si                           ; UNKNOWN
047BF4  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
047BF8  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
047BFC  2A E4                 SUB    ah, ah                       ; UNKNOWN
047BFE  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
047C01  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
047C05  2A ED                 SUB    ch, ch                       ; UNKNOWN
047C07  89 4E F2              MOV    word ptr [bp - 0xe], cx      ; UNKNOWN
047C0A  51                    PUSH   cx                           ; UNKNOWN
047C0B  50                    PUSH   ax                           ; UNKNOWN
047C0C  8B F3                 MOV    si, bx                       ; UNKNOWN
047C0E  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
047C13  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047C16  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
047C19  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047C1C  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047C1F  9A 20 01 C9 33        LCALL  0x33c9, 0x120                ; UNKNOWN
047C24  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047C27  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
047C2A  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
047C2D  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047C30  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047C33  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
047C38  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047C3B  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
047C3E  8A 84 83 88           MOV    al, byte ptr [si - 0x777d]   ; UNKNOWN
047C42  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
047C45  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
047C48  C4 5E EE              LES    bx, ptr [bp - 0x12]          ; UNKNOWN
047C4B  26 F6 07 0A           TEST   byte ptr es:[bx], 0xa        ; UNKNOWN
047C4F  74 03                 JE     0x47c54                      ; UNKNOWN
047C51  E9 D6 01              JMP    0x47e2a                      ; UNKNOWN
047C54  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
047C57  9A 35 15 B7 36        LCALL  0x36b7, 0x1535               ; UNKNOWN
047C5C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
047C5F  FE 84 96 88           INC    byte ptr [si - 0x776a]       ; UNKNOWN
047C63  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
047C66  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
047C69  8A 87 B8 34           MOV    al, byte ptr [bx + 0x34b8]   ; UNKNOWN
047C6D  2A E4                 SUB    ah, ah                       ; UNKNOWN
047C6F  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
047C72  80 BC 97 88 14        CMP    byte ptr [si - 0x7769], 0x14 ; UNKNOWN
047C77  75 05                 JNE    0x47c7e                      ; UNKNOWN
047C79  D1 F8                 SAR    ax, 1                        ; UNKNOWN
047C7B  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
047C7E  8A 46 E6              MOV    al, byte ptr [bp - 0x1a]     ; UNKNOWN
047C81  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
047C85  38 87 96 88           CMP    byte ptr [bx - 0x776a], al   ; UNKNOWN
047C89  73 03                 JAE    0x47c8e                      ; UNKNOWN
047C8B  E9 A5 01              JMP    0x47e33                      ; UNKNOWN
047C8E  2A C0                 SUB    al, al                       ; UNKNOWN
047C90  88 87 96 88           MOV    byte ptr [bx - 0x776a], al   ; UNKNOWN
047C94  88 87 88 88           MOV    byte ptr [bx - 0x7778], al   ; UNKNOWN
047C98  83 3E 16 3E 00        CMP    word ptr [0x3e16], 0         ; UNKNOWN
047C9D  74 28                 JE     0x47cc7                      ; UNKNOWN
047C9F  6A FF                 PUSH   -1                           ; UNKNOWN
047CA1  6A FF                 PUSH   -1                           ; UNKNOWN
047CA3  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047CA6  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047CA9  8B F3                 MOV    si, bx                       ; UNKNOWN
047CAB  9A 45 01 5F 24        LCALL  0x245f, 0x145                ; UNKNOWN
047CB0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
047CB3  8A 84 83 88           MOV    al, byte ptr [si - 0x777d]   ; UNKNOWN
047CB7  24 0F                 AND    al, 0xf                      ; UNKNOWN
047CB9  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
047CBD  3A 47 1A              CMP    al, byte ptr [bx + 0x1a]     ; UNKNOWN
047CC0  75 05                 JNE    0x47cc7                      ; UNKNOWN
047CC2  83 87 98 00 0A        ADD    word ptr [bx + 0x98], 0xa    ; UNKNOWN
047CC7  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
047CCA  39 06 0C 3E           CMP    word ptr [0x3e0c], ax        ; UNKNOWN
047CCE  74 1C                 JE     0x47cec                      ; UNKNOWN
047CD0  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
047CD5  74 2B                 JE     0x47d02                      ; UNKNOWN
047CD7  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
047CDC  7C 05                 JL     0x47ce3                      ; UNKNOWN
047CDE  B8 00 80              MOV    ax, 0x8000                   ; UNKNOWN
047CE1  EB 03                 JMP    0x47ce6                      ; UNKNOWN
047CE3  B8 00 40              MOV    ax, 0x4000                   ; UNKNOWN
047CE6  85 06 FA 3D           TEST   word ptr [0x3dfa], ax        ; UNKNOWN
047CEA  74 16                 JE     0x47d02                      ; UNKNOWN
047CEC  6A 01                 PUSH   1                            ; UNKNOWN
047CEE  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047CF1  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047CF4  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047CF7  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047CFA  9A F9 02 0B 38        LCALL  0x380b, 0x2f9                ; UNKNOWN
047CFF  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
047D02  C4 5E EE              LES    bx, ptr [bp - 0x12]          ; UNKNOWN
047D05  26 80 0F 08           OR     byte ptr es:[bx], 8          ; UNKNOWN
047D09  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
047D0C  0E                    PUSH   cs                           ; UNKNOWN
047D0D  E8 14 FB              CALL   0x47824                      ; UNKNOWN
047D10  83 C4 02              ADD    sp, 2                        ; UNKNOWN
047D13  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
047D16  39 06 0C 3E           CMP    word ptr [0x3e0c], ax        ; UNKNOWN
047D1A  74 1C                 JE     0x47d38                      ; UNKNOWN
047D1C  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
047D21  74 2D                 JE     0x47d50                      ; UNKNOWN
047D23  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
047D28  7C 05                 JL     0x47d2f                      ; UNKNOWN
047D2A  B8 00 80              MOV    ax, 0x8000                   ; UNKNOWN
047D2D  EB 03                 JMP    0x47d32                      ; UNKNOWN
047D2F  B8 00 40              MOV    ax, 0x4000                   ; UNKNOWN
047D32  85 06 FA 3D           TEST   word ptr [0x3dfa], ax        ; UNKNOWN
047D36  74 18                 JE     0x47d50                      ; UNKNOWN
047D38  6A 01                 PUSH   1                            ; UNKNOWN
047D3A  6A 03                 PUSH   3                            ; UNKNOWN
047D3C  6A 03                 PUSH   3                            ; UNKNOWN
047D3E  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
047D41  48                    DEC    ax                           ; UNKNOWN
047D42  50                    PUSH   ax                           ; UNKNOWN
047D43  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
047D46  48                    DEC    ax                           ; UNKNOWN
047D47  50                    PUSH   ax                           ; UNKNOWN
047D48  9A 0C 00 E4 35        LCALL  0x35e4, 0xc                  ; UNKNOWN
047D4D  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
047D50  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
047D53  6A FF                 PUSH   -1                           ; UNKNOWN
047D55  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047D58  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047D5B  9A 54 03 D2 14        LCALL  0x14d2, 0x354                ; UNKNOWN
047D60  83 C4 08              ADD    sp, 8                        ; UNKNOWN
047D63  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
047D66  0B C0                 OR     ax, ax                       ; UNKNOWN
047D68  7D 03                 JGE    0x47d6d                      ; UNKNOWN
047D6A  E9 C6 00              JMP    0x47e33                      ; UNKNOWN
047D6D  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047D70  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047D73  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
047D78  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047D7B  A8 10                 TEST   al, 0x10                     ; UNKNOWN
047D7D  74 03                 JE     0x47d82                      ; UNKNOWN
047D7F  E9 B1 00              JMP    0x47e33                      ; UNKNOWN
047D82  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047D85  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047D88  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
047D8D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047D90  0B C0                 OR     ax, ax                       ; UNKNOWN
047D92  7C 03                 JL     0x47d97                      ; UNKNOWN
047D94  E9 9C 00              JMP    0x47e33                      ; UNKNOWN
047D97  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
047D9B  9A 69 00 BA 33        LCALL  0x33ba, 0x69                 ; UNKNOWN
047DA0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
047DA3  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
047DA6  A1 78 73              MOV    ax, word ptr [0x7378]        ; UNKNOWN
047DA9  39 46 F6              CMP    word ptr [bp - 0xa], ax      ; UNKNOWN
047DAC  7D 03                 JGE    0x47db1                      ; UNKNOWN
047DAE  E9 82 00              JMP    0x47e33                      ; UNKNOWN
047DB1  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
047DB4  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
047DB7  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
047DBA  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
047DBD  0E                    PUSH   cs                           ; UNKNOWN
047DBE  E8 D6 F9              CALL   0x47797                      ; UNKNOWN
047DC1  83 C4 08              ADD    sp, 8                        ; UNKNOWN
047DC4  0B C0                 OR     ax, ax                       ; UNKNOWN
047DC6  75 6B                 JNE    0x47e33                      ; UNKNOWN
047DC8  6A 02                 PUSH   2                            ; UNKNOWN
047DCA  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
047DCD  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
047DD2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047DD5  0B C0                 OR     ax, ax                       ; UNKNOWN
047DD7  75 5A                 JNE    0x47e33                      ; UNKNOWN
047DD9  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
047DDE  7D 11                 JGE    0x47df1                      ; UNKNOWN
047DE0  6B 1E 0C 3E 34        IMUL   bx, word ptr [0x3e0c], 0x34  ; UNKNOWN
047DE5  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
047DEA  75 05                 JNE    0x47df1                      ; UNKNOWN
047DEC  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
047DEF  2A E4                 SUB    ah, ah                       ; UNKNOWN
047DF1  83 C0 03              ADD    ax, 3                        ; UNKNOWN
047DF4  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
047DF7  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
047DFA  83 3E 78 73 02        CMP    word ptr [0x7378], 2         ; UNKNOWN
047DFF  7F 05                 JG     0x47e06                      ; UNKNOWN
047E01  D1 E0                 SHL    ax, 1                        ; UNKNOWN
047E03  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
047E06  83 3E 78 73 01        CMP    word ptr [0x7378], 1         ; UNKNOWN
047E0B  7F 06                 JG     0x47e13                      ; UNKNOWN
047E0D  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
047E10  01 46 EC              ADD    word ptr [bp - 0x14], ax     ; UNKNOWN
047E13  6A 01                 PUSH   1                            ; UNKNOWN
047E15  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
047E18  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
047E1B  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
047E1F  9A F6 00 D2 14        LCALL  0x14d2, 0xf6                 ; UNKNOWN
047E24  83 C4 08              ADD    sp, 8                        ; UNKNOWN
047E27  5E                    POP    si                           ; UNKNOWN
047E28  C9                    LEAVE                               ; UNKNOWN
047E29  CB                    RETF                                ; UNKNOWN
