; ============================================================================
; func_01431C_unknown
; Region   : load_image
; Bytes    : file 0x01431C..0x0144A9  (397 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01431C  C8 2A 00 00           ENTER  0x2a, 0                      ; UNKNOWN
014320  56                    PUSH   si                           ; UNKNOWN
014321  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
014325  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
014329  2A E4                 SUB    ah, ah                       ; UNKNOWN
01432B  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
01432E  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
014332  2A ED                 SUB    ch, ch                       ; UNKNOWN
014334  89 4E E2              MOV    word ptr [bp - 0x1e], cx     ; UNKNOWN
014337  51                    PUSH   cx                           ; UNKNOWN
014338  50                    PUSH   ax                           ; UNKNOWN
014339  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
01433E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014341  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
014344  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
014347  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
01434B  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
014350  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014353  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
014356  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
014359  C1 E6 04              SHL    si, 4                        ; UNKNOWN
01435C  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
01435F  8A 80 17 88           MOV    al, byte ptr [bx + si - 0x77e9] ; UNKNOWN
014363  2A E4                 SUB    ah, ah                       ; UNKNOWN
014365  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
014368  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01436A  8B 8F C6 86           MOV    cx, word ptr [bx - 0x793a]   ; UNKNOWN
01436E  D1 E9                 SHR    cx, 1                        ; UNKNOWN
014370  03 C1                 ADD    ax, cx                       ; UNKNOWN
014372  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
014375  83 7E 08 02           CMP    word ptr [bp + 8], 2         ; UNKNOWN
014379  75 08                 JNE    0x14383                      ; UNKNOWN
01437B  D1 F8                 SAR    ax, 1                        ; UNKNOWN
01437D  03 46 E6              ADD    ax, word ptr [bp - 0x1a]     ; UNKNOWN
014380  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
014383  6A 0A                 PUSH   0xa                          ; UNKNOWN
014385  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
014388  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
01438D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014390  0B C0                 OR     ax, ax                       ; UNKNOWN
014392  74 08                 JE     0x1439c                      ; UNKNOWN
014394  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
014397  D1 F8                 SAR    ax, 1                        ; UNKNOWN
014399  01 46 E6              ADD    word ptr [bp - 0x1a], ax     ; UNKNOWN
01439C  8B 36 3A 82           MOV    si, word ptr [0x823a]        ; UNKNOWN
0143A0  C1 E6 04              SHL    si, 4                        ; UNKNOWN
0143A3  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0143A6  8A 80 E2 85           MOV    al, byte ptr [bx + si - 0x7a1e] ; UNKNOWN
0143AA  2A E4                 SUB    ah, ah                       ; UNKNOWN
0143AC  8B 1E 3A 82           MOV    bx, word ptr [0x823a]        ; UNKNOWN
0143B0  8A 8F 9A 85           MOV    cl, byte ptr [bx - 0x7a66]   ; UNKNOWN
0143B4  D0 E9                 SHR    cl, 1                        ; UNKNOWN
0143B6  2A ED                 SUB    ch, ch                       ; UNKNOWN
0143B8  03 C1                 ADD    ax, cx                       ; UNKNOWN
0143BA  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0143BC  8B 4E D6              MOV    cx, word ptr [bp - 0x2a]     ; UNKNOWN
0143BF  D1 F9                 SAR    cx, 1                        ; UNKNOWN
0143C1  03 C1                 ADD    ax, cx                       ; UNKNOWN
0143C3  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
0143C6  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
0143CA  7D 16                 JGE    0x143e2                      ; UNKNOWN
0143CC  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
0143D0  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0143D5  75 0B                 JNE    0x143e2                      ; UNKNOWN
0143D7  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
0143DA  2A E4                 SUB    ah, ah                       ; UNKNOWN
0143DC  40                    INC    ax                           ; UNKNOWN
0143DD  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
0143E0  EB 05                 JMP    0x143e7                      ; UNKNOWN
0143E2  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1      ; UNKNOWN
0143E7  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
0143EA  6A 00                 PUSH   0                            ; UNKNOWN
0143EC  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0143F1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0143F4  FF 76 E0              PUSH   word ptr [bp - 0x20]         ; UNKNOWN
0143F7  6A 00                 PUSH   0                            ; UNKNOWN
0143F9  8B F0                 MOV    si, ax                       ; UNKNOWN
0143FB  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
014400  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014403  3B C6                 CMP    ax, si                       ; UNKNOWN
014405  7D 05                 JGE    0x1440c                      ; UNKNOWN
014407  B8 01 00              MOV    ax, 1                        ; UNKNOWN
01440A  EB 02                 JMP    0x1440e                      ; UNKNOWN
01440C  2B C0                 SUB    ax, ax                       ; UNKNOWN
01440E  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
014411  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
014414  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
014417  FF 76 E2              PUSH   word ptr [bp - 0x1e]         ; UNKNOWN
01441A  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
01441D  9A 45 01 5F 24        LCALL  0x245f, 0x145                ; UNKNOWN
014422  83 C4 08              ADD    sp, 8                        ; UNKNOWN
014425  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
014428  0B C0                 OR     ax, ax                       ; UNKNOWN
01442A  7D 05                 JGE    0x14431                      ; UNKNOWN
01442C  C7 46 D8 00 00        MOV    word ptr [bp - 0x28], 0      ; UNKNOWN
014431  83 7E D8 00           CMP    word ptr [bp - 0x28], 0      ; UNKNOWN
014435  75 08                 JNE    0x1443f                      ; UNKNOWN
014437  8B 46 E0              MOV    ax, word ptr [bp - 0x20]     ; UNKNOWN
01443A  39 46 E6              CMP    word ptr [bp - 0x1a], ax     ; UNKNOWN
01443D  7E 06                 JLE    0x14445                      ; UNKNOWN
01443F  83 7E D6 4B           CMP    word ptr [bp - 0x2a], 0x4b   ; UNKNOWN
014443  7C 3F                 JL     0x14484                      ; UNKNOWN
014445  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
014449  7C 03                 JL     0x1444e                      ; UNKNOWN
01444B  E9 14 02              JMP    0x14662                      ; UNKNOWN
01444E  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
014452  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
014457  74 03                 JE     0x1445c                      ; UNKNOWN
014459  E9 06 02              JMP    0x14662                      ; UNKNOWN
01445C  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01445F  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
014464  83 C4 02              ADD    sp, 2                        ; UNKNOWN
014467  50                    PUSH   ax                           ; UNKNOWN
014468  6A 00                 PUSH   0                            ; UNKNOWN
01446A  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01446F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014472  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
014476  68 66 26              PUSH   0x2666                       ; UNKNOWN
014479  9A 00 37 97 1B        LCALL  0x1b97, 0x3700               ; UNKNOWN
01447E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014481  E9 DE 01              JMP    0x14662                      ; UNKNOWN
014484  83 7E D8 00           CMP    word ptr [bp - 0x28], 0      ; UNKNOWN
014488  75 66                 JNE    0x144f0                      ; UNKNOWN
01448A  83 7E D6 32           CMP    word ptr [bp - 0x2a], 0x32   ; UNKNOWN
01448E  7C 60                 JL     0x144f0                      ; UNKNOWN
014490  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
014494  7C 03                 JL     0x14499                      ; UNKNOWN
014496  E9 C9 01              JMP    0x14662                      ; UNKNOWN
014499  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
01449D  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0144A2  74 03                 JE     0x144a7                      ; UNKNOWN
0144A4  E9 BB 01              JMP    0x14662                      ; UNKNOWN
0144A7  8B C3                 MOV    ax, bx                       ; UNKNOWN
