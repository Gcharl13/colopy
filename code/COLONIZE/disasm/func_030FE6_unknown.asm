; ============================================================================
; func_030FE6_unknown
; Region   : load_image
; Bytes    : file 0x030FE6..0x031058  (114 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030FE6  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
030FEA  56                    PUSH   si                           ; UNKNOWN
030FEB  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
030FEE  50                    PUSH   ax                           ; UNKNOWN
030FEF  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
030FF3  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
030FF7  98                    CWDE                                ; UNKNOWN
030FF8  50                    PUSH   ax                           ; UNKNOWN
030FF9  9A 92 32 5F 24        LCALL  0x245f, 0x3292               ; UNKNOWN
030FFE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
031001  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
031004  0B C0                 OR     ax, ax                       ; UNKNOWN
031006  75 03                 JNE    0x3100b                      ; UNKNOWN
031008  E9 FA 01              JMP    0x31205                      ; UNKNOWN
03100B  83 F8 01              CMP    ax, 1                        ; UNKNOWN
03100E  74 03                 JE     0x31013                      ; UNKNOWN
031010  E9 98 00              JMP    0x310ab                      ; UNKNOWN
031013  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
031016  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
03101B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03101E  0B C0                 OR     ax, ax                       ; UNKNOWN
031020  74 03                 JE     0x31025                      ; UNKNOWN
031022  E9 E0 01              JMP    0x31205                      ; UNKNOWN
031025  83 7E F8 10           CMP    word ptr [bp - 8], 0x10      ; UNKNOWN
031029  75 2D                 JNE    0x31058                      ; UNKNOWN
03102B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
03102F  80 BF 95 00 02        CMP    byte ptr [bx + 0x95], 2      ; UNKNOWN
031034  72 22                 JB     0x31058                      ; UNKNOWN
031036  50                    PUSH   ax                           ; UNKNOWN
031037  6A 05                 PUSH   5                            ; UNKNOWN
031039  50                    PUSH   ax                           ; UNKNOWN
03103A  50                    PUSH   ax                           ; UNKNOWN
03103B  6A 02                 PUSH   2                            ; UNKNOWN
03103D  80 3E 66 74 01        CMP    byte ptr [0x7466], 1         ; UNKNOWN
031042  1B C0                 SBB    ax, ax                       ; UNKNOWN
031044  F7 D8                 NEG    ax                           ; UNKNOWN
031046  50                    PUSH   ax                           ; UNKNOWN
031047  68 46 1E              PUSH   0x1e46                       ; UNKNOWN
03104A  0E                    PUSH   cs                           ; UNKNOWN
03104B  E8 86 FE              CALL   0x30ed4                      ; UNKNOWN
03104E  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
031051  08 06 66 74           OR     byte ptr [0x7466], al        ; UNKNOWN
031055  5E                    POP    si                           ; UNKNOWN
031056  C9                    LEAVE                               ; UNKNOWN
031057  CB                    RETF                                ; UNKNOWN
