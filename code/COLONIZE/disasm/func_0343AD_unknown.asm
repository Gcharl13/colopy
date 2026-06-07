; ============================================================================
; func_0343AD_unknown
; Region   : load_image
; Bytes    : file 0x0343AD..0x034462  (181 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0343AD  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
0343B1  6A 3B                 PUSH   0x3b                         ; UNKNOWN
0343B3  6A 60                 PUSH   0x60                         ; UNKNOWN
0343B5  6A 78                 PUSH   0x78                         ; UNKNOWN
0343B7  68 E0 00              PUSH   0xe0                         ; UNKNOWN
0343BA  0E                    PUSH   cs                           ; UNKNOWN
0343BB  E8 92 F2              CALL   0x33650                      ; UNKNOWN
0343BE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0343C1  C7 46 FC E9 00        MOV    word ptr [bp - 4], 0xe9      ; UNKNOWN
0343C6  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0343CB  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
0343CE  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
0343D1  8B D0                 MOV    dx, ax                       ; UNKNOWN
0343D3  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
0343D8  EB 66                 JMP    0x34440                      ; UNKNOWN
0343DA  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
0343DD  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
0343E2  72 07                 JB     0x343eb                      ; UNKNOWN
0343E4  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
0343E9  76 4D                 JBE    0x34438                      ; UNKNOWN
0343EB  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff    ; UNKNOWN
0343F0  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0343F3  39 06 AC 79           CMP    word ptr [0x79ac], ax        ; UNKNOWN
0343F7  75 2B                 JNE    0x34424                      ; UNKNOWN
0343F9  C7 46 F8 0A 00        MOV    word ptr [bp - 8], 0xa       ; UNKNOWN
0343FE  83 3E E8 0E 00        CMP    word ptr [0xee8], 0          ; UNKNOWN
034403  74 0C                 JE     0x34411                      ; UNKNOWN
034405  83 3E BA 79 04        CMP    word ptr [0x79ba], 4         ; UNKNOWN
03440A  75 05                 JNE    0x34411                      ; UNKNOWN
03440C  C7 46 F8 0F 00        MOV    word ptr [bp - 8], 0xf       ; UNKNOWN
034411  83 3E EC 0A 02        CMP    word ptr [0xaec], 2          ; UNKNOWN
034416  75 0C                 JNE    0x34424                      ; UNKNOWN
034418  83 3E C0 79 00        CMP    word ptr [0x79c0], 0         ; UNKNOWN
03441D  74 05                 JE     0x34424                      ; UNKNOWN
03441F  C7 46 F8 0F 00        MOV    word ptr [bp - 8], 0xf       ; UNKNOWN
034424  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
034427  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
03442A  50                    PUSH   ax                           ; UNKNOWN
03442B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03442E  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
034431  0E                    PUSH   cs                           ; UNKNOWN
034432  E8 B1 FE              CALL   0x342e6                      ; UNKNOWN
034435  83 C4 08              ADD    sp, 8                        ; UNKNOWN
034438  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
03443B  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
034440  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
034443  0B C0                 OR     ax, ax                       ; UNKNOWN
034445  7D 93                 JGE    0x343da                      ; UNKNOWN
034447  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03444B  74 13                 JE     0x34460                      ; UNKNOWN
03444D  6A 78                 PUSH   0x78                         ; UNKNOWN
03444F  6A 60                 PUSH   0x60                         ; UNKNOWN
034451  6A 3B                 PUSH   0x3b                         ; UNKNOWN
034453  B8 E0 00              MOV    ax, 0xe0                     ; UNKNOWN
034456  BA 78 00              MOV    dx, 0x78                     ; UNKNOWN
034459  8B D8                 MOV    bx, ax                       ; UNKNOWN
03445B  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
034460  C9                    LEAVE                               ; UNKNOWN
034461  CB                    RETF                                ; UNKNOWN
