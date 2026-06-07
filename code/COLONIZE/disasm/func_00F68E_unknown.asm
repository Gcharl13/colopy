; ============================================================================
; func_00F68E_unknown
; Region   : load_image
; Bytes    : file 0x00F68E..0x00F6FF  (113 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F68E  C8 A0 00 00           ENTER  0xa0, 0                      ; UNKNOWN
00F692  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
00F695  2D 05 00              SUB    ax, 5                        ; UNKNOWN
00F698  74 18                 JE     0xf6b2                       ; UNKNOWN
00F69A  2D 03 00              SUB    ax, 3                        ; UNKNOWN
00F69D  74 19                 JE     0xf6b8                       ; UNKNOWN
00F69F  48                    DEC    ax                           ; UNKNOWN
00F6A0  74 1C                 JE     0xf6be                       ; UNKNOWN
00F6A2  48                    DEC    ax                           ; UNKNOWN
00F6A3  74 1F                 JE     0xf6c4                       ; UNKNOWN
00F6A5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00F6A8  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F6AB  50                    PUSH   ax                           ; UNKNOWN
00F6AC  0E                    PUSH   cs                           ; UNKNOWN
00F6AD  E8 50 FF              CALL   0xf600                       ; UNKNOWN
00F6B0  EB 2D                 JMP    0xf6df                       ; UNKNOWN
00F6B2  68 ED 06              PUSH   0x6ed                        ; UNKNOWN
00F6B5  EB 10                 JMP    0xf6c7                       ; UNKNOWN
00F6B7  90                    NOP                                 ; UNKNOWN
00F6B8  68 F4 06              PUSH   0x6f4                        ; UNKNOWN
00F6BB  EB 0A                 JMP    0xf6c7                       ; UNKNOWN
00F6BD  90                    NOP                                 ; UNKNOWN
00F6BE  68 FB 06              PUSH   0x6fb                        ; UNKNOWN
00F6C1  EB 04                 JMP    0xf6c7                       ; UNKNOWN
00F6C3  90                    NOP                                 ; UNKNOWN
00F6C4  68 02 07              PUSH   0x702                        ; UNKNOWN
00F6C7  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F6CA  50                    PUSH   ax                           ; UNKNOWN
00F6CB  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00F6D0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F6D3  68 CC 06              PUSH   0x6cc                        ; UNKNOWN
00F6D6  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F6D9  50                    PUSH   ax                           ; UNKNOWN
00F6DA  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F6DF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F6E2  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F6E5  16                    PUSH   ss                           ; UNKNOWN
00F6E6  50                    PUSH   ax                           ; UNKNOWN
00F6E7  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F6EB  16                    PUSH   ss                           ; UNKNOWN
00F6EC  50                    PUSH   ax                           ; UNKNOWN
00F6ED  E8 96 FE              CALL   0xf586                       ; UNKNOWN
00F6F0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F6F3  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F6F7  50                    PUSH   ax                           ; UNKNOWN
00F6F8  9A 00 00 B2 00        LCALL  0xb2, 0                      ; UNKNOWN
00F6FD  C9                    LEAVE                               ; UNKNOWN
00F6FE  CB                    RETF                                ; UNKNOWN
