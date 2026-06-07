; ============================================================================
; func_01C8C3_unknown
; Region   : load_image
; Bytes    : file 0x01C8C3..0x01CAFB  (568 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01C8C3  C8 1E 00 00           ENTER  0x1e, 0                      ; UNKNOWN
01C8C7  B8 01 00              MOV    ax, 1                        ; UNKNOWN
01C8CA  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01C8CD  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
01C8D0  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
01C8D5  2B C0                 SUB    ax, ax                       ; UNKNOWN
01C8D7  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01C8DA  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01C8DD  9A 42 38 5F 24        LCALL  0x245f, 0x3842               ; UNKNOWN
01C8E2  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
01C8E5  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
01C8E8  8B 0E B4 09           MOV    cx, word ptr [0x9b4]         ; UNKNOWN
01C8EC  8B 16 B6 09           MOV    dx, word ptr [0x9b6]         ; UNKNOWN
01C8F0  89 4E E8              MOV    word ptr [bp - 0x18], cx     ; UNKNOWN
01C8F3  89 56 EA              MOV    word ptr [bp - 0x16], dx     ; UNKNOWN
01C8F6  83 F8 0E              CMP    ax, 0xe                      ; UNKNOWN
01C8F9  7E 0F                 JLE    0x1c90a                      ; UNKNOWN
01C8FB  83 F8 16              CMP    ax, 0x16                     ; UNKNOWN
01C8FE  7E 0A                 JLE    0x1c90a                      ; UNKNOWN
01C900  C7 46 F8 02 00        MOV    word ptr [bp - 8], 2         ; UNKNOWN
01C905  C7 46 EC 10 00        MOV    word ptr [bp - 0x14], 0x10   ; UNKNOWN
01C90A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
01C90F  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
01C912  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
01C915  68 00 08              PUSH   0x800                        ; UNKNOWN
01C918  9A BE 06 97 1B        LCALL  0x1b97, 0x6be                ; UNKNOWN
01C91D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01C920  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01C923  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
01C926  0B D0                 OR     dx, ax                       ; UNKNOWN
01C928  75 03                 JNE    0x1c92d                      ; UNKNOWN
01C92A  E9 EB 01              JMP    0x1cb18                      ; UNKNOWN
01C92D  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
01C930  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1    ; UNKNOWN
01C935  FF 36 A1 3B           PUSH   word ptr [0x3ba1]            ; UNKNOWN
01C939  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
01C93E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C941  52                    PUSH   dx                           ; UNKNOWN
01C942  50                    PUSH   ax                           ; UNKNOWN
01C943  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01C946  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01C949  9A 17 0C 97 1B        LCALL  0x1b97, 0xc17                ; UNKNOWN
01C94E  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01C951  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01C955  7E 1E                 JLE    0x1c975                      ; UNKNOWN
01C957  6A 62                 PUSH   0x62                         ; UNKNOWN
01C959  FF 36 A5 3B           PUSH   word ptr [0x3ba5]            ; UNKNOWN
01C95D  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
01C962  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C965  52                    PUSH   dx                           ; UNKNOWN
01C966  50                    PUSH   ax                           ; UNKNOWN
01C967  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01C96A  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01C96D  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
01C972  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
01C975  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
01C978  F7 6E FE              IMUL   word ptr [bp - 2]            ; UNKNOWN
01C97B  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
01C97E  C7 46 E6 00 00        MOV    word ptr [bp - 0x1a], 0      ; UNKNOWN
01C983  EB 5F                 JMP    0x1c9e4                      ; UNKNOWN
01C985  03 46 E4              ADD    ax, word ptr [bp - 0x1c]     ; UNKNOWN
01C988  50                    PUSH   ax                           ; UNKNOWN
01C989  9A 6F 38 5F 24        LCALL  0x245f, 0x386f               ; UNKNOWN
01C98E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01C991  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
01C994  83 F8 FF              CMP    ax, -1                       ; UNKNOWN
01C997  7C 48                 JL     0x1c9e1                      ; UNKNOWN
01C999  50                    PUSH   ax                           ; UNKNOWN
01C99A  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01C99D  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01C9A0  0E                    PUSH   cs                           ; UNKNOWN
01C9A1  E8 B8 FD              CALL   0x1c75c                      ; UNKNOWN
01C9A4  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01C9A7  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01C9AB  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
01C9AF  98                    CWDE                                ; UNKNOWN
01C9B0  3B 46 E2              CMP    ax, word ptr [bp - 0x1e]     ; UNKNOWN
01C9B3  75 2C                 JNE    0x1c9e1                      ; UNKNOWN
01C9B5  40                    INC    ax                           ; UNKNOWN
01C9B6  40                    INC    ax                           ; UNKNOWN
01C9B7  50                    PUSH   ax                           ; UNKNOWN
01C9B8  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01C9BB  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01C9BE  9A C9 09 97 1B        LCALL  0x1b97, 0x9c9                ; UNKNOWN
01C9C3  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01C9C6  6A 01                 PUSH   1                            ; UNKNOWN
01C9C8  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
01C9CB  40                    INC    ax                           ; UNKNOWN
01C9CC  40                    INC    ax                           ; UNKNOWN
01C9CD  50                    PUSH   ax                           ; UNKNOWN
01C9CE  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01C9D1  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01C9D4  9A 15 09 97 1B        LCALL  0x1b97, 0x915                ; UNKNOWN
01C9D9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01C9DC  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
01C9E1  FF 46 E6              INC    word ptr [bp - 0x1a]         ; UNKNOWN
01C9E4  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
01C9E7  39 46 EC              CMP    word ptr [bp - 0x14], ax     ; UNKNOWN
01C9EA  7F 99                 JG     0x1c985                      ; UNKNOWN
01C9EC  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
01C9EF  48                    DEC    ax                           ; UNKNOWN
01C9F0  3B 46 FE              CMP    ax, word ptr [bp - 2]        ; UNKNOWN
01C9F3  7E 4B                 JLE    0x1ca40                      ; UNKNOWN
01C9F5  6A 63                 PUSH   0x63                         ; UNKNOWN
01C9F7  FF 36 A5 3B           PUSH   word ptr [0x3ba5]            ; UNKNOWN
01C9FB  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
01CA00  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01CA03  52                    PUSH   dx                           ; UNKNOWN
01CA04  50                    PUSH   ax                           ; UNKNOWN
01CA05  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01CA08  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01CA0B  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
01CA10  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
01CA13  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
01CA17  75 27                 JNE    0x1ca40                      ; UNKNOWN
01CA19  6A 65                 PUSH   0x65                         ; UNKNOWN
01CA1B  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01CA1E  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01CA21  9A C9 09 97 1B        LCALL  0x1b97, 0x9c9                ; UNKNOWN
01CA26  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01CA29  6A 01                 PUSH   1                            ; UNKNOWN
01CA2B  6A 65                 PUSH   0x65                         ; UNKNOWN
01CA2D  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01CA30  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01CA33  9A 15 09 97 1B        LCALL  0x1b97, 0x915                ; UNKNOWN
01CA38  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01CA3B  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
01CA40  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
01CA44  75 28                 JNE    0x1ca6e                      ; UNKNOWN
01CA46  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01CA4A  74 22                 JE     0x1ca6e                      ; UNKNOWN
01CA4C  6A 64                 PUSH   0x64                         ; UNKNOWN
01CA4E  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01CA51  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01CA54  9A C9 09 97 1B        LCALL  0x1b97, 0x9c9                ; UNKNOWN
01CA59  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01CA5C  6A 01                 PUSH   1                            ; UNKNOWN
01CA5E  6A 64                 PUSH   0x64                         ; UNKNOWN
01CA60  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01CA63  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01CA66  9A 15 09 97 1B        LCALL  0x1b97, 0x915                ; UNKNOWN
01CA6B  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01CA6E  C7 06 0E 0A 01 00     MOV    word ptr [0xa0e], 1          ; UNKNOWN
01CA74  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01CA77  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01CA7A  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
01CA7F  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01CA82  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
01CA85  0B 46 F4              OR     ax, word ptr [bp - 0xc]      ; UNKNOWN
01CA88  74 0B                 JE     0x1ca95                      ; UNKNOWN
01CA8A  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01CA8D  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01CA90  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
01CA95  2B C0                 SUB    ax, ax                       ; UNKNOWN
01CA97  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01CA9A  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01CA9D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
01CAA0  83 E8 62              SUB    ax, 0x62                     ; UNKNOWN
01CAA3  74 37                 JE     0x1cadc                      ; UNKNOWN
01CAA5  48                    DEC    ax                           ; UNKNOWN
01CAA6  74 39                 JE     0x1cae1                      ; UNKNOWN
01CAA8  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
01CAAD  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
01CAB1  7E 5C                 JLE    0x1cb0f                      ; UNKNOWN
01CAB3  83 3E 10 0A 00        CMP    word ptr [0xa10], 0          ; UNKNOWN
01CAB8  74 44                 JE     0x1cafe                      ; UNKNOWN
01CABA  8D 46 E2              LEA    ax, [bp - 0x1e]              ; UNKNOWN
01CABD  50                    PUSH   ax                           ; UNKNOWN
01CABE  8B 4E FC              MOV    cx, word ptr [bp - 4]        ; UNKNOWN
01CAC1  49                    DEC    cx                           ; UNKNOWN
01CAC2  49                    DEC    cx                           ; UNKNOWN
01CAC3  51                    PUSH   cx                           ; UNKNOWN
01CAC4  9A 92 32 5F 24        LCALL  0x245f, 0x3292               ; UNKNOWN
01CAC9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01CACC  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01CACF  48                    DEC    ax                           ; UNKNOWN
01CAD0  75 14                 JNE    0x1cae6                      ; UNKNOWN
01CAD2  FF 76 E2              PUSH   word ptr [bp - 0x1e]         ; UNKNOWN
01CAD5  9A 8C 1B A2 3F        LCALL  0x3fa2, 0x1b8c               ; UNKNOWN
01CADA  EB 18                 JMP    0x1caf4                      ; UNKNOWN
01CADC  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
01CADF  EB 2E                 JMP    0x1cb0f                      ; UNKNOWN
01CAE1  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
01CAE4  EB 29                 JMP    0x1cb0f                      ; UNKNOWN
01CAE6  83 7E F2 02           CMP    word ptr [bp - 0xe], 2       ; UNKNOWN
01CAEA  75 0B                 JNE    0x1caf7                      ; UNKNOWN
01CAEC  FF 76 E2              PUSH   word ptr [bp - 0x1e]         ; UNKNOWN
01CAEF  9A DC 07 A2 3F        LCALL  0x3fa2, 0x7dc                ; UNKNOWN
01CAF4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01CAF7  0E                    PUSH   cs                           ; UNKNOWN
01CAF8  E8 59 CF              CALL   0x19a54                      ; UNKNOWN
