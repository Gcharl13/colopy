; ============================================================================
; func_06A892_unknown
; Region   : load_image
; Bytes    : file 0x06A892..0x06A94B  (185 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A892  55                    PUSH   bp                           ; UNKNOWN
06A893  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A895  83 EC 08              SUB    sp, 8                        ; UNKNOWN
06A898  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
06A89B  3B 1E 45 12           CMP    bx, word ptr [0x1245]        ; UNKNOWN
06A89F  72 07                 JB     0x6a8a8                      ; UNKNOWN
06A8A1  B8 00 09              MOV    ax, 0x900                    ; UNKNOWN
06A8A4  F9                    STC                                 ; UNKNOWN
06A8A5  E9 C9 F5              JMP    0x69e71                      ; UNKNOWN
06A8A8  81 3E A0 15 D6 D6     CMP    word ptr [0x15a0], 0xd6d6    ; UNKNOWN
06A8AE  75 04                 JNE    0x6a8b4                      ; UNKNOWN
06A8B0  FF 16 A2 15           CALL   word ptr [0x15a2]            ; UNKNOWN
06A8B4  F6 87 47 12 20        TEST   byte ptr [bx + 0x1247], 0x20 ; UNKNOWN
06A8B9  74 0B                 JE     0x6a8c6                      ; UNKNOWN
06A8BB  B8 02 42              MOV    ax, 0x4202                   ; UNKNOWN
06A8BE  33 C9                 XOR    cx, cx                       ; UNKNOWN
06A8C0  8B D1                 MOV    dx, cx                       ; UNKNOWN
06A8C2  CD 21                 INT    0x21                         ; UNKNOWN
06A8C4  72 DF                 JB     0x6a8a5                      ; UNKNOWN
06A8C6  F6 87 47 12 80        TEST   byte ptr [bx + 0x1247], 0x80 ; UNKNOWN
06A8CB  74 70                 JE     0x6a93d                      ; UNKNOWN
06A8CD  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
06A8D0  1E                    PUSH   ds                           ; UNKNOWN
06A8D1  07                    POP    es                           ; UNKNOWN
06A8D2  33 C0                 XOR    ax, ax                       ; UNKNOWN
06A8D4  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
06A8D7  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
06A8DA  FC                    CLD                                 ; UNKNOWN
06A8DB  57                    PUSH   di                           ; UNKNOWN
06A8DC  56                    PUSH   si                           ; UNKNOWN
06A8DD  8B FA                 MOV    di, dx                       ; UNKNOWN
06A8DF  8B F2                 MOV    si, dx                       ; UNKNOWN
06A8E1  89 66 F8              MOV    word ptr [bp - 8], sp        ; UNKNOWN
06A8E4  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
06A8E7  E3 3A                 JCXZ   0x6a923                      ; UNKNOWN
06A8E9  B0 0A                 MOV    al, 0xa                      ; UNKNOWN
06A8EB  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
06A8ED  75 4C                 JNE    0x6a93b                      ; UNKNOWN
06A8EF  9A 94 2B 65 5F        LCALL  0x5f65, 0x2b94               ; UNKNOWN
06A8F4  3D A8 00              CMP    ax, 0xa8                     ; UNKNOWN
06A8F7  76 46                 JBE    0x6a93f                      ; UNKNOWN
06A8F9  83 EC 02              SUB    sp, 2                        ; UNKNOWN
06A8FC  8B DC                 MOV    bx, sp                       ; UNKNOWN
06A8FE  BA 00 02              MOV    dx, 0x200                    ; UNKNOWN
06A901  3D 28 02              CMP    ax, 0x228                    ; UNKNOWN
06A904  73 03                 JAE    0x6a909                      ; UNKNOWN
06A906  BA 80 00              MOV    dx, 0x80                     ; UNKNOWN
06A909  2B E2                 SUB    sp, dx                       ; UNKNOWN
06A90B  8B D4                 MOV    dx, sp                       ; UNKNOWN
06A90D  8B FA                 MOV    di, dx                       ; UNKNOWN
06A90F  16                    PUSH   ss                           ; UNKNOWN
06A910  07                    POP    es                           ; UNKNOWN
06A911  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
06A914  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
06A915  3C 0A                 CMP    al, 0xa                      ; UNKNOWN
06A917  74 0C                 JE     0x6a925                      ; UNKNOWN
06A919  3B FB                 CMP    di, bx                       ; UNKNOWN
06A91B  74 19                 JE     0x6a936                      ; UNKNOWN
06A91D  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
06A91E  E2 F4                 LOOP   0x6a914                      ; UNKNOWN
06A920  E8 23 00              CALL   0x6a946                      ; UNKNOWN
06A923  EB 6B                 JMP    0x6a990                      ; UNKNOWN
06A925  B0 0D                 MOV    al, 0xd                      ; UNKNOWN
06A927  3B FB                 CMP    di, bx                       ; UNKNOWN
06A929  75 03                 JNE    0x6a92e                      ; UNKNOWN
06A92B  E8 18 00              CALL   0x6a946                      ; UNKNOWN
06A92E  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
06A92F  B0 0A                 MOV    al, 0xa                      ; UNKNOWN
06A931  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
06A934  EB E3                 JMP    0x6a919                      ; UNKNOWN
06A936  E8 0D 00              CALL   0x6a946                      ; UNKNOWN
06A939  EB E2                 JMP    0x6a91d                      ; UNKNOWN
06A93B  5E                    POP    si                           ; UNKNOWN
06A93C  5F                    POP    di                           ; UNKNOWN
06A93D  EB 5F                 JMP    0x6a99e                      ; UNKNOWN
06A93F  B8 FC FF              MOV    ax, 0xfffc                   ; UNKNOWN
06A942  0E                    PUSH   cs                           ; UNKNOWN
06A943  E8 A2 DF              CALL   0x688e8                      ; UNKNOWN
06A946  50                    PUSH   ax                           ; UNKNOWN
06A947  53                    PUSH   bx                           ; UNKNOWN
06A948  51                    PUSH   cx                           ; UNKNOWN
06A949  8B CF                 MOV    cx, di                       ; UNKNOWN
