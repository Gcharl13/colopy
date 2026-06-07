; ============================================================================
; func_05EB10_unknown
; Region   : load_image
; Bytes    : file 0x05EB10..0x05EB4F  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05EB10  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
05EB14  50                    PUSH   ax                           ; UNKNOWN
05EB15  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
05EB1A  0B C0                 OR     ax, ax                       ; UNKNOWN
05EB1C  7C 4A                 JL     0x5eb68                      ; UNKNOWN
05EB1E  50                    PUSH   ax                           ; UNKNOWN
05EB1F  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
05EB24  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05EB27  0B C0                 OR     ax, ax                       ; UNKNOWN
05EB29  75 3D                 JNE    0x5eb68                      ; UNKNOWN
05EB2B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
05EB2E  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
05EB31  9A DE 35 5F 24        LCALL  0x245f, 0x35de               ; UNKNOWN
05EB36  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05EB39  0B C0                 OR     ax, ax                       ; UNKNOWN
05EB3B  74 0D                 JE     0x5eb4a                      ; UNKNOWN
05EB3D  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
05EB40  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05EB44  88 87 94 00           MOV    byte ptr [bx + 0x94], al     ; UNKNOWN
05EB48  EB 1E                 JMP    0x5eb68                      ; UNKNOWN
05EB4A  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
05EB4D  8B C3                 MOV    ax, bx                       ; UNKNOWN
