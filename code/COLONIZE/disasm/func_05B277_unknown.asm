; ============================================================================
; func_05B277_unknown
; Region   : load_image
; Bytes    : file 0x05B277..0x05B301  (138 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05B277  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
05B27B  56                    PUSH   si                           ; UNKNOWN
05B27C  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
05B281  8A 46 F2              MOV    al, byte ptr [bp - 0xe]      ; UNKNOWN
05B284  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
05B287  88 87 E8 CD           MOV    byte ptr [bx - 0x3218], al   ; UNKNOWN
05B28B  6A 00                 PUSH   0                            ; UNKNOWN
05B28D  6A 64                 PUSH   0x64                         ; UNKNOWN
05B28F  69 F3 3C 01           IMUL   si, bx, 0x13c                ; UNKNOWN
05B293  FF B4 D6 74           PUSH   word ptr [si + 0x74d6]       ; UNKNOWN
05B297  FF B4 D4 74           PUSH   word ptr [si + 0x74d4]       ; UNKNOWN
05B29B  9A D2 11 65 5F        LCALL  0x5f65, 0x11d2               ; UNKNOWN
05B2A0  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
05B2A3  8A 8F AE 86           MOV    cl, byte ptr [bx - 0x7952]   ; UNKNOWN
05B2A7  2A ED                 SUB    ch, ch                       ; UNKNOWN
05B2A9  D1 E1                 SHL    cx, 1                        ; UNKNOWN
05B2AB  03 C1                 ADD    ax, cx                       ; UNKNOWN
05B2AD  8A 8F BA 86           MOV    cl, byte ptr [bx - 0x7946]   ; UNKNOWN
05B2B1  2A ED                 SUB    ch, ch                       ; UNKNOWN
05B2B3  03 C1                 ADD    ax, cx                       ; UNKNOWN
05B2B5  D1 E3                 SHL    bx, 1                        ; UNKNOWN
05B2B7  03 87 C6 86           ADD    ax, word ptr [bx - 0x793a]   ; UNKNOWN
05B2BB  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
05B2BE  8B F3                 MOV    si, bx                       ; UNKNOWN
05B2C0  89 42 F8              MOV    word ptr [bp + si - 8], ax   ; UNKNOWN
05B2C3  FF 46 F2              INC    word ptr [bp - 0xe]          ; UNKNOWN
05B2C6  83 7E F2 04           CMP    word ptr [bp - 0xe], 4       ; UNKNOWN
05B2CA  7C B5                 JL     0x5b281                      ; UNKNOWN
05B2CC  1E                    PUSH   ds                           ; UNKNOWN
05B2CD  68 E8 CD              PUSH   0xcde8                       ; UNKNOWN
05B2D0  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
05B2D3  16                    PUSH   ss                           ; UNKNOWN
05B2D4  50                    PUSH   ax                           ; UNKNOWN
05B2D5  B8 04 00              MOV    ax, 4                        ; UNKNOWN
05B2D8  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
05B2DD  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
05B2E2  8A 46 F2              MOV    al, byte ptr [bp - 0xe]      ; UNKNOWN
05B2E5  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
05B2E8  8A 9F E8 CD           MOV    bl, byte ptr [bx - 0x3218]   ; UNKNOWN
05B2EC  2A FF                 SUB    bh, bh                       ; UNKNOWN
05B2EE  89 5E F4              MOV    word ptr [bp - 0xc], bx      ; UNKNOWN
05B2F1  88 87 E4 CD           MOV    byte ptr [bx - 0x321c], al   ; UNKNOWN
05B2F5  FF 46 F2              INC    word ptr [bp - 0xe]          ; UNKNOWN
05B2F8  83 7E F2 04           CMP    word ptr [bp - 0xe], 4       ; UNKNOWN
05B2FC  7C E4                 JL     0x5b2e2                      ; UNKNOWN
05B2FE  5E                    POP    si                           ; UNKNOWN
05B2FF  C9                    LEAVE                               ; UNKNOWN
05B300  CB                    RETF                                ; UNKNOWN
