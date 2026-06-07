; ============================================================================
; func_00EB2E_unknown
; Region   : load_image
; Bytes    : file 0x00EB2E..0x00EBE0  (178 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EB2E  C8 2E 00 00           ENTER  0x2e, 0                      ; UNKNOWN
00EB32  52                    PUSH   dx                           ; UNKNOWN
00EB33  50                    PUSH   ax                           ; UNKNOWN
00EB34  53                    PUSH   bx                           ; UNKNOWN
00EB35  56                    PUSH   si                           ; UNKNOWN
00EB36  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
00EB3B  1E                    PUSH   ds                           ; UNKNOWN
00EB3C  50                    PUSH   ax                           ; UNKNOWN
00EB3D  8D 1E DA 05           LEA    bx, [0x5da]                  ; UNKNOWN
00EB41  9A FC 00 E9 5A        LCALL  0x5ae9, 0xfc                 ; UNKNOWN
00EB46  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
00EB49  0B C0                 OR     ax, ax                       ; UNKNOWN
00EB4B  74 7C                 JE     0xebc9                       ; UNKNOWN
00EB4D  C7 46 D4 01 00        MOV    word ptr [bp - 0x2c], 1      ; UNKNOWN
00EB52  83 7E D0 01           CMP    word ptr [bp - 0x30], 1      ; UNKNOWN
00EB56  7C 27                 JL     0xeb7f                       ; UNKNOWN
00EB58  8B 5E D2              MOV    bx, word ptr [bp - 0x2e]     ; UNKNOWN
00EB5B  F6 47 06 10           TEST   byte ptr [bx + 6], 0x10      ; UNKNOWN
00EB5F  75 68                 JNE    0xebc9                       ; UNKNOWN
00EB61  53                    PUSH   bx                           ; UNKNOWN
00EB62  6A 24                 PUSH   0x24                         ; UNKNOWN
00EB64  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
00EB67  50                    PUSH   ax                           ; UNKNOWN
00EB68  9A FA 08 65 5F        LCALL  0x5f65, 0x8fa                ; UNKNOWN
00EB6D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00EB70  0B C0                 OR     ax, ax                       ; UNKNOWN
00EB72  74 55                 JE     0xebc9                       ; UNKNOWN
00EB74  8B 46 D0              MOV    ax, word ptr [bp - 0x30]     ; UNKNOWN
00EB77  FF 46 D4              INC    word ptr [bp - 0x2c]         ; UNKNOWN
00EB7A  39 46 D4              CMP    word ptr [bp - 0x2c], ax     ; UNKNOWN
00EB7D  7E D9                 JLE    0xeb58                       ; UNKNOWN
00EB7F  C7 46 D4 00 00        MOV    word ptr [bp - 0x2c], 0      ; UNKNOWN
00EB84  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
00EB87  50                    PUSH   ax                           ; UNKNOWN
00EB88  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
00EB8D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00EB90  0B C0                 OR     ax, ax                       ; UNKNOWN
00EB92  7E 21                 JLE    0xebb5                       ; UNKNOWN
00EB94  8B 76 D4              MOV    si, word ptr [bp - 0x2c]     ; UNKNOWN
00EB97  80 7A D6 20           CMP    byte ptr [bp + si - 0x2a], 0x20 ; UNKNOWN
00EB9B  7D 04                 JGE    0xeba1                       ; UNKNOWN
00EB9D  C6 42 D6 00           MOV    byte ptr [bp + si - 0x2a], 0 ; UNKNOWN
00EBA1  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
00EBA4  50                    PUSH   ax                           ; UNKNOWN
00EBA5  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
00EBAA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00EBAD  FF 46 D4              INC    word ptr [bp - 0x2c]         ; UNKNOWN
00EBB0  3B 46 D4              CMP    ax, word ptr [bp - 0x2c]     ; UNKNOWN
00EBB3  7F DF                 JG     0xeb94                       ; UNKNOWN
00EBB5  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
00EBB8  50                    PUSH   ax                           ; UNKNOWN
00EBB9  FF 76 CC              PUSH   word ptr [bp - 0x34]         ; UNKNOWN
00EBBC  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00EBC1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00EBC4  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
00EBC9  83 7E D2 00           CMP    word ptr [bp - 0x2e], 0      ; UNKNOWN
00EBCD  74 0B                 JE     0xebda                       ; UNKNOWN
00EBCF  FF 76 D2              PUSH   word ptr [bp - 0x2e]         ; UNKNOWN
00EBD2  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
00EBD7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00EBDA  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
00EBDD  5E                    POP    si                           ; UNKNOWN
00EBDE  C9                    LEAVE                               ; UNKNOWN
00EBDF  C3                    RET                                 ; UNKNOWN
