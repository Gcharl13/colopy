; ============================================================================
; func_01E074_unknown
; Region   : load_image
; Bytes    : file 0x01E074..0x01E0E0  (108 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E074  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
01E078  C7 46 F6 FF FF        MOV    word ptr [bp - 0xa], 0xffff  ; UNKNOWN
01E07D  C7 46 FE 0F 27        MOV    word ptr [bp - 2], 0x270f    ; UNKNOWN
01E082  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
01E087  EB 6A                 JMP    0x1e0f3                      ; UNKNOWN
01E089  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
01E08D  7C 0C                 JL     0x1e09b                      ; UNKNOWN
01E08F  6B D8 12              IMUL   bx, ax, 0x12                 ; UNKNOWN
01E092  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
01E095  38 87 DE 79           CMP    byte ptr [bx + 0x79de], al   ; UNKNOWN
01E099  75 55                 JNE    0x1e0f0                      ; UNKNOWN
01E09B  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
01E09F  7C 1D                 JL     0x1e0be                      ; UNKNOWN
01E0A1  6B 5E FA 12           IMUL   bx, word ptr [bp - 6], 0x12  ; UNKNOWN
01E0A5  8A 87 DD 79           MOV    al, byte ptr [bx + 0x79dd]   ; UNKNOWN
01E0A9  2A E4                 SUB    ah, ah                       ; UNKNOWN
01E0AB  50                    PUSH   ax                           ; UNKNOWN
01E0AC  8A 87 DC 79           MOV    al, byte ptr [bx + 0x79dc]   ; UNKNOWN
01E0B0  50                    PUSH   ax                           ; UNKNOWN
01E0B1  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
01E0B6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01E0B9  3B 46 0C              CMP    ax, word ptr [bp + 0xc]      ; UNKNOWN
01E0BC  75 32                 JNE    0x1e0f0                      ; UNKNOWN
01E0BE  6B 5E FA 12           IMUL   bx, word ptr [bp - 6], 0x12  ; UNKNOWN
01E0C2  8A 87 DD 79           MOV    al, byte ptr [bx + 0x79dd]   ; UNKNOWN
01E0C6  2A E4                 SUB    ah, ah                       ; UNKNOWN
01E0C8  2B 46 08              SUB    ax, word ptr [bp + 8]        ; UNKNOWN
01E0CB  F7 D8                 NEG    ax                           ; UNKNOWN
01E0CD  50                    PUSH   ax                           ; UNKNOWN
01E0CE  8A 87 DC 79           MOV    al, byte ptr [bx + 0x79dc]   ; UNKNOWN
01E0D2  2A E4                 SUB    ah, ah                       ; UNKNOWN
01E0D4  2B 46 06              SUB    ax, word ptr [bp + 6]        ; UNKNOWN
01E0D7  F7 D8                 NEG    ax                           ; UNKNOWN
01E0D9  50                    PUSH   ax                           ; UNKNOWN
01E0DA  9A 3A 00 C2 44        LCALL  0x44c2, 0x3a                 ; UNKNOWN
01E0DF  83                    DB     0x83                         ; UNKNOWN (raw)
