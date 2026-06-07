; ============================================================================
; func_06E3D0_unknown
; Region   : overlay
; Bytes    : file 0x06E3D0..0x06E4CD  (253 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06E3D0  C8 38 00 00           ENTER  0x38, 0 ; PROLOGUE
06E3D4  56                    PUSH   si ; STACK_PUSH
06E3D5  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1 ; LOCAL_STORE
06E3DA  83 3E 5C 1F 07        CMP    word ptr [0x1f5c], 7 ; CMP
06E3DF  7E 05                 JLE    0x6e3e6 ; CJUMP
06E3E1  B8 01 00              MOV    ax, 1 ; MOV
06E3E4  EB 02                 JMP    0x6e3e8 ; JUMP
06E3E6  2B C0                 SUB    ax, ax ; ARITH
06E3E8  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
06E3EB  2B C0                 SUB    ax, ax ; ARITH
06E3ED  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06E3F0  A3 68 1F              MOV    word ptr [0x1f68], ax ; GLOBAL_LOAD
06E3F3  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E3F6  26 F6 47 0A 10        TEST   byte ptr es:[bx + 0xa], 0x10 ; LOGIC
06E3FB  74 09                 JE     0x6e406 ; CJUMP
06E3FD  C7 06 8A 1F 01 00     MOV    word ptr [0x1f8a], 1 ; GLOBAL_LOAD
06E403  EB 04                 JMP    0x6e409 ; JUMP
06E405  90                    NOP ; NOP
06E406  A3 8A 1F              MOV    word ptr [0x1f8a], ax ; GLOBAL_LOAD
06E409  A3 62 1F              MOV    word ptr [0x1f62], ax ; GLOBAL_LOAD
06E40C  9A B8 0F 1F 19        LCALL  0x191f, 0xfb8 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5A8 type A) overlay @file 0x025900
06E411  EB 06                 JMP    0x6e419 ; JUMP
06E413  90                    NOP ; NOP
06E414  9A E0 03 1F 18        LCALL  0x181f, 0x3e0 ; THUNK -> 0x0AE7:0x0016 (thunk @file 0x01A9D0 type B) overlay @file 0x027006
06E419  9A F6 00 1F 18        LCALL  0x181f, 0xf6 ; THUNK -> 0x0AE7:0x0002 (thunk @file 0x01A6E6 type B) overlay @file 0x026FF2
06E41E  0B C0                 OR     ax, ax ; LOGIC
06E420  75 F2                 JNE    0x6e414 ; CJUMP
06E422  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E425  26 F6 47 0A 04        TEST   byte ptr es:[bx + 0xa], 4 ; LOGIC
06E42A  74 2E                 JE     0x6e45a ; CJUMP
06E42C  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
06E42F  EB 1D                 JMP    0x6e44e ; JUMP
06E431  90                    NOP ; NOP
06E432  8B C8                 MOV    cx, ax ; MOV
06E434  2A ED                 SUB    ch, ch ; ARITH
06E436  BA 01 00              MOV    dx, 1 ; MOV
06E439  D3 E2                 SHL    dx, cl ; LOGIC
06E43B  23 16 54 1F           AND    dx, word ptr [0x1f54] ; LOGIC
06E43F  52                    PUSH   dx ; STACK_PUSH
06E440  40                    INC    ax ; ARITH
06E441  50                    PUSH   ax ; STACK_PUSH
06E442  06                    PUSH   es ; STACK_PUSH
06E443  53                    PUSH   bx ; STACK_PUSH
06E444  0E                    PUSH   cs ; STACK_PUSH
06E445  E8 F2 13              CALL   0x6f83a ; CALL_NEAR
06E448  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
06E44B  FF 46 DE              INC    word ptr [bp - 0x22] ; ARITH
06E44E  8B 46 DE              MOV    ax, word ptr [bp - 0x22] ; LOCAL_LOAD
06E451  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E454  26 39 47 02           CMP    word ptr es:[bx + 2], ax ; CMP
06E458  7F D8                 JG     0x6e432 ; CJUMP
06E45A  26 C7 07 00 00        MOV    word ptr es:[bx], 0 ; MOV
06E45F  26 FF B7 82 00        PUSH   word ptr es:[bx + 0x82] ; PUSH_GLOBAL
06E464  26 FF B7 80 00        PUSH   word ptr es:[bx + 0x80] ; PUSH_GLOBAL
06E469  E8 FA E8              CALL   0x6cd66 ; CALL_NEAR
06E46C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06E46F  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E472  26 03 47 46           ADD    ax, word ptr es:[bx + 0x46] ; ARITH
06E476  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06E479  83 3E 5C 1F 00        CMP    word ptr [0x1f5c], 0 ; CMP
06E47E  7C 05                 JL     0x6e485 ; CJUMP
06E480  06                    PUSH   es ; STACK_PUSH
06E481  53                    PUSH   bx ; STACK_PUSH
06E482  E8 0D DA              CALL   0x6be92 ; CALL_NEAR
06E485  83 3E 5E 1F 00        CMP    word ptr [0x1f5e], 0 ; CMP
06E48A  7C 09                 JL     0x6e495 ; CJUMP
06E48C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E48F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E492  E8 7D DA              CALL   0x6bf12 ; CALL_NEAR
06E495  83 3E 60 1F 00        CMP    word ptr [0x1f60], 0 ; CMP
06E49A  7C 09                 JL     0x6e4a5 ; CJUMP
06E49C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E49F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E4A2  E8 97 DA              CALL   0x6bf3c ; CALL_NEAR
06E4A5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E4A8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E4AB  E8 B8 DA              CALL   0x6bf66 ; CALL_NEAR
06E4AE  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E4B1  26 8B 47 6A           MOV    ax, word ptr es:[bx + 0x6a] ; MOV
06E4B5  26 0B 47 68           OR     ax, word ptr es:[bx + 0x68] ; LOGIC
06E4B9  74 20                 JE     0x6e4db ; CJUMP
06E4BB  26 8B 47 68           MOV    ax, word ptr es:[bx + 0x68] ; MOV
06E4BF  26 8B 57 6A           MOV    dx, word ptr es:[bx + 0x6a] ; MOV
06E4C3  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
06E4C6  89 56 EC              MOV    word ptr [bp - 0x14], dx ; LOCAL_STORE
06E4C9  8E C2                 MOV    es, dx ; MOV
06E4CB  8B D8                 MOV    bx, ax ; MOV
