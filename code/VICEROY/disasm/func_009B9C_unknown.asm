; ============================================================================
; func_009B9C_unknown
; Region   : load_image
; Bytes    : file 0x009B9C..0x009FFC  (1120 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009B9C  C8 2A 00 00           ENTER  0x2a, 0                      ; UNKNOWN
009BA0  56                    PUSH   si                           ; UNKNOWN
009BA1  2B C0                 SUB    ax, ax                       ; UNKNOWN
009BA3  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; LOCAL_STORE
009BA6  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; LOCAL_STORE
009BA9  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; LOCAL_STORE
009BAC  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
009BAF  50                    PUSH   ax                           ; UNKNOWN
009BB0  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
009BB3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009BB6  0E                    PUSH   cs                           ; UNKNOWN
009BB7  E8 BA FD              CALL   0x9974                       ; UNKNOWN
009BBA  83 C4 06              ADD    sp, 6                        ; UNKNOWN
009BBD  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; LOCAL_STORE
009BC0  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; LOCAL_LOAD
009BC3  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
009BC5  0B C0                 OR     ax, ax                       ; UNKNOWN
009BC7  7D 03                 JGE    0x9bcc                       ; UNKNOWN
009BC9  E9 2A 04              JMP    0x9ff6                       ; UNKNOWN
009BCC  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009BD0  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
009BD3  2A E4                 SUB    ah, ah                       ; UNKNOWN
009BD5  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
009BD8  48                    DEC    ax                           ; UNKNOWN
009BD9  48                    DEC    ax                           ; UNKNOWN
009BDA  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
009BDD  50                    PUSH   ax                           ; UNKNOWN
009BDE  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
009BE0  2A E4                 SUB    ah, ah                       ; UNKNOWN
009BE2  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
009BE5  48                    DEC    ax                           ; UNKNOWN
009BE6  48                    DEC    ax                           ; UNKNOWN
009BE7  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
009BEA  50                    PUSH   ax                           ; UNKNOWN
009BEB  9A 0E 01 7F 03        LCALL  0x37f, 0x10e                 ; UNKNOWN
009BF0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009BF3  88 46 DA              MOV    byte ptr [bp - 0x26], al     ; LOCAL_STORE
009BF6  2A E4                 SUB    ah, ah                       ; UNKNOWN
009BF8  50                    PUSH   ax                           ; UNKNOWN
009BF9  9A 0E 00 E4 03        LCALL  0x3e4, 0xe                   ; UNKNOWN
009BFE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009C01  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; LOCAL_STORE
009C04  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009C07  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009C0A  9A B0 04 7F 03        LCALL  0x37f, 0x4b0                 ; UNKNOWN
009C0F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009C12  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; LOCAL_STORE
009C15  8B 76 E2              MOV    si, word ptr [bp - 0x1e]     ; LOCAL_LOAD
009C18  C1 E6 04              SHL    si, 4                        ; UNKNOWN
009C1B  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; LOCAL_LOAD
009C1E  8A 80 7B 2F           MOV    al, byte ptr [bx + si + 0x2f7b] ; MOV
009C22  2A E4                 SUB    ah, ah                       ; UNKNOWN
009C24  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; LOCAL_STORE
009C27  0B C0                 OR     ax, ax                       ; UNKNOWN
009C29  75 03                 JNE    0x9c2e                       ; UNKNOWN
009C2B  E9 86 00              JMP    0x9cb4                       ; UNKNOWN
009C2E  83 FB 08              CMP    bx, 8                        ; UNKNOWN
009C31  7C 54                 JL     0x9c87                       ; UNKNOWN
009C33  6A 1A                 PUSH   0x1a                         ; UNKNOWN
009C35  6A 19                 PUSH   0x19                         ; UNKNOWN
009C37  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009C3A  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009C3D  0E                    PUSH   cs                           ; UNKNOWN
009C3E  E8 AD FD              CALL   0x99ee                       ; UNKNOWN
009C41  83 C4 08              ADD    sp, 8                        ; UNKNOWN
009C44  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
009C47  3D 08 00              CMP    ax, 8                        ; UNKNOWN
009C4A  7C 06                 JL     0x9c52                       ; UNKNOWN
009C4C  83 6E DC 02           SUB    word ptr [bp - 0x24], 2      ; ARITH
009C50  EB 35                 JMP    0x9c87                       ; UNKNOWN
009C52  3D 06 00              CMP    ax, 6                        ; UNKNOWN
009C55  7C 05                 JL     0x9c5c                       ; UNKNOWN
009C57  FF 4E DC              DEC    word ptr [bp - 0x24]         ; UNKNOWN
009C5A  EB 2B                 JMP    0x9c87                       ; UNKNOWN
009C5C  3D 06 00              CMP    ax, 6                        ; UNKNOWN
009C5F  7D 05                 JGE    0x9c66                       ; UNKNOWN
009C61  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
009C64  EB 21                 JMP    0x9c87                       ; UNKNOWN
009C66  3D 04 00              CMP    ax, 4                        ; UNKNOWN
009C69  7D 07                 JGE    0x9c72                       ; UNKNOWN
009C6B  83 46 DC 02           ADD    word ptr [bp - 0x24], 2      ; ARITH
009C6F  EB 16                 JMP    0x9c87                       ; UNKNOWN
009C71  90                    NOP                                 ; UNKNOWN
009C72  3D 03 00              CMP    ax, 3                        ; UNKNOWN
009C75  7D 07                 JGE    0x9c7e                       ; UNKNOWN
009C77  83 46 DC 03           ADD    word ptr [bp - 0x24], 3      ; ARITH
009C7B  EB 0A                 JMP    0x9c87                       ; UNKNOWN
009C7D  90                    NOP                                 ; UNKNOWN
009C7E  3D 01 00              CMP    ax, 1                        ; UNKNOWN
009C81  7D 04                 JGE    0x9c87                       ; UNKNOWN
009C83  83 46 DC 04           ADD    word ptr [bp - 0x24], 4      ; ARITH
009C87  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; CMP
009C8B  75 27                 JNE    0x9cb4                       ; UNKNOWN
009C8D  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009C90  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009C93  9A 42 01 7F 03        LCALL  0x37f, 0x142                 ; UNKNOWN
009C98  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009C9B  A8 0A                 TEST   al, 0xa                      ; UNKNOWN
009C9D  74 03                 JE     0x9ca2                       ; UNKNOWN
009C9F  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
009CA2  F6 46 DA 40           TEST   byte ptr [bp - 0x26], 0x40   ; LOGIC
009CA6  74 0C                 JE     0x9cb4                       ; UNKNOWN
009CA8  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
009CAB  F6 46 DA 80           TEST   byte ptr [bp - 0x26], 0x80   ; LOGIC
009CAF  74 03                 JE     0x9cb4                       ; UNKNOWN
009CB1  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
009CB4  8B 46 DC              MOV    ax, word ptr [bp - 0x24]     ; LOCAL_LOAD
009CB7  0B C0                 OR     ax, ax                       ; UNKNOWN
009CB9  7D 02                 JGE    0x9cbd                       ; UNKNOWN
009CBB  2B C0                 SUB    ax, ax                       ; UNKNOWN
009CBD  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; LOCAL_STORE
009CC0  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
009CC3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009CC6  0E                    PUSH   cs                           ; UNKNOWN
009CC7  E8 8C EC              CALL   0x8956                       ; UNKNOWN
009CCA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009CCD  98                    CWDE                                ; UNKNOWN
009CCE  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; LOCAL_STORE
009CD1  50                    PUSH   ax                           ; UNKNOWN
009CD2  0E                    PUSH   cs                           ; UNKNOWN
009CD3  E8 2C F4              CALL   0x9102                       ; UNKNOWN
009CD6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009CD9  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; LOCAL_STORE
009CDC  3B 46 EE              CMP    ax, word ptr [bp - 0x12]     ; CMP
009CDF  75 05                 JNE    0x9ce6                       ; UNKNOWN
009CE1  B8 01 00              MOV    ax, 1                        ; UNKNOWN
009CE4  EB 02                 JMP    0x9ce8                       ; UNKNOWN
009CE6  2B C0                 SUB    ax, ax                       ; UNKNOWN
009CE8  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; LOCAL_STORE
009CEB  83 7E E0 1B           CMP    word ptr [bp - 0x20], 0x1b   ; CMP
009CEF  75 05                 JNE    0x9cf6                       ; UNKNOWN
009CF1  B8 01 00              MOV    ax, 1                        ; UNKNOWN
009CF4  EB 02                 JMP    0x9cf8                       ; UNKNOWN
009CF6  2B C0                 SUB    ax, ax                       ; UNKNOWN
009CF8  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
009CFB  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; CMP
009CFF  74 06                 JE     0x9d07                       ; UNKNOWN
009D01  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; CMP
009D05  75 07                 JNE    0x9d0e                       ; UNKNOWN
009D07  C7 46 EC 01 00        MOV    word ptr [bp - 0x14], 1      ; LOCAL_STORE
009D0C  EB 05                 JMP    0x9d13                       ; UNKNOWN
009D0E  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0      ; LOCAL_STORE
009D13  0E                    PUSH   cs                           ; UNKNOWN
009D14  E8 0D E8              CALL   0x8524                       ; UNKNOWN
009D17  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; LOCAL_STORE
009D1A  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
009D1D  2B C8                 SUB    cx, ax                       ; UNKNOWN
009D1F  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009D23  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
009D26  98                    CWDE                                ; UNKNOWN
009D27  F7 E9                 IMUL   cx                           ; UNKNOWN
009D29  05 32 00              ADD    ax, 0x32                     ; UNKNOWN
009D2C  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
009D2F  99                    CDQ                                 ; UNKNOWN
009D30  F7 F9                 IDIV   cx                           ; UNKNOWN
009D32  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; LOCAL_STORE
009D35  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; CMP
009D39  73 1B                 JAE    0x9d56                       ; UNKNOWN
009D3B  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
009D3E  2A E4                 SUB    ah, ah                       ; UNKNOWN
009D40  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
009D43  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah   ; CMP
009D47  75 0D                 JNE    0x9d56                       ; UNKNOWN
009D49  A0 A6 53              MOV    al, byte ptr [0x53a6]        ; UNKNOWN
009D4C  2D 0A 00              SUB    ax, 0xa                      ; UNKNOWN
009D4F  F7 D8                 NEG    ax                           ; UNKNOWN
009D51  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; LOCAL_STORE
009D54  EB 05                 JMP    0x9d5b                       ; UNKNOWN
009D56  C7 46 F2 0A 00        MOV    word ptr [bp - 0xe], 0xa     ; LOCAL_STORE
009D5B  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009D5F  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; CMP
009D63  73 0E                 JAE    0x9d73                       ; UNKNOWN
009D65  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
009D68  2A E4                 SUB    ah, ah                       ; UNKNOWN
009D6A  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
009D6D  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah   ; CMP
009D71  74 05                 JE     0x9d78                       ; UNKNOWN
009D73  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; LOCAL_STORE
009D78  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; LOCAL_LOAD
009D7B  99                    CDQ                                 ; UNKNOWN
009D7C  F7 7E F2              IDIV   word ptr [bp - 0xe]          ; UNKNOWN
009D7F  F7 D8                 NEG    ax                           ; UNKNOWN
009D81  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; LOCAL_STORE
009D84  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009D88  F6 47 1C 04           TEST   byte ptr [bx + 0x1c], 4      ; LOGIC
009D8C  74 04                 JE     0x9d92                       ; UNKNOWN
009D8E  40                    INC    ax                           ; UNKNOWN
009D8F  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; LOCAL_STORE
009D92  F6 47 1C 02           TEST   byte ptr [bx + 0x1c], 2      ; LOGIC
009D96  74 03                 JE     0x9d9b                       ; UNKNOWN
009D98  FF 46 E6              INC    word ptr [bp - 0x1a]         ; UNKNOWN
009D9B  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; CMP
009D9F  74 0C                 JE     0x9dad                       ; UNKNOWN
009DA1  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0      ; CMP
009DA5  7E 06                 JLE    0x9dad                       ; UNKNOWN
009DA7  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; LOCAL_LOAD
009DAA  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; ARITH
009DAD  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; CMP
009DB1  74 22                 JE     0x9dd5                       ; UNKNOWN
009DB3  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; CMP
009DB7  74 1C                 JE     0x9dd5                       ; UNKNOWN
009DB9  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; CMP
009DBD  74 13                 JE     0x9dd2                       ; UNKNOWN
009DBF  83 46 DC 02           ADD    word ptr [bp - 0x24], 2      ; ARITH
009DC3  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0      ; CMP
009DC7  7E 0C                 JLE    0x9dd5                       ; UNKNOWN
009DC9  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; LOCAL_LOAD
009DCC  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; ARITH
009DCF  EB 04                 JMP    0x9dd5                       ; UNKNOWN
009DD1  90                    NOP                                 ; UNKNOWN
009DD2  D1 66 DC              SHL    word ptr [bp - 0x24], 1      ; LOGIC
009DD5  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; LOCAL_LOAD
009DD8  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
009DDA  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
009DDD  0E                    PUSH   cs                           ; UNKNOWN
009DDE  E8 C9 FC              CALL   0x9aaa                       ; UNKNOWN
009DE1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009DE4  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; LOCAL_STORE
009DE7  83 7E E8 07           CMP    word ptr [bp - 0x18], 7      ; CMP
009DEB  75 0B                 JNE    0x9df8                       ; UNKNOWN
009DED  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; CMP
009DF1  7F 05                 JG     0x9df8                       ; UNKNOWN
009DF3  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; LOCAL_STORE
009DF8  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; CMP
009DFC  7D 06                 JGE    0x9e04                       ; UNKNOWN
009DFE  D1 66 DC              SHL    word ptr [bp - 0x24], 1      ; LOGIC
009E01  EB 10                 JMP    0x9e13                       ; UNKNOWN
009E03  90                    NOP                                 ; UNKNOWN
009E04  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; CMP
009E08  74 03                 JE     0x9e0d                       ; UNKNOWN
009E0A  D1 66 F0              SHL    word ptr [bp - 0x10], 1      ; LOGIC
009E0D  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; LOCAL_LOAD
009E10  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; ARITH
009E13  83 7E E8 06           CMP    word ptr [bp - 0x18], 6      ; CMP
009E17  75 16                 JNE    0x9e2f                       ; UNKNOWN
009E19  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; LOCAL_LOAD
009E1C  83 3F 06              CMP    word ptr [bx], 6             ; UNKNOWN
009E1F  75 04                 JNE    0x9e25                       ; UNKNOWN
009E21  FE 06 96 A8           INC    byte ptr [0xa896]            ; UNKNOWN
009E25  83 3F 07              CMP    word ptr [bx], 7             ; UNKNOWN
009E28  75 05                 JNE    0x9e2f                       ; UNKNOWN
009E2A  80 06 96 A8 02        ADD    byte ptr [0xa896], 2         ; UNKNOWN
009E2F  83 7E E8 0C           CMP    word ptr [bp - 0x18], 0xc    ; CMP
009E33  75 0C                 JNE    0x9e41                       ; UNKNOWN
009E35  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; LOCAL_LOAD
009E38  83 3F 07              CMP    word ptr [bx], 7             ; UNKNOWN
009E3B  75 04                 JNE    0x9e41                       ; UNKNOWN
009E3D  FE 06 96 A8           INC    byte ptr [0xa896]            ; UNKNOWN
009E41  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; LOCAL_LOAD
009E44  83 3F 07              CMP    word ptr [bx], 7             ; UNKNOWN
009E47  75 62                 JNE    0x9eab                       ; UNKNOWN
009E49  83 7E E8 FF           CMP    word ptr [bp - 0x18], -1     ; CMP
009E4D  75 5C                 JNE    0x9eab                       ; UNKNOWN
009E4F  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009E52  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009E55  9A 42 01 7F 03        LCALL  0x37f, 0x142                 ; UNKNOWN
009E5A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009E5D  A8 04                 TEST   al, 4                        ; UNKNOWN
009E5F  75 05                 JNE    0x9e66                       ; UNKNOWN
009E61  C7 46 D8 01 00        MOV    word ptr [bp - 0x28], 1      ; LOCAL_STORE
009E66  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; LOCAL_LOAD
009E69  83 3F 07              CMP    word ptr [bx], 7             ; UNKNOWN
009E6C  75 3D                 JNE    0x9eab                       ; UNKNOWN
009E6E  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009E71  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009E74  9A 42 01 7F 03        LCALL  0x37f, 0x142                 ; UNKNOWN
009E79  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009E7C  A8 04                 TEST   al, 4                        ; UNKNOWN
009E7E  75 2B                 JNE    0x9eab                       ; UNKNOWN
009E80  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; CMP
009E84  74 25                 JE     0x9eab                       ; UNKNOWN
009E86  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009E89  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009E8C  9A 42 01 7F 03        LCALL  0x37f, 0x142                 ; UNKNOWN
009E91  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009E94  A8 0A                 TEST   al, 0xa                      ; UNKNOWN
009E96  75 06                 JNE    0x9e9e                       ; UNKNOWN
009E98  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; CMP
009E9C  74 08                 JE     0x9ea6                       ; UNKNOWN
009E9E  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1      ; LOCAL_STORE
009EA3  EB 06                 JMP    0x9eab                       ; UNKNOWN
009EA5  90                    NOP                                 ; UNKNOWN
009EA6  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; LOCAL_STORE
009EAB  83 7E EE 05           CMP    word ptr [bp - 0x12], 5      ; CMP
009EAF  75 03                 JNE    0x9eb4                       ; UNKNOWN
009EB1  D1 66 DC              SHL    word ptr [bp - 0x24], 1      ; LOGIC
009EB4  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; CMP
009EB8  7F 03                 JG     0x9ebd                       ; UNKNOWN
009EBA  E9 92 00              JMP    0x9f4f                       ; UNKNOWN
009EBD  83 7E D8 00           CMP    word ptr [bp - 0x28], 0      ; CMP
009EC1  74 03                 JE     0x9ec6                       ; UNKNOWN
009EC3  E9 89 00              JMP    0x9f4f                       ; UNKNOWN
009EC6  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; LOCAL_STORE
009ECB  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; CMP
009ECF  74 06                 JE     0x9ed7                       ; UNKNOWN
009ED1  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; CMP
009ED5  74 06                 JE     0x9edd                       ; UNKNOWN
009ED7  83 7E EE 05           CMP    word ptr [bp - 0x12], 5      ; CMP
009EDB  75 05                 JNE    0x9ee2                       ; UNKNOWN
009EDD  C7 46 F6 02 00        MOV    word ptr [bp - 0xa], 2       ; LOCAL_STORE
009EE2  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; LOCAL_STORE
009EE7  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; CMP
009EEB  75 06                 JNE    0x9ef3                       ; UNKNOWN
009EED  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; LOCAL_LOAD
009EF0  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; LOCAL_STORE
009EF3  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009EF6  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009EF9  9A 42 01 7F 03        LCALL  0x37f, 0x142                 ; UNKNOWN
009EFE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009F01  A8 0A                 TEST   al, 0xa                      ; UNKNOWN
009F03  74 0C                 JE     0x9f11                       ; UNKNOWN
009F05  83 7E EE 03           CMP    word ptr [bp - 0x12], 3      ; CMP
009F09  7E 06                 JLE    0x9f11                       ; UNKNOWN
009F0B  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; LOCAL_LOAD
009F0E  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; ARITH
009F11  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009F14  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009F17  9A 42 01 7F 03        LCALL  0x37f, 0x142                 ; UNKNOWN
009F1C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009F1F  A8 40                 TEST   al, 0x40                     ; UNKNOWN
009F21  74 0C                 JE     0x9f2f                       ; UNKNOWN
009F23  83 7E EE 03           CMP    word ptr [bp - 0x12], 3      ; CMP
009F27  7F 06                 JG     0x9f2f                       ; UNKNOWN
009F29  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; LOCAL_LOAD
009F2C  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; ARITH
009F2F  F6 46 DA 40           TEST   byte ptr [bp - 0x26], 0x40   ; LOGIC
009F33  74 14                 JE     0x9f49                       ; UNKNOWN
009F35  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; LOCAL_LOAD
009F38  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; ARITH
009F3B  F6 46 DA 80           TEST   byte ptr [bp - 0x26], 0x80   ; LOGIC
009F3F  74 08                 JE     0x9f49                       ; UNKNOWN
009F41  39 46 F0              CMP    word ptr [bp - 0x10], ax     ; CMP
009F44  75 03                 JNE    0x9f49                       ; UNKNOWN
009F46  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; ARITH
009F49  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; LOCAL_LOAD
009F4C  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; ARITH
009F4F  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; CMP
009F53  7C 10                 JL     0x9f65                       ; UNKNOWN
009F55  6A 06                 PUSH   6                            ; UNKNOWN
009F57  0E                    PUSH   cs                           ; UNKNOWN
009F58  E8 E3 E6              CALL   0x863e                       ; UNKNOWN
009F5B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009F5E  0B C0                 OR     ax, ax                       ; UNKNOWN
009F60  75 03                 JNE    0x9f65                       ; UNKNOWN
009F62  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; LOCAL_STORE
009F65  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; CMP
009F69  75 1B                 JNE    0x9f86                       ; UNKNOWN
009F6B  6A 08                 PUSH   8                            ; UNKNOWN
009F6D  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009F71  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
009F74  2A E4                 SUB    ah, ah                       ; UNKNOWN
009F76  50                    PUSH   ax                           ; UNKNOWN
009F77  9A 00 00 81 09        LCALL  0x981, 0                     ; UNKNOWN
009F7C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009F7F  0B C0                 OR     ax, ax                       ; UNKNOWN
009F81  74 03                 JE     0x9f86                       ; UNKNOWN
009F83  D1 66 DC              SHL    word ptr [bp - 0x24], 1      ; LOGIC
009F86  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
009F8A  74 2D                 JE     0x9fb9                       ; UNKNOWN
009F8C  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; CMP
009F90  7E 27                 JLE    0x9fb9                       ; UNKNOWN
009F92  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; CMP
009F96  74 1E                 JE     0x9fb6                       ; UNKNOWN
009F98  83 7E EE 02           CMP    word ptr [bp - 0x12], 2      ; CMP
009F9C  74 18                 JE     0x9fb6                       ; UNKNOWN
009F9E  83 7E EE 03           CMP    word ptr [bp - 0x12], 3      ; CMP
009FA2  74 12                 JE     0x9fb6                       ; UNKNOWN
009FA4  83 7E EE 01           CMP    word ptr [bp - 0x12], 1      ; CMP
009FA8  74 0C                 JE     0x9fb6                       ; UNKNOWN
009FAA  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; CMP
009FAE  74 06                 JE     0x9fb6                       ; UNKNOWN
009FB0  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; CMP
009FB4  7C 03                 JL     0x9fb9                       ; UNKNOWN
009FB6  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
009FB9  8B 46 DC              MOV    ax, word ptr [bp - 0x24]     ; LOCAL_LOAD
009FBC  0B C0                 OR     ax, ax                       ; UNKNOWN
009FBE  7D 02                 JGE    0x9fc2                       ; UNKNOWN
009FC0  2B C0                 SUB    ax, ax                       ; UNKNOWN
009FC2  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; LOCAL_STORE
009FC5  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; CMP
009FC9  74 0D                 JE     0x9fd8                       ; UNKNOWN
009FCB  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; CMP
009FCF  7C 07                 JL     0x9fd8                       ; UNKNOWN
009FD1  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; LOCAL_LOAD
009FD4  C7 07 00 00           MOV    word ptr [bx], 0             ; UNKNOWN
009FD8  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; CMP
009FDC  74 18                 JE     0x9ff6                       ; UNKNOWN
009FDE  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0      ; CMP
009FE2  7D 12                 JGE    0x9ff6                       ; UNKNOWN
009FE4  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; LOCAL_LOAD
009FE7  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; ARITH
009FEA  8B 46 DC              MOV    ax, word ptr [bp - 0x24]     ; LOCAL_LOAD
009FED  0B C0                 OR     ax, ax                       ; UNKNOWN
009FEF  7D 02                 JGE    0x9ff3                       ; UNKNOWN
009FF1  2B C0                 SUB    ax, ax                       ; UNKNOWN
009FF3  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; LOCAL_STORE
009FF6  8B 46 DC              MOV    ax, word ptr [bp - 0x24]     ; LOCAL_LOAD
009FF9  5E                    POP    si                           ; UNKNOWN
009FFA  C9                    LEAVE                               ; UNKNOWN
009FFB  CB                    RETF                                ; UNKNOWN
