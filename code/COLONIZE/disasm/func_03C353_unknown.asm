; ============================================================================
; func_03C353_unknown
; Region   : load_image
; Bytes    : file 0x03C353..0x03C3C7  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C353  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03C357  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03C35C  83 3E E2 0E 00        CMP    word ptr [0xee2], 0          ; UNKNOWN
03C361  7C 21                 JL     0x3c384                      ; UNKNOWN
03C363  83 3E E4 0E 08        CMP    word ptr [0xee4], 8          ; UNKNOWN
03C368  7C 1A                 JL     0x3c384                      ; UNKNOWN
03C36A  A1 9C 82              MOV    ax, word ptr [0x829c]        ; UNKNOWN
03C36D  39 06 E2 0E           CMP    word ptr [0xee2], ax         ; UNKNOWN
03C371  7D 11                 JGE    0x3c384                      ; UNKNOWN
03C373  A1 9E 82              MOV    ax, word ptr [0x829e]        ; UNKNOWN
03C376  83 C0 08              ADD    ax, 8                        ; UNKNOWN
03C379  3B 06 E4 0E           CMP    ax, word ptr [0xee4]         ; UNKNOWN
03C37D  7E 05                 JLE    0x3c384                      ; UNKNOWN
03C37F  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03C384  81 3E E2 0E FC 00     CMP    word ptr [0xee2], 0xfc       ; UNKNOWN
03C38A  7C 1B                 JL     0x3c3a7                      ; UNKNOWN
03C38C  83 3E E4 0E 09        CMP    word ptr [0xee4], 9          ; UNKNOWN
03C391  7C 14                 JL     0x3c3a7                      ; UNKNOWN
03C393  81 3E E2 0E 34 01     CMP    word ptr [0xee2], 0x134      ; UNKNOWN
03C399  7D 0C                 JGE    0x3c3a7                      ; UNKNOWN
03C39B  83 3E E4 0E 30        CMP    word ptr [0xee4], 0x30       ; UNKNOWN
03C3A0  7D 05                 JGE    0x3c3a7                      ; UNKNOWN
03C3A2  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
03C3A7  68 96 00              PUSH   0x96                         ; UNKNOWN
03C3AA  6A 4F                 PUSH   0x4f                         ; UNKNOWN
03C3AC  6A 32                 PUSH   0x32                         ; UNKNOWN
03C3AE  68 F1 00              PUSH   0xf1                         ; UNKNOWN
03C3B1  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
03C3B6  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03C3B9  0B C0                 OR     ax, ax                       ; UNKNOWN
03C3BB  74 05                 JE     0x3c3c2                      ; UNKNOWN
03C3BD  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3         ; UNKNOWN
03C3C2  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03C3C5  C9                    LEAVE                               ; UNKNOWN
03C3C6  CB                    RETF                                ; UNKNOWN
