; ============================================================================
; func_02A0BC_unknown
; Region   : overlay
; Bytes    : file 0x02A0BC..0x02A1EE  (306 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02A0BC  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
02A0C0  56                    PUSH   si ; STACK_PUSH
02A0C1  A1 EA 07              MOV    ax, word ptr [0x7ea] ; GLOBAL_LOAD
02A0C4  2D 08 00              SUB    ax, 8 ; ARITH
02A0C7  3D 77 00              CMP    ax, 0x77 ; CMP
02A0CA  7E 03                 JLE    0x2a0cf ; CJUMP
02A0CC  B8 77 00              MOV    ax, 0x77 ; CONST_LOAD
02A0CF  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02A0D2  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
02A0D5  2D C8 00              SUB    ax, 0xc8 ; ARITH
02A0D8  3D 77 00              CMP    ax, 0x77 ; CMP
02A0DB  7E 03                 JLE    0x2a0e0 ; CJUMP
02A0DD  B8 77 00              MOV    ax, 0x77 ; CONST_LOAD
02A0E0  B9 18 00              MOV    cx, 0x18 ; CONST_LOAD
02A0E3  99                    CDQ ; ARITH
02A0E4  F7 F9                 IDIV   cx ; ARITH
02A0E6  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02A0E9  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
02A0EC  99                    CDQ ; ARITH
02A0ED  F7 F9                 IDIV   cx ; ARITH
02A0EF  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
02A0F2  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
02A0F6  75 03                 JNE    0x2a0fb ; CJUMP
02A0F8  E9 1D 02              JMP    0x2a318 ; JUMP
02A0FB  0B C0                 OR     ax, ax ; LOGIC
02A0FD  75 03                 JNE    0x2a102 ; CJUMP
02A0FF  E9 16 02              JMP    0x2a318 ; JUMP
02A102  83 7E F6 04           CMP    word ptr [bp - 0xa], 4 ; CMP
02A106  75 03                 JNE    0x2a10b ; CJUMP
02A108  E9 0D 02              JMP    0x2a318 ; JUMP
02A10B  3D 04 00              CMP    ax, 4 ; CMP
02A10E  75 03                 JNE    0x2a113 ; CJUMP
02A110  E9 05 02              JMP    0x2a318 ; JUMP
02A113  83 3E 54 8D 06        CMP    word ptr [0x8d54], 6 ; CMP
02A118  74 03                 JE     0x2a11d ; CJUMP
02A11A  E9 D1 00              JMP    0x2a1ee ; JUMP
02A11D  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
02A122  75 03                 JNE    0x2a127 ; CJUMP
02A124  E9 F1 01              JMP    0x2a318 ; JUMP
02A127  50                    PUSH   ax ; STACK_PUSH
02A128  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02A12B  9A E0 0C 1F 18        LCALL  0x181f, 0xce0 ; THUNK -> 0x05EB:0x06A6 (thunk @file 0x01B2D0 type B) overlay @file 0x027696
02A130  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02A133  0A C0                 OR     al, al ; LOGIC
02A135  7C 03                 JL     0x2a13a ; CJUMP
02A137  E9 DE 01              JMP    0x2a318 ; JUMP
02A13A  8B 76 F6              MOV    si, word ptr [bp - 0xa] ; LOCAL_LOAD
02A13D  8B C6                 MOV    ax, si ; MOV
02A13F  C1 E6 02              SHL    si, 2 ; LOGIC
02A142  03 F0                 ADD    si, ax ; ARITH
02A144  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
02A147  80 B8 F0 8D 00        CMP    byte ptr [bx + si - 0x7210], 0 ; CMP
02A14C  74 03                 JE     0x2a151 ; CJUMP
02A14E  E9 C7 01              JMP    0x2a318 ; JUMP
02A151  A3 30 03              MOV    word ptr [0x330], ax ; GLOBAL_LOAD
02A154  89 1E 32 03           MOV    word ptr [0x332], bx ; GLOBAL_LOAD
02A158  53                    PUSH   bx ; STACK_PUSH
02A159  50                    PUSH   ax ; STACK_PUSH
02A15A  0E                    PUSH   cs ; STACK_PUSH
02A15B  E8 39 28              CALL   0x2c997 ; CALL_NEAR
02A15E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02A161  FF 36 7C 8D           PUSH   word ptr [0x8d7c] ; PUSH_GLOBAL
02A165  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
02A16A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A16D  3D 09 00              CMP    ax, 9 ; CMP
02A170  7D 09                 JGE    0x2a17b ; CJUMP
02A172  3D 08 00              CMP    ax, 8 ; CMP
02A175  74 04                 JE     0x2a17b ; CJUMP
02A177  0B C0                 OR     ax, ax ; LOGIC
02A179  75 35                 JNE    0x2a1b0 ; CJUMP
02A17B  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02A17F  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
02A182  2A E4                 SUB    ah, ah ; ARITH
02A184  03 06 32 03           ADD    ax, word ptr [0x332] ; ARITH
02A188  48                    DEC    ax ; ARITH
02A189  48                    DEC    ax ; ARITH
02A18A  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
02A18D  50                    PUSH   ax ; STACK_PUSH
02A18E  8A 07                 MOV    al, byte ptr [bx] ; MOV
02A190  2A E4                 SUB    ah, ah ; ARITH
02A192  03 06 30 03           ADD    ax, word ptr [0x330] ; ARITH
02A196  48                    DEC    ax ; ARITH
02A197  48                    DEC    ax ; ARITH
02A198  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02A19B  50                    PUSH   ax ; STACK_PUSH
02A19C  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
02A1A1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02A1A4  0B C0                 OR     ax, ax ; LOGIC
02A1A6  74 04                 JE     0x2a1ac ; CJUMP
02A1A8  6A 08                 PUSH   8 ; STACK_PUSH
02A1AA  EB 05                 JMP    0x2a1b1 ; JUMP
02A1AC  6A 00                 PUSH   0 ; STACK_PUSH
02A1AE  EB 01                 JMP    0x2a1b1 ; JUMP
02A1B0  50                    PUSH   ax ; STACK_PUSH
02A1B1  FF 36 7C 8D           PUSH   word ptr [0x8d7c] ; PUSH_GLOBAL
02A1B5  0E                    PUSH   cs ; STACK_PUSH
02A1B6  E8 F2 27              CALL   0x2c9ab ; CALL_NEAR
02A1B9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02A1BC  3D 01 00              CMP    ax, 1 ; CMP
02A1BF  1B C0                 SBB    ax, ax ; ARITH
02A1C1  F7 D8                 NEG    ax ; ARITH
02A1C3  0B C0                 OR     ax, ax ; LOGIC
02A1C5  74 20                 JE     0x2a1e7 ; CJUMP
02A1C7  FF 36 7C 8D           PUSH   word ptr [0x8d7c] ; PUSH_GLOBAL
02A1CB  9A A6 0A 1F 18        LCALL  0x181f, 0xaa6 ; THUNK -> 0x05EB:0x169C (thunk @file 0x01B096 type B) overlay @file 0x02868C
02A1D0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A1D3  A0 7C 8D              MOV    al, byte ptr [0x8d7c] ; GLOBAL_LOAD
02A1D6  50                    PUSH   ax ; STACK_PUSH
02A1D7  FF 36 32 03           PUSH   word ptr [0x332] ; PUSH_GLOBAL
02A1DB  FF 36 30 03           PUSH   word ptr [0x330] ; PUSH_GLOBAL
02A1DF  9A 44 0D 1F 18        LCALL  0x181f, 0xd44 ; THUNK -> 0x05EB:0x06D2 (thunk @file 0x01B334 type B) overlay @file 0x0276C2
02A1E4  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02A1E7  0E                    PUSH   cs ; STACK_PUSH
02A1E8  E8 8D 28              CALL   0x2ca78 ; CALL_NEAR
02A1EB  5E                    POP    si ; STACK_POP
02A1EC  C9                    LEAVE ; EPILOGUE
02A1ED  CB                    RETF ; RETURN
