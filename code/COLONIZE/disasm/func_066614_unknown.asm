; ============================================================================
; func_066614_unknown
; Region   : load_image
; Bytes    : file 0x066614..0x066774  (352 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066614  C8 0E 02 00           ENTER  0x20e, 0                     ; UNKNOWN
066618  50                    PUSH   ax                           ; UNKNOWN
066619  53                    PUSH   bx                           ; UNKNOWN
06661A  57                    PUSH   di                           ; UNKNOWN
06661B  56                    PUSH   si                           ; UNKNOWN
06661C  2B C0                 SUB    ax, ax                       ; UNKNOWN
06661E  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
066621  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
066624  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
066627  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
06662A  89 86 FA FD           MOV    word ptr [bp - 0x206], ax    ; UNKNOWN
06662E  89 86 F8 FD           MOV    word ptr [bp - 0x208], ax    ; UNKNOWN
066632  89 86 E6 FE           MOV    word ptr [bp - 0x11a], ax    ; UNKNOWN
066636  89 86 E4 FE           MOV    word ptr [bp - 0x11c], ax    ; UNKNOWN
06663A  C7 06 32 01 0D 00     MOV    word ptr [0x132], 0xd        ; UNKNOWN
066640  89 86 1A FE           MOV    word ptr [bp - 0x1e6], ax    ; UNKNOWN
066644  53                    PUSH   bx                           ; UNKNOWN
066645  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
066648  50                    PUSH   ax                           ; UNKNOWN
066649  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
06664E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
066651  6A 2E                 PUSH   0x2e                         ; UNKNOWN
066653  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
066656  50                    PUSH   ax                           ; UNKNOWN
066657  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
06665C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06665F  0B C0                 OR     ax, ax                       ; UNKNOWN
066661  75 0F                 JNE    0x66672                      ; UNKNOWN
066663  68 CE 30              PUSH   0x30ce                       ; UNKNOWN
066666  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
066669  50                    PUSH   ax                           ; UNKNOWN
06666A  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
06666F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
066672  68 D2 30              PUSH   0x30d2                       ; UNKNOWN
066675  8D 86 04 FE           LEA    ax, [bp - 0x1fc]             ; UNKNOWN
066679  50                    PUSH   ax                           ; UNKNOWN
06667A  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
06667F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
066682  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
066685  89 86 18 FE           MOV    word ptr [bp - 0x1e8], ax    ; UNKNOWN
066689  50                    PUSH   ax                           ; UNKNOWN
06668A  9A 9E 0D 65 5F        LCALL  0x5f65, 0xd9e                ; UNKNOWN
06668F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
066692  80 7E AE 2A           CMP    byte ptr [bp - 0x52], 0x2a   ; UNKNOWN
066696  75 07                 JNE    0x6669f                      ; UNKNOWN
066698  8D 46 AF              LEA    ax, [bp - 0x51]              ; UNKNOWN
06669B  89 86 18 FE           MOV    word ptr [bp - 0x1e8], ax    ; UNKNOWN
06669F  8B 9E 18 FE           MOV    bx, word ptr [bp - 0x1e8]    ; UNKNOWN
0666A3  80 3F 52              CMP    byte ptr [bx], 0x52          ; UNKNOWN
0666A6  75 0B                 JNE    0x666b3                      ; UNKNOWN
0666A8  80 7F 01 4D           CMP    byte ptr [bx + 1], 0x4d      ; UNKNOWN
0666AC  75 05                 JNE    0x666b3                      ; UNKNOWN
0666AE  83 86 18 FE 02        ADD    word ptr [bp - 0x1e8], 2     ; UNKNOWN
0666B3  6A 06                 PUSH   6                            ; UNKNOWN
0666B5  FF B6 18 FE           PUSH   word ptr [bp - 0x1e8]        ; UNKNOWN
0666B9  8D 86 04 FE           LEA    ax, [bp - 0x1fc]             ; UNKNOWN
0666BD  50                    PUSH   ax                           ; UNKNOWN
0666BE  9A EE 07 65 5F        LCALL  0x5f65, 0x7ee                ; UNKNOWN
0666C3  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0666C6  8D 86 1A FE           LEA    ax, [bp - 0x1e6]             ; UNKNOWN
0666CA  16                    PUSH   ss                           ; UNKNOWN
0666CB  50                    PUSH   ax                           ; UNKNOWN
0666CC  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0666CF  16                    PUSH   ss                           ; UNKNOWN
0666D0  50                    PUSH   ax                           ; UNKNOWN
0666D1  8D 1E D5 30           LEA    bx, [0x30d5]                 ; UNKNOWN
0666D5  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0666D8  9A 0E 00 AC 5B        LCALL  0x5bac, 0xe                  ; UNKNOWN
0666DD  0B C0                 OR     ax, ax                       ; UNKNOWN
0666DF  74 09                 JE     0x666ea                      ; UNKNOWN
0666E1  C7 06 22 0F FF FF     MOV    word ptr [0xf22], 0xffff     ; UNKNOWN
0666E7  E9 5D 03              JMP    0x66a47                      ; UNKNOWN
0666EA  C7 06 22 0F FE FF     MOV    word ptr [0xf22], 0xfffe     ; UNKNOWN
0666F0  C7 86 F2 FD 98 00     MOV    word ptr [bp - 0x20e], 0x98  ; UNKNOWN
0666F6  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
0666FA  16                    PUSH   ss                           ; UNKNOWN
0666FB  50                    PUSH   ax                           ; UNKNOWN
0666FC  6A 00                 PUSH   0                            ; UNKNOWN
0666FE  6A 01                 PUSH   1                            ; UNKNOWN
066700  8D 86 1A FE           LEA    ax, [bp - 0x1e6]             ; UNKNOWN
066704  16                    PUSH   ss                           ; UNKNOWN
066705  50                    PUSH   ax                           ; UNKNOWN
066706  B8 98 00              MOV    ax, 0x98                     ; UNKNOWN
066709  99                    CDQ                                 ; UNKNOWN
06670A  9A 0A 00 D7 5B        LCALL  0x5bd7, 0xa                  ; UNKNOWN
06670F  0B D0                 OR     dx, ax                       ; UNKNOWN
066711  75 03                 JNE    0x66716                      ; UNKNOWN
066713  E9 31 03              JMP    0x66a47                      ; UNKNOWN
066716  8B 86 12 FF           MOV    ax, word ptr [bp - 0xee]     ; UNKNOWN
06671A  C1 E0 04              SHL    ax, 4                        ; UNKNOWN
06671D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
066720  8B 86 12 FF           MOV    ax, word ptr [bp - 0xee]     ; UNKNOWN
066724  8B C8                 MOV    cx, ax                       ; UNKNOWN
066726  D1 E0                 SHL    ax, 1                        ; UNKNOWN
066728  03 C1                 ADD    ax, cx                       ; UNKNOWN
06672A  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
06672D  83 C0 42              ADD    ax, 0x42                     ; UNKNOWN
066730  99                    CDQ                                 ; UNKNOWN
066731  89 86 E8 FE           MOV    word ptr [bp - 0x118], ax    ; UNKNOWN
066735  89 96 EA FE           MOV    word ptr [bp - 0x116], dx    ; UNKNOWN
066739  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
06673C  89 56 9A              MOV    word ptr [bp - 0x66], dx     ; UNKNOWN
06673F  89 86 F4 FD           MOV    word ptr [bp - 0x20c], ax    ; UNKNOWN
066743  89 96 F6 FD           MOV    word ptr [bp - 0x20a], dx    ; UNKNOWN
066747  F6 86 F0 FD 02        TEST   byte ptr [bp - 0x210], 2     ; UNKNOWN
06674C  75 15                 JNE    0x66763                      ; UNKNOWN
06674E  80 BE EC FE 00        CMP    byte ptr [bp - 0x114], 0     ; UNKNOWN
066753  75 0E                 JNE    0x66763                      ; UNKNOWN
066755  03 46 80              ADD    ax, word ptr [bp - 0x80]     ; UNKNOWN
066758  13 56 82              ADC    dx, word ptr [bp - 0x7e]     ; UNKNOWN
06675B  89 86 F4 FD           MOV    word ptr [bp - 0x20c], ax    ; UNKNOWN
06675F  89 96 F6 FD           MOV    word ptr [bp - 0x20a], dx    ; UNKNOWN
066763  A1 2A 0F              MOV    ax, word ptr [0xf2a]         ; UNKNOWN
066766  0B 06 28 0F           OR     ax, word ptr [0xf28]         ; UNKNOWN
06676A  74 22                 JE     0x6678e                      ; UNKNOWN
06676C  A1 C0 CE              MOV    ax, word ptr [0xcec0]        ; UNKNOWN
06676F  8B 16 C2 CE           MOV    dx, word ptr [0xcec2]        ; UNKNOWN
066773  39                    DB     0x39                         ; UNKNOWN (raw)
