; ============================================================================
; func_00B30A_unknown
; Region   : load_image
; Bytes    : file 0x00B30A..0x00B50B  (513 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B30A  C8 C4 00 00           ENTER  0xc4, 0                      ; UNKNOWN
00B30E  57                    PUSH   di                           ; UNKNOWN
00B30F  56                    PUSH   si                           ; UNKNOWN
00B310  C7 46 F0 FF FF        MOV    word ptr [bp - 0x10], 0xffff ; UNKNOWN
00B315  2B C0                 SUB    ax, ax                       ; UNKNOWN
00B317  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
00B31A  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
00B31D  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
00B320  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00B323  8D 46 BE              LEA    ax, [bp - 0x42]              ; UNKNOWN
00B326  50                    PUSH   ax                           ; UNKNOWN
00B327  6A 00                 PUSH   0                            ; UNKNOWN
00B329  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
00B32C  9A 3B 11 65 5F        LCALL  0x5f65, 0x113b               ; UNKNOWN
00B331  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00B334  0B C0                 OR     ax, ax                       ; UNKNOWN
00B336  74 03                 JE     0xb33b                       ; UNKNOWN
00B338  E9 AF 00              JMP    0xb3ea                       ; UNKNOWN
00B33B  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
00B33E  46                    INC    si                           ; UNKNOWN
00B33F  8D 46 BE              LEA    ax, [bp - 0x42]              ; UNKNOWN
00B342  50                    PUSH   ax                           ; UNKNOWN
00B343  9A 30 11 65 5F        LCALL  0x5f65, 0x1130               ; UNKNOWN
00B348  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00B34B  0B C0                 OR     ax, ax                       ; UNKNOWN
00B34D  74 EF                 JE     0xb33e                       ; UNKNOWN
00B34F  0B F6                 OR     si, si                       ; UNKNOWN
00B351  75 03                 JNE    0xb356                       ; UNKNOWN
00B353  E9 B8 00              JMP    0xb40e                       ; UNKNOWN
00B356  8D 44 09              LEA    ax, [si + 9]                 ; UNKNOWN
00B359  B9 0A 00              MOV    cx, 0xa                      ; UNKNOWN
00B35C  99                    CDQ                                 ; UNKNOWN
00B35D  F7 F9                 IDIV   cx                           ; UNKNOWN
00B35F  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
00B362  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
00B367  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
00B36C  8B 76 F6              MOV    si, word ptr [bp - 0xa]      ; UNKNOWN
00B36F  8B C6                 MOV    ax, si                       ; UNKNOWN
00B371  C1 E6 02              SHL    si, 2                        ; UNKNOWN
00B374  03 F0                 ADD    si, ax                       ; UNKNOWN
00B376  D1 E6                 SHL    si, 1                        ; UNKNOWN
00B378  8D 44 09              LEA    ax, [si + 9]                 ; UNKNOWN
00B37B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00B37E  8D 46 BE              LEA    ax, [bp - 0x42]              ; UNKNOWN
00B381  50                    PUSH   ax                           ; UNKNOWN
00B382  6A 00                 PUSH   0                            ; UNKNOWN
00B384  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
00B387  9A 3B 11 65 5F        LCALL  0x5f65, 0x113b               ; UNKNOWN
00B38C  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00B38F  0B C0                 OR     ax, ax                       ; UNKNOWN
00B391  75 5D                 JNE    0xb3f0                       ; UNKNOWN
00B393  89 76 F8              MOV    word ptr [bp - 8], si        ; UNKNOWN
00B396  8B 76 FA              MOV    si, word ptr [bp - 6]        ; UNKNOWN
00B399  8B 7E FE              MOV    di, word ptr [bp - 2]        ; UNKNOWN
00B39C  47                    INC    di                           ; UNKNOWN
00B39D  39 7E F8              CMP    word ptr [bp - 8], di        ; UNKNOWN
00B3A0  7F 26                 JG     0xb3c8                       ; UNKNOWN
00B3A2  39 7E FC              CMP    word ptr [bp - 4], di        ; UNKNOWN
00B3A5  7C 21                 JL     0xb3c8                       ; UNKNOWN
00B3A7  8D 46 DC              LEA    ax, [bp - 0x24]              ; UNKNOWN
00B3AA  50                    PUSH   ax                           ; UNKNOWN
00B3AB  8B C6                 MOV    ax, si                       ; UNKNOWN
00B3AD  46                    INC    si                           ; UNKNOWN
00B3AE  8B C8                 MOV    cx, ax                       ; UNKNOWN
00B3B0  D1 E0                 SHL    ax, 1                        ; UNKNOWN
00B3B2  03 C1                 ADD    ax, cx                       ; UNKNOWN
00B3B4  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
00B3B7  03 C1                 ADD    ax, cx                       ; UNKNOWN
00B3B9  8D 8E 3C FF           LEA    cx, [bp - 0xc4]              ; UNKNOWN
00B3BD  03 C1                 ADD    ax, cx                       ; UNKNOWN
00B3BF  50                    PUSH   ax                           ; UNKNOWN
00B3C0  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00B3C5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00B3C8  8D 46 BE              LEA    ax, [bp - 0x42]              ; UNKNOWN
00B3CB  50                    PUSH   ax                           ; UNKNOWN
00B3CC  9A 30 11 65 5F        LCALL  0x5f65, 0x1130               ; UNKNOWN
00B3D1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00B3D4  0B C0                 OR     ax, ax                       ; UNKNOWN
00B3D6  75 05                 JNE    0xb3dd                       ; UNKNOWN
00B3D8  83 FE 0A              CMP    si, 0xa                      ; UNKNOWN
00B3DB  7C BF                 JL     0xb39c                       ; UNKNOWN
00B3DD  0B F6                 OR     si, si                       ; UNKNOWN
00B3DF  75 14                 JNE    0xb3f5                       ; UNKNOWN
00B3E1  89 76 FE              MOV    word ptr [bp - 2], si        ; UNKNOWN
00B3E4  8B 7E EA              MOV    di, word ptr [bp - 0x16]     ; UNKNOWN
00B3E7  E9 D7 00              JMP    0xb4c1                       ; UNKNOWN
00B3EA  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
00B3ED  E9 5F FF              JMP    0xb34f                       ; UNKNOWN
00B3F0  8B 76 FA              MOV    si, word ptr [bp - 6]        ; UNKNOWN
00B3F3  EB E8                 JMP    0xb3dd                       ; UNKNOWN
00B3F5  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
00B3F8  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
00B3FB  2B D2                 SUB    dx, dx                       ; UNKNOWN
00B3FD  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
00B402  8B F8                 MOV    di, ax                       ; UNKNOWN
00B404  89 56 EC              MOV    word ptr [bp - 0x14], dx     ; UNKNOWN
00B407  0B D0                 OR     dx, ax                       ; UNKNOWN
00B409  75 09                 JNE    0xb414                       ; UNKNOWN
00B40B  89 7E EA              MOV    word ptr [bp - 0x16], di     ; UNKNOWN
00B40E  8B 76 EA              MOV    si, word ptr [bp - 0x16]     ; UNKNOWN
00B411  E9 DF 00              JMP    0xb4f3                       ; UNKNOWN
00B414  83 7E F6 00           CMP    word ptr [bp - 0xa], 0       ; UNKNOWN
00B418  74 12                 JE     0xb42c                       ; UNKNOWN
00B41A  6A 62                 PUSH   0x62                         ; UNKNOWN
00B41C  1E                    PUSH   ds                           ; UNKNOWN
00B41D  68 98 1A              PUSH   0x1a98                       ; UNKNOWN
00B420  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
00B423  57                    PUSH   di                           ; UNKNOWN
00B424  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
00B429  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
00B42C  2B D2                 SUB    dx, dx                       ; UNKNOWN
00B42E  0B F6                 OR     si, si                       ; UNKNOWN
00B430  7E 38                 JLE    0xb46a                       ; UNKNOWN
00B432  89 76 FA              MOV    word ptr [bp - 6], si        ; UNKNOWN
00B435  89 7E EA              MOV    word ptr [bp - 0x16], di     ; UNKNOWN
00B438  8D 8E 3C FF           LEA    cx, [bp - 0xc4]              ; UNKNOWN
00B43C  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
00B43F  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
00B442  8B FA                 MOV    di, dx                       ; UNKNOWN
00B444  8B F1                 MOV    si, cx                       ; UNKNOWN
00B446  8D 45 01              LEA    ax, [di + 1]                 ; UNKNOWN
00B449  50                    PUSH   ax                           ; UNKNOWN
00B44A  16                    PUSH   ss                           ; UNKNOWN
00B44B  56                    PUSH   si                           ; UNKNOWN
00B44C  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
00B44F  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
00B452  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
00B457  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
00B45A  83 C6 0D              ADD    si, 0xd                      ; UNKNOWN
00B45D  8D 45 01              LEA    ax, [di + 1]                 ; UNKNOWN
00B460  8B F8                 MOV    di, ax                       ; UNKNOWN
00B462  3B 7E FA              CMP    di, word ptr [bp - 6]        ; UNKNOWN
00B465  7C DF                 JL     0xb446                       ; UNKNOWN
00B467  8B 7E EA              MOV    di, word ptr [bp - 0x16]     ; UNKNOWN
00B46A  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
00B46D  48                    DEC    ax                           ; UNKNOWN
00B46E  3B 46 F6              CMP    ax, word ptr [bp - 0xa]      ; UNKNOWN
00B471  7E 12                 JLE    0xb485                       ; UNKNOWN
00B473  6A 63                 PUSH   0x63                         ; UNKNOWN
00B475  1E                    PUSH   ds                           ; UNKNOWN
00B476  68 9F 1A              PUSH   0x1a9f                       ; UNKNOWN
00B479  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
00B47C  57                    PUSH   di                           ; UNKNOWN
00B47D  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
00B482  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
00B485  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
00B48A  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
00B48D  57                    PUSH   di                           ; UNKNOWN
00B48E  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
00B493  48                    DEC    ax                           ; UNKNOWN
00B494  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
00B497  83 F8 61              CMP    ax, 0x61                     ; UNKNOWN
00B49A  75 0A                 JNE    0xb4a6                       ; UNKNOWN
00B49C  FF 4E F6              DEC    word ptr [bp - 0xa]          ; UNKNOWN
00B49F  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
00B4A4  EB 0A                 JMP    0xb4b0                       ; UNKNOWN
00B4A6  83 F8 62              CMP    ax, 0x62                     ; UNKNOWN
00B4A9  75 05                 JNE    0xb4b0                       ; UNKNOWN
00B4AB  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
00B4AE  EB EF                 JMP    0xb49f                       ; UNKNOWN
00B4B0  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
00B4B3  57                    PUSH   di                           ; UNKNOWN
00B4B4  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
00B4B9  2B C0                 SUB    ax, ax                       ; UNKNOWN
00B4BB  99                    CDQ                                 ; UNKNOWN
00B4BC  8B F8                 MOV    di, ax                       ; UNKNOWN
00B4BE  89 56 EC              MOV    word ptr [bp - 0x14], dx     ; UNKNOWN
00B4C1  89 7E EA              MOV    word ptr [bp - 0x16], di     ; UNKNOWN
00B4C4  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
00B4C8  74 03                 JE     0xb4cd                       ; UNKNOWN
00B4CA  E9 95 FE              JMP    0xb362                       ; UNKNOWN
00B4CD  8B F7                 MOV    si, di                       ; UNKNOWN
00B4CF  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
00B4D3  7C 1E                 JL     0xb4f3                       ; UNKNOWN
00B4D5  8B 7E F0              MOV    di, word ptr [bp - 0x10]     ; UNKNOWN
00B4D8  8B C7                 MOV    ax, di                       ; UNKNOWN
00B4DA  D1 E7                 SHL    di, 1                        ; UNKNOWN
00B4DC  03 F8                 ADD    di, ax                       ; UNKNOWN
00B4DE  C1 E7 02              SHL    di, 2                        ; UNKNOWN
00B4E1  03 F8                 ADD    di, ax                       ; UNKNOWN
00B4E3  8D 83 3C FF           LEA    ax, [bp + di - 0xc4]         ; UNKNOWN
00B4E7  50                    PUSH   ax                           ; UNKNOWN
00B4E8  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
00B4EB  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00B4F0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00B4F3  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
00B4F6  0B C6                 OR     ax, si                       ; UNKNOWN
00B4F8  74 0A                 JE     0xb504                       ; UNKNOWN
00B4FA  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
00B4FD  50                    PUSH   ax                           ; UNKNOWN
00B4FE  56                    PUSH   si                           ; UNKNOWN
00B4FF  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
00B504  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
00B507  5E                    POP    si                           ; UNKNOWN
00B508  5F                    POP    di                           ; UNKNOWN
00B509  C9                    LEAVE                               ; UNKNOWN
00B50A  CB                    RETF                                ; UNKNOWN
