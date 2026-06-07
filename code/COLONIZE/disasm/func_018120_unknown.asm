; ============================================================================
; func_018120_unknown
; Region   : load_image
; Bytes    : file 0x018120..0x0181E0  (192 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018120  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
018124  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
018129  2B C0                 SUB    ax, ax                       ; UNKNOWN
01812B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01812E  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
018131  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
018134  83 7E 06 13           CMP    word ptr [bp + 6], 0x13      ; UNKNOWN
018138  74 06                 JE     0x18140                      ; UNKNOWN
01813A  83 7E 06 14           CMP    word ptr [bp + 6], 0x14      ; UNKNOWN
01813E  75 10                 JNE    0x18150                      ; UNKNOWN
018140  A0 60 74              MOV    al, byte ptr [0x7460]        ; UNKNOWN
018143  2A E4                 SUB    ah, ah                       ; UNKNOWN
018145  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
018148  C7 46 FC 3F 00        MOV    word ptr [bp - 4], 0x3f      ; UNKNOWN
01814D  E9 B1 00              JMP    0x18201                      ; UNKNOWN
018150  83 7E 06 11           CMP    word ptr [bp + 6], 0x11      ; UNKNOWN
018154  75 0E                 JNE    0x18164                      ; UNKNOWN
018156  A1 98 73              MOV    ax, word ptr [0x7398]        ; UNKNOWN
018159  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01815C  C7 46 FC 1F 00        MOV    word ptr [bp - 4], 0x1f      ; UNKNOWN
018161  E9 9D 00              JMP    0x18201                      ; UNKNOWN
018164  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
018167  9A 9E 14 5F 24        LCALL  0x245f, 0x149e               ; UNKNOWN
01816C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01816F  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
018172  0B C0                 OR     ax, ax                       ; UNKNOWN
018174  7D 03                 JGE    0x18179                      ; UNKNOWN
018176  E9 88 00              JMP    0x18201                      ; UNKNOWN
018179  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01817C  9A 30 15 5F 24        LCALL  0x245f, 0x1530               ; UNKNOWN
018181  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018184  0B C0                 OR     ax, ax                       ; UNKNOWN
018186  7C 79                 JL     0x18201                      ; UNKNOWN
018188  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
01818B  EB 32                 JMP    0x181bf                      ; UNKNOWN
01818D  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
018190  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
018193  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
018196  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
018199  EB 46                 JMP    0x181e1                      ; UNKNOWN
01819B  C7 46 FA 10 00        MOV    word ptr [bp - 6], 0x10      ; UNKNOWN
0181A0  C7 46 FC 37 00        MOV    word ptr [bp - 4], 0x37      ; UNKNOWN
0181A5  EB 3A                 JMP    0x181e1                      ; UNKNOWN
0181A7  C7 46 FA 11 00        MOV    word ptr [bp - 6], 0x11      ; UNKNOWN
0181AC  C7 46 FC 39 00        MOV    word ptr [bp - 4], 0x39      ; UNKNOWN
0181B1  EB 2E                 JMP    0x181e1                      ; UNKNOWN
0181B3  C7 46 FA 12 00        MOV    word ptr [bp - 6], 0x12      ; UNKNOWN
0181B8  C7 46 FC 3F 00        MOV    word ptr [bp - 4], 0x3f      ; UNKNOWN
0181BD  EB 22                 JMP    0x181e1                      ; UNKNOWN
0181BF  83 E8 09              SUB    ax, 9                        ; UNKNOWN
0181C2  83 F8 08              CMP    ax, 8                        ; UNKNOWN
0181C5  77 1A                 JA     0x181e1                      ; UNKNOWN
0181C7  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0181C9  93                    XCHG   bx, ax                       ; UNKNOWN
0181CA  2E FF A7 DF 15        JMP    word ptr cs:[bx + 0x15df]    ; UNKNOWN
0181CF  9D                    POPF                                ; UNKNOWN
0181D0  15 9D 15              ADC    ax, 0x159d                   ; UNKNOWN
0181D3  9D                    POPF                                ; UNKNOWN
0181D4  15 9D 15              ADC    ax, 0x159d                   ; UNKNOWN
0181D7  AB                    STOSW  word ptr es:[di], ax         ; UNKNOWN
0181D8  15 9D 15              ADC    ax, 0x159d                   ; UNKNOWN
0181DB  9D                    POPF                                ; UNKNOWN
0181DC  15 B7 15              ADC    ax, 0x15b7                   ; UNKNOWN
0181DF  C3                    RET                                 ; UNKNOWN
