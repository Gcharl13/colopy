; ============================================================================
; func_01DD26_unknown
; Region   : load_image
; Bytes    : file 0x01DD26..0x01DDB7  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01DD26  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
01DD2A  2B C0                 SUB    ax, ax                       ; UNKNOWN
01DD2C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01DD2F  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01DD32  EB 27                 JMP    0x1dd5b                      ; UNKNOWN
01DD34  6B D8 12              IMUL   bx, ax, 0x12                 ; UNKNOWN
01DD37  8A 87 DE 79           MOV    al, byte ptr [bx + 0x79de]   ; UNKNOWN
01DD3B  2A 46 06              SUB    al, byte ptr [bp + 6]        ; UNKNOWN
01DD3E  3C 04                 CMP    al, 4                        ; UNKNOWN
01DD40  75 16                 JNE    0x1dd58                      ; UNKNOWN
01DD42  8A 87 E1 79           MOV    al, byte ptr [bx + 0x79e1]   ; UNKNOWN
01DD46  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
01DD49  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
01DD4C  75 0A                 JNE    0x1dd58                      ; UNKNOWN
01DD4E  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
01DD53  C6 87 E1 79 FF        MOV    byte ptr [bx + 0x79e1], 0xff ; UNKNOWN
01DD58  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
01DD5B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
01DD5E  39 06 12 3E           CMP    word ptr [0x3e12], ax        ; UNKNOWN
01DD62  7F D0                 JG     0x1dd34                      ; UNKNOWN
01DD64  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01DD68  74 4B                 JE     0x1ddb5                      ; UNKNOWN
01DD6A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
01DD6D  83 C0 04              ADD    ax, 4                        ; UNKNOWN
01DD70  50                    PUSH   ax                           ; UNKNOWN
01DD71  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
01DD76  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01DD79  50                    PUSH   ax                           ; UNKNOWN
01DD7A  6A 00                 PUSH   0                            ; UNKNOWN
01DD7C  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01DD81  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DD84  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
01DD87  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
01DD8C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01DD8F  50                    PUSH   ax                           ; UNKNOWN
01DD90  6A 01                 PUSH   1                            ; UNKNOWN
01DD92  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01DD97  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DD9A  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
01DD9E  7D 15                 JGE    0x1ddb5                      ; UNKNOWN
01DDA0  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
01DDA4  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
01DDA9  75 0A                 JNE    0x1ddb5                      ; UNKNOWN
01DDAB  6A 01                 PUSH   1                            ; UNKNOWN
01DDAD  68 72 17              PUSH   0x1772                       ; UNKNOWN
01DDB0  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01DDB5  C9                    LEAVE                               ; UNKNOWN
01DDB6  CB                    RETF                                ; UNKNOWN
