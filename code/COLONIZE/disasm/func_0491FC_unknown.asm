; ============================================================================
; func_0491FC_unknown
; Region   : load_image
; Bytes    : file 0x0491FC..0x049281  (133 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0491FC  C8 62 00 00           ENTER  0x62, 0                      ; UNKNOWN
049200  56                    PUSH   si                           ; UNKNOWN
049201  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
049205  6A FA                 PUSH   -6                           ; UNKNOWN
049207  6A FA                 PUSH   -6                           ; UNKNOWN
049209  6A 00                 PUSH   0                            ; UNKNOWN
04920B  9A 86 00 C1 38        LCALL  0x38c1, 0x86                 ; UNKNOWN
049210  83 C4 08              ADD    sp, 8                        ; UNKNOWN
049213  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
049216  0B C0                 OR     ax, ax                       ; UNKNOWN
049218  7D 03                 JGE    0x4921d                      ; UNKNOWN
04921A  E9 9E 06              JMP    0x498bb                      ; UNKNOWN
04921D  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
049220  C6 87 88 88 00        MOV    byte ptr [bx - 0x7778], 0    ; UNKNOWN
049225  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
049228  88 87 82 88           MOV    byte ptr [bx - 0x777e], al   ; UNKNOWN
04922C  C6 87 97 88 13        MOV    byte ptr [bx - 0x7769], 0x13 ; UNKNOWN
049231  8B F3                 MOV    si, bx                       ; UNKNOWN
049233  0E                    PUSH   cs                           ; UNKNOWN
049234  E8 06 FC              CALL   0x48e3d                      ; UNKNOWN
049237  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04923A  2A E4                 SUB    ah, ah                       ; UNKNOWN
04923C  50                    PUSH   ax                           ; UNKNOWN
04923D  6A 05                 PUSH   5                            ; UNKNOWN
04923F  68 40 01              PUSH   0x140                        ; UNKNOWN
049242  6A 00                 PUSH   0                            ; UNKNOWN
049244  FF 36 D2 33           PUSH   word ptr [0x33d2]            ; UNKNOWN
049248  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04924D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
049250  52                    PUSH   dx                           ; UNKNOWN
049251  50                    PUSH   ax                           ; UNKNOWN
049252  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
049257  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04925A  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04925E  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
049261  2A E4                 SUB    ah, ah                       ; UNKNOWN
049263  83 C0 07              ADD    ax, 7                        ; UNKNOWN
049266  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
049269  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
04926D  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
049270  50                    PUSH   ax                           ; UNKNOWN
049271  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
049276  83 C4 02              ADD    sp, 2                        ; UNKNOWN
049279  8A 9C 82 88           MOV    bl, byte ptr [si - 0x777e]   ; UNKNOWN
04927D  2A FF                 SUB    bh, bh                       ; UNKNOWN
04927F  8B C3                 MOV    ax, bx                       ; UNKNOWN
