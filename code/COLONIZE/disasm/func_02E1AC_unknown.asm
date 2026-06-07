; ============================================================================
; func_02E1AC_unknown
; Region   : load_image
; Bytes    : file 0x02E1AC..0x02E224  (120 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E1AC  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02E1B0  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02E1B3  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E1B5  8B 87 88 73           MOV    ax, word ptr [bx + 0x7388]   ; UNKNOWN
02E1B9  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02E1BC  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E1BF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02E1C2  0E                    PUSH   cs                           ; UNKNOWN
02E1C3  E8 01 FF              CALL   0x2e0c7                      ; UNKNOWN
02E1C6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E1C9  50                    PUSH   ax                           ; UNKNOWN
02E1CA  0E                    PUSH   cs                           ; UNKNOWN
02E1CB  E8 BA F7              CALL   0x2d988                      ; UNKNOWN
02E1CE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E1D1  83 F8 02              CMP    ax, 2                        ; UNKNOWN
02E1D4  7E 0E                 JLE    0x2e1e4                      ; UNKNOWN
02E1D6  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02E1D9  D1 E0                 SHL    ax, 1                        ; UNKNOWN
02E1DB  B9 03 00              MOV    cx, 3                        ; UNKNOWN
02E1DE  99                    CDQ                                 ; UNKNOWN
02E1DF  F7 F9                 IDIV   cx                           ; UNKNOWN
02E1E1  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E1E4  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02E1E7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E1EA  0E                    PUSH   cs                           ; UNKNOWN
02E1EB  E8 81 FF              CALL   0x2e16f                      ; UNKNOWN
02E1EE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02E1F1  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02E1F4  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E1F6  83 BF 19 74 00        CMP    word ptr [bx + 0x7419], 0    ; UNKNOWN
02E1FB  74 2B                 JE     0x2e228                      ; UNKNOWN
02E1FD  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02E200  39 46 FA              CMP    word ptr [bp - 6], ax        ; UNKNOWN
02E203  74 23                 JE     0x2e228                      ; UNKNOWN
02E205  39 87 19 74           CMP    word ptr [bx + 0x7419], ax   ; UNKNOWN
02E209  75 05                 JNE    0x2e210                      ; UNKNOWN
02E20B  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02E20E  EB 14                 JMP    0x2e224                      ; UNKNOWN
02E210  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02E213  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E215  8B 87 19 74           MOV    ax, word ptr [bx + 0x7419]   ; UNKNOWN
02E219  8B C8                 MOV    cx, ax                       ; UNKNOWN
02E21B  D1 E0                 SHL    ax, 1                        ; UNKNOWN
02E21D  03 C1                 ADD    ax, cx                       ; UNKNOWN
02E21F  99                    CDQ                                 ; UNKNOWN
02E220  2B C2                 SUB    ax, dx                       ; UNKNOWN
02E222  D1 F8                 SAR    ax, 1                        ; UNKNOWN
