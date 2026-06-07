; ============================================================================
; func_009972_unknown
; Region   : load_image
; Bytes    : file 0x009972..0x009A53  (225 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009972  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
009976  68 23 03              PUSH   0x323                        ; UNKNOWN
009979  FF 36 38 03           PUSH   word ptr [0x338]             ; UNKNOWN
00997D  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
009982  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009985  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
009988  0B C0                 OR     ax, ax                       ; UNKNOWN
00998A  75 12                 JNE    0x999e                       ; UNKNOWN
00998C  FF 36 38 03           PUSH   word ptr [0x338]             ; UNKNOWN
009990  68 26 03              PUSH   0x326                        ; UNKNOWN
009993  9A D8 00 00 00        LCALL  0, 0xd8                      ; UNKNOWN
009998  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00999B  E9 97 00              JMP    0x9a35                       ; UNKNOWN
00999E  50                    PUSH   ax                           ; UNKNOWN
00999F  6A 01                 PUSH   1                            ; UNKNOWN
0099A1  6A 02                 PUSH   2                            ; UNKNOWN
0099A3  68 70 04              PUSH   0x470                        ; UNKNOWN
0099A6  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
0099AB  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0099AE  0B C0                 OR     ax, ax                       ; UNKNOWN
0099B0  75 03                 JNE    0x99b5                       ; UNKNOWN
0099B2  E9 80 00              JMP    0x9a35                       ; UNKNOWN
0099B5  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0099B8  6A 01                 PUSH   1                            ; UNKNOWN
0099BA  6A 02                 PUSH   2                            ; UNKNOWN
0099BC  68 72 04              PUSH   0x472                        ; UNKNOWN
0099BF  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
0099C4  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0099C7  0B C0                 OR     ax, ax                       ; UNKNOWN
0099C9  74 6A                 JE     0x9a35                       ; UNKNOWN
0099CB  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0099CE  6A 01                 PUSH   1                            ; UNKNOWN
0099D0  6A 02                 PUSH   2                            ; UNKNOWN
0099D2  68 74 04              PUSH   0x474                        ; UNKNOWN
0099D5  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
0099DA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0099DD  0B C0                 OR     ax, ax                       ; UNKNOWN
0099DF  74 54                 JE     0x9a35                       ; UNKNOWN
0099E1  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0099E4  6A 01                 PUSH   1                            ; UNKNOWN
0099E6  6A 02                 PUSH   2                            ; UNKNOWN
0099E8  68 76 04              PUSH   0x476                        ; UNKNOWN
0099EB  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
0099F0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0099F3  0B C0                 OR     ax, ax                       ; UNKNOWN
0099F5  74 3E                 JE     0x9a35                       ; UNKNOWN
0099F7  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0099FA  6A 01                 PUSH   1                            ; UNKNOWN
0099FC  6A 02                 PUSH   2                            ; UNKNOWN
0099FE  68 78 04              PUSH   0x478                        ; UNKNOWN
009A01  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
009A06  83 C4 08              ADD    sp, 8                        ; UNKNOWN
009A09  0B C0                 OR     ax, ax                       ; UNKNOWN
009A0B  74 28                 JE     0x9a35                       ; UNKNOWN
009A0D  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
009A10  6A 01                 PUSH   1                            ; UNKNOWN
009A12  6A 02                 PUSH   2                            ; UNKNOWN
009A14  68 7A 04              PUSH   0x47a                        ; UNKNOWN
009A17  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
009A1C  83 C4 08              ADD    sp, 8                        ; UNKNOWN
009A1F  0B C0                 OR     ax, ax                       ; UNKNOWN
009A21  74 12                 JE     0x9a35                       ; UNKNOWN
009A23  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
009A26  6A 01                 PUSH   1                            ; UNKNOWN
009A28  6A 02                 PUSH   2                            ; UNKNOWN
009A2A  68 7C 04              PUSH   0x47c                        ; UNKNOWN
009A2D  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
009A32  83 C4 08              ADD    sp, 8                        ; UNKNOWN
009A35  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
009A39  74 0B                 JE     0x9a46                       ; UNKNOWN
009A3B  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
009A3E  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
009A43  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009A46  A1 72 04              MOV    ax, word ptr [0x472]         ; UNKNOWN
009A49  9A 00 00 0B 5D        LCALL  0x5d0b, 0                    ; UNKNOWN
009A4E  A2 6E 04              MOV    byte ptr [0x46e], al         ; UNKNOWN
009A51  C9                    LEAVE                               ; UNKNOWN
009A52  CB                    RETF                                ; UNKNOWN
