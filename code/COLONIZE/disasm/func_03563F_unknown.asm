; ============================================================================
; func_03563F_unknown
; Region   : load_image
; Bytes    : file 0x03563F..0x0356C5  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03563F  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
035643  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
035648  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
03564B  50                    PUSH   ax                           ; UNKNOWN
03564C  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
03564F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
035652  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
035657  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03565A  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
03565D  50                    PUSH   ax                           ; UNKNOWN
03565E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
035661  9A A3 31 5F 24        LCALL  0x245f, 0x31a3               ; UNKNOWN
035666  83 C4 06              ADD    sp, 6                        ; UNKNOWN
035669  0B C0                 OR     ax, ax                       ; UNKNOWN
03566B  75 58                 JNE    0x356c5                      ; UNKNOWN
03566D  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
035670  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
035673  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
035678  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03567B  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
03567E  6A 01                 PUSH   1                            ; UNKNOWN
035680  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
035685  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035688  6A 04                 PUSH   4                            ; UNKNOWN
03568A  0E                    PUSH   cs                           ; UNKNOWN
03568B  E8 65 F1              CALL   0x347f3                      ; UNKNOWN
03568E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035691  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
035694  D1 E3                 SHL    bx, 1                        ; UNKNOWN
035696  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
03569A  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
03569F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0356A2  9A 27 02 2B 3E        LCALL  0x3e2b, 0x227                ; UNKNOWN
0356A7  1E                    PUSH   ds                           ; UNKNOWN
0356A8  68 1C 20              PUSH   0x201c                       ; UNKNOWN
0356AB  9A 86 01 2B 3E        LCALL  0x3e2b, 0x186                ; UNKNOWN
0356B0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0356B3  6A 00                 PUSH   0                            ; UNKNOWN
0356B5  6A 78                 PUSH   0x78                         ; UNKNOWN
0356B7  6A 03                 PUSH   3                            ; UNKNOWN
0356B9  0E                    PUSH   cs                           ; UNKNOWN
0356BA  E8 16 F1              CALL   0x347d3                      ; UNKNOWN
0356BD  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0356C0  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0356C3  C9                    LEAVE                               ; UNKNOWN
0356C4  CB                    RETF                                ; UNKNOWN
