; ============================================================================
; func_02DAA5_unknown
; Region   : load_image
; Bytes    : file 0x02DAA5..0x02DB29  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DAA5  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02DAA9  56                    PUSH   si                           ; UNKNOWN
02DAAA  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02DAAF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02DAB2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DAB5  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
02DABA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02DABD  0B C0                 OR     ax, ax                       ; UNKNOWN
02DABF  74 62                 JE     0x2db23                      ; UNKNOWN
02DAC1  0E                    PUSH   cs                           ; UNKNOWN
02DAC2  E8 91 FF              CALL   0x2da56                      ; UNKNOWN
02DAC5  8B D8                 MOV    bx, ax                       ; UNKNOWN
02DAC7  8A 87 D6 0A           MOV    al, byte ptr [bx + 0xad6]    ; UNKNOWN
02DACB  2A E4                 SUB    ah, ah                       ; UNKNOWN
02DACD  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02DAD0  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
02DAD3  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02DAD7  38 07                 CMP    byte ptr [bx], al            ; UNKNOWN
02DAD9  75 0D                 JNE    0x2dae8                      ; UNKNOWN
02DADB  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
02DADE  38 47 01              CMP    byte ptr [bx + 1], al        ; UNKNOWN
02DAE1  75 05                 JNE    0x2dae8                      ; UNKNOWN
02DAE3  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02DAE8  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
02DAED  EB 2E                 JMP    0x2db1d                      ; UNKNOWN
02DAEF  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02DAF2  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
02DAF5  7D 2C                 JGE    0x2db23                      ; UNKNOWN
02DAF7  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
02DAFA  8A 87 38 09           MOV    al, byte ptr [bx + 0x938]    ; UNKNOWN
02DAFE  8B 36 38 73           MOV    si, word ptr [0x7338]        ; UNKNOWN
02DB02  02 04                 ADD    al, byte ptr [si]            ; UNKNOWN
02DB04  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
02DB07  75 11                 JNE    0x2db1a                      ; UNKNOWN
02DB09  8A 87 4D 09           MOV    al, byte ptr [bx + 0x94d]    ; UNKNOWN
02DB0D  02 44 01              ADD    al, byte ptr [si + 1]        ; UNKNOWN
02DB10  3A 46 08              CMP    al, byte ptr [bp + 8]        ; UNKNOWN
02DB13  75 05                 JNE    0x2db1a                      ; UNKNOWN
02DB15  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02DB1A  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02DB1D  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
02DB21  74 CC                 JE     0x2daef                      ; UNKNOWN
02DB23  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02DB26  5E                    POP    si                           ; UNKNOWN
02DB27  C9                    LEAVE                               ; UNKNOWN
02DB28  CB                    RETF                                ; UNKNOWN
