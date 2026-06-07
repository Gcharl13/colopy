; ============================================================================
; func_008982_unknown
; Region   : load_image
; Bytes    : file 0x008982..0x008B96  (532 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008982  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
008986  57                    PUSH   di                           ; UNKNOWN
008987  56                    PUSH   si                           ; UNKNOWN
008988  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00898B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00898E  0E                    PUSH   cs                           ; UNKNOWN
00898F  E8 00 FF              CALL   0x8892                       ; UNKNOWN
008992  83 C4 04              ADD    sp, 4                        ; UNKNOWN
008995  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; LOCAL_STORE
008998  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00899C  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
00899F  2A E4                 SUB    ah, ah                       ; UNKNOWN
0089A1  50                    PUSH   ax                           ; UNKNOWN
0089A2  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0089A4  50                    PUSH   ax                           ; UNKNOWN
0089A5  9A A0 02 7F 03        LCALL  0x37f, 0x2a0                 ; UNKNOWN
0089AA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0089AD  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0089B0  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; CMP
0089B4  7D 03                 JGE    0x89b9                       ; UNKNOWN
0089B6  E9 D9 01              JMP    0x8b92                       ; UNKNOWN
0089B9  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; LOCAL_LOAD
0089BC  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
0089C0  8B 76 F4              MOV    si, word ptr [bp - 0xc]      ; LOCAL_LOAD
0089C3  88 40 70              MOV    byte ptr [bx + si + 0x70], al ; MOV
0089C6  0A C0                 OR     al, al                       ; UNKNOWN
0089C8  7D 03                 JGE    0x89cd                       ; UNKNOWN
0089CA  E9 C5 01              JMP    0x8b92                       ; UNKNOWN
0089CD  80 3E 4D 03 00        CMP    byte ptr [0x34d], 0          ; UNKNOWN
0089D2  74 03                 JE     0x89d7                       ; UNKNOWN
0089D4  E9 BB 01              JMP    0x8b92                       ; UNKNOWN
0089D7  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
0089DA  2A E4                 SUB    ah, ah                       ; UNKNOWN
0089DC  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
0089DF  48                    DEC    ax                           ; UNKNOWN
0089E0  48                    DEC    ax                           ; UNKNOWN
0089E1  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0089E4  50                    PUSH   ax                           ; UNKNOWN
0089E5  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0089E7  2A E4                 SUB    ah, ah                       ; UNKNOWN
0089E9  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
0089EC  48                    DEC    ax                           ; UNKNOWN
0089ED  48                    DEC    ax                           ; UNKNOWN
0089EE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0089F1  50                    PUSH   ax                           ; UNKNOWN
0089F2  9A 14 03 7F 03        LCALL  0x37f, 0x314                 ; UNKNOWN
0089F7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0089FA  0B C0                 OR     ax, ax                       ; UNKNOWN
0089FC  7D 2A                 JGE    0x8a28                       ; UNKNOWN
0089FE  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
008A01  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
008A04  9A E4 03 7F 03        LCALL  0x37f, 0x3e4                 ; UNKNOWN
008A09  83 C4 04              ADD    sp, 4                        ; UNKNOWN
008A0C  0B C0                 OR     ax, ax                       ; UNKNOWN
008A0E  7D 18                 JGE    0x8a28                       ; UNKNOWN
008A10  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
008A14  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
008A17  2A E4                 SUB    ah, ah                       ; UNKNOWN
008A19  50                    PUSH   ax                           ; UNKNOWN
008A1A  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
008A1D  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
008A20  9A 28 02 7F 03        LCALL  0x37f, 0x228                 ; UNKNOWN
008A25  83 C4 06              ADD    sp, 6                        ; UNKNOWN
008A28  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
008A2B  8B C6                 MOV    ax, si                       ; UNKNOWN
008A2D  C1 E6 02              SHL    si, 2                        ; UNKNOWN
008A30  03 F0                 ADD    si, ax                       ; UNKNOWN
008A32  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
008A35  8A 80 9E 8D           MOV    al, byte ptr [bx + si - 0x7262] ; MOV
008A39  98                    CWDE                                ; UNKNOWN
008A3A  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; LOCAL_STORE
008A3D  0B C0                 OR     ax, ax                       ; UNKNOWN
008A3F  7D 03                 JGE    0x8a44                       ; UNKNOWN
008A41  E9 3F 01              JMP    0x8b83                       ; UNKNOWN
008A44  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
008A47  6A FF                 PUSH   -1                           ; UNKNOWN
008A49  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
008A4C  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
008A4F  9A 84 0D 1F 18        LCALL  0x181f, 0xd84                ; UNKNOWN
008A54  83 C4 08              ADD    sp, 8                        ; UNKNOWN
008A57  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
008A5C  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
008A60  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; CMP
008A64  73 0E                 JAE    0x8a74                       ; UNKNOWN
008A66  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
008A69  2A E4                 SUB    ah, ah                       ; UNKNOWN
008A6B  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
008A6E  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah   ; CMP
008A72  74 6F                 JE     0x8ae3                       ; UNKNOWN
008A74  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
008A77  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
008A7A  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
008A7E  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
008A81  2A E4                 SUB    ah, ah                       ; UNKNOWN
008A83  50                    PUSH   ax                           ; UNKNOWN
008A84  FF 36 4C 8D           PUSH   word ptr [0x8d4c]            ; UNKNOWN
008A88  9A 78 0D 1F 18        LCALL  0x181f, 0xd78                ; UNKNOWN
008A8D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
008A90  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
008A93  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
008A97  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
008A9A  2A E4                 SUB    ah, ah                       ; UNKNOWN
008A9C  50                    PUSH   ax                           ; UNKNOWN
008A9D  0E                    PUSH   cs                           ; UNKNOWN
008A9E  E8 53 FD              CALL   0x87f4                       ; UNKNOWN
008AA1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
008AA4  8B C8                 MOV    cx, ax                       ; UNKNOWN
008AA6  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
008AA9  8B DA                 MOV    bx, dx                       ; UNKNOWN
008AAB  99                    CDQ                                 ; UNKNOWN
008AAC  2B C8                 SUB    cx, ax                       ; UNKNOWN
008AAE  1B DA                 SBB    bx, dx                       ; UNKNOWN
008AB0  8B F0                 MOV    si, ax                       ; UNKNOWN
008AB2  D1 F8                 SAR    ax, 1                        ; UNKNOWN
008AB4  8B FA                 MOV    di, dx                       ; UNKNOWN
008AB6  99                    CDQ                                 ; UNKNOWN
008AB7  3B DA                 CMP    bx, dx                       ; UNKNOWN
008AB9  7C 23                 JL     0x8ade                       ; UNKNOWN
008ABB  7F 04                 JG     0x8ac1                       ; UNKNOWN
008ABD  3B C8                 CMP    cx, ax                       ; UNKNOWN
008ABF  72 1D                 JB     0x8ade                       ; UNKNOWN
008AC1  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e]        ; UNKNOWN
008AC5  FE 47 05              INC    byte ptr [bx + 5]            ; UNKNOWN
008AC8  57                    PUSH   di                           ; UNKNOWN
008AC9  56                    PUSH   si                           ; UNKNOWN
008ACA  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
008ACE  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
008AD1  2A E4                 SUB    ah, ah                       ; UNKNOWN
008AD3  50                    PUSH   ax                           ; UNKNOWN
008AD4  0E                    PUSH   cs                           ; UNKNOWN
008AD5  E8 6E FD              CALL   0x8846                       ; UNKNOWN
008AD8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
008ADB  EB 06                 JMP    0x8ae3                       ; UNKNOWN
008ADD  90                    NOP                                 ; UNKNOWN
008ADE  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
008AE3  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
008AE7  74 03                 JE     0x8aec                       ; UNKNOWN
008AE9  E9 85 00              JMP    0x8b71                       ; UNKNOWN
008AEC  83 3E 94 53 04        CMP    word ptr [0x5394], 4         ; UNKNOWN
008AF1  7D 17                 JGE    0x8b0a                       ; UNKNOWN
008AF3  6B 1E 94 53 34        IMUL   bx, word ptr [0x5394], 0x34  ; ARITH
008AF8  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0    ; CMP
008AFD  75 0B                 JNE    0x8b0a                       ; UNKNOWN
008AFF  A0 A6 53              MOV    al, byte ptr [0x53a6]        ; UNKNOWN
008B02  2A E4                 SUB    ah, ah                       ; UNKNOWN
008B04  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; LOCAL_STORE
008B07  EB 06                 JMP    0x8b0f                       ; UNKNOWN
008B09  90                    NOP                                 ; UNKNOWN
008B0A  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0      ; LOCAL_STORE
008B0F  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; LOCAL_LOAD
008B12  05 05 00              ADD    ax, 5                        ; UNKNOWN
008B15  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; LOCAL_STORE
008B18  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; LOCAL_STORE
008B1B  83 3E B8 8D 02        CMP    word ptr [0x8db8], 2         ; UNKNOWN
008B20  7F 05                 JG     0x8b27                       ; UNKNOWN
008B22  D1 E0                 SHL    ax, 1                        ; UNKNOWN
008B24  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; LOCAL_STORE
008B27  83 3E B8 8D 01        CMP    word ptr [0x8db8], 1         ; UNKNOWN
008B2C  7F 06                 JG     0x8b34                       ; UNKNOWN
008B2E  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; LOCAL_LOAD
008B31  01 46 F2              ADD    word ptr [bp - 0xe], ax      ; ARITH
008B34  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; LOCAL_LOAD
008B37  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; LOCAL_STORE
008B3A  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
008B3D  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
008B40  9A B0 04 7F 03        LCALL  0x37f, 0x4b0                 ; UNKNOWN
008B45  83 C4 04              ADD    sp, 4                        ; UNKNOWN
008B48  40                    INC    ax                           ; UNKNOWN
008B49  74 08                 JE     0x8b53                       ; UNKNOWN
008B4B  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; LOCAL_LOAD
008B4E  D1 E0                 SHL    ax, 1                        ; UNKNOWN
008B50  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; LOCAL_STORE
008B53  6A 00                 PUSH   0                            ; UNKNOWN
008B55  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
008B58  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
008B5C  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
008B5F  2A E4                 SUB    ah, ah                       ; UNKNOWN
008B61  50                    PUSH   ax                           ; UNKNOWN
008B62  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; LOCAL_LOAD
008B65  2D 04 00              SUB    ax, 4                        ; UNKNOWN
008B68  50                    PUSH   ax                           ; UNKNOWN
008B69  9A 6C 0D 1F 18        LCALL  0x181f, 0xd6c                ; UNKNOWN
008B6E  83 C4 08              ADD    sp, 8                        ; UNKNOWN
008B71  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
008B74  8B C6                 MOV    ax, si                       ; UNKNOWN
008B76  C1 E6 02              SHL    si, 2                        ; UNKNOWN
008B79  03 F0                 ADD    si, ax                       ; UNKNOWN
008B7B  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
008B7E  C6 80 9E 8D FF        MOV    byte ptr [bx + si - 0x7262], 0xff ; CONST_LOAD
008B83  6A 01                 PUSH   1                            ; UNKNOWN
008B85  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
008B88  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
008B8B  0E                    PUSH   cs                           ; UNKNOWN
008B8C  E8 89 FD              CALL   0x8918                       ; UNKNOWN
008B8F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
008B92  5E                    POP    si                           ; UNKNOWN
008B93  5F                    POP    di                           ; UNKNOWN
008B94  C9                    LEAVE                               ; UNKNOWN
008B95  CB                    RETF                                ; UNKNOWN
