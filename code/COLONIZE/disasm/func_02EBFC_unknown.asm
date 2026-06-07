; ============================================================================
; func_02EBFC_unknown
; Region   : load_image
; Bytes    : file 0x02EBFC..0x02EC51  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EBFC  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02EC00  2B C0                 SUB    ax, ax                       ; UNKNOWN
02EC02  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02EC05  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02EC08  EB 35                 JMP    0x2ec3f                      ; UNKNOWN
02EC0A  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02EC0D  83 7E FE 05           CMP    word ptr [bp - 2], 5         ; UNKNOWN
02EC11  7D 29                 JGE    0x2ec3c                      ; UNKNOWN
02EC13  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02EC16  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02EC19  0E                    PUSH   cs                           ; UNKNOWN
02EC1A  E8 69 F0              CALL   0x2dc86                      ; UNKNOWN
02EC1D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02EC20  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
02EC23  75 E5                 JNE    0x2ec0a                      ; UNKNOWN
02EC25  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02EC28  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02EC2B  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
02EC2D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02EC30  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02EC33  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
02EC35  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
02EC3A  EB CE                 JMP    0x2ec0a                      ; UNKNOWN
02EC3C  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02EC3F  83 7E FC 05           CMP    word ptr [bp - 4], 5         ; UNKNOWN
02EC43  7D 07                 JGE    0x2ec4c                      ; UNKNOWN
02EC45  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02EC4A  EB C1                 JMP    0x2ec0d                      ; UNKNOWN
02EC4C  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02EC4F  C9                    LEAVE                               ; UNKNOWN
02EC50  CB                    RETF                                ; UNKNOWN
