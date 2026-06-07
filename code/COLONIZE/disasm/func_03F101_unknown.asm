; ============================================================================
; func_03F101_unknown
; Region   : load_image
; Bytes    : file 0x03F101..0x03F177  (118 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03F101  C8 22 00 00           ENTER  0x22, 0                      ; UNKNOWN
03F105  57                    PUSH   di                           ; UNKNOWN
03F106  56                    PUSH   si                           ; UNKNOWN
03F107  C7 06 BE 0B 01 00     MOV    word ptr [0xbbe], 1          ; UNKNOWN
03F10D  C7 46 DE 00 00        MOV    word ptr [bp - 0x22], 0      ; UNKNOWN
03F112  83 7E DE 00           CMP    word ptr [bp - 0x22], 0      ; UNKNOWN
03F116  74 08                 JE     0x3f120                      ; UNKNOWN
03F118  BE 42 84              MOV    si, 0x8442                   ; UNKNOWN
03F11B  BF 01 00              MOV    di, 1                        ; UNKNOWN
03F11E  EB 05                 JMP    0x3f125                      ; UNKNOWN
03F120  BE 34 83              MOV    si, 0x8334                   ; UNKNOWN
03F123  2B FF                 SUB    di, di                       ; UNKNOWN
03F125  68 0E 01              PUSH   0x10e                        ; UNKNOWN
03F128  6A 00                 PUSH   0                            ; UNKNOWN
03F12A  56                    PUSH   si                           ; UNKNOWN
03F12B  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
03F130  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03F133  2B C0                 SUB    ax, ax                       ; UNKNOWN
03F135  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
03F138  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
03F13B  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
03F140  89 7E EC              MOV    word ptr [bp - 0x14], di     ; UNKNOWN
03F143  89 76 E0              MOV    word ptr [bp - 0x20], si     ; UNKNOWN
03F146  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03F14B  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1       ; UNKNOWN
03F150  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03F153  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03F156  8D 46 E6              LEA    ax, [bp - 0x1a]              ; UNKNOWN
03F159  50                    PUSH   ax                           ; UNKNOWN
03F15A  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
03F15D  8B 56 F4              MOV    dx, word ptr [bp - 0xc]      ; UNKNOWN
03F160  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
03F163  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
03F166  8D 5E E8              LEA    bx, [bp - 0x18]              ; UNKNOWN
03F169  E8 16 FF              CALL   0x3f082                      ; UNKNOWN
03F16C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03F16F  0B C0                 OR     ax, ax                       ; UNKNOWN
03F171  7D 03                 JGE    0x3f176                      ; UNKNOWN
03F173  E9 CA 00              JMP    0x3f240                      ; UNKNOWN
03F176  C7                    DB     0xC7                         ; UNKNOWN (raw)
