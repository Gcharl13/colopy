; ============================================================================
; func_03418D_unknown
; Region   : load_image
; Bytes    : file 0x03418D..0x03425F  (210 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03418D  C8 56 00 00           ENTER  0x56, 0                      ; UNKNOWN
034191  6A 33                 PUSH   0x33                         ; UNKNOWN
034193  6A 46                 PUSH   0x46                         ; UNKNOWN
034195  6A 76                 PUSH   0x76                         ; UNKNOWN
034197  6A 01                 PUSH   1                            ; UNKNOWN
034199  0E                    PUSH   cs                           ; UNKNOWN
03419A  E8 B3 F4              CALL   0x33650                      ; UNKNOWN
03419D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0341A0  FF 36 0C 33           PUSH   word ptr [0x330c]            ; UNKNOWN
0341A4  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
0341A9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0341AC  52                    PUSH   dx                           ; UNKNOWN
0341AD  50                    PUSH   ax                           ; UNKNOWN
0341AE  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0341B1  16                    PUSH   ss                           ; UNKNOWN
0341B2  50                    PUSH   ax                           ; UNKNOWN
0341B3  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
0341B8  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0341BB  6A 45                 PUSH   0x45                         ; UNKNOWN
0341BD  6A 78                 PUSH   0x78                         ; UNKNOWN
0341BF  6A 46                 PUSH   0x46                         ; UNKNOWN
0341C1  6A 01                 PUSH   1                            ; UNKNOWN
0341C3  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0341C6  16                    PUSH   ss                           ; UNKNOWN
0341C7  50                    PUSH   ax                           ; UNKNOWN
0341C8  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
0341CD  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
0341D0  C7 46 AC 02 00        MOV    word ptr [bp - 0x54], 2      ; UNKNOWN
0341D5  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0341DA  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
0341DD  83 E8 10              SUB    ax, 0x10                     ; UNKNOWN
0341E0  8B D0                 MOV    dx, ax                       ; UNKNOWN
0341E2  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
0341E7  EB 1F                 JMP    0x34208                      ; UNKNOWN
0341E9  6A FF                 PUSH   -1                           ; UNKNOWN
0341EB  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
0341EE  50                    PUSH   ax                           ; UNKNOWN
0341EF  6A 01                 PUSH   1                            ; UNKNOWN
0341F1  6A 0D                 PUSH   0xd                          ; UNKNOWN
0341F3  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
0341F6  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
0341F9  0E                    PUSH   cs                           ; UNKNOWN
0341FA  E8 2D FA              CALL   0x33c2a                      ; UNKNOWN
0341FD  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
034200  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
034203  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
034208  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
03420B  0B C0                 OR     ax, ax                       ; UNKNOWN
03420D  7D DA                 JGE    0x341e9                      ; UNKNOWN
03420F  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
034212  83 E8 0C              SUB    ax, 0xc                      ; UNKNOWN
034215  8B D0                 MOV    dx, ax                       ; UNKNOWN
034217  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
03421C  EB 1F                 JMP    0x3423d                      ; UNKNOWN
03421E  6A FF                 PUSH   -1                           ; UNKNOWN
034220  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
034223  50                    PUSH   ax                           ; UNKNOWN
034224  6A 01                 PUSH   1                            ; UNKNOWN
034226  6A 0D                 PUSH   0xd                          ; UNKNOWN
034228  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
03422B  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
03422E  0E                    PUSH   cs                           ; UNKNOWN
03422F  E8 F8 F9              CALL   0x33c2a                      ; UNKNOWN
034232  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
034235  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
034238  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
03423D  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
034240  0B C0                 OR     ax, ax                       ; UNKNOWN
034242  7D DA                 JGE    0x3421e                      ; UNKNOWN
034244  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
034248  74 13                 JE     0x3425d                      ; UNKNOWN
03424A  6A 76                 PUSH   0x76                         ; UNKNOWN
03424C  6A 46                 PUSH   0x46                         ; UNKNOWN
03424E  6A 33                 PUSH   0x33                         ; UNKNOWN
034250  B8 01 00              MOV    ax, 1                        ; UNKNOWN
034253  BA 76 00              MOV    dx, 0x76                     ; UNKNOWN
034256  8B D8                 MOV    bx, ax                       ; UNKNOWN
034258  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
03425D  C9                    LEAVE                               ; UNKNOWN
03425E  CB                    RETF                                ; UNKNOWN
