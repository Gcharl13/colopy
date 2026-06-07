; ============================================================================
; func_040543_unknown
; Region   : load_image
; Bytes    : file 0x040543..0x04060C  (201 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040543  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
040547  57                    PUSH   di                           ; UNKNOWN
040548  56                    PUSH   si                           ; UNKNOWN
040549  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
04054C  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
04054F  57                    PUSH   di                           ; UNKNOWN
040550  56                    PUSH   si                           ; UNKNOWN
040551  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
040556  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040559  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04055C  57                    PUSH   di                           ; UNKNOWN
04055D  56                    PUSH   si                           ; UNKNOWN
04055E  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
040563  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040566  0B C0                 OR     ax, ax                       ; UNKNOWN
040568  7C 05                 JL     0x4056f                      ; UNKNOWN
04056A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
04056D  EB 02                 JMP    0x40571                      ; UNKNOWN
04056F  2B C0                 SUB    ax, ax                       ; UNKNOWN
040571  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
040574  C7 06 82 C0 FF FF     MOV    word ptr [0xc082], 0xffff    ; UNKNOWN
04057A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
04057F  83 7E FC 08           CMP    word ptr [bp - 4], 8         ; UNKNOWN
040583  7D 79                 JGE    0x405fe                      ; UNKNOWN
040585  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
040588  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
04058C  98                    CWDE                                ; UNKNOWN
04058D  8B F0                 MOV    si, ax                       ; UNKNOWN
04058F  03 76 06              ADD    si, word ptr [bp + 6]        ; UNKNOWN
040592  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
040596  98                    CWDE                                ; UNKNOWN
040597  8B F8                 MOV    di, ax                       ; UNKNOWN
040599  03 7E 08              ADD    di, word ptr [bp + 8]        ; UNKNOWN
04059C  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
0405A0  74 05                 JE     0x405a7                      ; UNKNOWN
0405A2  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
0405A5  EB 0A                 JMP    0x405b1                      ; UNKNOWN
0405A7  57                    PUSH   di                           ; UNKNOWN
0405A8  56                    PUSH   si                           ; UNKNOWN
0405A9  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
0405AE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0405B1  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0405B4  57                    PUSH   di                           ; UNKNOWN
0405B5  56                    PUSH   si                           ; UNKNOWN
0405B6  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
0405BB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0405BE  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0405C1  0B C0                 OR     ax, ax                       ; UNKNOWN
0405C3  7D 0F                 JGE    0x405d4                      ; UNKNOWN
0405C5  57                    PUSH   di                           ; UNKNOWN
0405C6  56                    PUSH   si                           ; UNKNOWN
0405C7  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
0405CC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0405CF  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0405D2  EB 06                 JMP    0x405da                      ; UNKNOWN
0405D4  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0405D7  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0405DA  8B 56 F6              MOV    dx, word ptr [bp - 0xa]      ; UNKNOWN
0405DD  0B D2                 OR     dx, dx                       ; UNKNOWN
0405DF  7C 11                 JL     0x405f2                      ; UNKNOWN
0405E1  39 56 0A              CMP    word ptr [bp + 0xa], dx      ; UNKNOWN
0405E4  74 0C                 JE     0x405f2                      ; UNKNOWN
0405E6  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
0405E9  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
0405EC  75 04                 JNE    0x405f2                      ; UNKNOWN
0405EE  89 16 82 C0           MOV    word ptr [0xc082], dx        ; UNKNOWN
0405F2  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
0405F5  83 3E 82 C0 00        CMP    word ptr [0xc082], 0         ; UNKNOWN
0405FA  7D 02                 JGE    0x405fe                      ; UNKNOWN
0405FC  EB 81                 JMP    0x4057f                      ; UNKNOWN
0405FE  83 3E 82 C0 00        CMP    word ptr [0xc082], 0         ; UNKNOWN
040603  7C 07                 JL     0x4060c                      ; UNKNOWN
040605  B8 01 00              MOV    ax, 1                        ; UNKNOWN
040608  5E                    POP    si                           ; UNKNOWN
040609  5F                    POP    di                           ; UNKNOWN
04060A  C9                    LEAVE                               ; UNKNOWN
04060B  CB                    RETF                                ; UNKNOWN
