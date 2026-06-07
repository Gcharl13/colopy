; ============================================================================
; func_035CB4_unknown
; Region   : load_image
; Bytes    : file 0x035CB4..0x035DB5  (257 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035CB4  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
035CB8  56                    PUSH   si                           ; UNKNOWN
035CB9  C7 46 EE FF FF        MOV    word ptr [bp - 0x12], 0xffff ; UNKNOWN
035CBE  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
035CC3  EB 4E                 JMP    0x35d13                      ; UNKNOWN
035CC5  A1 EF 0A              MOV    ax, word ptr [0xaef]         ; UNKNOWN
035CC8  39 46 F4              CMP    word ptr [bp - 0xc], ax      ; UNKNOWN
035CCB  7D 4C                 JGE    0x35d19                      ; UNKNOWN
035CCD  8D 46 F0              LEA    ax, [bp - 0x10]              ; UNKNOWN
035CD0  50                    PUSH   ax                           ; UNKNOWN
035CD1  8D 4E F2              LEA    cx, [bp - 0xe]               ; UNKNOWN
035CD4  51                    PUSH   cx                           ; UNKNOWN
035CD5  8D 56 F6              LEA    dx, [bp - 0xa]               ; UNKNOWN
035CD8  52                    PUSH   dx                           ; UNKNOWN
035CD9  8D 5E FA              LEA    bx, [bp - 6]                 ; UNKNOWN
035CDC  53                    PUSH   bx                           ; UNKNOWN
035CDD  8D 76 F8              LEA    si, [bp - 8]                 ; UNKNOWN
035CE0  56                    PUSH   si                           ; UNKNOWN
035CE1  6A 02                 PUSH   2                            ; UNKNOWN
035CE3  6A 05                 PUSH   5                            ; UNKNOWN
035CE5  68 92 00              PUSH   0x92                         ; UNKNOWN
035CE8  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
035CEB  0E                    PUSH   cs                           ; UNKNOWN
035CEC  E8 71 DE              CALL   0x33b60                      ; UNKNOWN
035CEF  83 C4 12              ADD    sp, 0x12                     ; UNKNOWN
035CF2  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
035CF5  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
035CF8  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
035CFB  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
035CFE  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
035D03  83 C4 08              ADD    sp, 8                        ; UNKNOWN
035D06  0B C0                 OR     ax, ax                       ; UNKNOWN
035D08  74 06                 JE     0x35d10                      ; UNKNOWN
035D0A  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
035D0D  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
035D10  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
035D13  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
035D17  7C AC                 JL     0x35cc5                      ; UNKNOWN
035D19  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
035D1D  7D 03                 JGE    0x35d22                      ; UNKNOWN
035D1F  E9 59 01              JMP    0x35e7b                      ; UNKNOWN
035D22  83 3E BA 79 0A        CMP    word ptr [0x79ba], 0xa       ; UNKNOWN
035D27  74 03                 JE     0x35d2c                      ; UNKNOWN
035D29  E9 89 00              JMP    0x35db5                      ; UNKNOWN
035D2C  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
035D31  75 03                 JNE    0x35d36                      ; UNKNOWN
035D33  E9 45 01              JMP    0x35e7b                      ; UNKNOWN
035D36  83 3E A2 79 00        CMP    word ptr [0x79a2], 0         ; UNKNOWN
035D3B  75 31                 JNE    0x35d6e                      ; UNKNOWN
035D3D  FF 36 9C 79           PUSH   word ptr [0x799c]            ; UNKNOWN
035D41  0E                    PUSH   cs                           ; UNKNOWN
035D42  E8 3E D7              CALL   0x33483                      ; UNKNOWN
035D45  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035D48  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
035D4B  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
035D4E  0E                    PUSH   cs                           ; UNKNOWN
035D4F  E8 31 D7              CALL   0x33483                      ; UNKNOWN
035D52  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035D55  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
035D58  9A 0E 00 EF 21        LCALL  0x21ef, 0xe                  ; UNKNOWN
035D5D  50                    PUSH   ax                           ; UNKNOWN
035D5E  FF 36 9E 79           PUSH   word ptr [0x799e]            ; UNKNOWN
035D62  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
035D65  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
035D68  0E                    PUSH   cs                           ; UNKNOWN
035D69  E8 D3 F8              CALL   0x3563f                      ; UNKNOWN
035D6C  EB 41                 JMP    0x35daf                      ; UNKNOWN
035D6E  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
035D71  0E                    PUSH   cs                           ; UNKNOWN
035D72  E8 0E D7              CALL   0x33483                      ; UNKNOWN
035D75  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035D78  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
035D7B  FF 36 A4 79           PUSH   word ptr [0x79a4]            ; UNKNOWN
035D7F  0E                    PUSH   cs                           ; UNKNOWN
035D80  E8 84 D6              CALL   0x33407                      ; UNKNOWN
035D83  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035D86  0B C0                 OR     ax, ax                       ; UNKNOWN
035D88  74 12                 JE     0x35d9c                      ; UNKNOWN
035D8A  FF 36 A4 79           PUSH   word ptr [0x79a4]            ; UNKNOWN
035D8E  0E                    PUSH   cs                           ; UNKNOWN
035D8F  E8 47 FE              CALL   0x35bd9                      ; UNKNOWN
035D92  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035D95  0B C0                 OR     ax, ax                       ; UNKNOWN
035D97  75 03                 JNE    0x35d9c                      ; UNKNOWN
035D99  E9 DF 00              JMP    0x35e7b                      ; UNKNOWN
035D9C  9A 0E 00 EF 21        LCALL  0x21ef, 0xe                  ; UNKNOWN
035DA1  50                    PUSH   ax                           ; UNKNOWN
035DA2  6A 01                 PUSH   1                            ; UNKNOWN
035DA4  FF 36 A4 79           PUSH   word ptr [0x79a4]            ; UNKNOWN
035DA8  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
035DAB  0E                    PUSH   cs                           ; UNKNOWN
035DAC  E8 DB EF              CALL   0x34d8a                      ; UNKNOWN
035DAF  83 C4 08              ADD    sp, 8                        ; UNKNOWN
035DB2  5E                    POP    si                           ; UNKNOWN
035DB3  C9                    LEAVE                               ; UNKNOWN
035DB4  CB                    RETF                                ; UNKNOWN
