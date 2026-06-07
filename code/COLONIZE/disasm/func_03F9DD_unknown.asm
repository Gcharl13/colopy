; ============================================================================
; func_03F9DD_unknown
; Region   : load_image
; Bytes    : file 0x03F9DD..0x03FA8A  (173 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03F9DD  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
03F9E1  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
03F9E6  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
03F9E9  C6 87 DA 86 00        MOV    byte ptr [bx - 0x7926], 0    ; UNKNOWN
03F9EE  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
03F9F1  83 7E FC 1D           CMP    word ptr [bp - 4], 0x1d      ; UNKNOWN
03F9F5  7C EF                 JL     0x3f9e6                      ; UNKNOWN
03F9F7  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
03F9FC  EB 2F                 JMP    0x3fa2d                      ; UNKNOWN
03F9FE  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03FA01  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
03FA05  24 0F                 AND    al, 0xf                      ; UNKNOWN
03FA07  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
03FA0A  75 1E                 JNE    0x3fa2a                      ; UNKNOWN
03FA0C  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
03FA0F  9A F0 08 5F 24        LCALL  0x245f, 0x8f0                ; UNKNOWN
03FA14  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03FA17  0B C0                 OR     ax, ax                       ; UNKNOWN
03FA19  7C 0F                 JL     0x3fa2a                      ; UNKNOWN
03FA1B  6B 5E F8 1C           IMUL   bx, word ptr [bp - 8], 0x1c  ; UNKNOWN
03FA1F  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
03FA23  98                    CWDE                                ; UNKNOWN
03FA24  8B D8                 MOV    bx, ax                       ; UNKNOWN
03FA26  FE 87 DA 86           INC    byte ptr [bx - 0x7926]       ; UNKNOWN
03FA2A  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
03FA2D  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
03FA30  39 06 14 3E           CMP    word ptr [0x3e14], ax        ; UNKNOWN
03FA34  7F C8                 JG     0x3f9fe                      ; UNKNOWN
03FA36  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
03FA3B  EB 26                 JMP    0x3fa63                      ; UNKNOWN
03FA3D  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
03FA40  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
03FA44  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
03FA47  98                    CWDE                                ; UNKNOWN
03FA48  3B 46 FE              CMP    ax, word ptr [bp - 2]        ; UNKNOWN
03FA4B  7E 13                 JLE    0x3fa60                      ; UNKNOWN
03FA4D  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03FA50  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
03FA55  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03FA58  8B D8                 MOV    bx, ax                       ; UNKNOWN
03FA5A  FE 87 DA 86           INC    byte ptr [bx - 0x7926]       ; UNKNOWN
03FA5E  EB DD                 JMP    0x3fa3d                      ; UNKNOWN
03FA60  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
03FA63  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
03FA66  39 06 16 3E           CMP    word ptr [0x3e16], ax        ; UNKNOWN
03FA6A  7E 1C                 JLE    0x3fa88                      ; UNKNOWN
03FA6C  50                    PUSH   ax                           ; UNKNOWN
03FA6D  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
03FA72  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03FA75  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
03FA78  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
03FA7C  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
03FA7F  75 DF                 JNE    0x3fa60                      ; UNKNOWN
03FA81  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03FA86  EB B8                 JMP    0x3fa40                      ; UNKNOWN
03FA88  C9                    LEAVE                               ; UNKNOWN
03FA89  CB                    RETF                                ; UNKNOWN
