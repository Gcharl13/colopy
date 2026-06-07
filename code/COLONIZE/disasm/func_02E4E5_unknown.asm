; ============================================================================
; func_02E4E5_unknown
; Region   : load_image
; Bytes    : file 0x02E4E5..0x02E599  (180 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E4E5  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
02E4E9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E4EC  0E                    PUSH   cs                           ; UNKNOWN
02E4ED  E8 F7 FE              CALL   0x2e3e7                      ; UNKNOWN
02E4F0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E4F3  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
02E4F6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E4F9  0E                    PUSH   cs                           ; UNKNOWN
02E4FA  E8 23 FF              CALL   0x2e420                      ; UNKNOWN
02E4FD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E500  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02E503  83 7E F8 13           CMP    word ptr [bp - 8], 0x13      ; UNKNOWN
02E507  7F 15                 JG     0x2e51e                      ; UNKNOWN
02E509  83 F8 1C              CMP    ax, 0x1c                     ; UNKNOWN
02E50C  75 05                 JNE    0x2e513                      ; UNKNOWN
02E50E  C7 46 FA 13 00        MOV    word ptr [bp - 6], 0x13      ; UNKNOWN
02E513  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02E516  9A 0C 00 76 1A        LCALL  0x1a76, 0xc                  ; UNKNOWN
02E51B  E9 8B 00              JMP    0x2e5a9                      ; UNKNOWN
02E51E  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
02E521  83 C0 52              ADD    ax, 0x52                     ; UNKNOWN
02E524  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E527  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
02E52A  39 46 FA              CMP    word ptr [bp - 6], ax        ; UNKNOWN
02E52D  75 05                 JNE    0x2e534                      ; UNKNOWN
02E52F  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02E532  EB 02                 JMP    0x2e536                      ; UNKNOWN
02E534  2B C0                 SUB    ax, ax                       ; UNKNOWN
02E536  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E539  83 7E FA 15           CMP    word ptr [bp - 6], 0x15      ; UNKNOWN
02E53D  75 0B                 JNE    0x2e54a                      ; UNKNOWN
02E53F  83 7E F8 17           CMP    word ptr [bp - 8], 0x17      ; UNKNOWN
02E543  75 05                 JNE    0x2e54a                      ; UNKNOWN
02E545  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02E54A  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
02E54E  75 09                 JNE    0x2e559                      ; UNKNOWN
02E550  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
02E553  83 C0 36              ADD    ax, 0x36                     ; UNKNOWN
02E556  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E559  83 7E F8 15           CMP    word ptr [bp - 8], 0x15      ; UNKNOWN
02E55D  74 06                 JE     0x2e565                      ; UNKNOWN
02E55F  83 7E F8 17           CMP    word ptr [bp - 8], 0x17      ; UNKNOWN
02E563  75 47                 JNE    0x2e5ac                      ; UNKNOWN
02E565  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E569  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E56C  98                    CWDE                                ; UNKNOWN
02E56D  2B 46 06              SUB    ax, word ptr [bp + 6]        ; UNKNOWN
02E570  F7 D8                 NEG    ax                           ; UNKNOWN
02E572  50                    PUSH   ax                           ; UNKNOWN
02E573  0E                    PUSH   cs                           ; UNKNOWN
02E574  E8 8A F9              CALL   0x2df01                      ; UNKNOWN
02E577  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E57A  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
02E57D  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
02E580  80 BF 82 88 09        CMP    byte ptr [bx - 0x777e], 9    ; UNKNOWN
02E585  74 07                 JE     0x2e58e                      ; UNKNOWN
02E587  80 BF 82 88 07        CMP    byte ptr [bx - 0x777e], 7    ; UNKNOWN
02E58C  75 1E                 JNE    0x2e5ac                      ; UNKNOWN
02E58E  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
02E591  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
02E595  2A FF                 SUB    bh, bh                       ; UNKNOWN
02E597  8B C3                 MOV    ax, bx                       ; UNKNOWN
