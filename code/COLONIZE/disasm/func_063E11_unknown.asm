; ============================================================================
; func_063E11_unknown
; Region   : load_image
; Bytes    : file 0x063E11..0x063E5A  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063E11  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
063E15  C7 46 F6 00 FF        MOV    word ptr [bp - 0xa], 0xff00  ; UNKNOWN
063E1A  C7 46 F8 00 A0        MOV    word ptr [bp - 8], 0xa000    ; UNKNOWN
063E1F  C7 46 FA 50 FD        MOV    word ptr [bp - 6], 0xfd50    ; UNKNOWN
063E24  C7 46 FC 00 A0        MOV    word ptr [bp - 4], 0xa000    ; UNKNOWN
063E29  C7 46 FE 60 00        MOV    word ptr [bp - 2], 0x60      ; UNKNOWN
063E2E  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
063E32  74 10                 JE     0x63e44                      ; UNKNOWN
063E34  6A 60                 PUSH   0x60                         ; UNKNOWN
063E36  68 00 A0              PUSH   0xa000                       ; UNKNOWN
063E39  68 50 FD              PUSH   0xfd50                       ; UNKNOWN
063E3C  68 00 A0              PUSH   0xa000                       ; UNKNOWN
063E3F  68 00 FF              PUSH   0xff00                       ; UNKNOWN
063E42  EB 0F                 JMP    0x63e53                      ; UNKNOWN
063E44  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
063E47  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
063E4A  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
063E4D  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
063E50  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
063E53  9A BE 12 65 5F        LCALL  0x5f65, 0x12be               ; UNKNOWN
063E58  C9                    LEAVE                               ; UNKNOWN
063E59  CB                    RETF                                ; UNKNOWN
