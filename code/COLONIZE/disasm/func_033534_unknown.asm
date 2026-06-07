; ============================================================================
; func_033534_unknown
; Region   : load_image
; Bytes    : file 0x033534..0x0335E2  (174 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033534  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
033538  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03353D  83 7E 06 14           CMP    word ptr [bp + 6], 0x14      ; UNKNOWN
033541  75 05                 JNE    0x33548                      ; UNKNOWN
033543  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
033548  83 7E 06 18           CMP    word ptr [bp + 6], 0x18      ; UNKNOWN
03354C  75 05                 JNE    0x33553                      ; UNKNOWN
03354E  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3         ; UNKNOWN
033553  83 7E 06 16           CMP    word ptr [bp + 6], 0x16      ; UNKNOWN
033557  75 05                 JNE    0x3355e                      ; UNKNOWN
033559  C7 46 FE 05 00        MOV    word ptr [bp - 2], 5         ; UNKNOWN
03355E  83 7E 06 15           CMP    word ptr [bp + 6], 0x15      ; UNKNOWN
033562  75 41                 JNE    0x335a5                      ; UNKNOWN
033564  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
033569  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
03356E  7D 16                 JGE    0x33586                      ; UNKNOWN
033570  6B 1E 9A 79 34        IMUL   bx, word ptr [0x799a], 0x34  ; UNKNOWN
033575  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
03357A  75 0A                 JNE    0x33586                      ; UNKNOWN
03357C  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
03357F  2A E4                 SUB    ah, ah                       ; UNKNOWN
033581  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
033584  EB 05                 JMP    0x3358b                      ; UNKNOWN
033586  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
03358B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03358E  83 C0 04              ADD    ax, 4                        ; UNKNOWN
033591  50                    PUSH   ax                           ; UNKNOWN
033592  6A 00                 PUSH   0                            ; UNKNOWN
033594  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
033599  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03359C  0B C0                 OR     ax, ax                       ; UNKNOWN
03359E  75 05                 JNE    0x335a5                      ; UNKNOWN
0335A0  C7 46 FE 04 00        MOV    word ptr [bp - 2], 4         ; UNKNOWN
0335A5  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
0335A8  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
0335AB  50                    PUSH   ax                           ; UNKNOWN
0335AC  50                    PUSH   ax                           ; UNKNOWN
0335AD  FF 36 9A 79           PUSH   word ptr [0x799a]            ; UNKNOWN
0335B1  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0335B4  9A AE 06 B7 36        LCALL  0x36b7, 0x6ae                ; UNKNOWN
0335B9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0335BC  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0335BF  0B C0                 OR     ax, ax                       ; UNKNOWN
0335C1  7C 1A                 JL     0x335dd                      ; UNKNOWN
0335C3  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
0335C6  C6 87 88 88 01        MOV    byte ptr [bx - 0x7778], 1    ; UNKNOWN
0335CB  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
0335CE  88 87 97 88           MOV    byte ptr [bx - 0x7769], al   ; UNKNOWN
0335D2  83 7E FE 02           CMP    word ptr [bp - 2], 2         ; UNKNOWN
0335D6  75 05                 JNE    0x335dd                      ; UNKNOWN
0335D8  C6 87 95 88 64        MOV    byte ptr [bx - 0x776b], 0x64 ; UNKNOWN
0335DD  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
0335E0  C9                    LEAVE                               ; UNKNOWN
0335E1  CB                    RETF                                ; UNKNOWN
