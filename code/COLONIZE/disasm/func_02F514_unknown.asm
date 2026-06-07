; ============================================================================
; func_02F514_unknown
; Region   : load_image
; Bytes    : file 0x02F514..0x02F7A8  (660 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02F514  C8 2A 00 00           ENTER  0x2a, 0                      ; UNKNOWN
02F518  56                    PUSH   si                           ; UNKNOWN
02F519  2A C0                 SUB    al, al                       ; UNKNOWN
02F51B  A2 63 74              MOV    byte ptr [0x7463], al        ; UNKNOWN
02F51E  A2 64 74              MOV    byte ptr [0x7464], al        ; UNKNOWN
02F521  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F525  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02F528  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F52A  50                    PUSH   ax                           ; UNKNOWN
02F52B  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02F52D  50                    PUSH   ax                           ; UNKNOWN
02F52E  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
02F533  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F536  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
02F539  83 F8 18              CMP    ax, 0x18                     ; UNKNOWN
02F53C  75 07                 JNE    0x2f545                      ; UNKNOWN
02F53E  C6 06 5F 74 00        MOV    byte ptr [0x745f], 0         ; UNKNOWN
02F543  EB 40                 JMP    0x2f585                      ; UNKNOWN
02F545  83 F8 01              CMP    ax, 1                        ; UNKNOWN
02F548  74 0A                 JE     0x2f554                      ; UNKNOWN
02F54A  83 F8 11              CMP    ax, 0x11                     ; UNKNOWN
02F54D  74 05                 JE     0x2f554                      ; UNKNOWN
02F54F  83 F8 09              CMP    ax, 9                        ; UNKNOWN
02F552  75 07                 JNE    0x2f55b                      ; UNKNOWN
02F554  C6 06 5F 74 01        MOV    byte ptr [0x745f], 1         ; UNKNOWN
02F559  EB 2A                 JMP    0x2f585                      ; UNKNOWN
02F55B  83 F8 1B              CMP    ax, 0x1b                     ; UNKNOWN
02F55E  74 19                 JE     0x2f579                      ; UNKNOWN
02F560  83 F8 1C              CMP    ax, 0x1c                     ; UNKNOWN
02F563  74 14                 JE     0x2f579                      ; UNKNOWN
02F565  83 F8 08              CMP    ax, 8                        ; UNKNOWN
02F568  7C 05                 JL     0x2f56f                      ; UNKNOWN
02F56A  83 F8 10              CMP    ax, 0x10                     ; UNKNOWN
02F56D  7C 0A                 JL     0x2f579                      ; UNKNOWN
02F56F  83 F8 10              CMP    ax, 0x10                     ; UNKNOWN
02F572  7C 0C                 JL     0x2f580                      ; UNKNOWN
02F574  83 F8 18              CMP    ax, 0x18                     ; UNKNOWN
02F577  7D 07                 JGE    0x2f580                      ; UNKNOWN
02F579  C6 06 5F 74 02        MOV    byte ptr [0x745f], 2         ; UNKNOWN
02F57E  EB 05                 JMP    0x2f585                      ; UNKNOWN
02F580  C6 06 5F 74 03        MOV    byte ptr [0x745f], 3         ; UNKNOWN
02F585  80 3E 1E 3E 00        CMP    byte ptr [0x3e1e], 0         ; UNKNOWN
02F58A  75 05                 JNE    0x2f591                      ; UNKNOWN
02F58C  80 06 5F 74 02        ADD    byte ptr [0x745f], 2         ; UNKNOWN
02F591  80 3E 1E 3E 01        CMP    byte ptr [0x3e1e], 1         ; UNKNOWN
02F596  75 04                 JNE    0x2f59c                      ; UNKNOWN
02F598  FE 06 5F 74           INC    byte ptr [0x745f]            ; UNKNOWN
02F59C  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F5A0  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02F5A3  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F5A5  50                    PUSH   ax                           ; UNKNOWN
02F5A6  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02F5A8  50                    PUSH   ax                           ; UNKNOWN
02F5A9  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02F5AE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F5B1  A8 40                 TEST   al, 0x40                     ; UNKNOWN
02F5B3  74 04                 JE     0x2f5b9                      ; UNKNOWN
02F5B5  FE 06 5F 74           INC    byte ptr [0x745f]            ; UNKNOWN
02F5B9  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F5BD  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02F5C0  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F5C2  50                    PUSH   ax                           ; UNKNOWN
02F5C3  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02F5C5  50                    PUSH   ax                           ; UNKNOWN
02F5C6  9A 9A 04 C9 33        LCALL  0x33c9, 0x49a                ; UNKNOWN
02F5CB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F5CE  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
02F5D1  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
02F5D6  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F5DA  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02F5DD  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F5DF  50                    PUSH   ax                           ; UNKNOWN
02F5E0  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02F5E2  50                    PUSH   ax                           ; UNKNOWN
02F5E3  9A 04 01 C9 33        LCALL  0x33c9, 0x104                ; UNKNOWN
02F5E8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F5EB  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F5ED  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02F5F0  A8 40                 TEST   al, 0x40                     ; UNKNOWN
02F5F2  74 10                 JE     0x2f604                      ; UNKNOWN
02F5F4  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
02F5F9  F6 46 FE 80           TEST   byte ptr [bp - 2], 0x80      ; UNKNOWN
02F5FD  74 05                 JE     0x2f604                      ; UNKNOWN
02F5FF  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2      ; UNKNOWN
02F604  83 7E EC 01           CMP    word ptr [bp - 0x14], 1      ; UNKNOWN
02F608  74 0C                 JE     0x2f616                      ; UNKNOWN
02F60A  83 7E EC 09           CMP    word ptr [bp - 0x14], 9      ; UNKNOWN
02F60E  74 06                 JE     0x2f616                      ; UNKNOWN
02F610  83 7E EC 02           CMP    word ptr [bp - 0x14], 2      ; UNKNOWN
02F614  75 05                 JNE    0x2f61b                      ; UNKNOWN
02F616  80 06 5F 74 02        ADD    byte ptr [0x745f], 2         ; UNKNOWN
02F61B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F61F  F6 47 1C 04           TEST   byte ptr [bx + 0x1c], 4      ; UNKNOWN
02F623  74 04                 JE     0x2f629                      ; UNKNOWN
02F625  FE 06 5F 74           INC    byte ptr [0x745f]            ; UNKNOWN
02F629  F6 47 1C 02           TEST   byte ptr [bx + 0x1c], 2      ; UNKNOWN
02F62D  74 04                 JE     0x2f633                      ; UNKNOWN
02F62F  FE 06 5F 74           INC    byte ptr [0x745f]            ; UNKNOWN
02F633  C6 06 61 74 FF        MOV    byte ptr [0x7461], 0xff      ; UNKNOWN
02F638  C6 06 62 74 00        MOV    byte ptr [0x7462], 0         ; UNKNOWN
02F63D  C7 46 E4 01 00        MOV    word ptr [bp - 0x1c], 1      ; UNKNOWN
02F642  EB 1B                 JMP    0x2f65f                      ; UNKNOWN
02F644  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
02F647  A0 62 74              MOV    al, byte ptr [0x7462]        ; UNKNOWN
02F64A  98                    CWDE                                ; UNKNOWN
02F64B  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
02F64E  7D 0C                 JGE    0x2f65c                      ; UNKNOWN
02F650  8A 46 E4              MOV    al, byte ptr [bp - 0x1c]     ; UNKNOWN
02F653  A2 61 74              MOV    byte ptr [0x7461], al        ; UNKNOWN
02F656  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
02F659  A2 62 74              MOV    byte ptr [0x7462], al        ; UNKNOWN
02F65C  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
02F65F  83 7E E4 08           CMP    word ptr [bp - 0x1c], 8      ; UNKNOWN
02F663  7D 2F                 JGE    0x2f694                      ; UNKNOWN
02F665  83 7E E4 05           CMP    word ptr [bp - 0x1c], 5      ; UNKNOWN
02F669  74 F1                 JE     0x2f65c                      ; UNKNOWN
02F66B  8B 76 DC              MOV    si, word ptr [bp - 0x24]     ; UNKNOWN
02F66E  C1 E6 04              SHL    si, 4                        ; UNKNOWN
02F671  8B 5E E4              MOV    bx, word ptr [bp - 0x1c]     ; UNKNOWN
02F674  8A 80 BB 34           MOV    al, byte ptr [bx + si + 0x34bb] ; UNKNOWN
02F678  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F67A  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02F67D  53                    PUSH   bx                           ; UNKNOWN
02F67E  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
02F681  0E                    PUSH   cs                           ; UNKNOWN
02F682  E8 27 F7              CALL   0x2edac                      ; UNKNOWN
02F685  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F688  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
02F68B  0B C0                 OR     ax, ax                       ; UNKNOWN
02F68D  7D B5                 JGE    0x2f644                      ; UNKNOWN
02F68F  D1 66 FA              SHL    word ptr [bp - 6], 1         ; UNKNOWN
02F692  EB B3                 JMP    0x2f647                      ; UNKNOWN
02F694  80 3E 61 74 00        CMP    byte ptr [0x7461], 0         ; UNKNOWN
02F699  7C 2A                 JL     0x2f6c5                      ; UNKNOWN
02F69B  80 3E 1E 3E 00        CMP    byte ptr [0x3e1e], 0         ; UNKNOWN
02F6A0  75 04                 JNE    0x2f6a6                      ; UNKNOWN
02F6A2  FE 06 62 74           INC    byte ptr [0x7462]            ; UNKNOWN
02F6A6  8A 46 EE              MOV    al, byte ptr [bp - 0x12]     ; UNKNOWN
02F6A9  00 06 62 74           ADD    byte ptr [0x7462], al        ; UNKNOWN
02F6AD  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F6B1  F6 47 1C 04           TEST   byte ptr [bx + 0x1c], 4      ; UNKNOWN
02F6B5  74 04                 JE     0x2f6bb                      ; UNKNOWN
02F6B7  FE 06 62 74           INC    byte ptr [0x7462]            ; UNKNOWN
02F6BB  F6 47 1C 02           TEST   byte ptr [bx + 0x1c], 2      ; UNKNOWN
02F6BF  74 04                 JE     0x2f6c5                      ; UNKNOWN
02F6C1  FE 06 62 74           INC    byte ptr [0x7462]            ; UNKNOWN
02F6C5  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; UNKNOWN
02F6CA  8B 5E E4              MOV    bx, word ptr [bp - 0x1c]     ; UNKNOWN
02F6CD  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02F6CF  C7 87 88 73 00 00     MOV    word ptr [bx + 0x7388], 0    ; UNKNOWN
02F6D5  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
02F6D8  83 7E E4 14           CMP    word ptr [bp - 0x1c], 0x14   ; UNKNOWN
02F6DC  7C EC                 JL     0x2f6ca                      ; UNKNOWN
02F6DE  A0 5F 74              MOV    al, byte ptr [0x745f]        ; UNKNOWN
02F6E1  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F6E3  01 06 88 73           ADD    word ptr [0x7388], ax        ; UNKNOWN
02F6E7  38 26 61 74           CMP    byte ptr [0x7461], ah        ; UNKNOWN
02F6EB  7C 10                 JL     0x2f6fd                      ; UNKNOWN
02F6ED  A0 61 74              MOV    al, byte ptr [0x7461]        ; UNKNOWN
02F6F0  98                    CWDE                                ; UNKNOWN
02F6F1  8B D8                 MOV    bx, ax                       ; UNKNOWN
02F6F3  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02F6F5  A0 62 74              MOV    al, byte ptr [0x7462]        ; UNKNOWN
02F6F8  98                    CWDE                                ; UNKNOWN
02F6F9  01 87 88 73           ADD    word ptr [bx + 0x7388], ax   ; UNKNOWN
02F6FD  C7 46 E6 00 00        MOV    word ptr [bp - 0x1a], 0      ; UNKNOWN
02F702  EB 57                 JMP    0x2f75b                      ; UNKNOWN
02F704  FF 46 E8              INC    word ptr [bp - 0x18]         ; UNKNOWN
02F707  83 7E E8 05           CMP    word ptr [bp - 0x18], 5      ; UNKNOWN
02F70B  7D 4B                 JGE    0x2f758                      ; UNKNOWN
02F70D  6A 01                 PUSH   1                            ; UNKNOWN
02F70F  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
02F712  50                    PUSH   ax                           ; UNKNOWN
02F713  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
02F716  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
02F719  0E                    PUSH   cs                           ; UNKNOWN
02F71A  E8 80 F7              CALL   0x2ee9d                      ; UNKNOWN
02F71D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02F720  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
02F723  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; UNKNOWN
02F727  7C DB                 JL     0x2f704                      ; UNKNOWN
02F729  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
02F72C  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
02F72F  0E                    PUSH   cs                           ; UNKNOWN
02F730  E8 53 E5              CALL   0x2dc86                      ; UNKNOWN
02F733  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F736  98                    CWDE                                ; UNKNOWN
02F737  8B F0                 MOV    si, ax                       ; UNKNOWN
02F739  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F73D  80 78 20 08           CMP    byte ptr [bx + si + 0x20], 8 ; UNKNOWN
02F741  75 07                 JNE    0x2f74a                      ; UNKNOWN
02F743  8A 46 F0              MOV    al, byte ptr [bp - 0x10]     ; UNKNOWN
02F746  00 06 63 74           ADD    byte ptr [0x7463], al        ; UNKNOWN
02F74A  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
02F74D  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
02F750  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02F752  01 87 88 73           ADD    word ptr [bx + 0x7388], ax   ; UNKNOWN
02F756  EB AC                 JMP    0x2f704                      ; UNKNOWN
02F758  FF 46 E6              INC    word ptr [bp - 0x1a]         ; UNKNOWN
02F75B  83 7E E6 05           CMP    word ptr [bp - 0x1a], 5      ; UNKNOWN
02F75F  7D 07                 JGE    0x2f768                      ; UNKNOWN
02F761  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0      ; UNKNOWN
02F766  EB 9F                 JMP    0x2f707                      ; UNKNOWN
02F768  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; UNKNOWN
02F76D  EB 23                 JMP    0x2f792                      ; UNKNOWN
02F76F  8D 46 DA              LEA    ax, [bp - 0x26]              ; UNKNOWN
02F772  50                    PUSH   ax                           ; UNKNOWN
02F773  FF 76 E4              PUSH   word ptr [bp - 0x1c]         ; UNKNOWN
02F776  0E                    PUSH   cs                           ; UNKNOWN
02F777  E8 7E FB              CALL   0x2f2f8                      ; UNKNOWN
02F77A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F77D  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
02F780  83 7E DA 00           CMP    word ptr [bp - 0x26], 0      ; UNKNOWN
02F784  7C 09                 JL     0x2f78f                      ; UNKNOWN
02F786  8B 5E DA              MOV    bx, word ptr [bp - 0x26]     ; UNKNOWN
02F789  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02F78B  01 87 88 73           ADD    word ptr [bx + 0x7388], ax   ; UNKNOWN
02F78F  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
02F792  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F796  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02F799  98                    CWDE                                ; UNKNOWN
02F79A  3B 46 E4              CMP    ax, word ptr [bp - 0x1c]     ; UNKNOWN
02F79D  7F D0                 JG     0x2f76f                      ; UNKNOWN
02F79F  FF 06 AA 73           INC    word ptr [0x73aa]            ; UNKNOWN
02F7A3  6A 25                 PUSH   0x25                         ; UNKNOWN
02F7A5  0E                    PUSH   cs                           ; UNKNOWN
02F7A6  E8                    DB     0xE8                         ; UNKNOWN (raw)
02F7A7  CF                    DB     0xCF                         ; UNKNOWN (raw)
