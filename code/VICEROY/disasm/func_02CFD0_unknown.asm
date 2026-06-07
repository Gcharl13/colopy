; ============================================================================
; func_02CFD0_unknown
; Region   : overlay
; Bytes    : file 0x02CFD0..0x02D0E2  (274 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02CFD0  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
02CFD4  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
02CFD9  2B C0                 SUB    ax, ax ; ARITH
02CFDB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02CFDE  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02CFE1  80 3E 97 A8 00        CMP    byte ptr [0xa897], 0 ; CMP
02CFE6  75 03                 JNE    0x2cfeb ; CJUMP
02CFE8  E9 D9 00              JMP    0x2d0c4 ; JUMP
02CFEB  39 06 90 08           CMP    word ptr [0x890], ax ; CMP
02CFEF  75 2C                 JNE    0x2d01d ; CJUMP
02CFF1  39 46 0C              CMP    word ptr [bp + 0xc], ax ; CMP
02CFF4  75 11                 JNE    0x2d007 ; CJUMP
02CFF6  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02CFFA  8A 07                 MOV    al, byte ptr [bx] ; MOV
02CFFC  2A E4                 SUB    ah, ah ; ARITH
02CFFE  89 46 0C              MOV    word ptr [bp + 0xc], ax ; LOCAL_STORE
02D001  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
02D004  89 46 0E              MOV    word ptr [bp + 0xe], ax ; LOCAL_STORE
02D007  6A 00                 PUSH   0 ; STACK_PUSH
02D009  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
02D00C  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
02D00F  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
02D012  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
02D015  9A 52 03 1F 18        LCALL  0x181f, 0x352 ; THUNK -> 0x0984:0x02FC (thunk @file 0x01A942 type B) overlay @file 0x032212
02D01A  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
02D01D  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
02D020  40                    INC    ax ; ARITH
02D021  40                    INC    ax ; ARITH
02D022  1E                    PUSH   ds ; STACK_PUSH
02D023  50                    PUSH   ax ; STACK_PUSH
02D024  6A 00                 PUSH   0 ; STACK_PUSH
02D026  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
02D02B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02D02E  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
02D031  A3 5E 1F              MOV    word ptr [0x1f5e], ax ; GLOBAL_LOAD
02D034  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
02D038  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
02D03B  2B D2                 SUB    dx, dx ; ARITH
02D03D  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
02D042  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02D045  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
02D048  0B D0                 OR     dx, ax ; LOGIC
02D04A  74 78                 JE     0x2d0c4 ; CJUMP
02D04C  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
02D050  74 43                 JE     0x2d095 ; CJUMP
02D052  83 3E 90 08 00        CMP    word ptr [0x890], 0 ; CMP
02D057  75 3C                 JNE    0x2d095 ; CJUMP
02D059  6A 01                 PUSH   1 ; STACK_PUSH
02D05B  FF 36 FE 2D           PUSH   word ptr [0x2dfe] ; PUSH_GLOBAL
02D05F  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
02D064  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D067  52                    PUSH   dx ; STACK_PUSH
02D068  50                    PUSH   ax ; STACK_PUSH
02D069  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02D06C  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
02D06F  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
02D074  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
02D077  6A 02                 PUSH   2 ; STACK_PUSH
02D079  FF 36 00 2E           PUSH   word ptr [0x2e00] ; PUSH_GLOBAL
02D07D  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
02D082  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D085  52                    PUSH   dx ; STACK_PUSH
02D086  50                    PUSH   ax ; STACK_PUSH
02D087  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02D08A  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
02D08D  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
02D092  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
02D095  83 7E 12 00           CMP    word ptr [bp + 0x12], 0 ; CMP
02D099  7E 08                 JLE    0x2d0a3 ; CJUMP
02D09B  8B 46 12              MOV    ax, word ptr [bp + 0x12] ; LOCAL_LOAD
02D09E  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
02D0A3  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02D0A6  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
02D0A9  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
02D0AE  3D 02 00              CMP    ax, 2 ; CMP
02D0B1  75 11                 JNE    0x2d0c4 ; CJUMP
02D0B3  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
02D0B8  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
02D0BC  7C 06                 JL     0x2d0c4 ; CJUMP
02D0BE  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
02D0C1  A2 37 03              MOV    byte ptr [0x337], al ; GLOBAL_LOAD
02D0C4  C7 06 5E 1F FF FF     MOV    word ptr [0x1f5e], 0xffff ; GLOBAL_LOAD
02D0CA  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
02D0CD  0B 46 FA              OR     ax, word ptr [bp - 6] ; LOGIC
02D0D0  74 0B                 JE     0x2d0dd ; CJUMP
02D0D2  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02D0D5  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
02D0D8  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
02D0DD  8A 46 F8              MOV    al, byte ptr [bp - 8] ; LOCAL_LOAD
02D0E0  C9                    LEAVE ; EPILOGUE
02D0E1  CB                    RETF ; RETURN
