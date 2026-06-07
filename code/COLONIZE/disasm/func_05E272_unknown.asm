; ============================================================================
; func_05E272_unknown
; Region   : load_image
; Bytes    : file 0x05E272..0x05E2C3  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05E272  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
05E276  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05E279  9A 54 06 B7 36        LCALL  0x36b7, 0x654                ; UNKNOWN
05E27E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05E281  2A E4                 SUB    ah, ah                       ; UNKNOWN
05E283  83 C0 03              ADD    ax, 3                        ; UNKNOWN
05E286  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
05E289  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
05E28D  80 BF 82 88 10        CMP    byte ptr [bx - 0x777e], 0x10 ; UNKNOWN
05E292  75 03                 JNE    0x5e297                      ; UNKNOWN
05E294  D1 66 FE              SHL    word ptr [bp - 2], 1         ; UNKNOWN
05E297  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
05E29B  80 BF 82 88 0F        CMP    byte ptr [bx - 0x777e], 0xf  ; UNKNOWN
05E2A0  75 04                 JNE    0x5e2a6                      ; UNKNOWN
05E2A2  83 46 FE 03           ADD    word ptr [bp - 2], 3         ; UNKNOWN
05E2A6  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
05E2AA  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
05E2AE  2A E4                 SUB    ah, ah                       ; UNKNOWN
05E2B0  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
05E2B3  29 46 FE              SUB    word ptr [bp - 2], ax        ; UNKNOWN
05E2B6  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
05E2B9  83 F8 01              CMP    ax, 1                        ; UNKNOWN
05E2BC  7D 03                 JGE    0x5e2c1                      ; UNKNOWN
05E2BE  B8 01 00              MOV    ax, 1                        ; UNKNOWN
05E2C1  C9                    LEAVE                               ; UNKNOWN
05E2C2  CB                    RETF                                ; UNKNOWN
