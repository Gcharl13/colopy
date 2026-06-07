; ============================================================================
; func_009318_unknown
; Region   : load_image
; Bytes    : file 0x009318..0x009626  (782 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009318  C8 2C 00 00           ENTER  0x2c, 0                      ; UNKNOWN
00931C  56                    PUSH   si                           ; UNKNOWN
00931D  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; LOCAL_STORE
009322  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
009325  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; LOCAL_STORE
009328  3D 17 00              CMP    ax, 0x17                     ; UNKNOWN
00932B  75 05                 JNE    0x9332                       ; UNKNOWN
00932D  C7 46 D4 15 00        MOV    word ptr [bp - 0x2c], 0x15   ; LOCAL_STORE
009332  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009335  0E                    PUSH   cs                           ; UNKNOWN
009336  E8 8F FD              CALL   0x90c8                       ; UNKNOWN
009339  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00933C  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; LOCAL_STORE
00933F  50                    PUSH   ax                           ; UNKNOWN
009340  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
009343  50                    PUSH   ax                           ; UNKNOWN
009344  0E                    PUSH   cs                           ; UNKNOWN
009345  E8 F6 FC              CALL   0x903e                       ; UNKNOWN
009348  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00934B  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; LOCAL_STORE
00934E  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0      ; LOCAL_STORE
009353  EB 26                 JMP    0x937b                       ; UNKNOWN
009355  90                    NOP                                 ; UNKNOWN
009356  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
00935A  8A 87 59 31           MOV    al, byte ptr [bx + 0x3159]   ; MOV
00935E  2A E4                 SUB    ah, ah                       ; UNKNOWN
009360  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
009363  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
009366  8B 76 E0              MOV    si, word ptr [bp - 0x20]     ; LOCAL_LOAD
009369  D1 E6                 SHL    si, 1                        ; UNKNOWN
00936B  8B 72 D8              MOV    si, word ptr [bp + si - 0x28] ; LOCAL_LOAD
00936E  D1 E6                 SHL    si, 1                        ; UNKNOWN
009370  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009374  01 80 9A 00           ADD    word ptr [bx + si + 0x9a], ax ; ARITH
009378  FF 46 E0              INC    word ptr [bp - 0x20]         ; UNKNOWN
00937B  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; LOCAL_LOAD
00937E  39 46 E0              CMP    word ptr [bp - 0x20], ax     ; CMP
009381  7D 3D                 JGE    0x93c0                       ; UNKNOWN
009383  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009387  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00938A  98                    CWDE                                ; UNKNOWN
00938B  2B 46 06              SUB    ax, word ptr [bp + 6]        ; UNKNOWN
00938E  F7 D8                 NEG    ax                           ; UNKNOWN
009390  50                    PUSH   ax                           ; UNKNOWN
009391  0E                    PUSH   cs                           ; UNKNOWN
009392  E8 3F F8              CALL   0x8bd4                       ; UNKNOWN
009395  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009398  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; LOCAL_STORE
00939B  8B 76 E0              MOV    si, word ptr [bp - 0x20]     ; LOCAL_LOAD
00939E  D1 E6                 SHL    si, 1                        ; UNKNOWN
0093A0  8B 42 D8              MOV    ax, word ptr [bp + si - 0x28] ; LOCAL_LOAD
0093A3  3D 0E 00              CMP    ax, 0xe                      ; UNKNOWN
0093A6  74 AE                 JE     0x9356                       ; UNKNOWN
0093A8  77 06                 JA     0x93b0                       ; UNKNOWN
0093AA  0A C0                 OR     al, al                       ; UNKNOWN
0093AC  74 0A                 JE     0x93b8                       ; UNKNOWN
0093AE  2C 08                 SUB    al, 8                        ; UNKNOWN
0093B0  C7 46 FA 32 00        MOV    word ptr [bp - 6], 0x32      ; LOCAL_STORE
0093B5  EB AC                 JMP    0x9363                       ; UNKNOWN
0093B7  90                    NOP                                 ; UNKNOWN
0093B8  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
0093BD  EB A4                 JMP    0x9363                       ; UNKNOWN
0093BF  90                    NOP                                 ; UNKNOWN
0093C0  6A 10                 PUSH   0x10                         ; UNKNOWN
0093C2  6A 00                 PUSH   0                            ; UNKNOWN
0093C4  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
0093C7  50                    PUSH   ax                           ; UNKNOWN
0093C8  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae                 ; UNKNOWN
0093CD  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0093D0  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
0093D4  8B 87 B6 00           MOV    ax, word ptr [bx + 0xb6]     ; MOV
0093D8  B9 14 00              MOV    cx, 0x14                     ; UNKNOWN
0093DB  99                    CDQ                                 ; UNKNOWN
0093DC  F7 F9                 IDIV   cx                           ; UNKNOWN
0093DE  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0093E1  6B C0 14              IMUL   ax, ax, 0x14                 ; UNKNOWN
0093E4  3D 64 00              CMP    ax, 0x64                     ; UNKNOWN
0093E7  7E 03                 JLE    0x93ec                       ; UNKNOWN
0093E9  B8 64 00              MOV    ax, 0x64                     ; UNKNOWN
0093EC  88 46 F8              MOV    byte ptr [bp - 8], al        ; UNKNOWN
0093EF  B0 32                 MOV    al, 0x32                     ; UNKNOWN
0093F1  88 46 F9              MOV    byte ptr [bp - 7], al        ; UNKNOWN
0093F4  88 46 F2              MOV    byte ptr [bp - 0xe], al      ; LOCAL_STORE
0093F7  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; LOCAL_LOAD
0093FA  39 46 08              CMP    word ptr [bp + 8], ax        ; UNKNOWN
0093FD  74 0C                 JE     0x940b                       ; UNKNOWN
0093FF  6A 00                 PUSH   0                            ; UNKNOWN
009401  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009404  0E                    PUSH   cs                           ; UNKNOWN
009405  E8 64 FB              CALL   0x8f6c                       ; UNKNOWN
009408  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00940B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00940E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009411  0E                    PUSH   cs                           ; UNKNOWN
009412  E8 85 FE              CALL   0x929a                       ; UNKNOWN
009415  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009418  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00941B  0B C0                 OR     ax, ax                       ; UNKNOWN
00941D  75 03                 JNE    0x9422                       ; UNKNOWN
00941F  E9 B4 00              JMP    0x94d6                       ; UNKNOWN
009422  48                    DEC    ax                           ; UNKNOWN
009423  75 03                 JNE    0x9428                       ; UNKNOWN
009425  E9 4E 01              JMP    0x9576                       ; UNKNOWN
009428  48                    DEC    ax                           ; UNKNOWN
009429  75 03                 JNE    0x942e                       ; UNKNOWN
00942B  E9 D2 00              JMP    0x9500                       ; UNKNOWN
00942E  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009432  80 7F 1F 20           CMP    byte ptr [bx + 0x1f], 0x20   ; CMP
009436  7C 03                 JL     0x943b                       ; UNKNOWN
009438  E9 87 01              JMP    0x95c2                       ; UNKNOWN
00943B  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00943E  98                    CWDE                                ; UNKNOWN
00943F  2B 46 06              SUB    ax, word ptr [bp + 6]        ; UNKNOWN
009442  F7 D8                 NEG    ax                           ; UNKNOWN
009444  50                    PUSH   ax                           ; UNKNOWN
009445  0E                    PUSH   cs                           ; UNKNOWN
009446  E8 8B F7              CALL   0x8bd4                       ; UNKNOWN
009449  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00944C  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; LOCAL_STORE
00944F  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009453  83 87 C6 00 64        ADD    word ptr [bx + 0xc6], 0x64   ; ARITH
009458  83 97 C8 00 00        ADC    word ptr [bx + 0xc8], 0      ; ARITH
00945D  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
009460  98                    CWDE                                ; UNKNOWN
009461  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; LOCAL_STORE
009464  FE 47 1F              INC    byte ptr [bx + 0x1f]         ; UNKNOWN
009467  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00946A  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
00946D  0E                    PUSH   cs                           ; UNKNOWN
00946E  E8 A7 FE              CALL   0x9318                       ; UNKNOWN
009471  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009474  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
009478  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b]   ; MOV
00947C  98                    CWDE                                ; UNKNOWN
00947D  50                    PUSH   ax                           ; UNKNOWN
00947E  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
009481  0E                    PUSH   cs                           ; UNKNOWN
009482  E8 B7 FC              CALL   0x913c                       ; UNKNOWN
009485  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009488  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
00948B  9A 24 08 27 04        LCALL  0x427, 0x824                 ; UNKNOWN
009490  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009493  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; LOCAL_LOAD
009496  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; LOCAL_STORE
009499  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00949D  80 7F 1F 03           CMP    byte ptr [bx + 0x1f], 3      ; CMP
0094A1  7D 03                 JGE    0x94a6                       ; UNKNOWN
0094A3  E9 C8 00              JMP    0x956e                       ; UNKNOWN
0094A6  83 3E 5C 03 00        CMP    word ptr [0x35c], 0          ; UNKNOWN
0094AB  74 03                 JE     0x94b0                       ; UNKNOWN
0094AD  E9 BE 00              JMP    0x956e                       ; UNKNOWN
0094B0  6A 09                 PUSH   9                            ; UNKNOWN
0094B2  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
0094B5  2A E4                 SUB    ah, ah                       ; UNKNOWN
0094B7  50                    PUSH   ax                           ; UNKNOWN
0094B8  9A 00 00 81 09        LCALL  0x981, 0                     ; UNKNOWN
0094BD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0094C0  0B C0                 OR     ax, ax                       ; UNKNOWN
0094C2  75 03                 JNE    0x94c7                       ; UNKNOWN
0094C4  E9 A7 00              JMP    0x956e                       ; UNKNOWN
0094C7  6A 01                 PUSH   1                            ; UNKNOWN
0094C9  6A 00                 PUSH   0                            ; UNKNOWN
0094CB  0E                    PUSH   cs                           ; UNKNOWN
0094CC  E8 11 FE              CALL   0x92e0                       ; UNKNOWN
0094CF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0094D2  E9 99 00              JMP    0x956e                       ; UNKNOWN
0094D5  90                    NOP                                 ; UNKNOWN
0094D6  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
0094D9  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
0094DD  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0094E0  88 40 20              MOV    byte ptr [bx + si + 0x20], al ; MOV
0094E3  89 76 D6              MOV    word ptr [bp - 0x2a], si     ; LOCAL_STORE
0094E6  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0094E9  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
0094EC  50                    PUSH   ax                           ; UNKNOWN
0094ED  0E                    PUSH   cs                           ; UNKNOWN
0094EE  E8 4D FB              CALL   0x903e                       ; UNKNOWN
0094F1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0094F4  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; LOCAL_STORE
0094F7  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0      ; LOCAL_STORE
0094FC  E9 D2 00              JMP    0x95d1                       ; UNKNOWN
0094FF  90                    NOP                                 ; UNKNOWN
009500  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009504  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
009507  2A E4                 SUB    ah, ah                       ; UNKNOWN
009509  50                    PUSH   ax                           ; UNKNOWN
00950A  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
00950C  50                    PUSH   ax                           ; UNKNOWN
00950D  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; MOV
009510  50                    PUSH   ax                           ; UNKNOWN
009511  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
009514  0E                    PUSH   cs                           ; UNKNOWN
009515  E8 AE F6              CALL   0x8bc6                       ; UNKNOWN
009518  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00951B  50                    PUSH   ax                           ; UNKNOWN
00951C  9A B4 06 27 04        LCALL  0x427, 0x6b4                 ; UNKNOWN
009521  83 C4 08              ADD    sp, 8                        ; UNKNOWN
009524  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; LOCAL_STORE
009527  0B C0                 OR     ax, ax                       ; UNKNOWN
009529  7C BB                 JL     0x94e6                       ; UNKNOWN
00952B  50                    PUSH   ax                           ; UNKNOWN
00952C  9A 5E 15 27 04        LCALL  0x427, 0x155e                ; UNKNOWN
009531  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009534  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009537  0E                    PUSH   cs                           ; UNKNOWN
009538  E8 C7 FB              CALL   0x9102                       ; UNKNOWN
00953B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00953E  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
009541  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
009544  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
009548  88 87 5B 31           MOV    byte ptr [bx + 0x315b], al   ; MOV
00954C  83 7E 08 14           CMP    word ptr [bp + 8], 0x14      ; CMP
009550  75 07                 JNE    0x9559                       ; UNKNOWN
009552  8A 46 F8              MOV    al, byte ptr [bp - 8]        ; UNKNOWN
009555  88 87 59 31           MOV    byte ptr [bx + 0x3159], al   ; MOV
009559  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00955C  0E                    PUSH   cs                           ; UNKNOWN
00955D  E8 54 FA              CALL   0x8fb4                       ; UNKNOWN
009560  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009563  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009567  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00956A  98                    CWDE                                ; UNKNOWN
00956B  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; LOCAL_STORE
00956E  0E                    PUSH   cs                           ; UNKNOWN
00956F  E8 FE F6              CALL   0x8c70                       ; UNKNOWN
009572  E9 71 FF              JMP    0x94e6                       ; UNKNOWN
009575  90                    NOP                                 ; UNKNOWN
009576  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00957A  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00957D  98                    CWDE                                ; UNKNOWN
00957E  2B 46 06              SUB    ax, word ptr [bp + 6]        ; UNKNOWN
009581  F7 D8                 NEG    ax                           ; UNKNOWN
009583  50                    PUSH   ax                           ; UNKNOWN
009584  0E                    PUSH   cs                           ; UNKNOWN
009585  E8 4C F6              CALL   0x8bd4                       ; UNKNOWN
009588  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00958B  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; LOCAL_STORE
00958E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
009591  0E                    PUSH   cs                           ; UNKNOWN
009592  E8 31 F6              CALL   0x8bc6                       ; UNKNOWN
009595  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009598  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
00959C  88 87 46 31           MOV    byte ptr [bx + 0x3146], al   ; MOV
0095A0  C6 87 4C 31 00        MOV    byte ptr [bx + 0x314c], 0    ; MOV
0095A5  83 7E 08 14           CMP    word ptr [bp + 8], 0x14      ; CMP
0095A9  75 07                 JNE    0x95b2                       ; UNKNOWN
0095AB  8A 46 F8              MOV    al, byte ptr [bp - 8]        ; UNKNOWN
0095AE  88 87 59 31           MOV    byte ptr [bx + 0x3159], al   ; MOV
0095B2  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
0095B5  9A 5E 15 27 04        LCALL  0x427, 0x155e                ; UNKNOWN
0095BA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0095BD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0095C0  EB A9                 JMP    0x956b                       ; UNKNOWN
0095C2  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
0095C5  98                    CWDE                                ; UNKNOWN
0095C6  48                    DEC    ax                           ; UNKNOWN
0095C7  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; LOCAL_STORE
0095CA  E9 19 FF              JMP    0x94e6                       ; UNKNOWN
0095CD  90                    NOP                                 ; UNKNOWN
0095CE  FF 46 E0              INC    word ptr [bp - 0x20]         ; UNKNOWN
0095D1  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; LOCAL_LOAD
0095D4  39 46 E0              CMP    word ptr [bp - 0x20], ax     ; CMP
0095D7  7D 37                 JGE    0x9610                       ; UNKNOWN
0095D9  8B 76 E0              MOV    si, word ptr [bp - 0x20]     ; LOCAL_LOAD
0095DC  D1 E6                 SHL    si, 1                        ; UNKNOWN
0095DE  8B 72 D8              MOV    si, word ptr [bp + si - 0x28] ; LOCAL_LOAD
0095E1  8A 42 EA              MOV    al, byte ptr [bp + si - 0x16] ; LOCAL_LOAD
0095E4  2A E4                 SUB    ah, ah                       ; UNKNOWN
0095E6  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0095E9  0B F6                 OR     si, si                       ; UNKNOWN
0095EB  75 03                 JNE    0x95f0                       ; UNKNOWN
0095ED  89 76 E4              MOV    word ptr [bp - 0x1c], si     ; LOCAL_STORE
0095F0  8B 76 E0              MOV    si, word ptr [bp - 0x20]     ; LOCAL_LOAD
0095F3  D1 E6                 SHL    si, 1                        ; UNKNOWN
0095F5  8B 72 D8              MOV    si, word ptr [bp + si - 0x28] ; LOCAL_LOAD
0095F8  D1 E6                 SHL    si, 1                        ; UNKNOWN
0095FA  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
0095FE  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; MOV
009602  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
009605  79 02                 JNS    0x9609                       ; UNKNOWN
009607  2B C0                 SUB    ax, ax                       ; UNKNOWN
009609  89 80 9A 00           MOV    word ptr [bx + si + 0x9a], ax ; MOV
00960D  EB BF                 JMP    0x95ce                       ; UNKNOWN
00960F  90                    NOP                                 ; UNKNOWN
009610  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
009614  80 7F 1F 00           CMP    byte ptr [bx + 0x1f], 0      ; CMP
009618  75 06                 JNE    0x9620                       ; UNKNOWN
00961A  C7 06 48 03 01 00     MOV    word ptr [0x348], 1          ; UNKNOWN
009620  8B 46 D6              MOV    ax, word ptr [bp - 0x2a]     ; LOCAL_LOAD
009623  5E                    POP    si                           ; UNKNOWN
009624  C9                    LEAVE                               ; UNKNOWN
009625  CB                    RETF                                ; UNKNOWN
