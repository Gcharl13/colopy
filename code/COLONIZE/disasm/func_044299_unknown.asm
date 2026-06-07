; ============================================================================
; func_044299_unknown
; Region   : load_image
; Bytes    : file 0x044299..0x04433C  (163 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044299  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
04429D  50                    PUSH   ax                           ; UNKNOWN
04429E  56                    PUSH   si                           ; UNKNOWN
04429F  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; UNKNOWN
0442A4  C4 1E 9E C1           LES    bx, ptr [0xc19e]             ; UNKNOWN
0442A8  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
0442AB  A2 B5 C1              MOV    byte ptr [0xc1b5], al        ; UNKNOWN
0442AE  C4 1E A2 C1           LES    bx, ptr [0xc1a2]             ; UNKNOWN
0442B2  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
0442B5  A2 B7 C1              MOV    byte ptr [0xc1b7], al        ; UNKNOWN
0442B8  C4 1E A6 C1           LES    bx, ptr [0xc1a6]             ; UNKNOWN
0442BC  26 8A 0F              MOV    cl, byte ptr es:[bx]         ; UNKNOWN
0442BF  88 0E B6 C1           MOV    byte ptr [0xc1b6], cl        ; UNKNOWN
0442C3  2A E4                 SUB    ah, ah                       ; UNKNOWN
0442C5  50                    PUSH   ax                           ; UNKNOWN
0442C6  9A FE 05 C9 33        LCALL  0x33c9, 0x5fe                ; UNKNOWN
0442CB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0442CE  A2 B8 C1              MOV    byte ptr [0xc1b8], al        ; UNKNOWN
0442D1  80 3E B4 C1 00        CMP    byte ptr [0xc1b4], 0         ; UNKNOWN
0442D6  74 09                 JE     0x442e1                      ; UNKNOWN
0442D8  A0 B4 C1              MOV    al, byte ptr [0xc1b4]        ; UNKNOWN
0442DB  84 06 B6 C1           TEST   byte ptr [0xc1b6], al        ; UNKNOWN
0442DF  74 06                 JE     0x442e7                      ; UNKNOWN
0442E1  83 7E DA 00           CMP    word ptr [bp - 0x26], 0      ; UNKNOWN
0442E5  74 07                 JE     0x442ee                      ; UNKNOWN
0442E7  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
0442EC  EB 05                 JMP    0x442f3                      ; UNKNOWN
0442EE  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
0442F3  A0 B7 C1              MOV    al, byte ptr [0xc1b7]        ; UNKNOWN
0442F6  25 C0 00              AND    ax, 0xc0                     ; UNKNOWN
0442F9  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
0442FC  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
044300  74 3A                 JE     0x4433c                      ; UNKNOWN
044302  B8 95 00              MOV    ax, 0x95                     ; UNKNOWN
044305  E8 BF FB              CALL   0x43ec7                      ; UNKNOWN
044308  83 3E 34 0B 00        CMP    word ptr [0xb34], 0          ; UNKNOWN
04430D  74 03                 JE     0x44312                      ; UNKNOWN
04430F  E9 B0 03              JMP    0x446c2                      ; UNKNOWN
044312  80 3E B8 C1 19        CMP    byte ptr [0xc1b8], 0x19      ; UNKNOWN
044317  74 07                 JE     0x44320                      ; UNKNOWN
044319  80 3E B8 C1 1A        CMP    byte ptr [0xc1b8], 0x1a      ; UNKNOWN
04431E  75 07                 JNE    0x44327                      ; UNKNOWN
044320  C7 46 DE 01 00        MOV    word ptr [bp - 0x22], 1      ; UNKNOWN
044325  EB 05                 JMP    0x4432c                      ; UNKNOWN
044327  C7 46 DE 00 00        MOV    word ptr [bp - 0x22], 0      ; UNKNOWN
04432C  6A 00                 PUSH   0                            ; UNKNOWN
04432E  FF 76 DE              PUSH   word ptr [bp - 0x22]         ; UNKNOWN
044331  6A 01                 PUSH   1                            ; UNKNOWN
044333  E8 11 FD              CALL   0x44047                      ; UNKNOWN
044336  83 C4 06              ADD    sp, 6                        ; UNKNOWN
044339  5E                    POP    si                           ; UNKNOWN
04433A  C9                    LEAVE                               ; UNKNOWN
04433B  C3                    RET                                 ; UNKNOWN
