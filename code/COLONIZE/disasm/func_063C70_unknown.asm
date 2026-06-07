; ============================================================================
; func_063C70_unknown
; Region   : load_image
; Bytes    : file 0x063C70..0x063CE5  (117 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063C70  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
063C74  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
063C79  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
063C7C  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
063C7F  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
063C84  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
063C87  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
063C8A  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
063C8D  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
063C90  89 87 26 CE           MOV    word ptr [bx - 0x31da], ax   ; UNKNOWN
063C94  89 97 28 CE           MOV    word ptr [bx - 0x31d8], dx   ; UNKNOWN
063C98  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
063C9B  83 7E FA 08           CMP    word ptr [bp - 6], 8         ; UNKNOWN
063C9F  7C E3                 JL     0x63c84                      ; UNKNOWN
063CA1  2B C0                 SUB    ax, ax                       ; UNKNOWN
063CA3  A3 24 CE              MOV    word ptr [0xce24], ax        ; UNKNOWN
063CA6  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
063CA9  EB 16                 JMP    0x63cc1                      ; UNKNOWN
063CAB  8B D8                 MOV    bx, ax                       ; UNKNOWN
063CAD  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
063CB0  8A 87 02 CE           MOV    al, byte ptr [bx - 0x31fe]   ; UNKNOWN
063CB4  2A E4                 SUB    ah, ah                       ; UNKNOWN
063CB6  01 06 24 CE           ADD    word ptr [0xce24], ax        ; UNKNOWN
063CBA  88 A7 03 CE           MOV    byte ptr [bx - 0x31fd], ah   ; UNKNOWN
063CBE  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
063CC1  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
063CC4  39 06 00 CE           CMP    word ptr [0xce00], ax        ; UNKNOWN
063CC8  7F E1                 JG     0x63cab                      ; UNKNOWN
063CCA  C7 06 22 CE 03 00     MOV    word ptr [0xce22], 3         ; UNKNOWN
063CD0  83 3E 24 CE 10        CMP    word ptr [0xce24], 0x10      ; UNKNOWN
063CD5  7F 06                 JG     0x63cdd                      ; UNKNOWN
063CD7  C7 06 22 CE 00 00     MOV    word ptr [0xce22], 0         ; UNKNOWN
063CDD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
063CE0  A3 14 0C              MOV    word ptr [0xc14], ax         ; UNKNOWN
063CE3  C9                    LEAVE                               ; UNKNOWN
063CE4  CB                    RETF                                ; UNKNOWN
