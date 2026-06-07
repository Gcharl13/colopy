; ============================================================================
; func_00EBE4_unknown
; Region   : load_image
; Bytes    : file 0x00EBE4..0x00ED85  (417 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EBE4  C8 50 00 00           ENTER  0x50, 0                      ; UNKNOWN
00EBE8  52                    PUSH   dx                           ; UNKNOWN
00EBE9  50                    PUSH   ax                           ; UNKNOWN
00EBEA  53                    PUSH   bx                           ; UNKNOWN
00EBEB  83 7E 06 EC           CMP    word ptr [bp + 6], -0x14     ; UNKNOWN
00EBEF  75 03                 JNE    0xebf4                       ; UNKNOWN
00EBF1  E9 8D 01              JMP    0xed81                       ; UNKNOWN
00EBF4  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
00EBF7  52                    PUSH   dx                           ; UNKNOWN
00EBF8  50                    PUSH   ax                           ; UNKNOWN
00EBF9  53                    PUSH   bx                           ; UNKNOWN
00EBFA  68 E0 05              PUSH   0x5e0                        ; UNKNOWN
00EBFD  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00EC00  50                    PUSH   ax                           ; UNKNOWN
00EC01  9A CC 0A 65 5F        LCALL  0x5f65, 0xacc                ; UNKNOWN
00EC06  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
00EC09  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00EC0C  50                    PUSH   ax                           ; UNKNOWN
00EC0D  68 06 06              PUSH   0x606                        ; UNKNOWN
00EC10  9A 50 00 00 00        LCALL  0, 0x50                      ; UNKNOWN
00EC15  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00EC18  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
00EC1C  74 0D                 JE     0xec2b                       ; UNKNOWN
00EC1E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00EC21  16                    PUSH   ss                           ; UNKNOWN
00EC22  50                    PUSH   ax                           ; UNKNOWN
00EC23  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00EC26  9A 0A 00 E5 5A        LCALL  0x5ae5, 0xa                  ; UNKNOWN
00EC2B  68 A8 D3              PUSH   0xd3a8                       ; UNKNOWN
00EC2E  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
00EC33  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00EC36  0B C0                 OR     ax, ax                       ; UNKNOWN
00EC38  74 20                 JE     0xec5a                       ; UNKNOWN
00EC3A  68 A8 D3              PUSH   0xd3a8                       ; UNKNOWN
00EC3D  68 0A 06              PUSH   0x60a                        ; UNKNOWN
00EC40  9A 50 00 00 00        LCALL  0, 0x50                      ; UNKNOWN
00EC45  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00EC48  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
00EC4C  74 0C                 JE     0xec5a                       ; UNKNOWN
00EC4E  1E                    PUSH   ds                           ; UNKNOWN
00EC4F  68 A8 D3              PUSH   0xd3a8                       ; UNKNOWN
00EC52  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00EC55  9A 0A 00 E5 5A        LCALL  0x5ae5, 0xa                  ; UNKNOWN
00EC5A  80 3E 31 01 00        CMP    byte ptr [0x131], 0          ; UNKNOWN
00EC5F  74 6B                 JE     0xeccc                       ; UNKNOWN
00EC61  6A 0A                 PUSH   0xa                          ; UNKNOWN
00EC63  FF 76 AE              PUSH   word ptr [bp - 0x52]         ; UNKNOWN
00EC66  FF 36 36 01           PUSH   word ptr [0x136]             ; UNKNOWN
00EC6A  FF 36 34 01           PUSH   word ptr [0x134]             ; UNKNOWN
00EC6E  9A A6 08 65 5F        LCALL  0x5f65, 0x8a6                ; UNKNOWN
00EC73  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00EC76  6A 0A                 PUSH   0xa                          ; UNKNOWN
00EC78  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
00EC7B  FF 36 3A 01           PUSH   word ptr [0x13a]             ; UNKNOWN
00EC7F  FF 36 38 01           PUSH   word ptr [0x138]             ; UNKNOWN
00EC83  9A A6 08 65 5F        LCALL  0x5f65, 0x8a6                ; UNKNOWN
00EC88  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00EC8B  FF 36 3A 01           PUSH   word ptr [0x13a]             ; UNKNOWN
00EC8F  FF 36 38 01           PUSH   word ptr [0x138]             ; UNKNOWN
00EC93  FF 36 36 01           PUSH   word ptr [0x136]             ; UNKNOWN
00EC97  FF 36 34 01           PUSH   word ptr [0x134]             ; UNKNOWN
00EC9B  68 0E 06              PUSH   0x60e                        ; UNKNOWN
00EC9E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ECA1  50                    PUSH   ax                           ; UNKNOWN
00ECA2  9A CC 0A 65 5F        LCALL  0x5f65, 0xacc                ; UNKNOWN
00ECA7  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
00ECAA  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ECAD  50                    PUSH   ax                           ; UNKNOWN
00ECAE  68 49 06              PUSH   0x649                        ; UNKNOWN
00ECB1  9A 50 00 00 00        LCALL  0, 0x50                      ; UNKNOWN
00ECB6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00ECB9  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
00ECBD  74 0D                 JE     0xeccc                       ; UNKNOWN
00ECBF  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ECC2  16                    PUSH   ss                           ; UNKNOWN
00ECC3  50                    PUSH   ax                           ; UNKNOWN
00ECC4  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00ECC7  9A 0A 00 E5 5A        LCALL  0x5ae5, 0xa                  ; UNKNOWN
00ECCC  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
00ECD0  74 0C                 JE     0xecde                       ; UNKNOWN
00ECD2  1E                    PUSH   ds                           ; UNKNOWN
00ECD3  68 4D 06              PUSH   0x64d                        ; UNKNOWN
00ECD6  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00ECD9  9A 0A 00 E5 5A        LCALL  0x5ae5, 0xa                  ; UNKNOWN
00ECDE  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
00ECE1  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00ECE4  68 4F 06              PUSH   0x64f                        ; UNKNOWN
00ECE7  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ECEA  50                    PUSH   ax                           ; UNKNOWN
00ECEB  9A CC 0A 65 5F        LCALL  0x5f65, 0xacc                ; UNKNOWN
00ECF0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00ECF3  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ECF6  50                    PUSH   ax                           ; UNKNOWN
00ECF7  68 6D 06              PUSH   0x66d                        ; UNKNOWN
00ECFA  9A 50 00 00 00        LCALL  0, 0x50                      ; UNKNOWN
00ECFF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00ED02  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
00ED06  74 0D                 JE     0xed15                       ; UNKNOWN
00ED08  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ED0B  16                    PUSH   ss                           ; UNKNOWN
00ED0C  50                    PUSH   ax                           ; UNKNOWN
00ED0D  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00ED10  9A 0A 00 E5 5A        LCALL  0x5ae5, 0xa                  ; UNKNOWN
00ED15  FF 36 38 12           PUSH   word ptr [0x1238]            ; UNKNOWN
00ED19  68 71 06              PUSH   0x671                        ; UNKNOWN
00ED1C  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ED1F  50                    PUSH   ax                           ; UNKNOWN
00ED20  9A CC 0A 65 5F        LCALL  0x5f65, 0xacc                ; UNKNOWN
00ED25  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00ED28  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ED2B  50                    PUSH   ax                           ; UNKNOWN
00ED2C  68 8E 06              PUSH   0x68e                        ; UNKNOWN
00ED2F  9A 50 00 00 00        LCALL  0, 0x50                      ; UNKNOWN
00ED34  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00ED37  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
00ED3B  74 0D                 JE     0xed4a                       ; UNKNOWN
00ED3D  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ED40  16                    PUSH   ss                           ; UNKNOWN
00ED41  50                    PUSH   ax                           ; UNKNOWN
00ED42  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00ED45  9A 0A 00 E5 5A        LCALL  0x5ae5, 0xa                  ; UNKNOWN
00ED4A  9A 23 00 1F 5E        LCALL  0x5e1f, 0x23                 ; UNKNOWN
00ED4F  50                    PUSH   ax                           ; UNKNOWN
00ED50  68 92 06              PUSH   0x692                        ; UNKNOWN
00ED53  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ED56  50                    PUSH   ax                           ; UNKNOWN
00ED57  9A CC 0A 65 5F        LCALL  0x5f65, 0xacc                ; UNKNOWN
00ED5C  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00ED5F  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ED62  50                    PUSH   ax                           ; UNKNOWN
00ED63  68 AF 06              PUSH   0x6af                        ; UNKNOWN
00ED66  9A 50 00 00 00        LCALL  0, 0x50                      ; UNKNOWN
00ED6B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00ED6E  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
00ED72  74 0D                 JE     0xed81                       ; UNKNOWN
00ED74  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00ED77  16                    PUSH   ss                           ; UNKNOWN
00ED78  50                    PUSH   ax                           ; UNKNOWN
00ED79  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00ED7C  9A 0A 00 E5 5A        LCALL  0x5ae5, 0xa                  ; UNKNOWN
00ED81  C9                    LEAVE                               ; UNKNOWN
00ED82  C2 0A 00              RET    0xa                          ; UNKNOWN
