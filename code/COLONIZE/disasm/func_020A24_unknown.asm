; ============================================================================
; func_020A24_unknown
; Region   : load_image
; Bytes    : file 0x020A24..0x020A67  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020A24  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
020A28  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
020A2B  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
020A2E  74 0F                 JE     0x20a3f                      ; UNKNOWN
020A30  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
020A35  74 0F                 JE     0x20a46                      ; UNKNOWN
020A37  A1 4A 3E              MOV    ax, word ptr [0x3e4a]        ; UNKNOWN
020A3A  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
020A3D  75 07                 JNE    0x20a46                      ; UNKNOWN
020A3F  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
020A44  EB 05                 JMP    0x20a4b                      ; UNKNOWN
020A46  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
020A4B  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
020A50  74 15                 JE     0x20a67                      ; UNKNOWN
020A52  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
020A56  75 03                 JNE    0x20a5b                      ; UNKNOWN
020A58  E9 03 01              JMP    0x20b5e                      ; UNKNOWN
020A5B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
020A5E  0E                    PUSH   cs                           ; UNKNOWN
020A5F  E8 C7 FB              CALL   0x20629                      ; UNKNOWN
020A62  83 C4 02              ADD    sp, 2                        ; UNKNOWN
020A65  C9                    LEAVE                               ; UNKNOWN
020A66  CB                    RETF                                ; UNKNOWN
