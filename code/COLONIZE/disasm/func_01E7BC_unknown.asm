; ============================================================================
; func_01E7BC_unknown
; Region   : load_image
; Bytes    : file 0x01E7BC..0x01E80D  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E7BC  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01E7C0  56                    PUSH   si                           ; UNKNOWN
01E7C1  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
01E7C4  48                    DEC    ax                           ; UNKNOWN
01E7C5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01E7C8  EB 76                 JMP    0x1e840                      ; UNKNOWN
01E7CA  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
01E7CE  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
01E7D2  24 0F                 AND    al, 0xf                      ; UNKNOWN
01E7D4  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
01E7D7  75 64                 JNE    0x1e83d                      ; UNKNOWN
01E7D9  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
01E7DD  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
01E7E1  2A E4                 SUB    ah, ah                       ; UNKNOWN
01E7E3  50                    PUSH   ax                           ; UNKNOWN
01E7E4  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
01E7E8  50                    PUSH   ax                           ; UNKNOWN
01E7E9  8B F3                 MOV    si, bx                       ; UNKNOWN
01E7EB  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
01E7F0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01E7F3  0B C0                 OR     ax, ax                       ; UNKNOWN
01E7F5  75 46                 JNE    0x1e83d                      ; UNKNOWN
01E7F7  80 BC 82 88 0D        CMP    byte ptr [si - 0x777e], 0xd  ; UNKNOWN
01E7FC  72 34                 JB     0x1e832                      ; UNKNOWN
01E7FE  80 BC 82 88 12        CMP    byte ptr [si - 0x777e], 0x12 ; UNKNOWN
01E803  77 2D                 JA     0x1e832                      ; UNKNOWN
01E805  8A 9C 82 88           MOV    bl, byte ptr [si - 0x777e]   ; UNKNOWN
01E809  2A FF                 SUB    bh, bh                       ; UNKNOWN
01E80B  8B C3                 MOV    ax, bx                       ; UNKNOWN
