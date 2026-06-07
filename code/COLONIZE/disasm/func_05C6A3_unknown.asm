; ============================================================================
; func_05C6A3_unknown
; Region   : load_image
; Bytes    : file 0x05C6A3..0x05C801  (350 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05C6A3  C8 D6 00 00           ENTER  0xd6, 0                      ; UNKNOWN
05C6A7  57                    PUSH   di                           ; UNKNOWN
05C6A8  56                    PUSH   si                           ; UNKNOWN
05C6A9  C7 86 4E FF FF FF     MOV    word ptr [bp - 0xb2], 0xffff ; UNKNOWN
05C6AF  2B C0                 SUB    ax, ax                       ; UNKNOWN
05C6B1  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax     ; UNKNOWN
05C6B5  89 86 34 FF           MOV    word ptr [bp - 0xcc], ax     ; UNKNOWN
05C6B9  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
05C6BC  89 86 5A FF           MOV    word ptr [bp - 0xa6], ax     ; UNKNOWN
05C6C0  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
05C6C3  89 86 2E FF           MOV    word ptr [bp - 0xd2], ax     ; UNKNOWN
05C6C7  89 86 46 FF           MOV    word ptr [bp - 0xba], ax     ; UNKNOWN
05C6CB  89 86 52 FF           MOV    word ptr [bp - 0xae], ax     ; UNKNOWN
05C6CF  89 86 44 FF           MOV    word ptr [bp - 0xbc], ax     ; UNKNOWN
05C6D3  89 86 66 FF           MOV    word ptr [bp - 0x9a], ax     ; UNKNOWN
05C6D7  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
05C6DA  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
05C6DD  0E                    PUSH   cs                           ; UNKNOWN
05C6DE  E8 96 EB              CALL   0x5b277                      ; UNKNOWN
05C6E1  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
05C6E5  7D 0B                 JGE    0x5c6f2                      ; UNKNOWN
05C6E7  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
05C6EB  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
05C6F0  74 16                 JE     0x5c708                      ; UNKNOWN
05C6F2  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C6F5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C6F8  0E                    PUSH   cs                           ; UNKNOWN
05C6F9  E8 1C FE              CALL   0x5c518                      ; UNKNOWN
05C6FC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C6FF  C7 86 74 FF 01 00     MOV    word ptr [bp - 0x8c], 1      ; UNKNOWN
05C705  E9 1B 1B              JMP    0x5e223                      ; UNKNOWN
05C708  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
05C70D  74 03                 JE     0x5c712                      ; UNKNOWN
05C70F  E9 11 1B              JMP    0x5e223                      ; UNKNOWN
05C712  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
05C715  89 86 46 FF           MOV    word ptr [bp - 0xba], ax     ; UNKNOWN
05C719  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C71C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C71F  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
05C724  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C727  A8 20                 TEST   al, 0x20                     ; UNKNOWN
05C729  75 10                 JNE    0x5c73b                      ; UNKNOWN
05C72B  C7 86 46 FF 01 00     MOV    word ptr [bp - 0xba], 1      ; UNKNOWN
05C731  6A 0A                 PUSH   0xa                          ; UNKNOWN
05C733  9A 64 00 9A 46        LCALL  0x469a, 0x64                 ; UNKNOWN
05C738  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05C73B  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
05C73E  D1 E3                 SHL    bx, 1                        ; UNKNOWN
05C740  8B 87 40 3E           MOV    ax, word ptr [bx + 0x3e40]   ; UNKNOWN
05C744  83 C0 10              ADD    ax, 0x10                     ; UNKNOWN
05C747  3B 06 06 3E           CMP    ax, word ptr [0x3e06]        ; UNKNOWN
05C74B  7F 16                 JG     0x5c763                      ; UNKNOWN
05C74D  C7 86 46 FF 01 00     MOV    word ptr [bp - 0xba], 1      ; UNKNOWN
05C753  6A 10                 PUSH   0x10                         ; UNKNOWN
05C755  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C758  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C75B  9A CE 00 49 22        LCALL  0x2249, 0xce                 ; UNKNOWN
05C760  83 C4 06              ADD    sp, 6                        ; UNKNOWN
05C763  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C766  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C769  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
05C76E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C771  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
05C774  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax     ; UNKNOWN
05C778  83 BE 46 FF 00        CMP    word ptr [bp - 0xba], 0      ; UNKNOWN
05C77D  75 03                 JNE    0x5c782                      ; UNKNOWN
05C77F  E9 A1 1A              JMP    0x5e223                      ; UNKNOWN
05C782  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
05C785  0B C0                 OR     ax, ax                       ; UNKNOWN
05C787  74 0B                 JE     0x5c794                      ; UNKNOWN
05C789  48                    DEC    ax                           ; UNKNOWN
05C78A  74 4F                 JE     0x5c7db                      ; UNKNOWN
05C78C  48                    DEC    ax                           ; UNKNOWN
05C78D  74 51                 JE     0x5c7e0                      ; UNKNOWN
05C78F  48                    DEC    ax                           ; UNKNOWN
05C790  74 53                 JE     0x5c7e5                      ; UNKNOWN
05C792  EB 08                 JMP    0x5c79c                      ; UNKNOWN
05C794  B8 20 80              MOV    ax, 0x8020                   ; UNKNOWN
05C797  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
05C79C  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; UNKNOWN
05C7A1  F6 87 AA 74 04        TEST   byte ptr [bx + 0x74aa], 4    ; UNKNOWN
05C7A6  74 06                 JE     0x5c7ae                      ; UNKNOWN
05C7A8  C7 86 66 FF 01 00     MOV    word ptr [bp - 0x9a], 1      ; UNKNOWN
05C7AE  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C7B1  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
05C7B6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05C7B9  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
05C7BC  D1 E3                 SHL    bx, 1                        ; UNKNOWN
05C7BE  8B 87 40 3E           MOV    ax, word ptr [bx + 0x3e40]   ; UNKNOWN
05C7C2  89 86 76 FF           MOV    word ptr [bp - 0x8a], ax     ; UNKNOWN
05C7C6  A1 06 3E              MOV    ax, word ptr [0x3e06]        ; UNKNOWN
05C7C9  89 87 40 3E           MOV    word ptr [bx + 0x3e40], ax   ; UNKNOWN
05C7CD  B8 01 00              MOV    ax, 1                        ; UNKNOWN
05C7D0  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax     ; UNKNOWN
05C7D4  89 86 36 FF           MOV    word ptr [bp - 0xca], ax     ; UNKNOWN
05C7D8  E9 20 01              JMP    0x5c8fb                      ; UNKNOWN
05C7DB  B8 21 80              MOV    ax, 0x8021                   ; UNKNOWN
05C7DE  EB B7                 JMP    0x5c797                      ; UNKNOWN
05C7E0  B8 22 80              MOV    ax, 0x8022                   ; UNKNOWN
05C7E3  EB B2                 JMP    0x5c797                      ; UNKNOWN
05C7E5  B8 23 80              MOV    ax, 0x8023                   ; UNKNOWN
05C7E8  EB AD                 JMP    0x5c797                      ; UNKNOWN
05C7EA  2A C0                 SUB    al, al                       ; UNKNOWN
05C7EC  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
05C7EF  03 9E 36 FF           ADD    bx, word ptr [bp - 0xca]     ; UNKNOWN
05C7F3  38 87 57 87           CMP    byte ptr [bx - 0x78a9], al   ; UNKNOWN
05C7F7  76 3A                 JBE    0x5c833                      ; UNKNOWN
05C7F9  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
05C7FC  C1 E6 04              SHL    si, 4                        ; UNKNOWN
05C7FF  8B C3                 MOV    ax, bx                       ; UNKNOWN
