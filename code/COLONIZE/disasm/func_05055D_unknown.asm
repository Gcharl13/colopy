; ============================================================================
; func_05055D_unknown
; Region   : load_image
; Bytes    : file 0x05055D..0x050743  (486 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05055D  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
050561  56                    PUSH   si                           ; UNKNOWN
050562  C7 46 E8 FF FF        MOV    word ptr [bp - 0x18], 0xffff ; UNKNOWN
050567  C7 46 F2 08 00        MOV    word ptr [bp - 0xe], 8       ; UNKNOWN
05056C  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
050571  E9 8E 01              JMP    0x50702                      ; UNKNOWN
050574  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
050577  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
05057A  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
05057F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
050582  0B C0                 OR     ax, ax                       ; UNKNOWN
050584  7D 40                 JGE    0x505c6                      ; UNKNOWN
050586  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
050589  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
05058C  75 38                 JNE    0x505c6                      ; UNKNOWN
05058E  6A 02                 PUSH   2                            ; UNKNOWN
050590  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
050593  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
050596  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
05059B  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
05059E  50                    PUSH   ax                           ; UNKNOWN
05059F  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
0505A4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0505A7  48                    DEC    ax                           ; UNKNOWN
0505A8  75 1C                 JNE    0x505c6                      ; UNKNOWN
0505AA  6B 5E EC 1C           IMUL   bx, word ptr [bp - 0x14], 0x1c ; UNKNOWN
0505AE  80 BF 82 88 0B        CMP    byte ptr [bx - 0x777e], 0xb  ; UNKNOWN
0505B3  75 05                 JNE    0x505ba                      ; UNKNOWN
0505B5  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0505B8  EB 02                 JMP    0x505bc                      ; UNKNOWN
0505BA  2B C0                 SUB    ax, ax                       ; UNKNOWN
0505BC  3B 46 0E              CMP    ax, word ptr [bp + 0xe]      ; UNKNOWN
0505BF  74 05                 JE     0x505c6                      ; UNKNOWN
0505C1  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
0505C6  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0505C9  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0505CC  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
0505D1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0505D4  0B C0                 OR     ax, ax                       ; UNKNOWN
0505D6  75 03                 JNE    0x505db                      ; UNKNOWN
0505D8  E9 24 01              JMP    0x506ff                      ; UNKNOWN
0505DB  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0505DE  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0505E1  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
0505E6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0505E9  0B C0                 OR     ax, ax                       ; UNKNOWN
0505EB  74 03                 JE     0x505f0                      ; UNKNOWN
0505ED  E9 0F 01              JMP    0x506ff                      ; UNKNOWN
0505F0  83 7E F6 08           CMP    word ptr [bp - 0xa], 8       ; UNKNOWN
0505F4  74 08                 JE     0x505fe                      ; UNKNOWN
0505F6  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
0505F9  75 03                 JNE    0x505fe                      ; UNKNOWN
0505FB  E9 01 01              JMP    0x506ff                      ; UNKNOWN
0505FE  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
050601  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
050604  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
050609  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05060C  8B D8                 MOV    bx, ax                       ; UNKNOWN
05060E  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
050611  8A 87 B7 34           MOV    al, byte ptr [bx + 0x34b7]   ; UNKNOWN
050615  2A E4                 SUB    ah, ah                       ; UNKNOWN
050617  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
05061A  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
05061F  8B 5E F4              MOV    bx, word ptr [bp - 0xc]      ; UNKNOWN
050622  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
050626  98                    CWDE                                ; UNKNOWN
050627  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
05062A  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
05062D  50                    PUSH   ax                           ; UNKNOWN
05062E  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
050632  98                    CWDE                                ; UNKNOWN
050633  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
050636  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
050639  50                    PUSH   ax                           ; UNKNOWN
05063A  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
05063F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
050642  0B C0                 OR     ax, ax                       ; UNKNOWN
050644  75 03                 JNE    0x50649                      ; UNKNOWN
050646  E9 99 00              JMP    0x506e2                      ; UNKNOWN
050649  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
05064C  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
05064F  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
050654  83 C4 04              ADD    sp, 4                        ; UNKNOWN
050657  0B C0                 OR     ax, ax                       ; UNKNOWN
050659  74 03                 JE     0x5065e                      ; UNKNOWN
05065B  E9 84 00              JMP    0x506e2                      ; UNKNOWN
05065E  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
050661  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
050664  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
050669  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05066C  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
05066F  0B C0                 OR     ax, ax                       ; UNKNOWN
050671  7D 6F                 JGE    0x506e2                      ; UNKNOWN
050673  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
050676  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
050679  9A F1 01 C9 33        LCALL  0x33c9, 0x1f1                ; UNKNOWN
05067E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
050681  98                    CWDE                                ; UNKNOWN
050682  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
050685  0B C0                 OR     ax, ax                       ; UNKNOWN
050687  7C 1F                 JL     0x506a8                      ; UNKNOWN
050689  83 F8 04              CMP    ax, 4                        ; UNKNOWN
05068C  7D 1A                 JGE    0x506a8                      ; UNKNOWN
05068E  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
050691  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
050696  75 10                 JNE    0x506a8                      ; UNKNOWN
050698  50                    PUSH   ax                           ; UNKNOWN
050699  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05069C  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
0506A1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0506A4  A8 40                 TEST   al, 0x40                     ; UNKNOWN
0506A6  75 3A                 JNE    0x506e2                      ; UNKNOWN
0506A8  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
0506AC  74 34                 JE     0x506e2                      ; UNKNOWN
0506AE  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0506B1  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0506B4  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
0506B9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0506BC  50                    PUSH   ax                           ; UNKNOWN
0506BD  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0506C0  0E                    PUSH   cs                           ; UNKNOWN
0506C1  E8 83 FC              CALL   0x50347                      ; UNKNOWN
0506C4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0506C7  C1 E0 04              SHL    ax, 4                        ; UNKNOWN
0506CA  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
0506CD  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
0506D0  8B F0                 MOV    si, ax                       ; UNKNOWN
0506D2  9A E8 02 C9 33        LCALL  0x33c9, 0x2e8                ; UNKNOWN
0506D7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0506DA  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0506DD  03 F0                 ADD    si, ax                       ; UNKNOWN
0506DF  01 76 F8              ADD    word ptr [bp - 8], si        ; UNKNOWN
0506E2  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
0506E5  83 7E F4 08           CMP    word ptr [bp - 0xc], 8       ; UNKNOWN
0506E9  7D 03                 JGE    0x506ee                      ; UNKNOWN
0506EB  E9 31 FF              JMP    0x5061f                      ; UNKNOWN
0506EE  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
0506F1  39 46 E8              CMP    word ptr [bp - 0x18], ax     ; UNKNOWN
0506F4  7D 09                 JGE    0x506ff                      ; UNKNOWN
0506F6  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
0506F9  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
0506FC  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
0506FF  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
050702  83 7E F6 09           CMP    word ptr [bp - 0xa], 9       ; UNKNOWN
050706  7D 35                 JGE    0x5073d                      ; UNKNOWN
050708  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
05070B  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
05070F  98                    CWDE                                ; UNKNOWN
050710  03 46 0A              ADD    ax, word ptr [bp + 0xa]      ; UNKNOWN
050713  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
050716  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
05071B  50                    PUSH   ax                           ; UNKNOWN
05071C  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
050720  98                    CWDE                                ; UNKNOWN
050721  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
050724  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
050727  50                    PUSH   ax                           ; UNKNOWN
050728  9A 14 04 C9 33        LCALL  0x33c9, 0x414                ; UNKNOWN
05072D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
050730  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
050733  0B C0                 OR     ax, ax                       ; UNKNOWN
050735  7C 03                 JL     0x5073a                      ; UNKNOWN
050737  E9 3A FE              JMP    0x50574                      ; UNKNOWN
05073A  E9 84 FE              JMP    0x505c1                      ; UNKNOWN
05073D  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
050740  5E                    POP    si                           ; UNKNOWN
050741  C9                    LEAVE                               ; UNKNOWN
050742  CB                    RETF                                ; UNKNOWN
