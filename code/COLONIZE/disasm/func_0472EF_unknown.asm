; ============================================================================
; func_0472EF_unknown
; Region   : load_image
; Bytes    : file 0x0472EF..0x04736D  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0472EF  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
0472F3  80 3E C6 0B 00        CMP    byte ptr [0xbc6], 0          ; UNKNOWN
0472F8  74 6C                 JE     0x47366                      ; UNKNOWN
0472FA  83 3E E8 0E 00        CMP    word ptr [0xee8], 0          ; UNKNOWN
0472FF  75 65                 JNE    0x47366                      ; UNKNOWN
047301  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
047306  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
047309  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
04730C  83 C0 1E              ADD    ax, 0x1e                     ; UNKNOWN
04730F  83 D2 00              ADC    dx, 0                        ; UNKNOWN
047312  3B 16 3C C6           CMP    dx, word ptr [0xc63c]        ; UNKNOWN
047316  7C 0F                 JL     0x47327                      ; UNKNOWN
047318  7F 06                 JG     0x47320                      ; UNKNOWN
04731A  3B 06 3A C6           CMP    ax, word ptr [0xc63a]        ; UNKNOWN
04731E  76 07                 JBE    0x47327                      ; UNKNOWN
047320  8B 16 3C C6           MOV    dx, word ptr [0xc63c]        ; UNKNOWN
047324  A1 3A C6              MOV    ax, word ptr [0xc63a]        ; UNKNOWN
047327  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04732A  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
04732D  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
047332  0B C0                 OR     ax, ax                       ; UNKNOWN
047334  75 19                 JNE    0x4734f                      ; UNKNOWN
047336  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
047339  50                    PUSH   ax                           ; UNKNOWN
04733A  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
04733D  50                    PUSH   ax                           ; UNKNOWN
04733E  9A 73 03 1E 5C        LCALL  0x5c1e, 0x373                ; UNKNOWN
047343  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047346  0B C0                 OR     ax, ax                       ; UNKNOWN
047348  75 05                 JNE    0x4734f                      ; UNKNOWN
04734A  BA 01 00              MOV    dx, 1                        ; UNKNOWN
04734D  EB 02                 JMP    0x47351                      ; UNKNOWN
04734F  2B D2                 SUB    dx, dx                       ; UNKNOWN
047351  0B D2                 OR     dx, dx                       ; UNKNOWN
047353  74 11                 JE     0x47366                      ; UNKNOWN
047355  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
04735A  3B 56 FE              CMP    dx, word ptr [bp - 2]        ; UNKNOWN
04735D  7C CE                 JL     0x4732d                      ; UNKNOWN
04735F  7F 05                 JG     0x47366                      ; UNKNOWN
047361  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
047364  72 C7                 JB     0x4732d                      ; UNKNOWN
047366  9A E4 00 EF 21        LCALL  0x21ef, 0xe4                 ; UNKNOWN
04736B  C9                    LEAVE                               ; UNKNOWN
04736C  CB                    RETF                                ; UNKNOWN
