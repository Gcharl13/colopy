; ============================================================================
; func_04376E_unknown
; Region   : load_image
; Bytes    : file 0x04376E..0x04394A  (476 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04376E  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
043772  57                    PUSH   di                           ; UNKNOWN
043773  56                    PUSH   si                           ; UNKNOWN
043774  2B F6                 SUB    si, si                       ; UNKNOWN
043776  39 36 8A 82           CMP    word ptr [0x828a], si        ; UNKNOWN
04377A  7F 03                 JG     0x4377f                      ; UNKNOWN
04377C  E9 02 02              JMP    0x43981                      ; UNKNOWN
04377F  2B FF                 SUB    di, di                       ; UNKNOWN
043781  39 3E 88 82           CMP    word ptr [0x8288], di        ; UNKNOWN
043785  7F 03                 JG     0x4378a                      ; UNKNOWN
043787  E9 E8 01              JMP    0x43972                      ; UNKNOWN
04378A  89 76 F4              MOV    word ptr [bp - 0xc], si      ; UNKNOWN
04378D  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
043792  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
043795  57                    PUSH   di                           ; UNKNOWN
043796  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
04379B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04379E  0B C0                 OR     ax, ax                       ; UNKNOWN
0437A0  75 03                 JNE    0x437a5                      ; UNKNOWN
0437A2  E9 34 01              JMP    0x438d9                      ; UNKNOWN
0437A5  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
0437A8  57                    PUSH   di                           ; UNKNOWN
0437A9  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
0437AE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0437B1  0B C0                 OR     ax, ax                       ; UNKNOWN
0437B3  74 03                 JE     0x437b8                      ; UNKNOWN
0437B5  E9 21 01              JMP    0x438d9                      ; UNKNOWN
0437B8  89 7E EC              MOV    word ptr [bp - 0x14], di     ; UNKNOWN
0437BB  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
0437BE  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
0437C1  8A 87 4D 09           MOV    al, byte ptr [bx + 0x94d]    ; UNKNOWN
0437C5  98                    CWDE                                ; UNKNOWN
0437C6  03 46 F4              ADD    ax, word ptr [bp - 0xc]      ; UNKNOWN
0437C9  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0437CC  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
0437D1  50                    PUSH   ax                           ; UNKNOWN
0437D2  8A 87 38 09           MOV    al, byte ptr [bx + 0x938]    ; UNKNOWN
0437D6  98                    CWDE                                ; UNKNOWN
0437D7  03 46 EC              ADD    ax, word ptr [bp - 0x14]     ; UNKNOWN
0437DA  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0437DD  50                    PUSH   ax                           ; UNKNOWN
0437DE  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
0437E3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0437E6  0B C0                 OR     ax, ax                       ; UNKNOWN
0437E8  75 03                 JNE    0x437ed                      ; UNKNOWN
0437EA  E9 DD 00              JMP    0x438ca                      ; UNKNOWN
0437ED  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
0437F0  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
0437F3  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
0437F8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0437FB  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
0437FE  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
043801  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
043804  9A 9A 04 C9 33        LCALL  0x33c9, 0x49a                ; UNKNOWN
043809  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04380C  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04380F  40                    INC    ax                           ; UNKNOWN
043810  74 0E                 JE     0x43820                      ; UNKNOWN
043812  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
043815  8A 87 93 3D           MOV    al, byte ptr [bx + 0x3d93]   ; UNKNOWN
043819  2A E4                 SUB    ah, ah                       ; UNKNOWN
04381B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04381E  EB 4C                 JMP    0x4386c                      ; UNKNOWN
043820  83 7E EE 19           CMP    word ptr [bp - 0x12], 0x19   ; UNKNOWN
043824  75 3A                 JNE    0x43860                      ; UNKNOWN
043826  BA 02 00              MOV    dx, 2                        ; UNKNOWN
043829  2B F6                 SUB    si, si                       ; UNKNOWN
04382B  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
04382E  8B FA                 MOV    di, dx                       ; UNKNOWN
043830  8A 84 2F 09           MOV    al, byte ptr [si + 0x92f]    ; UNKNOWN
043834  98                    CWDE                                ; UNKNOWN
043835  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
043838  50                    PUSH   ax                           ; UNKNOWN
043839  8A 84 26 09           MOV    al, byte ptr [si + 0x926]    ; UNKNOWN
04383D  98                    CWDE                                ; UNKNOWN
04383E  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
043841  50                    PUSH   ax                           ; UNKNOWN
043842  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
043847  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04384A  0B C0                 OR     ax, ax                       ; UNKNOWN
04384C  75 02                 JNE    0x43850                      ; UNKNOWN
04384E  47                    INC    di                           ; UNKNOWN
04384F  47                    INC    di                           ; UNKNOWN
043850  46                    INC    si                           ; UNKNOWN
043851  83 FE 08              CMP    si, 8                        ; UNKNOWN
043854  7C DA                 JL     0x43830                      ; UNKNOWN
043856  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
043859  8B D7                 MOV    dx, di                       ; UNKNOWN
04385B  C1 FF 02              SAR    di, 2                        ; UNKNOWN
04385E  EB 0E                 JMP    0x4386e                      ; UNKNOWN
043860  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
043863  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
043866  8A 87 B9 34           MOV    al, byte ptr [bx + 0x34b9]   ; UNKNOWN
04386A  2A E4                 SUB    ah, ah                       ; UNKNOWN
04386C  8B F8                 MOV    di, ax                       ; UNKNOWN
04386E  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
043871  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
043874  9A 04 01 C9 33        LCALL  0x33c9, 0x104                ; UNKNOWN
043879  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04387C  A8 40                 TEST   al, 0x40                     ; UNKNOWN
04387E  74 01                 JE     0x43881                      ; UNKNOWN
043880  47                    INC    di                           ; UNKNOWN
043881  BA 02 00              MOV    dx, 2                        ; UNKNOWN
043884  83 7E F2 04           CMP    word ptr [bp - 0xe], 4       ; UNKNOWN
043888  7D 10                 JGE    0x4389a                      ; UNKNOWN
04388A  BA 05 00              MOV    dx, 5                        ; UNKNOWN
04388D  83 7E EE 19           CMP    word ptr [bp - 0x12], 0x19   ; UNKNOWN
043891  75 07                 JNE    0x4389a                      ; UNKNOWN
043893  8D 45 01              LEA    ax, [di + 1]                 ; UNKNOWN
043896  D1 F8                 SAR    ax, 1                        ; UNKNOWN
043898  8B F8                 MOV    di, ax                       ; UNKNOWN
04389A  83 7E F2 08           CMP    word ptr [bp - 0xe], 8       ; UNKNOWN
04389E  7D 02                 JGE    0x438a2                      ; UNKNOWN
0438A0  42                    INC    dx                           ; UNKNOWN
0438A1  42                    INC    dx                           ; UNKNOWN
0438A2  83 7E F2 0C           CMP    word ptr [bp - 0xe], 0xc     ; UNKNOWN
0438A6  7D 01                 JGE    0x438a9                      ; UNKNOWN
0438A8  42                    INC    dx                           ; UNKNOWN
0438A9  83 7E F2 14           CMP    word ptr [bp - 0xe], 0x14    ; UNKNOWN
0438AD  7D 01                 JGE    0x438b0                      ; UNKNOWN
0438AF  42                    INC    dx                           ; UNKNOWN
0438B0  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
0438B3  83 7E F2 14           CMP    word ptr [bp - 0xe], 0x14    ; UNKNOWN
0438B7  75 05                 JNE    0x438be                      ; UNKNOWN
0438B9  C7 46 FA 04 00        MOV    word ptr [bp - 6], 4         ; UNKNOWN
0438BE  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
0438C1  F7 EF                 IMUL   di                           ; UNKNOWN
0438C3  D1 F8                 SAR    ax, 1                        ; UNKNOWN
0438C5  8B F8                 MOV    di, ax                       ; UNKNOWN
0438C7  01 7E F0              ADD    word ptr [bp - 0x10], di     ; UNKNOWN
0438CA  FF 46 F2              INC    word ptr [bp - 0xe]          ; UNKNOWN
0438CD  83 7E F2 15           CMP    word ptr [bp - 0xe], 0x15    ; UNKNOWN
0438D1  7D 03                 JGE    0x438d6                      ; UNKNOWN
0438D3  E9 E8 FE              JMP    0x437be                      ; UNKNOWN
0438D6  8B 7E EC              MOV    di, word ptr [bp - 0x14]     ; UNKNOWN
0438D9  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
0438DC  57                    PUSH   di                           ; UNKNOWN
0438DD  9A A7 00 5F 24        LCALL  0x245f, 0xa7                 ; UNKNOWN
0438E2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0438E5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0438E8  0B C0                 OR     ax, ax                       ; UNKNOWN
0438EA  74 19                 JE     0x43905                      ; UNKNOWN
0438EC  FF 36 7C 73           PUSH   word ptr [0x737c]            ; UNKNOWN
0438F0  FF 36 7A 73           PUSH   word ptr [0x737a]            ; UNKNOWN
0438F4  9A BC 01 C9 33        LCALL  0x33c9, 0x1bc                ; UNKNOWN
0438F9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0438FC  FE C8                 DEC    al                           ; UNKNOWN
0438FE  74 05                 JE     0x43905                      ; UNKNOWN
043900  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
043905  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
043909  75 03                 JNE    0x4390e                      ; UNKNOWN
04390B  D1 7E F0              SAR    word ptr [bp - 0x10], 1      ; UNKNOWN
04390E  8B 76 F0              MOV    si, word ptr [bp - 0x10]     ; UNKNOWN
043911  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
043914  57                    PUSH   di                           ; UNKNOWN
043915  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04391A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04391D  83 F8 1B              CMP    ax, 0x1b                     ; UNKNOWN
043920  75 02                 JNE    0x43924                      ; UNKNOWN
043922  2B F6                 SUB    si, si                       ; UNKNOWN
043924  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
043927  57                    PUSH   di                           ; UNKNOWN
043928  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04392D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
043930  83 F8 1C              CMP    ax, 0x1c                     ; UNKNOWN
043933  75 02                 JNE    0x43937                      ; UNKNOWN
043935  D1 FE                 SAR    si, 1                        ; UNKNOWN
043937  6A 0F                 PUSH   0xf                          ; UNKNOWN
043939  6A 00                 PUSH   0                            ; UNKNOWN
04393B  8B C6                 MOV    ax, si                       ; UNKNOWN
04393D  B9 0A 00              MOV    cx, 0xa                      ; UNKNOWN
043940  99                    CDQ                                 ; UNKNOWN
043941  F7 F9                 IDIV   cx                           ; UNKNOWN
043943  50                    PUSH   ax                           ; UNKNOWN
043944  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
043949  83                    DB     0x83                         ; UNKNOWN (raw)
