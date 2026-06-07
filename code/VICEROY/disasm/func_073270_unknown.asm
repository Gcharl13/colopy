; ============================================================================
; func_073270_unknown
; Region   : overlay
; Bytes    : file 0x073270..0x073473  (515 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "(More)"  (auto-named via string xrefs)
; ============================================================================

073270  C8 C4 00 00           ENTER  0xc4, 0 ; PROLOGUE
073274  57                    PUSH   di ; STACK_PUSH
073275  56                    PUSH   si ; STACK_PUSH
073276  C7 46 F0 FF FF        MOV    word ptr [bp - 0x10], 0xffff ; LOCAL_STORE
07327B  2B C0                 SUB    ax, ax ; ARITH
07327D  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
073280  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
073283  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
073286  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
073289  8D 46 BE              LEA    ax, [bp - 0x42] ; ADDR
07328C  50                    PUSH   ax ; STACK_PUSH
07328D  6A 00                 PUSH   0 ; STACK_PUSH
07328F  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
073292  9A 63 0E 1D 0D        LCALL  0xd1d, 0xe63 ; LCALL
073297  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
07329A  0B C0                 OR     ax, ax ; LOGIC
07329C  74 03                 JE     0x732a1 ; CJUMP
07329E  E9 AF 00              JMP    0x73350 ; JUMP
0732A1  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
0732A4  46                    INC    si ; ARITH
0732A5  8D 46 BE              LEA    ax, [bp - 0x42] ; ADDR
0732A8  50                    PUSH   ax ; STACK_PUSH
0732A9  9A 58 0E 1D 0D        LCALL  0xd1d, 0xe58 ; LCALL
0732AE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0732B1  0B C0                 OR     ax, ax ; LOGIC
0732B3  74 EF                 JE     0x732a4 ; CJUMP
0732B5  0B F6                 OR     si, si ; LOGIC
0732B7  75 03                 JNE    0x732bc ; CJUMP
0732B9  E9 B9 00              JMP    0x73375 ; JUMP
0732BC  8D 44 09              LEA    ax, [si + 9] ; ADDR
0732BF  B9 0A 00              MOV    cx, 0xa ; CONST_LOAD
0732C2  99                    CDQ ; ARITH
0732C3  F7 F9                 IDIV   cx ; ARITH
0732C5  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
0732C8  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
0732CD  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
0732D2  8B 76 F6              MOV    si, word ptr [bp - 0xa] ; LOCAL_LOAD
0732D5  8B C6                 MOV    ax, si ; MOV
0732D7  C1 E6 02              SHL    si, 2 ; LOGIC
0732DA  03 F0                 ADD    si, ax ; ARITH
0732DC  D1 E6                 SHL    si, 1 ; LOGIC
0732DE  8D 44 09              LEA    ax, [si + 9] ; ADDR
0732E1  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0732E4  8D 46 BE              LEA    ax, [bp - 0x42] ; ADDR
0732E7  50                    PUSH   ax ; STACK_PUSH
0732E8  6A 00                 PUSH   0 ; STACK_PUSH
0732EA  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0732ED  9A 63 0E 1D 0D        LCALL  0xd1d, 0xe63 ; LCALL
0732F2  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0732F5  0B C0                 OR     ax, ax ; LOGIC
0732F7  75 5D                 JNE    0x73356 ; CJUMP
0732F9  89 76 F8              MOV    word ptr [bp - 8], si ; LOCAL_STORE
0732FC  8B 76 FA              MOV    si, word ptr [bp - 6] ; LOCAL_LOAD
0732FF  8B 7E FE              MOV    di, word ptr [bp - 2] ; LOCAL_LOAD
073302  47                    INC    di ; ARITH
073303  39 7E F8              CMP    word ptr [bp - 8], di ; CMP
073306  7F 26                 JG     0x7332e ; CJUMP
073308  39 7E FC              CMP    word ptr [bp - 4], di ; CMP
07330B  7C 21                 JL     0x7332e ; CJUMP
07330D  8D 46 DC              LEA    ax, [bp - 0x24] ; ADDR
073310  50                    PUSH   ax ; STACK_PUSH
073311  8B C6                 MOV    ax, si ; MOV
073313  46                    INC    si ; ARITH
073314  8B C8                 MOV    cx, ax ; MOV
073316  D1 E0                 SHL    ax, 1 ; LOGIC
073318  03 C1                 ADD    ax, cx ; ARITH
07331A  C1 E0 02              SHL    ax, 2 ; LOGIC
07331D  03 C1                 ADD    ax, cx ; ARITH
07331F  8D 8E 3C FF           LEA    cx, [bp - 0xc4] ; ADDR
073323  03 C1                 ADD    ax, cx ; ARITH
073325  50                    PUSH   ax ; STACK_PUSH
073326  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
07332B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07332E  8D 46 BE              LEA    ax, [bp - 0x42] ; ADDR
073331  50                    PUSH   ax ; STACK_PUSH
073332  9A 58 0E 1D 0D        LCALL  0xd1d, 0xe58 ; LCALL
073337  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
07333A  0B C0                 OR     ax, ax ; LOGIC
07333C  75 05                 JNE    0x73343 ; CJUMP
07333E  83 FE 0A              CMP    si, 0xa ; CMP
073341  7C BF                 JL     0x73302 ; CJUMP
073343  0B F6                 OR     si, si ; LOGIC
073345  75 15                 JNE    0x7335c ; CJUMP
073347  89 76 FE              MOV    word ptr [bp - 2], si ; LOCAL_STORE
07334A  8B 7E EA              MOV    di, word ptr [bp - 0x16] ; LOCAL_LOAD
07334D  E9 D9 00              JMP    0x73429 ; JUMP
073350  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
073353  E9 5F FF              JMP    0x732b5 ; JUMP
073356  8B 76 FA              MOV    si, word ptr [bp - 6] ; LOCAL_LOAD
073359  EB E8                 JMP    0x73343 ; JUMP
07335B  90                    NOP ; NOP
07335C  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
07335F  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
073362  2B D2                 SUB    dx, dx ; ARITH
073364  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
073369  8B F8                 MOV    di, ax ; MOV
07336B  89 56 EC              MOV    word ptr [bp - 0x14], dx ; LOCAL_STORE
07336E  0B D0                 OR     dx, ax ; LOGIC
073370  75 0A                 JNE    0x7337c ; CJUMP
073372  89 7E EA              MOV    word ptr [bp - 0x16], di ; LOCAL_STORE
073375  8B 76 EA              MOV    si, word ptr [bp - 0x16] ; LOCAL_LOAD
073378  E9 E0 00              JMP    0x7345b ; JUMP
07337B  90                    NOP ; NOP
07337C  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
073380  74 12                 JE     0x73394 ; CJUMP
073382  6A 62                 PUSH   0x62 ; PUSH_CONST
073384  1E                    PUSH   ds ; STACK_PUSH
073385  68 58 21              PUSH   0x2158                       ; STRING: "(More)"
073388  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
07338B  57                    PUSH   di ; STACK_PUSH
07338C  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
073391  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
073394  2B D2                 SUB    dx, dx ; ARITH
073396  0B F6                 OR     si, si ; LOGIC
073398  7E 38                 JLE    0x733d2 ; CJUMP
07339A  89 76 FA              MOV    word ptr [bp - 6], si ; LOCAL_STORE
07339D  89 7E EA              MOV    word ptr [bp - 0x16], di ; LOCAL_STORE
0733A0  8D 8E 3C FF           LEA    cx, [bp - 0xc4] ; ADDR
0733A4  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
0733A7  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
0733AA  8B FA                 MOV    di, dx ; MOV
0733AC  8B F1                 MOV    si, cx ; MOV
0733AE  8D 45 01              LEA    ax, [di + 1] ; ADDR
0733B1  50                    PUSH   ax ; STACK_PUSH
0733B2  16                    PUSH   ss ; STACK_PUSH
0733B3  56                    PUSH   si ; STACK_PUSH
0733B4  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
0733B7  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
0733BA  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
0733BF  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0733C2  83 C6 0D              ADD    si, 0xd ; ARITH
0733C5  8D 45 01              LEA    ax, [di + 1] ; ADDR
0733C8  8B F8                 MOV    di, ax ; MOV
0733CA  3B 7E FA              CMP    di, word ptr [bp - 6] ; CMP
0733CD  7C DF                 JL     0x733ae ; CJUMP
0733CF  8B 7E EA              MOV    di, word ptr [bp - 0x16] ; LOCAL_LOAD
0733D2  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
0733D5  48                    DEC    ax ; ARITH
0733D6  3B 46 F6              CMP    ax, word ptr [bp - 0xa] ; CMP
0733D9  7E 12                 JLE    0x733ed ; CJUMP
0733DB  6A 63                 PUSH   0x63 ; PUSH_CONST
0733DD  1E                    PUSH   ds ; STACK_PUSH
0733DE  68 5F 21              PUSH   0x215f                       ; STRING: "(More)"
0733E1  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
0733E4  57                    PUSH   di ; STACK_PUSH
0733E5  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
0733EA  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0733ED  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0733F2  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
0733F5  57                    PUSH   di ; STACK_PUSH
0733F6  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
0733FB  48                    DEC    ax ; ARITH
0733FC  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
0733FF  3D 61 00              CMP    ax, 0x61 ; CMP
073402  75 0A                 JNE    0x7340e ; CJUMP
073404  FF 4E F6              DEC    word ptr [bp - 0xa] ; ARITH
073407  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
07340C  EB 0A                 JMP    0x73418 ; JUMP
07340E  3D 62 00              CMP    ax, 0x62 ; CMP
073411  75 05                 JNE    0x73418 ; CJUMP
073413  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
073416  EB EF                 JMP    0x73407 ; JUMP
073418  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
07341B  57                    PUSH   di ; STACK_PUSH
07341C  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
073421  2B C0                 SUB    ax, ax ; ARITH
073423  99                    CDQ ; ARITH
073424  8B F8                 MOV    di, ax ; MOV
073426  89 56 EC              MOV    word ptr [bp - 0x14], dx ; LOCAL_STORE
073429  89 7E EA              MOV    word ptr [bp - 0x16], di ; LOCAL_STORE
07342C  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
073430  74 03                 JE     0x73435 ; CJUMP
073432  E9 93 FE              JMP    0x732c8 ; JUMP
073435  8B F7                 MOV    si, di ; MOV
073437  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
07343B  7C 1E                 JL     0x7345b ; CJUMP
07343D  8B 7E F0              MOV    di, word ptr [bp - 0x10] ; LOCAL_LOAD
073440  8B C7                 MOV    ax, di ; MOV
073442  D1 E7                 SHL    di, 1 ; LOGIC
073444  03 F8                 ADD    di, ax ; ARITH
073446  C1 E7 02              SHL    di, 2 ; LOGIC
073449  03 F8                 ADD    di, ax ; ARITH
07344B  8D 83 3C FF           LEA    ax, [bp + di - 0xc4] ; ADDR
07344F  50                    PUSH   ax ; STACK_PUSH
073450  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
073453  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
073458  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07345B  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
07345E  0B C6                 OR     ax, si ; LOGIC
073460  74 0A                 JE     0x7346c ; CJUMP
073462  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
073465  50                    PUSH   ax ; STACK_PUSH
073466  56                    PUSH   si ; STACK_PUSH
073467  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
07346C  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
07346F  5E                    POP    si ; STACK_POP
073470  5F                    POP    di ; STACK_POP
073471  C9                    LEAVE ; EPILOGUE
073472  CB                    RETF ; RETURN
