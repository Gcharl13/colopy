; ============================================================================
; func_01073C_unknown
; Region   : load_image
; Bytes    : file 0x01073C..0x010774  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01073C  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
010740  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
010743  83 C0 04              ADD    ax, 4                        ; UNKNOWN
010746  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
010749  A1 12 3E              MOV    ax, word ptr [0x3e12]        ; UNKNOWN
01074C  48                    DEC    ax                           ; UNKNOWN
01074D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
010750  EB 1A                 JMP    0x1076c                      ; UNKNOWN
010752  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
010755  6B 5E FE 12           IMUL   bx, word ptr [bp - 2], 0x12  ; UNKNOWN
010759  38 87 DE 79           CMP    byte ptr [bx + 0x79de], al   ; UNKNOWN
01075D  75 0A                 JNE    0x10769                      ; UNKNOWN
01075F  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
010762  0E                    PUSH   cs                           ; UNKNOWN
010763  E8 40 F4              CALL   0xfba6                       ; UNKNOWN
010766  83 C4 02              ADD    sp, 2                        ; UNKNOWN
010769  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
01076C  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
010770  7D E0                 JGE    0x10752                      ; UNKNOWN
010772  C9                    LEAVE                               ; UNKNOWN
010773  CB                    RETF                                ; UNKNOWN
