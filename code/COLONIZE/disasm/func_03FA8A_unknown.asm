; ============================================================================
; func_03FA8A_unknown
; Region   : load_image
; Bytes    : file 0x03FA8A..0x03FB40  (182 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FA8A  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
03FA8E  56                    PUSH   si                           ; UNKNOWN
03FA8F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03FA92  83 C0 04              ADD    ax, 4                        ; UNKNOWN
03FA95  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
03FA98  2A C0                 SUB    al, al                       ; UNKNOWN
03FA9A  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
03FA9D  88 87 9A 85           MOV    byte ptr [bx - 0x7a66], al   ; UNKNOWN
03FAA1  88 87 67 88           MOV    byte ptr [bx - 0x7799], al   ; UNKNOWN
03FAA5  88 87 6F 88           MOV    byte ptr [bx - 0x7791], al   ; UNKNOWN
03FAA9  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
03FAAE  2A C0                 SUB    al, al                       ; UNKNOWN
03FAB0  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
03FAB3  C1 E6 04              SHL    si, 4                        ; UNKNOWN
03FAB6  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
03FAB9  88 80 E2 85           MOV    byte ptr [bx + si - 0x7a1e], al ; UNKNOWN
03FABD  88 87 07 87           MOV    byte ptr [bx - 0x78f9], al   ; UNKNOWN
03FAC1  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
03FAC4  83 7E FA 10           CMP    word ptr [bp - 6], 0x10      ; UNKNOWN
03FAC8  7C E4                 JL     0x3faae                      ; UNKNOWN
03FACA  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
03FACF  EB 3D                 JMP    0x3fb0e                      ; UNKNOWN
03FAD1  50                    PUSH   ax                           ; UNKNOWN
03FAD2  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
03FAD7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03FADA  8A 46 F8              MOV    al, byte ptr [bp - 8]        ; UNKNOWN
03FADD  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
03FAE1  38 47 02              CMP    byte ptr [bx + 2], al        ; UNKNOWN
03FAE4  75 25                 JNE    0x3fb0b                      ; UNKNOWN
03FAE6  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
03FAE9  FE 84 6F 88           INC    byte ptr [si - 0x7791]       ; UNKNOWN
03FAED  8A 47 04              MOV    al, byte ptr [bx + 4]        ; UNKNOWN
03FAF0  00 84 67 88           ADD    byte ptr [si - 0x7799], al   ; UNKNOWN
03FAF4  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
03FAF7  2A E4                 SUB    ah, ah                       ; UNKNOWN
03FAF9  50                    PUSH   ax                           ; UNKNOWN
03FAFA  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
03FAFC  50                    PUSH   ax                           ; UNKNOWN
03FAFD  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
03FB02  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03FB05  8B D8                 MOV    bx, ax                       ; UNKNOWN
03FB07  FE 87 07 87           INC    byte ptr [bx - 0x78f9]       ; UNKNOWN
03FB0B  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
03FB0E  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
03FB11  39 06 12 3E           CMP    word ptr [0x3e12], ax        ; UNKNOWN
03FB15  7F BA                 JG     0x3fad1                      ; UNKNOWN
03FB17  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
03FB1C  EB 4D                 JMP    0x3fb6b                      ; UNKNOWN
03FB1E  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03FB21  8A 8F 83 88           MOV    cl, byte ptr [bx - 0x777d]   ; UNKNOWN
03FB25  80 E1 0F              AND    cl, 0xf                      ; UNKNOWN
03FB28  3A 4E F8              CMP    cl, byte ptr [bp - 8]        ; UNKNOWN
03FB2B  75 3B                 JNE    0x3fb68                      ; UNKNOWN
03FB2D  6A 01                 PUSH   1                            ; UNKNOWN
03FB2F  50                    PUSH   ax                           ; UNKNOWN
03FB30  9A 4C 00 75 38        LCALL  0x3875, 0x4c                 ; UNKNOWN
03FB35  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03FB38  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03FB3B  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
03FB3E  81                    DB     0x81                         ; UNKNOWN (raw)
03FB3F  C3                    DB     0xC3                         ; UNKNOWN (raw)
