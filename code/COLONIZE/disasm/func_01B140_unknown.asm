; ============================================================================
; func_01B140_unknown
; Region   : load_image
; Bytes    : file 0x01B140..0x01B1F0  (176 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01B140  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
01B144  56                    PUSH   si                           ; UNKNOWN
01B145  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
01B149  8D 06 DB 16           LEA    ax, [0x16db]                 ; UNKNOWN
01B14D  2B D2                 SUB    dx, dx                       ; UNKNOWN
01B14F  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
01B154  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01B157  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
01B15A  0B D0                 OR     dx, ax                       ; UNKNOWN
01B15C  74 78                 JE     0x1b1d6                      ; UNKNOWN
01B15E  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
01B163  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
01B166  40                    INC    ax                           ; UNKNOWN
01B167  50                    PUSH   ax                           ; UNKNOWN
01B168  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
01B16B  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01B16D  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01B171  8B F0                 MOV    si, ax                       ; UNKNOWN
01B173  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
01B178  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B17B  52                    PUSH   dx                           ; UNKNOWN
01B17C  50                    PUSH   ax                           ; UNKNOWN
01B17D  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
01B180  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
01B183  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
01B188  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
01B18B  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
01B18E  9A FF 02 5F 24        LCALL  0x245f, 0x2ff                ; UNKNOWN
01B193  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B196  8B D0                 MOV    dx, ax                       ; UNKNOWN
01B198  8B C6                 MOV    ax, si                       ; UNKNOWN
01B19A  9A A8 36 97 1B        LCALL  0x1b97, 0x36a8               ; UNKNOWN
01B19F  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
01B1A2  83 7E FA 10           CMP    word ptr [bp - 6], 0x10      ; UNKNOWN
01B1A6  7C BB                 JL     0x1b163                      ; UNKNOWN
01B1A8  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
01B1AB  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
01B1AE  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
01B1B3  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
01B1B8  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
01B1BB  40                    INC    ax                           ; UNKNOWN
01B1BC  9A D1 36 97 1B        LCALL  0x1b97, 0x36d1               ; UNKNOWN
01B1C1  50                    PUSH   ax                           ; UNKNOWN
01B1C2  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
01B1C5  9A 22 03 5F 24        LCALL  0x245f, 0x322                ; UNKNOWN
01B1CA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01B1CD  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
01B1D0  83 7E FA 10           CMP    word ptr [bp - 6], 0x10      ; UNKNOWN
01B1D4  7C E2                 JL     0x1b1b8                      ; UNKNOWN
01B1D6  0E                    PUSH   cs                           ; UNKNOWN
01B1D7  E8 91 E9              CALL   0x19b6b                      ; UNKNOWN
01B1DA  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
01B1DD  0B 46 FC              OR     ax, word ptr [bp - 4]        ; UNKNOWN
01B1E0  74 0B                 JE     0x1b1ed                      ; UNKNOWN
01B1E2  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
01B1E5  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
01B1E8  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
01B1ED  5E                    POP    si                           ; UNKNOWN
01B1EE  C9                    LEAVE                               ; UNKNOWN
01B1EF  CB                    RETF                                ; UNKNOWN
