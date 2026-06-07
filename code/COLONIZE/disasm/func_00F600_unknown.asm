; ============================================================================
; func_00F600_unknown
; Region   : load_image
; Bytes    : file 0x00F600..0x00F68D  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F600  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
00F604  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
00F607  0B C0                 OR     ax, ax                       ; UNKNOWN
00F609  74 11                 JE     0xf61c                       ; UNKNOWN
00F60B  48                    DEC    ax                           ; UNKNOWN
00F60C  74 14                 JE     0xf622                       ; UNKNOWN
00F60E  48                    DEC    ax                           ; UNKNOWN
00F60F  74 17                 JE     0xf628                       ; UNKNOWN
00F611  48                    DEC    ax                           ; UNKNOWN
00F612  74 1A                 JE     0xf62e                       ; UNKNOWN
00F614  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
00F617  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
00F61A  EB 20                 JMP    0xf63c                       ; UNKNOWN
00F61C  68 D9 06              PUSH   0x6d9                        ; UNKNOWN
00F61F  EB 10                 JMP    0xf631                       ; UNKNOWN
00F621  90                    NOP                                 ; UNKNOWN
00F622  68 DD 06              PUSH   0x6dd                        ; UNKNOWN
00F625  EB 0A                 JMP    0xf631                       ; UNKNOWN
00F627  90                    NOP                                 ; UNKNOWN
00F628  68 E1 06              PUSH   0x6e1                        ; UNKNOWN
00F62B  EB 04                 JMP    0xf631                       ; UNKNOWN
00F62D  90                    NOP                                 ; UNKNOWN
00F62E  68 E5 06              PUSH   0x6e5                        ; UNKNOWN
00F631  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00F634  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00F639  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F63C  6A 0A                 PUSH   0xa                          ; UNKNOWN
00F63E  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
00F641  50                    PUSH   ax                           ; UNKNOWN
00F642  FF 36 02 3E           PUSH   word ptr [0x3e02]            ; UNKNOWN
00F646  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
00F64B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00F64E  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
00F651  50                    PUSH   ax                           ; UNKNOWN
00F652  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00F655  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F65A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F65D  81 3E 02 3E 40 06     CMP    word ptr [0x3e02], 0x640     ; UNKNOWN
00F663  7C 1B                 JL     0xf680                       ; UNKNOWN
00F665  83 3E 04 3E 00        CMP    word ptr [0x3e04], 0         ; UNKNOWN
00F66A  75 06                 JNE    0xf672                       ; UNKNOWN
00F66C  68 E9 06              PUSH   0x6e9                        ; UNKNOWN
00F66F  EB 04                 JMP    0xf675                       ; UNKNOWN
00F671  90                    NOP                                 ; UNKNOWN
00F672  68 EB 06              PUSH   0x6eb                        ; UNKNOWN
00F675  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00F678  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F67D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F680  68 CC 06              PUSH   0x6cc                        ; UNKNOWN
00F683  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00F686  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00F68B  C9                    LEAVE                               ; UNKNOWN
00F68C  CB                    RETF                                ; UNKNOWN
