; ============================================================================
; func_034089_unknown
; Region   : load_image
; Bytes    : file 0x034089..0x034161  (216 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034089  C8 56 00 00           ENTER  0x56, 0                      ; UNKNOWN
03408D  6A 33                 PUSH   0x33                         ; UNKNOWN
03408F  6A 46                 PUSH   0x46                         ; UNKNOWN
034091  6A 76                 PUSH   0x76                         ; UNKNOWN
034093  6A 48                 PUSH   0x48                         ; UNKNOWN
034095  0E                    PUSH   cs                           ; UNKNOWN
034096  E8 B7 F5              CALL   0x33650                      ; UNKNOWN
034099  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03409C  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
0340A0  FF 36 0E 33           PUSH   word ptr [0x330e]            ; UNKNOWN
0340A4  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0340A7  50                    PUSH   ax                           ; UNKNOWN
0340A8  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
0340AD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0340B0  6A 45                 PUSH   0x45                         ; UNKNOWN
0340B2  6A 78                 PUSH   0x78                         ; UNKNOWN
0340B4  6A 46                 PUSH   0x46                         ; UNKNOWN
0340B6  6A 48                 PUSH   0x48                         ; UNKNOWN
0340B8  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0340BB  16                    PUSH   ss                           ; UNKNOWN
0340BC  50                    PUSH   ax                           ; UNKNOWN
0340BD  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
0340C2  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
0340C5  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
0340C9  6B 06 9A 79 34        IMUL   ax, word ptr [0x799a], 0x34  ; UNKNOWN
0340CE  05 9E C0              ADD    ax, 0xc09e                   ; UNKNOWN
0340D1  50                    PUSH   ax                           ; UNKNOWN
0340D2  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0340D5  50                    PUSH   ax                           ; UNKNOWN
0340D6  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
0340DB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0340DE  6A 45                 PUSH   0x45                         ; UNKNOWN
0340E0  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
0340E4  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
0340E7  2A E4                 SUB    ah, ah                       ; UNKNOWN
0340E9  83 C0 79              ADD    ax, 0x79                     ; UNKNOWN
0340EC  50                    PUSH   ax                           ; UNKNOWN
0340ED  6A 46                 PUSH   0x46                         ; UNKNOWN
0340EF  6A 48                 PUSH   0x48                         ; UNKNOWN
0340F1  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0340F4  16                    PUSH   ss                           ; UNKNOWN
0340F5  50                    PUSH   ax                           ; UNKNOWN
0340F6  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
0340FB  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
0340FE  C7 46 AC 49 00        MOV    word ptr [bp - 0x54], 0x49   ; UNKNOWN
034103  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
034108  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
03410B  83 E8 1C              SUB    ax, 0x1c                     ; UNKNOWN
03410E  8B D0                 MOV    dx, ax                       ; UNKNOWN
034110  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
034115  EB 1F                 JMP    0x34136                      ; UNKNOWN
034117  6A FF                 PUSH   -1                           ; UNKNOWN
034119  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
03411C  50                    PUSH   ax                           ; UNKNOWN
03411D  6A 01                 PUSH   1                            ; UNKNOWN
03411F  6A 0D                 PUSH   0xd                          ; UNKNOWN
034121  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
034124  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
034127  0E                    PUSH   cs                           ; UNKNOWN
034128  E8 FF FA              CALL   0x33c2a                      ; UNKNOWN
03412B  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
03412E  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
034131  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
034136  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
034139  0B C0                 OR     ax, ax                       ; UNKNOWN
03413B  7D DA                 JGE    0x34117                      ; UNKNOWN
03413D  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
034140  83 E8 18              SUB    ax, 0x18                     ; UNKNOWN
034143  8B D0                 MOV    dx, ax                       ; UNKNOWN
034145  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
03414A  EB 1F                 JMP    0x3416b                      ; UNKNOWN
03414C  6A FF                 PUSH   -1                           ; UNKNOWN
03414E  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
034151  50                    PUSH   ax                           ; UNKNOWN
034152  6A 01                 PUSH   1                            ; UNKNOWN
034154  6A 0D                 PUSH   0xd                          ; UNKNOWN
034156  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
034159  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
03415C  0E                    PUSH   cs                           ; UNKNOWN
03415D  E8 CA FA              CALL   0x33c2a                      ; UNKNOWN
034160  83                    DB     0x83                         ; UNKNOWN (raw)
