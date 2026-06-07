; ============================================================================
; func_05C518_unknown
; Region   : load_image
; Bytes    : file 0x05C518..0x05C62F  (279 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05C518  55                    PUSH   bp                           ; UNKNOWN
05C519  8B EC                 MOV    bp, sp                       ; UNKNOWN
05C51B  56                    PUSH   si                           ; UNKNOWN
05C51C  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
05C521  74 03                 JE     0x5c526                      ; UNKNOWN
05C523  E9 7A 01              JMP    0x5c6a0                      ; UNKNOWN
05C526  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
05C529  03 06 06 3E           ADD    ax, word ptr [0x3e06]        ; UNKNOWN
05C52D  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
05C530  B9 03 00              MOV    cx, 3                        ; UNKNOWN
05C533  99                    CDQ                                 ; UNKNOWN
05C534  F7 F9                 IDIV   cx                           ; UNKNOWN
05C536  0B D2                 OR     dx, dx                       ; UNKNOWN
05C538  74 15                 JE     0x5c54f                      ; UNKNOWN
05C53A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C53D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C540  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
05C545  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C548  A8 20                 TEST   al, 0x20                     ; UNKNOWN
05C54A  74 03                 JE     0x5c54f                      ; UNKNOWN
05C54C  E9 51 01              JMP    0x5c6a0                      ; UNKNOWN
05C54F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C552  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C555  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
05C55A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C55D  A8 02                 TEST   al, 2                        ; UNKNOWN
05C55F  74 03                 JE     0x5c564                      ; UNKNOWN
05C561  E9 3C 01              JMP    0x5c6a0                      ; UNKNOWN
05C564  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C567  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C56A  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
05C56F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C572  A8 02                 TEST   al, 2                        ; UNKNOWN
05C574  74 03                 JE     0x5c579                      ; UNKNOWN
05C576  E9 27 01              JMP    0x5c6a0                      ; UNKNOWN
05C579  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C57C  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
05C581  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05C584  50                    PUSH   ax                           ; UNKNOWN
05C585  6A 00                 PUSH   0                            ; UNKNOWN
05C587  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
05C58C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C58F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C592  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
05C597  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05C59A  50                    PUSH   ax                           ; UNKNOWN
05C59B  6A 01                 PUSH   1                            ; UNKNOWN
05C59D  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
05C5A2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C5A5  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C5A8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C5AB  0E                    PUSH   cs                           ; UNKNOWN
05C5AC  E8 A9 FC              CALL   0x5c258                      ; UNKNOWN
05C5AF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C5B2  0B C0                 OR     ax, ax                       ; UNKNOWN
05C5B4  75 79                 JNE    0x5c62f                      ; UNKNOWN
05C5B6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C5B9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C5BC  0E                    PUSH   cs                           ; UNKNOWN
05C5BD  E8 98 FC              CALL   0x5c258                      ; UNKNOWN
05C5C0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C5C3  0B C0                 OR     ax, ax                       ; UNKNOWN
05C5C5  75 68                 JNE    0x5c62f                      ; UNKNOWN
05C5C7  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C5CA  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C5CD  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
05C5D2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C5D5  A8 40                 TEST   al, 0x40                     ; UNKNOWN
05C5D7  74 03                 JE     0x5c5dc                      ; UNKNOWN
05C5D9  E9 C4 00              JMP    0x5c6a0                      ; UNKNOWN
05C5DC  6A 02                 PUSH   2                            ; UNKNOWN
05C5DE  68 F7 2D              PUSH   0x2df7                       ; UNKNOWN
05C5E1  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
05C5E6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C5E9  6A 40                 PUSH   0x40                         ; UNKNOWN
05C5EB  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C5EE  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C5F1  9A 65 00 49 22        LCALL  0x2249, 0x65                 ; UNKNOWN
05C5F6  83 C4 06              ADD    sp, 6                        ; UNKNOWN
05C5F9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C5FC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C5FF  0E                    PUSH   cs                           ; UNKNOWN
05C600  E8 37 FE              CALL   0x5c43a                      ; UNKNOWN
05C603  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C606  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C609  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05C60C  0E                    PUSH   cs                           ; UNKNOWN
05C60D  E8 2A FE              CALL   0x5c43a                      ; UNKNOWN
05C610  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C613  B0 01                 MOV    al, 1                        ; UNKNOWN
05C615  69 76 06 3C 01        IMUL   si, word ptr [bp + 6], 0x13c ; UNKNOWN
05C61A  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
05C61D  88 80 EA 74           MOV    byte ptr [bx + si + 0x74ea], al ; UNKNOWN
05C621  69 F3 3C 01           IMUL   si, bx, 0x13c                ; UNKNOWN
05C625  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
05C628  88 80 EA 74           MOV    byte ptr [bx + si + 0x74ea], al ; UNKNOWN
05C62C  5E                    POP    si                           ; UNKNOWN
05C62D  C9                    LEAVE                               ; UNKNOWN
05C62E  CB                    RETF                                ; UNKNOWN
