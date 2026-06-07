; ============================================================================
; func_008C70_unknown
; Region   : load_image
; Bytes    : file 0x008C70..0x008CB2  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008C70  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
008C74  2B C0                 SUB    ax, ax                       ; UNKNOWN
008C76  A3 72 8D              MOV    word ptr [0x8d72], ax        ; UNKNOWN
008C79  A3 74 8D              MOV    word ptr [0x8d74], ax        ; UNKNOWN
008C7C  A3 76 8D              MOV    word ptr [0x8d76], ax        ; UNKNOWN
008C7F  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
008C83  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
008C85  2A E4                 SUB    ah, ah                       ; UNKNOWN
008C87  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
008C8A  2A F6                 SUB    dh, dh                       ; UNKNOWN
008C8C  9A 5C 00 27 04        LCALL  0x427, 0x5c                  ; UNKNOWN
008C91  A3 78 8D              MOV    word ptr [0x8d78], ax        ; UNKNOWN
008C94  EB 3D                 JMP    0x8cd3                       ; UNKNOWN
008C96  50                    PUSH   ax                           ; UNKNOWN
008C97  0E                    PUSH   cs                           ; UNKNOWN
008C98  E8 FB FE              CALL   0x8b96                       ; UNKNOWN
008C9B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
008C9E  0B C0                 OR     ax, ax                       ; UNKNOWN
008CA0  74 04                 JE     0x8ca6                       ; UNKNOWN
008CA2  FF 06 72 8D           INC    word ptr [0x8d72]            ; UNKNOWN
008CA6  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; ARITH
008CAA  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146]   ; MOV
008CAE  2A FF                 SUB    bh, bh                       ; UNKNOWN
008CB0  8B C3                 MOV    ax, bx                       ; UNKNOWN
