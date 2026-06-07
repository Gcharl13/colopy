; ============================================================================
; func_00A222_unknown
; Region   : load_image
; Bytes    : file 0x00A222..0x00A3E1  (447 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A222  C8 2A 00 00           ENTER  0x2a, 0                      ; UNKNOWN
00A226  56                    PUSH   si                           ; UNKNOWN
00A227  2A C0                 SUB    al, al                       ; UNKNOWN
00A229  A2 95 A8              MOV    byte ptr [0xa895], al        ; UNKNOWN
00A22C  A2 96 A8              MOV    byte ptr [0xa896], al        ; UNKNOWN
00A22F  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A233  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
00A236  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A238  50                    PUSH   ax                           ; UNKNOWN
00A239  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
00A23B  50                    PUSH   ax                           ; UNKNOWN
00A23C  9A 3A 00 E4 03        LCALL  0x3e4, 0x3a                  ; UNKNOWN
00A241  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A244  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; LOCAL_STORE
00A247  3D 18 00              CMP    ax, 0x18                     ; UNKNOWN
00A24A  75 08                 JNE    0xa254                       ; UNKNOWN
00A24C  C6 06 91 A8 00        MOV    byte ptr [0xa891], 0         ; UNKNOWN
00A251  EB 42                 JMP    0xa295                       ; UNKNOWN
00A253  90                    NOP                                 ; UNKNOWN
00A254  3D 01 00              CMP    ax, 1                        ; UNKNOWN
00A257  74 0A                 JE     0xa263                       ; UNKNOWN
00A259  3D 11 00              CMP    ax, 0x11                     ; UNKNOWN
00A25C  74 05                 JE     0xa263                       ; UNKNOWN
00A25E  3D 09 00              CMP    ax, 9                        ; UNKNOWN
00A261  75 07                 JNE    0xa26a                       ; UNKNOWN
00A263  C6 06 91 A8 01        MOV    byte ptr [0xa891], 1         ; UNKNOWN
00A268  EB 2B                 JMP    0xa295                       ; UNKNOWN
00A26A  3D 1B 00              CMP    ax, 0x1b                     ; UNKNOWN
00A26D  74 19                 JE     0xa288                       ; UNKNOWN
00A26F  3D 1C 00              CMP    ax, 0x1c                     ; UNKNOWN
00A272  74 14                 JE     0xa288                       ; UNKNOWN
00A274  3D 08 00              CMP    ax, 8                        ; UNKNOWN
00A277  7C 05                 JL     0xa27e                       ; UNKNOWN
00A279  3D 10 00              CMP    ax, 0x10                     ; UNKNOWN
00A27C  7C 0A                 JL     0xa288                       ; UNKNOWN
00A27E  3D 10 00              CMP    ax, 0x10                     ; UNKNOWN
00A281  7C 0D                 JL     0xa290                       ; UNKNOWN
00A283  3D 18 00              CMP    ax, 0x18                     ; UNKNOWN
00A286  7D 08                 JGE    0xa290                       ; UNKNOWN
00A288  C6 06 91 A8 02        MOV    byte ptr [0xa891], 2         ; UNKNOWN
00A28D  EB 06                 JMP    0xa295                       ; UNKNOWN
00A28F  90                    NOP                                 ; UNKNOWN
00A290  C6 06 91 A8 03        MOV    byte ptr [0xa891], 3         ; UNKNOWN
00A295  80 3E A6 53 00        CMP    byte ptr [0x53a6], 0         ; UNKNOWN
00A29A  75 05                 JNE    0xa2a1                       ; UNKNOWN
00A29C  80 06 91 A8 02        ADD    byte ptr [0xa891], 2         ; UNKNOWN
00A2A1  80 3E A6 53 01        CMP    byte ptr [0x53a6], 1         ; UNKNOWN
00A2A6  75 04                 JNE    0xa2ac                       ; UNKNOWN
00A2A8  FE 06 91 A8           INC    byte ptr [0xa891]            ; UNKNOWN
00A2AC  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A2B0  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
00A2B3  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A2B5  50                    PUSH   ax                           ; UNKNOWN
00A2B6  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
00A2B8  50                    PUSH   ax                           ; UNKNOWN
00A2B9  9A 42 01 7F 03        LCALL  0x37f, 0x142                 ; UNKNOWN
00A2BE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A2C1  A8 40                 TEST   al, 0x40                     ; UNKNOWN
00A2C3  74 04                 JE     0xa2c9                       ; UNKNOWN
00A2C5  FE 06 91 A8           INC    byte ptr [0xa891]            ; UNKNOWN
00A2C9  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A2CD  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
00A2D0  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A2D2  50                    PUSH   ax                           ; UNKNOWN
00A2D3  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
00A2D5  50                    PUSH   ax                           ; UNKNOWN
00A2D6  9A B0 04 7F 03        LCALL  0x37f, 0x4b0                 ; UNKNOWN
00A2DB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A2DE  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; LOCAL_STORE
00A2E1  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; LOCAL_STORE
00A2E6  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A2EA  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
00A2ED  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A2EF  50                    PUSH   ax                           ; UNKNOWN
00A2F0  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
00A2F2  50                    PUSH   ax                           ; UNKNOWN
00A2F3  9A 0E 01 7F 03        LCALL  0x37f, 0x10e                 ; UNKNOWN
00A2F8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A2FB  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A2FD  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00A300  A8 40                 TEST   al, 0x40                     ; UNKNOWN
00A302  74 10                 JE     0xa314                       ; UNKNOWN
00A304  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; LOCAL_STORE
00A309  F6 46 FE 80           TEST   byte ptr [bp - 2], 0x80      ; LOGIC
00A30D  74 05                 JE     0xa314                       ; UNKNOWN
00A30F  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2      ; LOCAL_STORE
00A314  83 7E EC 01           CMP    word ptr [bp - 0x14], 1      ; CMP
00A318  74 0C                 JE     0xa326                       ; UNKNOWN
00A31A  83 7E EC 09           CMP    word ptr [bp - 0x14], 9      ; CMP
00A31E  74 06                 JE     0xa326                       ; UNKNOWN
00A320  83 7E EC 02           CMP    word ptr [bp - 0x14], 2      ; CMP
00A324  75 05                 JNE    0xa32b                       ; UNKNOWN
00A326  80 06 91 A8 02        ADD    byte ptr [0xa891], 2         ; UNKNOWN
00A32B  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A32F  F6 47 1C 04           TEST   byte ptr [bx + 0x1c], 4      ; LOGIC
00A333  74 04                 JE     0xa339                       ; UNKNOWN
00A335  FE 06 91 A8           INC    byte ptr [0xa891]            ; UNKNOWN
00A339  F6 47 1C 02           TEST   byte ptr [bx + 0x1c], 2      ; LOGIC
00A33D  74 04                 JE     0xa343                       ; UNKNOWN
00A33F  FE 06 91 A8           INC    byte ptr [0xa891]            ; UNKNOWN
00A343  C6 06 93 A8 FF        MOV    byte ptr [0xa893], 0xff      ; GLOBAL_LOAD
00A348  C6 06 94 A8 00        MOV    byte ptr [0xa894], 0         ; UNKNOWN
00A34D  C7 46 E4 01 00        MOV    word ptr [bp - 0x1c], 1      ; LOCAL_STORE
00A352  EB 1B                 JMP    0xa36f                       ; UNKNOWN
00A354  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
00A357  A0 94 A8              MOV    al, byte ptr [0xa894]        ; UNKNOWN
00A35A  98                    CWDE                                ; UNKNOWN
00A35B  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
00A35E  7D 0C                 JGE    0xa36c                       ; UNKNOWN
00A360  8A 46 E4              MOV    al, byte ptr [bp - 0x1c]     ; LOCAL_LOAD
00A363  A2 93 A8              MOV    byte ptr [0xa893], al        ; UNKNOWN
00A366  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
00A369  A2 94 A8              MOV    byte ptr [0xa894], al        ; UNKNOWN
00A36C  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
00A36F  83 7E E4 08           CMP    word ptr [bp - 0x1c], 8      ; CMP
00A373  7D 2F                 JGE    0xa3a4                       ; UNKNOWN
00A375  83 7E E4 05           CMP    word ptr [bp - 0x1c], 5      ; CMP
00A379  74 F1                 JE     0xa36c                       ; UNKNOWN
00A37B  8B 76 DC              MOV    si, word ptr [bp - 0x24]     ; LOCAL_LOAD
00A37E  C1 E6 04              SHL    si, 4                        ; UNKNOWN
00A381  8B 5E E4              MOV    bx, word ptr [bp - 0x1c]     ; LOCAL_LOAD
00A384  8A 80 7B 2F           MOV    al, byte ptr [bx + si + 0x2f7b] ; MOV
00A388  2A E4                 SUB    ah, ah                       ; UNKNOWN
00A38A  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
00A38D  53                    PUSH   bx                           ; UNKNOWN
00A38E  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
00A391  0E                    PUSH   cs                           ; UNKNOWN
00A392  E8 15 F7              CALL   0x9aaa                       ; UNKNOWN
00A395  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A398  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; LOCAL_STORE
00A39B  0B C0                 OR     ax, ax                       ; UNKNOWN
00A39D  7D B5                 JGE    0xa354                       ; UNKNOWN
00A39F  D1 66 FA              SHL    word ptr [bp - 6], 1         ; UNKNOWN
00A3A2  EB B3                 JMP    0xa357                       ; UNKNOWN
00A3A4  80 3E 93 A8 00        CMP    byte ptr [0xa893], 0         ; UNKNOWN
00A3A9  7C 2A                 JL     0xa3d5                       ; UNKNOWN
00A3AB  80 3E A6 53 00        CMP    byte ptr [0x53a6], 0         ; UNKNOWN
00A3B0  75 04                 JNE    0xa3b6                       ; UNKNOWN
00A3B2  FE 06 94 A8           INC    byte ptr [0xa894]            ; UNKNOWN
00A3B6  8A 46 EE              MOV    al, byte ptr [bp - 0x12]     ; LOCAL_LOAD
00A3B9  00 06 94 A8           ADD    byte ptr [0xa894], al        ; UNKNOWN
00A3BD  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00A3C1  F6 47 1C 04           TEST   byte ptr [bx + 0x1c], 4      ; LOGIC
00A3C5  74 04                 JE     0xa3cb                       ; UNKNOWN
00A3C7  FE 06 94 A8           INC    byte ptr [0xa894]            ; UNKNOWN
00A3CB  F6 47 1C 02           TEST   byte ptr [bx + 0x1c], 2      ; LOGIC
00A3CF  74 04                 JE     0xa3d5                       ; UNKNOWN
00A3D1  FE 06 94 A8           INC    byte ptr [0xa894]            ; UNKNOWN
00A3D5  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; LOCAL_STORE
00A3DA  8B 5E E4              MOV    bx, word ptr [bp - 0x1c]     ; LOCAL_LOAD
00A3DD  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00A3DF  C7                    DB     0xC7                         ; UNKNOWN (raw)
00A3E0  87                    DB     0x87                         ; UNKNOWN (raw)
