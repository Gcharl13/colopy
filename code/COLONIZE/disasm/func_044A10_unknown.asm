; ============================================================================
; func_044A10_unknown
; Region   : load_image
; Bytes    : file 0x044A10..0x044A4B  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044A10  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
044A14  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
044A19  EB 1F                 JMP    0x44a3a                      ; UNKNOWN
044A1B  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
044A1E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
044A21  39 06 88 82           CMP    word ptr [0x8288], ax        ; UNKNOWN
044A25  7E 10                 JLE    0x44a37                      ; UNKNOWN
044A27  6A FF                 PUSH   -1                           ; UNKNOWN
044A29  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
044A2C  50                    PUSH   ax                           ; UNKNOWN
044A2D  9A 19 02 C9 33        LCALL  0x33c9, 0x219                ; UNKNOWN
044A32  83 C4 06              ADD    sp, 6                        ; UNKNOWN
044A35  EB E4                 JMP    0x44a1b                      ; UNKNOWN
044A37  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
044A3A  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
044A3D  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
044A40  7D 07                 JGE    0x44a49                      ; UNKNOWN
044A42  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
044A47  EB D5                 JMP    0x44a1e                      ; UNKNOWN
044A49  C9                    LEAVE                               ; UNKNOWN
044A4A  CB                    RETF                                ; UNKNOWN
