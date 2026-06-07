; ============================================================================
; func_06A058_unknown
; Region   : load_image
; Bytes    : file 0x06A058..0x06A140  (232 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A058  55                    PUSH   bp                           ; UNKNOWN
06A059  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A05B  83 EC 08              SUB    sp, 8                        ; UNKNOWN
06A05E  57                    PUSH   di                           ; UNKNOWN
06A05F  56                    PUSH   si                           ; UNKNOWN
06A060  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
06A063  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
06A065  98                    CWDE                                ; UNKNOWN
06A066  3D 77 00              CMP    ax, 0x77                     ; UNKNOWN
06A069  74 45                 JE     0x6a0b0                      ; UNKNOWN
06A06B  77 08                 JA     0x6a075                      ; UNKNOWN
06A06D  2C 61                 SUB    al, 0x61                     ; UNKNOWN
06A06F  74 49                 JE     0x6a0ba                      ; UNKNOWN
06A071  2C 11                 SUB    al, 0x11                     ; UNKNOWN
06A073  74 05                 JE     0x6a07a                      ; UNKNOWN
06A075  2B C0                 SUB    ax, ax                       ; UNKNOWN
06A077  E9 C0 00              JMP    0x6a13a                      ; UNKNOWN
06A07A  2B F6                 SUB    si, si                       ; UNKNOWN
06A07C  C6 46 FC 01           MOV    byte ptr [bp - 4], 1         ; UNKNOWN
06A080  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
06A085  FF 46 08              INC    word ptr [bp + 8]            ; UNKNOWN
06A088  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
06A08B  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
06A08E  74 5A                 JE     0x6a0ea                      ; UNKNOWN
06A090  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
06A094  74 54                 JE     0x6a0ea                      ; UNKNOWN
06A096  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
06A098  98                    CWDE                                ; UNKNOWN
06A099  3D 74 00              CMP    ax, 0x74                     ; UNKNOWN
06A09C  74 34                 JE     0x6a0d2                      ; UNKNOWN
06A09E  77 08                 JA     0x6a0a8                      ; UNKNOWN
06A0A0  2C 2B                 SUB    al, 0x2b                     ; UNKNOWN
06A0A2  74 1C                 JE     0x6a0c0                      ; UNKNOWN
06A0A4  2C 37                 SUB    al, 0x37                     ; UNKNOWN
06A0A6  74 36                 JE     0x6a0de                      ; UNKNOWN
06A0A8  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
06A0AD  EB D6                 JMP    0x6a085                      ; UNKNOWN
06A0AF  90                    NOP                                 ; UNKNOWN
06A0B0  BE 01 03              MOV    si, 0x301                    ; UNKNOWN
06A0B3  C6 46 FC 02           MOV    byte ptr [bp - 4], 2         ; UNKNOWN
06A0B7  EB C7                 JMP    0x6a080                      ; UNKNOWN
06A0B9  90                    NOP                                 ; UNKNOWN
06A0BA  BE 09 01              MOV    si, 0x109                    ; UNKNOWN
06A0BD  EB F4                 JMP    0x6a0b3                      ; UNKNOWN
06A0BF  90                    NOP                                 ; UNKNOWN
06A0C0  F7 C6 02 00           TEST   si, 2                        ; UNKNOWN
06A0C4  75 E2                 JNE    0x6a0a8                      ; UNKNOWN
06A0C6  83 CE 02              OR     si, 2                        ; UNKNOWN
06A0C9  83 E6 FE              AND    si, 0xfffe                   ; UNKNOWN
06A0CC  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80      ; UNKNOWN
06A0D0  EB B3                 JMP    0x6a085                      ; UNKNOWN
06A0D2  F7 C6 00 C0           TEST   si, 0xc000                   ; UNKNOWN
06A0D6  75 D0                 JNE    0x6a0a8                      ; UNKNOWN
06A0D8  81 CE 00 40           OR     si, 0x4000                   ; UNKNOWN
06A0DC  EB A7                 JMP    0x6a085                      ; UNKNOWN
06A0DE  F7 C6 00 C0           TEST   si, 0xc000                   ; UNKNOWN
06A0E2  75 C4                 JNE    0x6a0a8                      ; UNKNOWN
06A0E4  81 CE 00 80           OR     si, 0x8000                   ; UNKNOWN
06A0E8  EB 9B                 JMP    0x6a085                      ; UNKNOWN
06A0EA  B8 A4 01              MOV    ax, 0x1a4                    ; UNKNOWN
06A0ED  50                    PUSH   ax                           ; UNKNOWN
06A0EE  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06A0F1  56                    PUSH   si                           ; UNKNOWN
06A0F2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06A0F5  9A D8 29 65 5F        LCALL  0x5f65, 0x29d8               ; UNKNOWN
06A0FA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
06A0FD  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
06A100  0B C0                 OR     ax, ax                       ; UNKNOWN
06A102  7D 03                 JGE    0x6a107                      ; UNKNOWN
06A104  E9 6E FF              JMP    0x6a075                      ; UNKNOWN
06A107  FF 06 4C 15           INC    word ptr [0x154c]            ; UNKNOWN
06A10B  8B 7E 0C              MOV    di, word ptr [bp + 0xc]      ; UNKNOWN
06A10E  8B C7                 MOV    ax, di                       ; UNKNOWN
06A110  2D 78 12              SUB    ax, 0x1278                   ; UNKNOWN
06A113  05 18 13              ADD    ax, 0x1318                   ; UNKNOWN
06A116  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
06A119  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
06A11C  88 45 06              MOV    byte ptr [di + 6], al        ; UNKNOWN
06A11F  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
06A122  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
06A125  2B C0                 SUB    ax, ax                       ; UNKNOWN
06A127  89 45 02              MOV    word ptr [di + 2], ax        ; UNKNOWN
06A12A  89 47 04              MOV    word ptr [bx + 4], ax        ; UNKNOWN
06A12D  89 05                 MOV    word ptr [di], ax            ; UNKNOWN
06A12F  89 45 04              MOV    word ptr [di + 4], ax        ; UNKNOWN
06A132  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
06A135  88 45 07              MOV    byte ptr [di + 7], al        ; UNKNOWN
06A138  8B C7                 MOV    ax, di                       ; UNKNOWN
06A13A  5E                    POP    si                           ; UNKNOWN
06A13B  5F                    POP    di                           ; UNKNOWN
06A13C  8B E5                 MOV    sp, bp                       ; UNKNOWN
06A13E  5D                    POP    bp                           ; UNKNOWN
06A13F  CB                    RETF                                ; UNKNOWN
