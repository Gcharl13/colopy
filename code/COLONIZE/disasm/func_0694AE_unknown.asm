; ============================================================================
; func_0694AE_unknown
; Region   : load_image
; Bytes    : file 0x0694AE..0x069601  (339 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0694AE  55                    PUSH   bp                           ; UNKNOWN
0694AF  8B EC                 MOV    bp, sp                       ; UNKNOWN
0694B1  83 EC 06              SUB    sp, 6                        ; UNKNOWN
0694B4  57                    PUSH   di                           ; UNKNOWN
0694B5  56                    PUSH   si                           ; UNKNOWN
0694B6  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0694B9  2B C0                 SUB    ax, ax                       ; UNKNOWN
0694BB  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0694BE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0694C1  80 7C 01 3A           CMP    byte ptr [si + 1], 0x3a      ; UNKNOWN
0694C5  75 21                 JNE    0x694e8                      ; UNKNOWN
0694C7  39 46 08              CMP    word ptr [bp + 8], ax        ; UNKNOWN
0694CA  74 17                 JE     0x694e3                      ; UNKNOWN
0694CC  B8 02 00              MOV    ax, 2                        ; UNKNOWN
0694CF  50                    PUSH   ax                           ; UNKNOWN
0694D0  56                    PUSH   si                           ; UNKNOWN
0694D1  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0694D4  9A 24 08 65 5F        LCALL  0x5f65, 0x824                ; UNKNOWN
0694D9  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0694DC  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0694DF  C6 47 02 00           MOV    byte ptr [bx + 2], 0         ; UNKNOWN
0694E3  46                    INC    si                           ; UNKNOWN
0694E4  46                    INC    si                           ; UNKNOWN
0694E5  EB 0C                 JMP    0x694f3                      ; UNKNOWN
0694E7  90                    NOP                                 ; UNKNOWN
0694E8  39 46 08              CMP    word ptr [bp + 8], ax        ; UNKNOWN
0694EB  74 06                 JE     0x694f3                      ; UNKNOWN
0694ED  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0694F0  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
0694F3  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
0694F8  8B FE                 MOV    di, si                       ; UNKNOWN
0694FA  EB 09                 JMP    0x69505                      ; UNKNOWN
0694FC  80 3D 2E              CMP    byte ptr [di], 0x2e          ; UNKNOWN
0694FF  75 03                 JNE    0x69504                      ; UNKNOWN
069501  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
069504  47                    INC    di                           ; UNKNOWN
069505  80 3D 00              CMP    byte ptr [di], 0             ; UNKNOWN
069508  74 12                 JE     0x6951c                      ; UNKNOWN
06950A  80 3D 2F              CMP    byte ptr [di], 0x2f          ; UNKNOWN
06950D  74 05                 JE     0x69514                      ; UNKNOWN
06950F  80 3D 5C              CMP    byte ptr [di], 0x5c          ; UNKNOWN
069512  75 E8                 JNE    0x694fc                      ; UNKNOWN
069514  8D 45 01              LEA    ax, [di + 1]                 ; UNKNOWN
069517  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
06951A  EB E8                 JMP    0x69504                      ; UNKNOWN
06951C  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
069520  74 32                 JE     0x69554                      ; UNKNOWN
069522  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
069526  74 26                 JE     0x6954e                      ; UNKNOWN
069528  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
06952B  2B C6                 SUB    ax, si                       ; UNKNOWN
06952D  3D FF 00              CMP    ax, 0xff                     ; UNKNOWN
069530  7E 03                 JLE    0x69535                      ; UNKNOWN
069532  B8 FF 00              MOV    ax, 0xff                     ; UNKNOWN
069535  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
069538  50                    PUSH   ax                           ; UNKNOWN
069539  56                    PUSH   si                           ; UNKNOWN
06953A  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06953D  9A 24 08 65 5F        LCALL  0x5f65, 0x824                ; UNKNOWN
069542  83 C4 06              ADD    sp, 6                        ; UNKNOWN
069545  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
069548  03 5E 0A              ADD    bx, word ptr [bp + 0xa]      ; UNKNOWN
06954B  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
06954E  8B 76 FC              MOV    si, word ptr [bp - 4]        ; UNKNOWN
069551  EB 0D                 JMP    0x69560                      ; UNKNOWN
069553  90                    NOP                                 ; UNKNOWN
069554  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
069558  74 06                 JE     0x69560                      ; UNKNOWN
06955A  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
06955D  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
069560  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
069564  74 5E                 JE     0x695c4                      ; UNKNOWN
069566  39 76 FE              CMP    word ptr [bp - 2], si        ; UNKNOWN
069569  72 59                 JB     0x695c4                      ; UNKNOWN
06956B  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
06956F  74 26                 JE     0x69597                      ; UNKNOWN
069571  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
069574  2B C6                 SUB    ax, si                       ; UNKNOWN
069576  3D FF 00              CMP    ax, 0xff                     ; UNKNOWN
069579  7E 03                 JLE    0x6957e                      ; UNKNOWN
06957B  B8 FF 00              MOV    ax, 0xff                     ; UNKNOWN
06957E  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
069581  50                    PUSH   ax                           ; UNKNOWN
069582  56                    PUSH   si                           ; UNKNOWN
069583  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
069586  9A 24 08 65 5F        LCALL  0x5f65, 0x824                ; UNKNOWN
06958B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
06958E  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
069591  03 5E 0C              ADD    bx, word ptr [bp + 0xc]      ; UNKNOWN
069594  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
069597  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0       ; UNKNOWN
06959B  74 5E                 JE     0x695fb                      ; UNKNOWN
06959D  8B C7                 MOV    ax, di                       ; UNKNOWN
06959F  2B 46 FE              SUB    ax, word ptr [bp - 2]        ; UNKNOWN
0695A2  3D FF 00              CMP    ax, 0xff                     ; UNKNOWN
0695A5  7E 03                 JLE    0x695aa                      ; UNKNOWN
0695A7  B8 FF 00              MOV    ax, 0xff                     ; UNKNOWN
0695AA  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0695AD  50                    PUSH   ax                           ; UNKNOWN
0695AE  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0695B1  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
0695B4  9A 24 08 65 5F        LCALL  0x5f65, 0x824                ; UNKNOWN
0695B9  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0695BC  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0695BF  03 5E 0E              ADD    bx, word ptr [bp + 0xe]      ; UNKNOWN
0695C2  EB 34                 JMP    0x695f8                      ; UNKNOWN
0695C4  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
0695C8  74 25                 JE     0x695ef                      ; UNKNOWN
0695CA  8B C7                 MOV    ax, di                       ; UNKNOWN
0695CC  2B C6                 SUB    ax, si                       ; UNKNOWN
0695CE  3D FF 00              CMP    ax, 0xff                     ; UNKNOWN
0695D1  7E 03                 JLE    0x695d6                      ; UNKNOWN
0695D3  B8 FF 00              MOV    ax, 0xff                     ; UNKNOWN
0695D6  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0695D9  50                    PUSH   ax                           ; UNKNOWN
0695DA  56                    PUSH   si                           ; UNKNOWN
0695DB  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
0695DE  9A 24 08 65 5F        LCALL  0x5f65, 0x824                ; UNKNOWN
0695E3  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0695E6  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0695E9  03 5E 0C              ADD    bx, word ptr [bp + 0xc]      ; UNKNOWN
0695EC  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
0695EF  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0       ; UNKNOWN
0695F3  74 06                 JE     0x695fb                      ; UNKNOWN
0695F5  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
0695F8  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
0695FB  5E                    POP    si                           ; UNKNOWN
0695FC  5F                    POP    di                           ; UNKNOWN
0695FD  8B E5                 MOV    sp, bp                       ; UNKNOWN
0695FF  5D                    POP    bp                           ; UNKNOWN
069600  CB                    RETF                                ; UNKNOWN
