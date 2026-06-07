; ============================================================================
; func_05B301_unknown
; Region   : load_image
; Bytes    : file 0x05B301..0x05B3AC  (171 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05B301  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
05B305  56                    PUSH   si                           ; UNKNOWN
05B306  6A 40                 PUSH   0x40                         ; UNKNOWN
05B308  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05B30B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05B30E  9A 65 00 49 22        LCALL  0x2249, 0x65                 ; UNKNOWN
05B313  83 C4 06              ADD    sp, 6                        ; UNKNOWN
05B316  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
05B319  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
05B31D  7C 03                 JL     0x5b322                      ; UNKNOWN
05B31F  E9 84 00              JMP    0x5b3a6                      ; UNKNOWN
05B322  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
05B326  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
05B32B  75 79                 JNE    0x5b3a6                      ; UNKNOWN
05B32D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05B330  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
05B335  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05B338  50                    PUSH   ax                           ; UNKNOWN
05B339  6A 00                 PUSH   0                            ; UNKNOWN
05B33B  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
05B340  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B343  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05B346  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
05B34B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05B34E  50                    PUSH   ax                           ; UNKNOWN
05B34F  6A 01                 PUSH   1                            ; UNKNOWN
05B351  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
05B356  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B359  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
05B35C  83 E8 04              SUB    ax, 4                        ; UNKNOWN
05B35F  50                    PUSH   ax                           ; UNKNOWN
05B360  68 56 2D              PUSH   0x2d56                       ; UNKNOWN
05B363  8B F0                 MOV    si, ax                       ; UNKNOWN
05B365  9A 00 37 97 1B        LCALL  0x1b97, 0x3700               ; UNKNOWN
05B36A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B36D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05B370  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
05B373  83 E8 04              SUB    ax, 4                        ; UNKNOWN
05B376  50                    PUSH   ax                           ; UNKNOWN
05B377  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
05B37C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B37F  83 F8 19              CMP    ax, 0x19                     ; UNKNOWN
05B382  7D 22                 JGE    0x5b3a6                      ; UNKNOWN
05B384  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05B387  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
05B38C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05B38F  50                    PUSH   ax                           ; UNKNOWN
05B390  6A 00                 PUSH   0                            ; UNKNOWN
05B392  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
05B397  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B39A  56                    PUSH   si                           ; UNKNOWN
05B39B  68 62 2D              PUSH   0x2d62                       ; UNKNOWN
05B39E  9A 00 37 97 1B        LCALL  0x1b97, 0x3700               ; UNKNOWN
05B3A3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05B3A6  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
05B3A9  5E                    POP    si                           ; UNKNOWN
05B3AA  C9                    LEAVE                               ; UNKNOWN
05B3AB  CB                    RETF                                ; UNKNOWN
