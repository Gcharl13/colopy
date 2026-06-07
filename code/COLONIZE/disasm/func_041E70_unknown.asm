; ============================================================================
; func_041E70_unknown
; Region   : load_image
; Bytes    : file 0x041E70..0x041FD4  (356 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041E70  C8 1A 00 00           ENTER  0x1a, 0                      ; UNKNOWN
041E74  53                    PUSH   bx                           ; UNKNOWN
041E75  52                    PUSH   dx                           ; UNKNOWN
041E76  50                    PUSH   ax                           ; UNKNOWN
041E77  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
041E7C  8D 4E 10              LEA    cx, [bp + 0x10]              ; UNKNOWN
041E7F  51                    PUSH   cx                           ; UNKNOWN
041E80  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
041E83  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
041E86  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
041E89  8D 4E FC              LEA    cx, [bp - 4]                 ; UNKNOWN
041E8C  51                    PUSH   cx                           ; UNKNOWN
041E8D  8D 4E EC              LEA    cx, [bp - 0x14]              ; UNKNOWN
041E90  51                    PUSH   cx                           ; UNKNOWN
041E91  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041E94  0E                    PUSH   cs                           ; UNKNOWN
041E95  E8 6A FE              CALL   0x41d02                      ; UNKNOWN
041E98  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
041E9B  0B C0                 OR     ax, ax                       ; UNKNOWN
041E9D  75 03                 JNE    0x41ea2                      ; UNKNOWN
041E9F  E9 2E 01              JMP    0x41fd0                      ; UNKNOWN
041EA2  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
041EA7  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
041EAA  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
041EAD  2B 46 E4              SUB    ax, word ptr [bp - 0x1c]     ; UNKNOWN
041EB0  F7 D8                 NEG    ax                           ; UNKNOWN
041EB2  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
041EB5  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
041EB8  8A 4E EC              MOV    cl, byte ptr [bp - 0x14]     ; UNKNOWN
041EBB  D3 7E 08              SAR    word ptr [bp + 8], cl        ; UNKNOWN
041EBE  D3 7E E8              SAR    word ptr [bp - 0x18], cl     ; UNKNOWN
041EC1  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
041EC4  D3 F8                 SAR    ax, cl                       ; UNKNOWN
041EC6  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
041EC9  8B 46 E4              MOV    ax, word ptr [bp - 0x1c]     ; UNKNOWN
041ECC  D3 F8                 SAR    ax, cl                       ; UNKNOWN
041ECE  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
041ED1  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
041ED5  74 0D                 JE     0x41ee4                      ; UNKNOWN
041ED7  8A 46 F6              MOV    al, byte ptr [bp - 0xa]      ; UNKNOWN
041EDA  22 46 FA              AND    al, byte ptr [bp - 6]        ; UNKNOWN
041EDD  A8 01                 TEST   al, 1                        ; UNKNOWN
041EDF  74 03                 JE     0x41ee4                      ; UNKNOWN
041EE1  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
041EE4  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
041EE7  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
041EEA  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
041EEF  EB 73                 JMP    0x41f64                      ; UNKNOWN
041EF1  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
041EF5  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
041EF9  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
041EFC  40                    INC    ax                           ; UNKNOWN
041EFD  50                    PUSH   ax                           ; UNKNOWN
041EFE  8B 46 E0              MOV    ax, word ptr [bp - 0x20]     ; UNKNOWN
041F01  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
041F05  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
041F08  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
041F0D  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
041F10  39 46 E8              CMP    word ptr [bp - 0x18], ax     ; UNKNOWN
041F13  75 06                 JNE    0x41f1b                      ; UNKNOWN
041F15  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
041F18  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
041F1B  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
041F1E  39 46 E8              CMP    word ptr [bp - 0x18], ax     ; UNKNOWN
041F21  7F 1C                 JG     0x41f3f                      ; UNKNOWN
041F23  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
041F27  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
041F2B  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
041F2E  40                    INC    ax                           ; UNKNOWN
041F2F  50                    PUSH   ax                           ; UNKNOWN
041F30  B8 38 00              MOV    ax, 0x38                     ; UNKNOWN
041F33  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
041F37  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
041F3A  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
041F3F  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
041F42  01 46 10              ADD    word ptr [bp + 0x10], ax     ; UNKNOWN
041F45  F6 46 06 01           TEST   byte ptr [bp + 6], 1         ; UNKNOWN
041F49  74 16                 JE     0x41f61                      ; UNKNOWN
041F4B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
041F4E  01 46 F8              ADD    word ptr [bp - 8], ax        ; UNKNOWN
041F51  EB 06                 JMP    0x41f59                      ; UNKNOWN
041F53  29 46 F8              SUB    word ptr [bp - 8], ax        ; UNKNOWN
041F56  FF 46 10              INC    word ptr [bp + 0x10]         ; UNKNOWN
041F59  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
041F5C  39 46 F8              CMP    word ptr [bp - 8], ax        ; UNKNOWN
041F5F  7D F2                 JGE    0x41f53                      ; UNKNOWN
041F61  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
041F64  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
041F67  39 46 F0              CMP    word ptr [bp - 0x10], ax     ; UNKNOWN
041F6A  7D 1C                 JGE    0x41f88                      ; UNKNOWN
041F6C  F6 46 06 02           TEST   byte ptr [bp + 6], 2         ; UNKNOWN
041F70  75 03                 JNE    0x41f75                      ; UNKNOWN
041F72  E9 7C FF              JMP    0x41ef1                      ; UNKNOWN
041F75  6A 03                 PUSH   3                            ; UNKNOWN
041F77  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
041F7A  43                    INC    bx                           ; UNKNOWN
041F7B  8B 46 E0              MOV    ax, word ptr [bp - 0x20]     ; UNKNOWN
041F7E  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
041F81  9A 60 01 76 1A        LCALL  0x1a76, 0x160                ; UNKNOWN
041F86  EB 85                 JMP    0x41f0d                      ; UNKNOWN
041F88  A1 96 0B              MOV    ax, word ptr [0xb96]         ; UNKNOWN
041F8B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
041F8E  83 7E EA 01           CMP    word ptr [bp - 0x16], 1      ; UNKNOWN
041F92  75 0B                 JNE    0x41f9f                      ; UNKNOWN
041F94  83 7E E4 01           CMP    word ptr [bp - 0x1c], 1      ; UNKNOWN
041F98  7E 05                 JLE    0x41f9f                      ; UNKNOWN
041F9A  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
041F9F  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
041FA3  74 2B                 JE     0x41fd0                      ; UNKNOWN
041FA5  6A 01                 PUSH   1                            ; UNKNOWN
041FA7  6A 0F                 PUSH   0xf                          ; UNKNOWN
041FA9  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
041FAC  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
041FAF  40                    INC    ax                           ; UNKNOWN
041FB0  40                    INC    ax                           ; UNKNOWN
041FB1  50                    PUSH   ax                           ; UNKNOWN
041FB2  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
041FB5  0E                    PUSH   cs                           ; UNKNOWN
041FB6  E8 22 FE              CALL   0x41ddb                      ; UNKNOWN
041FB9  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
041FBC  6A 01                 PUSH   1                            ; UNKNOWN
041FBE  6A 0C                 PUSH   0xc                          ; UNKNOWN
041FC0  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
041FC3  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
041FC6  40                    INC    ax                           ; UNKNOWN
041FC7  40                    INC    ax                           ; UNKNOWN
041FC8  50                    PUSH   ax                           ; UNKNOWN
041FC9  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
041FCC  0E                    PUSH   cs                           ; UNKNOWN
041FCD  E8 0B FE              CALL   0x41ddb                      ; UNKNOWN
041FD0  C9                    LEAVE                               ; UNKNOWN
041FD1  CA 0C 00              RETF   0xc                          ; UNKNOWN
