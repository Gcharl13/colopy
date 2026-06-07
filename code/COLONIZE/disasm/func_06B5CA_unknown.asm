; ============================================================================
; func_06B5CA_unknown
; Region   : load_image
; Bytes    : file 0x06B5CA..0x06B732  (360 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B5CA  55                    PUSH   bp                           ; UNKNOWN
06B5CB  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B5CD  83 EC 0C              SUB    sp, 0xc                      ; UNKNOWN
06B5D0  57                    PUSH   di                           ; UNKNOWN
06B5D1  56                    PUSH   si                           ; UNKNOWN
06B5D2  2B F6                 SUB    si, si                       ; UNKNOWN
06B5D4  39 76 08              CMP    word ptr [bp + 8], si        ; UNKNOWN
06B5D7  75 06                 JNE    0x6b5df                      ; UNKNOWN
06B5D9  A1 5F 12              MOV    ax, word ptr [0x125f]        ; UNKNOWN
06B5DC  89 46 08              MOV    word ptr [bp + 8], ax        ; UNKNOWN
06B5DF  39 76 08              CMP    word ptr [bp + 8], si        ; UNKNOWN
06B5E2  74 27                 JE     0x6b60b                      ; UNKNOWN
06B5E4  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
06B5E7  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
06B5EA  EB 11                 JMP    0x6b5fd                      ; UNKNOWN
06B5EC  83 46 FA 02           ADD    word ptr [bp - 6], 2         ; UNKNOWN
06B5F0  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
06B5F2  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06B5F7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B5FA  40                    INC    ax                           ; UNKNOWN
06B5FB  03 F0                 ADD    si, ax                       ; UNKNOWN
06B5FD  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
06B600  83 3F 00              CMP    word ptr [bx], 0             ; UNKNOWN
06B603  74 06                 JE     0x6b60b                      ; UNKNOWN
06B605  81 FE FF 7F           CMP    si, 0x7fff                   ; UNKNOWN
06B609  76 E1                 JBE    0x6b5ec                      ; UNKNOWN
06B60B  83 3E 9C 15 00        CMP    word ptr [0x159c], 0         ; UNKNOWN
06B610  74 1E                 JE     0x6b630                      ; UNKNOWN
06B612  A1 45 12              MOV    ax, word ptr [0x1245]        ; UNKNOWN
06B615  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
06B618  EB 03                 JMP    0x6b61d                      ; UNKNOWN
06B61A  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
06B61D  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
06B621  74 12                 JE     0x6b635                      ; UNKNOWN
06B623  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
06B626  80 BF 46 12 00        CMP    byte ptr [bx + 0x1246], 0    ; UNKNOWN
06B62B  75 08                 JNE    0x6b635                      ; UNKNOWN
06B62D  EB EB                 JMP    0x6b61a                      ; UNKNOWN
06B62F  90                    NOP                                 ; UNKNOWN
06B630  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
06B635  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
06B639  74 0A                 JE     0x6b645                      ; UNKNOWN
06B63B  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
06B63E  05 07 00              ADD    ax, 7                        ; UNKNOWN
06B641  D1 E0                 SHL    ax, 1                        ; UNKNOWN
06B643  03 F0                 ADD    si, ax                       ; UNKNOWN
06B645  83 7E 10 00           CMP    word ptr [bp + 0x10], 0      ; UNKNOWN
06B649  74 10                 JE     0x6b65b                      ; UNKNOWN
06B64B  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
06B64E  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06B653  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B656  05 03 00              ADD    ax, 3                        ; UNKNOWN
06B659  03 F0                 ADD    si, ax                       ; UNKNOWN
06B65B  46                    INC    si                           ; UNKNOWN
06B65C  89 76 F8              MOV    word ptr [bp - 8], si        ; UNKNOWN
06B65F  81 FE FF 7F           CMP    si, 0x7fff                   ; UNKNOWN
06B663  76 13                 JBE    0x6b678                      ; UNKNOWN
06B665  C7 06 38 12 07 00     MOV    word ptr [0x1238], 7         ; UNKNOWN
06B66B  C7 06 43 12 0A 00     MOV    word ptr [0x1243], 0xa       ; UNKNOWN
06B671  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06B674  E9 C4 01              JMP    0x6b83b                      ; UNKNOWN
06B677  90                    NOP                                 ; UNKNOWN
06B678  8B 36 42 15           MOV    si, word ptr [0x1542]        ; UNKNOWN
06B67C  C7 06 42 15 10 00     MOV    word ptr [0x1542], 0x10      ; UNKNOWN
06B682  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
06B685  05 0F 00              ADD    ax, 0xf                      ; UNKNOWN
06B688  50                    PUSH   ax                           ; UNKNOWN
06B689  9A 82 23 65 5F        LCALL  0x5f65, 0x2382               ; UNKNOWN
06B68E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B691  8B F8                 MOV    di, ax                       ; UNKNOWN
06B693  0B FF                 OR     di, di                       ; UNKNOWN
06B695  75 13                 JNE    0x6b6aa                      ; UNKNOWN
06B697  C7 06 38 12 0C 00     MOV    word ptr [0x1238], 0xc       ; UNKNOWN
06B69D  C7 06 43 12 08 00     MOV    word ptr [0x1243], 8         ; UNKNOWN
06B6A3  89 36 42 15           MOV    word ptr [0x1542], si        ; UNKNOWN
06B6A7  EB C8                 JMP    0x6b671                      ; UNKNOWN
06B6A9  90                    NOP                                 ; UNKNOWN
06B6AA  89 36 42 15           MOV    word ptr [0x1542], si        ; UNKNOWN
06B6AE  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
06B6B1  89 3F                 MOV    word ptr [bx], di            ; UNKNOWN
06B6B3  05 0F 00              ADD    ax, 0xf                      ; UNKNOWN
06B6B6  24 F0                 AND    al, 0xf0                     ; UNKNOWN
06B6B8  8B F8                 MOV    di, ax                       ; UNKNOWN
06B6BA  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
06B6BD  89 3F                 MOV    word ptr [bx], di            ; UNKNOWN
06B6BF  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
06B6C3  74 2F                 JE     0x6b6f4                      ; UNKNOWN
06B6C5  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
06B6C8  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
06B6CB  EB 1F                 JMP    0x6b6ec                      ; UNKNOWN
06B6CD  90                    NOP                                 ; UNKNOWN
06B6CE  2B C0                 SUB    ax, ax                       ; UNKNOWN
06B6D0  50                    PUSH   ax                           ; UNKNOWN
06B6D1  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
06B6D3  57                    PUSH   di                           ; UNKNOWN
06B6D4  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
06B6D9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B6DC  50                    PUSH   ax                           ; UNKNOWN
06B6DD  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
06B6E2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B6E5  40                    INC    ax                           ; UNKNOWN
06B6E6  8B F8                 MOV    di, ax                       ; UNKNOWN
06B6E8  83 46 FA 02           ADD    word ptr [bp - 6], 2         ; UNKNOWN
06B6EC  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
06B6EF  83 3F 00              CMP    word ptr [bx], 0             ; UNKNOWN
06B6F2  75 DA                 JNE    0x6b6ce                      ; UNKNOWN
06B6F4  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
06B6F8  74 49                 JE     0x6b743                      ; UNKNOWN
06B6FA  2B C0                 SUB    ax, ax                       ; UNKNOWN
06B6FC  50                    PUSH   ax                           ; UNKNOWN
06B6FD  B8 1C 12              MOV    ax, 0x121c                   ; UNKNOWN
06B700  50                    PUSH   ax                           ; UNKNOWN
06B701  57                    PUSH   di                           ; UNKNOWN
06B702  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
06B707  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B70A  50                    PUSH   ax                           ; UNKNOWN
06B70B  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
06B710  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06B713  8B F8                 MOV    di, ax                       ; UNKNOWN
06B715  2B F6                 SUB    si, si                       ; UNKNOWN
06B717  EB 1C                 JMP    0x6b735                      ; UNKNOWN
06B719  90                    NOP                                 ; UNKNOWN
06B71A  8A 84 47 12           MOV    al, byte ptr [si + 0x1247]   ; UNKNOWN
06B71E  B1 04                 MOV    cl, 4                        ; UNKNOWN
06B720  8B D0                 MOV    dx, ax                       ; UNKNOWN
06B722  D2 F8                 SAR    al, cl                       ; UNKNOWN
06B724  24 0F                 AND    al, 0xf                      ; UNKNOWN
06B726  04 41                 ADD    al, 0x41                     ; UNKNOWN
06B728  88 05                 MOV    byte ptr [di], al            ; UNKNOWN
06B72A  47                    INC    di                           ; UNKNOWN
06B72B  80 E2 0F              AND    dl, 0xf                      ; UNKNOWN
06B72E  80 C2 41              ADD    dl, 0x41                     ; UNKNOWN
06B731  88                    DB     0x88                         ; UNKNOWN (raw)
