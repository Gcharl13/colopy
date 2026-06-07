; ============================================================================
; func_031208_unknown
; Region   : load_image
; Bytes    : file 0x031208..0x0312C3  (187 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031208  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
03120C  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
031211  E9 9F 00              JMP    0x312b3                      ; UNKNOWN
031214  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
031217  83 7E F8 05           CMP    word ptr [bp - 8], 5         ; UNKNOWN
03121B  7E 03                 JLE    0x31220                      ; UNKNOWN
03121D  E9 90 00              JMP    0x312b0                      ; UNKNOWN
031220  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
031223  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
031226  9A 96 06 5F 24        LCALL  0x245f, 0x696                ; UNKNOWN
03122B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03122E  98                    CWDE                                ; UNKNOWN
03122F  0B C0                 OR     ax, ax                       ; UNKNOWN
031231  7C E1                 JL     0x31214                      ; UNKNOWN
031233  50                    PUSH   ax                           ; UNKNOWN
031234  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
031239  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03123C  83 F8 07              CMP    ax, 7                        ; UNKNOWN
03123F  74 05                 JE     0x31246                      ; UNKNOWN
031241  83 F8 06              CMP    ax, 6                        ; UNKNOWN
031244  75 CE                 JNE    0x31214                      ; UNKNOWN
031246  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
03124A  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
03124D  2A E4                 SUB    ah, ah                       ; UNKNOWN
03124F  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
031252  48                    DEC    ax                           ; UNKNOWN
031253  48                    DEC    ax                           ; UNKNOWN
031254  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
031257  50                    PUSH   ax                           ; UNKNOWN
031258  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
03125A  2A E4                 SUB    ah, ah                       ; UNKNOWN
03125C  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
03125F  48                    DEC    ax                           ; UNKNOWN
031260  48                    DEC    ax                           ; UNKNOWN
031261  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
031264  50                    PUSH   ax                           ; UNKNOWN
031265  9A 9A 04 C9 33        LCALL  0x33c9, 0x49a                ; UNKNOWN
03126A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03126D  83 F8 0C              CMP    ax, 0xc                      ; UNKNOWN
031270  74 05                 JE     0x31277                      ; UNKNOWN
031272  83 F8 06              CMP    ax, 6                        ; UNKNOWN
031275  75 9D                 JNE    0x31214                      ; UNKNOWN
031277  6A 01                 PUSH   1                            ; UNKNOWN
031279  6A 04                 PUSH   4                            ; UNKNOWN
03127B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03127E  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
031281  9A 53 01 C9 33        LCALL  0x33c9, 0x153                ; UNKNOWN
031286  83 C4 08              ADD    sp, 8                        ; UNKNOWN
031289  6A 00                 PUSH   0                            ; UNKNOWN
03128B  6A 03                 PUSH   3                            ; UNKNOWN
03128D  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
031290  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
031293  6A FF                 PUSH   -1                           ; UNKNOWN
031295  80 3E 66 74 01        CMP    byte ptr [0x7466], 1         ; UNKNOWN
03129A  1B C0                 SBB    ax, ax                       ; UNKNOWN
03129C  F7 D8                 NEG    ax                           ; UNKNOWN
03129E  50                    PUSH   ax                           ; UNKNOWN
03129F  68 69 1E              PUSH   0x1e69                       ; UNKNOWN
0312A2  0E                    PUSH   cs                           ; UNKNOWN
0312A3  E8 2E FC              CALL   0x30ed4                      ; UNKNOWN
0312A6  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
0312A9  08 06 66 74           OR     byte ptr [0x7466], al        ; UNKNOWN
0312AD  E9 64 FF              JMP    0x31214                      ; UNKNOWN
0312B0  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
0312B3  83 7E F6 05           CMP    word ptr [bp - 0xa], 5       ; UNKNOWN
0312B7  7D 08                 JGE    0x312c1                      ; UNKNOWN
0312B9  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
0312BE  E9 56 FF              JMP    0x31217                      ; UNKNOWN
0312C1  C9                    LEAVE                               ; UNKNOWN
0312C2  CB                    RETF                                ; UNKNOWN
