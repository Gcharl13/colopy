; ============================================================================
; func_04A7CA_unknown
; Region   : overlay
; Bytes    : file 0x04A7CA..0x04A9C5  (507 bytes)
; Purpose  : Chief greeting  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "CHIEFHOWDY"  (auto-named via string xrefs)
; ============================================================================

04A7CA  C8 24 00 00           ENTER  0x24, 0 ; PROLOGUE
04A7CE  57                    PUSH   di ; STACK_PUSH
04A7CF  56                    PUSH   si ; STACK_PUSH
04A7D0  C7 46 E6 00 00        MOV    word ptr [bp - 0x1a], 0 ; LOCAL_STORE
04A7D5  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04A7D9  80 BF 5B 31 16        CMP    byte ptr [bx + 0x315b], 0x16 ; CMP
04A7DE  75 06                 JNE    0x4a7e6 ; CJUMP
04A7E0  B8 01 00              MOV    ax, 1 ; MOV
04A7E3  EB 03                 JMP    0x4a7e8 ; JUMP
04A7E5  90                    NOP ; NOP
04A7E6  2B C0                 SUB    ax, ax ; ARITH
04A7E8  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
04A7EB  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04A7EE  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04A7F2  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04A7F7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A7FA  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
04A7FD  3D 4B 00              CMP    ax, 0x4b ; CMP
04A800  7C 18                 JL     0x4a81a ; CJUMP
04A802  6A 06                 PUSH   6 ; STACK_PUSH
04A804  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04A807  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
04A80C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A80F  0B C0                 OR     ax, ax ; LOGIC
04A811  75 03                 JNE    0x4a816 ; CJUMP
04A813  E9 5C 03              JMP    0x4ab72 ; JUMP
04A816  E9 A9 03              JMP    0x4abc2 ; JUMP
04A819  90                    NOP ; NOP
04A81A  6B 46 DC 28           IMUL   ax, word ptr [bp - 0x24], 0x28 ; ARITH
04A81E  05 64 00              ADD    ax, 0x64 ; ARITH
04A821  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04A824  50                    PUSH   ax ; STACK_PUSH
04A825  6A 00                 PUSH   0 ; STACK_PUSH
04A827  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04A82C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A82F  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
04A832  83 7E DE 19           CMP    word ptr [bp - 0x22], 0x19 ; CMP
04A836  7C 0B                 JL     0x4a843 ; CJUMP
04A838  8B 46 DE              MOV    ax, word ptr [bp - 0x22] ; LOCAL_LOAD
04A83B  C1 F8 02              SAR    ax, 2 ; LOGIC
04A83E  3B 46 E8              CMP    ax, word ptr [bp - 0x18] ; CMP
04A841  7D BF                 JGE    0x4a802 ; CJUMP
04A843  83 3E 52 8D 02        CMP    word ptr [0x8d52], 2 ; CMP
04A848  75 21                 JNE    0x4a86b ; CJUMP
04A84A  8A 4E DC              MOV    cl, byte ptr [bp - 0x24] ; LOCAL_LOAD
04A84D  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
04A850  2A E4                 SUB    ah, ah ; ARITH
04A852  2D 08 00              SUB    ax, 8 ; ARITH
04A855  F7 D8                 NEG    ax ; ARITH
04A857  D3 E0                 SHL    ax, cl ; LOGIC
04A859  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04A85C  50                    PUSH   ax ; STACK_PUSH
04A85D  6A 00                 PUSH   0 ; STACK_PUSH
04A85F  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04A864  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A867  0B C0                 OR     ax, ax ; LOGIC
04A869  74 97                 JE     0x4a802 ; CJUMP
04A86B  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
04A86F  7C 03                 JL     0x4a874 ; CJUMP
04A871  E9 F0 00              JMP    0x4a964 ; JUMP
04A874  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
04A878  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04A87D  74 03                 JE     0x4a882 ; CJUMP
04A87F  E9 E2 00              JMP    0x4a964 ; JUMP
04A882  6A 01                 PUSH   1 ; STACK_PUSH
04A884  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04A887  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04A88A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04A88D  0E                    PUSH   cs ; STACK_PUSH
04A88E  E8 AD 11              CALL   0x4ba3e ; CALL_NEAR
04A891  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04A894  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
04A897  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04A89A  6A FF                 PUSH   -1 ; STACK_PUSH
04A89C  FF 36 4C 8D           PUSH   word ptr [0x8d4c] ; PUSH_GLOBAL
04A8A0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04A8A3  0E                    PUSH   cs ; STACK_PUSH
04A8A4  E8 A1 11              CALL   0x4ba48 ; CALL_NEAR
04A8A7  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04A8AA  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0 ; LOCAL_STORE
04A8AF  8A 46 E4              MOV    al, byte ptr [bp - 0x1c] ; LOCAL_LOAD
04A8B2  8B 76 E4              MOV    si, word ptr [bp - 0x1c] ; LOCAL_LOAD
04A8B5  88 42 EE              MOV    byte ptr [bp + si - 0x12], al ; LOCAL_STORE
04A8B8  FF 46 E4              INC    word ptr [bp - 0x1c] ; ARITH
04A8BB  83 7E E4 10           CMP    word ptr [bp - 0x1c], 0x10 ; CMP
04A8BF  7C EE                 JL     0x4a8af ; CJUMP
04A8C1  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04A8C5  80 7F 08 00           CMP    byte ptr [bx + 8], 0 ; CMP
04A8C9  7C 0E                 JL     0x4a8d9 ; CJUMP
04A8CB  8A 47 08              MOV    al, byte ptr [bx + 8] ; MOV
04A8CE  98                    CWDE ; ARITH
04A8CF  8B D8                 MOV    bx, ax ; MOV
04A8D1  D1 E3                 SHL    bx, 1 ; LOGIC
04A8D3  C7 87 58 9E 00 00     MOV    word ptr [bx - 0x61a8], 0 ; MOV
04A8D9  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04A8DD  80 7F 09 00           CMP    byte ptr [bx + 9], 0 ; CMP
04A8E1  7C 0E                 JL     0x4a8f1 ; CJUMP
04A8E3  8A 47 09              MOV    al, byte ptr [bx + 9] ; MOV
04A8E6  98                    CWDE ; ARITH
04A8E7  8B D8                 MOV    bx, ax ; MOV
04A8E9  D1 E3                 SHL    bx, 1 ; LOGIC
04A8EB  C7 87 58 9E 00 00     MOV    word ptr [bx - 0x61a8], 0 ; MOV
04A8F1  8D 46 EE              LEA    ax, [bp - 0x12] ; ADDR
04A8F4  16                    PUSH   ss ; STACK_PUSH
04A8F5  50                    PUSH   ax ; STACK_PUSH
04A8F6  1E                    PUSH   ds ; STACK_PUSH
04A8F7  68 58 9E              PUSH   0x9e58 ; PUSH_CONST
04A8FA  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
04A8FD  9A D0 0E 1F 19        LCALL  0x191f, 0xed0 ; THUNK -> 0x0CF8:0x000A (thunk @file 0x01C4C0 type B)
04A902  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
04A905  C1 E3 03              SHL    bx, 3 ; LOGIC
04A908  FF B7 A4 8E           PUSH   word ptr [bx - 0x715c] ; PUSH_GLOBAL
04A90C  6A 00                 PUSH   0 ; STACK_PUSH
04A90E  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04A913  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A916  8A 5E FD              MOV    bl, byte ptr [bp - 3] ; LOCAL_LOAD
04A919  2A FF                 SUB    bh, bh ; ARITH
04A91B  D1 E3                 SHL    bx, 1 ; LOGIC
04A91D  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
04A921  6A 01                 PUSH   1 ; STACK_PUSH
04A923  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04A928  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A92B  8A 5E FC              MOV    bl, byte ptr [bp - 4] ; LOCAL_LOAD
04A92E  2A FF                 SUB    bh, bh ; ARITH
04A930  D1 E3                 SHL    bx, 1 ; LOGIC
04A932  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
04A936  6A 02                 PUSH   2 ; STACK_PUSH
04A938  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04A93D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A940  8A 5E FB              MOV    bl, byte ptr [bp - 5] ; LOCAL_LOAD
04A943  2A FF                 SUB    bh, bh ; ARITH
04A945  D1 E3                 SHL    bx, 1 ; LOGIC
04A947  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
04A94B  6A 03                 PUSH   3 ; STACK_PUSH
04A94D  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04A952  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A955  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04A959  68 30 16              PUSH   0x1630                       ; STRING: "CHIEFHOWDY"
04A95C  9A 9C 01 1F 19        LCALL  0x191f, 0x19c ; THUNK -> 0x0000:0x3760 (thunk @file 0x01B78C type A) overlay @file 0x029060
04A961  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A964  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04A967  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
04A96C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04A96F  50                    PUSH   ax ; STACK_PUSH
04A970  6A 00                 PUSH   0 ; STACK_PUSH
04A972  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04A977  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A97A  8B 46 DE              MOV    ax, word ptr [bp - 0x22] ; LOCAL_LOAD
04A97D  39 46 E8              CMP    word ptr [bp - 0x18], ax ; CMP
04A980  7F 03                 JG     0x4a985 ; CJUMP
04A982  E9 3D 02              JMP    0x4abc2 ; JUMP
04A985  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04A989  F6 47 03 08           TEST   byte ptr [bx + 3], 8 ; LOGIC
04A98D  74 03                 JE     0x4a992 ; CJUMP
04A98F  E9 30 02              JMP    0x4abc2 ; JUMP
04A992  80 4F 03 08           OR     byte ptr [bx + 3], 8 ; LOGIC
04A996  6A 03                 PUSH   3 ; STACK_PUSH
04A998  6A 01                 PUSH   1 ; STACK_PUSH
04A99A  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04A99F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A9A2  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04A9A5  48                    DEC    ax ; ARITH
04A9A6  74 0C                 JE     0x4a9b4 ; CJUMP
04A9A8  48                    DEC    ax ; ARITH
04A9A9  74 75                 JE     0x4aa20 ; CJUMP
04A9AB  48                    DEC    ax ; ARITH
04A9AC  75 03                 JNE    0x4a9b1 ; CJUMP
04A9AE  E9 09 01              JMP    0x4aaba ; JUMP
04A9B1  E9 0E 02              JMP    0x4abc2 ; JUMP
04A9B4  83 7E DC 00           CMP    word ptr [bp - 0x24], 0 ; CMP
04A9B8  75 66                 JNE    0x4aa20 ; CJUMP
04A9BA  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
04A9BE  8A 5F 02              MOV    bl, byte ptr [bx + 2] ; MOV
04A9C1  2A FF                 SUB    bh, bh ; ARITH
04A9C3  8B C3                 MOV    ax, bx ; MOV
