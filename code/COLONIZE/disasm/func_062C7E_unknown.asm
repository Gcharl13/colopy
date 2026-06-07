; ============================================================================
; func_062C7E_unknown
; Region   : load_image
; Bytes    : file 0x062C7E..0x062D0A  (140 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

062C7E  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
062C82  56                    PUSH   si                           ; UNKNOWN
062C83  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
062C88  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
062C8C  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
062C90  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
062C93  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
062C96  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
062C9A  8A 4F 1A              MOV    cl, byte ptr [bx + 0x1a]     ; UNKNOWN
062C9D  2A ED                 SUB    ch, ch                       ; UNKNOWN
062C9F  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
062CA2  83 F8 04              CMP    ax, 4                        ; UNKNOWN
062CA5  7D 2A                 JGE    0x62cd1                      ; UNKNOWN
062CA7  6B F0 34              IMUL   si, ax, 0x34                 ; UNKNOWN
062CAA  38 AC B7 C0           CMP    byte ptr [si - 0x3f49], ch   ; UNKNOWN
062CAE  75 21                 JNE    0x62cd1                      ; UNKNOWN
062CB0  8D 47 02              LEA    ax, [bx + 2]                 ; UNKNOWN
062CB3  1E                    PUSH   ds                           ; UNKNOWN
062CB4  50                    PUSH   ax                           ; UNKNOWN
062CB5  6A 00                 PUSH   0                            ; UNKNOWN
062CB7  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
062CBC  83 C4 06              ADD    sp, 6                        ; UNKNOWN
062CBF  6A 03                 PUSH   3                            ; UNKNOWN
062CC1  68 EE 2F              PUSH   0x2fee                       ; UNKNOWN
062CC4  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
062CC9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
062CCC  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
062CCF  EB 05                 JMP    0x62cd6                      ; UNKNOWN
062CD1  C7 46 FA 03 00        MOV    word ptr [bp - 6], 3         ; UNKNOWN
062CD6  83 7E FA 03           CMP    word ptr [bp - 6], 3         ; UNKNOWN
062CDA  74 05                 JE     0x62ce1                      ; UNKNOWN
062CDC  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
062CE1  83 7E FA 03           CMP    word ptr [bp - 6], 3         ; UNKNOWN
062CE5  7C 03                 JL     0x62cea                      ; UNKNOWN
062CE7  E9 8A 01              JMP    0x62e74                      ; UNKNOWN
062CEA  83 7E FA 01           CMP    word ptr [bp - 6], 1         ; UNKNOWN
062CEE  75 5A                 JNE    0x62d4a                      ; UNKNOWN
062CF0  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
062CF5  74 13                 JE     0x62d0a                      ; UNKNOWN
062CF7  6A 01                 PUSH   1                            ; UNKNOWN
062CF9  68 FA 2F              PUSH   0x2ffa                       ; UNKNOWN
062CFC  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
062D01  83 C4 04              ADD    sp, 4                        ; UNKNOWN
062D04  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
062D07  5E                    POP    si                           ; UNKNOWN
062D08  C9                    LEAVE                               ; UNKNOWN
062D09  CB                    RETF                                ; UNKNOWN
