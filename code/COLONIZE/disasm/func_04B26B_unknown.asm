; ============================================================================
; func_04B26B_unknown
; Region   : load_image
; Bytes    : file 0x04B26B..0x04B3AE  (323 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04B26B  C8 6E 00 00           ENTER  0x6e, 0                      ; UNKNOWN
04B26F  57                    PUSH   di                           ; UNKNOWN
04B270  56                    PUSH   si                           ; UNKNOWN
04B271  6A 01                 PUSH   1                            ; UNKNOWN
04B273  0E                    PUSH   cs                           ; UNKNOWN
04B274  E8 EB FE              CALL   0x4b162                      ; UNKNOWN
04B277  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B27A  68 90 00              PUSH   0x90                         ; UNKNOWN
04B27D  6A 05                 PUSH   5                            ; UNKNOWN
04B27F  68 40 01              PUSH   0x140                        ; UNKNOWN
04B282  6A 00                 PUSH   0                            ; UNKNOWN
04B284  FF 36 34 33           PUSH   word ptr [0x3334]            ; UNKNOWN
04B288  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04B28D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B290  52                    PUSH   dx                           ; UNKNOWN
04B291  50                    PUSH   ax                           ; UNKNOWN
04B292  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04B297  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04B29A  C7 46 A6 0A 00        MOV    word ptr [bp - 0x5a], 0xa    ; UNKNOWN
04B29F  C7 46 A4 19 00        MOV    word ptr [bp - 0x5c], 0x19   ; UNKNOWN
04B2A4  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0      ; UNKNOWN
04B2A9  E9 9E 03              JMP    0x4b64a                      ; UNKNOWN
04B2AC  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
04B2AF  8A 87 7A 09           MOV    al, byte ptr [bx + 0x97a]    ; UNKNOWN
04B2B3  88 46 92              MOV    byte ptr [bp - 0x6e], al     ; UNKNOWN
04B2B6  83 FB 0A              CMP    bx, 0xa                      ; UNKNOWN
04B2B9  75 04                 JNE    0x4b2bf                      ; UNKNOWN
04B2BB  C6 46 92 0C           MOV    byte ptr [bp - 0x6e], 0xc    ; UNKNOWN
04B2BF  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
04B2C3  53                    PUSH   bx                           ; UNKNOWN
04B2C4  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
04B2C9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B2CC  50                    PUSH   ax                           ; UNKNOWN
04B2CD  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04B2D0  50                    PUSH   ax                           ; UNKNOWN
04B2D1  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04B2D6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04B2D9  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04B2DC  50                    PUSH   ax                           ; UNKNOWN
04B2DD  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
04B2E2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B2E5  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
04B2E9  F6 47 03 80           TEST   byte ptr [bx + 3], 0x80      ; UNKNOWN
04B2ED  74 48                 JE     0x4b337                      ; UNKNOWN
04B2EF  FF 36 FE 33           PUSH   word ptr [0x33fe]            ; UNKNOWN
04B2F3  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04B2F6  50                    PUSH   ax                           ; UNKNOWN
04B2F7  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04B2FC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04B2FF  6A 00                 PUSH   0                            ; UNKNOWN
04B301  8B 46 94              MOV    ax, word ptr [bp - 0x6c]     ; UNKNOWN
04B304  40                    INC    ax                           ; UNKNOWN
04B305  50                    PUSH   ax                           ; UNKNOWN
04B306  FF 76 98              PUSH   word ptr [bp - 0x68]         ; UNKNOWN
04B309  8D 4E AE              LEA    cx, [bp - 0x52]              ; UNKNOWN
04B30C  16                    PUSH   ss                           ; UNKNOWN
04B30D  51                    PUSH   cx                           ; UNKNOWN
04B30E  8B F0                 MOV    si, ax                       ; UNKNOWN
04B310  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04B315  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04B318  6A 00                 PUSH   0                            ; UNKNOWN
04B31A  FF 76 94              PUSH   word ptr [bp - 0x6c]         ; UNKNOWN
04B31D  8B 46 98              MOV    ax, word ptr [bp - 0x68]     ; UNKNOWN
04B320  40                    INC    ax                           ; UNKNOWN
04B321  50                    PUSH   ax                           ; UNKNOWN
04B322  8D 4E AE              LEA    cx, [bp - 0x52]              ; UNKNOWN
04B325  16                    PUSH   ss                           ; UNKNOWN
04B326  51                    PUSH   cx                           ; UNKNOWN
04B327  8B F8                 MOV    di, ax                       ; UNKNOWN
04B329  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04B32E  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04B331  6A 00                 PUSH   0                            ; UNKNOWN
04B333  56                    PUSH   si                           ; UNKNOWN
04B334  57                    PUSH   di                           ; UNKNOWN
04B335  EB 36                 JMP    0x4b36d                      ; UNKNOWN
04B337  6A 00                 PUSH   0                            ; UNKNOWN
04B339  FF 76 94              PUSH   word ptr [bp - 0x6c]         ; UNKNOWN
04B33C  8B 46 98              MOV    ax, word ptr [bp - 0x68]     ; UNKNOWN
04B33F  40                    INC    ax                           ; UNKNOWN
04B340  50                    PUSH   ax                           ; UNKNOWN
04B341  8D 4E AE              LEA    cx, [bp - 0x52]              ; UNKNOWN
04B344  16                    PUSH   ss                           ; UNKNOWN
04B345  51                    PUSH   cx                           ; UNKNOWN
04B346  8B F0                 MOV    si, ax                       ; UNKNOWN
04B348  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04B34D  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04B350  6A 00                 PUSH   0                            ; UNKNOWN
04B352  8B 46 94              MOV    ax, word ptr [bp - 0x6c]     ; UNKNOWN
04B355  40                    INC    ax                           ; UNKNOWN
04B356  50                    PUSH   ax                           ; UNKNOWN
04B357  FF 76 98              PUSH   word ptr [bp - 0x68]         ; UNKNOWN
04B35A  8D 4E AE              LEA    cx, [bp - 0x52]              ; UNKNOWN
04B35D  16                    PUSH   ss                           ; UNKNOWN
04B35E  51                    PUSH   cx                           ; UNKNOWN
04B35F  8B F8                 MOV    di, ax                       ; UNKNOWN
04B361  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04B366  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04B369  6A 00                 PUSH   0                            ; UNKNOWN
04B36B  57                    PUSH   di                           ; UNKNOWN
04B36C  56                    PUSH   si                           ; UNKNOWN
04B36D  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04B370  16                    PUSH   ss                           ; UNKNOWN
04B371  50                    PUSH   ax                           ; UNKNOWN
04B372  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04B377  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04B37A  8A 46 92              MOV    al, byte ptr [bp - 0x6e]     ; UNKNOWN
04B37D  2A E4                 SUB    ah, ah                       ; UNKNOWN
04B37F  50                    PUSH   ax                           ; UNKNOWN
04B380  FF 76 94              PUSH   word ptr [bp - 0x6c]         ; UNKNOWN
04B383  FF 76 98              PUSH   word ptr [bp - 0x68]         ; UNKNOWN
04B386  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04B389  16                    PUSH   ss                           ; UNKNOWN
04B38A  50                    PUSH   ax                           ; UNKNOWN
04B38B  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04B390  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04B393  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
04B396  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
04B39A  F6 47 03 80           TEST   byte ptr [bx + 3], 0x80      ; UNKNOWN
04B39E  74 03                 JE     0x4b3a3                      ; UNKNOWN
04B3A0  E9 A0 02              JMP    0x4b643                      ; UNKNOWN
04B3A3  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
04B3A7  8A 5F 02              MOV    bl, byte ptr [bx + 2]        ; UNKNOWN
04B3AA  2A FF                 SUB    bh, bh                       ; UNKNOWN
04B3AC  8B C3                 MOV    ax, bx                       ; UNKNOWN
