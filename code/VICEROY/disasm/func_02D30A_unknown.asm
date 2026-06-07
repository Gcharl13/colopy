; ============================================================================
; func_02D30A_unknown
; Region   : overlay
; Bytes    : file 0x02D30A..0x02D3C6  (188 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "DEPLETION"  (auto-named via string xrefs)
; ============================================================================

02D30A  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
02D30E  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
02D313  E9 9F 00              JMP    0x2d3b5 ; JUMP
02D316  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
02D319  83 7E F8 05           CMP    word ptr [bp - 8], 5 ; CMP
02D31D  7E 03                 JLE    0x2d322 ; CJUMP
02D31F  E9 90 00              JMP    0x2d3b2 ; JUMP
02D322  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02D325  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
02D328  9A E0 0C 1F 18        LCALL  0x181f, 0xce0 ; THUNK -> 0x05EB:0x06A6 (thunk @file 0x01B2D0 type B) overlay @file 0x027696
02D32D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D330  98                    CWDE ; ARITH
02D331  0B C0                 OR     ax, ax ; LOGIC
02D333  7C E1                 JL     0x2d316 ; CJUMP
02D335  50                    PUSH   ax ; STACK_PUSH
02D336  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
02D33B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D33E  3D 07 00              CMP    ax, 7 ; CMP
02D341  74 05                 JE     0x2d348 ; CJUMP
02D343  3D 06 00              CMP    ax, 6 ; CMP
02D346  75 CE                 JNE    0x2d316 ; CJUMP
02D348  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D34C  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
02D34F  2A E4                 SUB    ah, ah ; ARITH
02D351  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
02D354  48                    DEC    ax ; ARITH
02D355  48                    DEC    ax ; ARITH
02D356  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02D359  50                    PUSH   ax ; STACK_PUSH
02D35A  8A 07                 MOV    al, byte ptr [bx] ; MOV
02D35C  2A E4                 SUB    ah, ah ; ARITH
02D35E  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
02D361  48                    DEC    ax ; ARITH
02D362  48                    DEC    ax ; ARITH
02D363  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02D366  50                    PUSH   ax ; STACK_PUSH
02D367  9A 18 07 1F 18        LCALL  0x181f, 0x718 ; THUNK -> 0x037F:0x04B0 (thunk @file 0x01AD08 type B) overlay @file 0x02EFEC
02D36C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D36F  3D 0C 00              CMP    ax, 0xc ; CMP
02D372  74 05                 JE     0x2d379 ; CJUMP
02D374  3D 06 00              CMP    ax, 6 ; CMP
02D377  75 9D                 JNE    0x2d316 ; CJUMP
02D379  6A 01                 PUSH   1 ; STACK_PUSH
02D37B  6A 04                 PUSH   4 ; STACK_PUSH
02D37D  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02D380  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
02D383  9A 8C 06 1F 18        LCALL  0x181f, 0x68c ; THUNK -> 0x037F:0x015E (thunk @file 0x01AC7C type B) overlay @file 0x02EC9A
02D388  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02D38B  6A 00                 PUSH   0 ; STACK_PUSH
02D38D  6A 03                 PUSH   3 ; STACK_PUSH
02D38F  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02D392  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
02D395  6A FF                 PUSH   -1 ; STACK_PUSH
02D397  80 3E 98 A8 01        CMP    byte ptr [0xa898], 1 ; CMP
02D39C  1B C0                 SBB    ax, ax ; ARITH
02D39E  F7 D8                 NEG    ax ; ARITH
02D3A0  50                    PUSH   ax ; STACK_PUSH
02D3A1  68 75 0D              PUSH   0xd75                        ; STRING: "DEPLETION"
02D3A4  0E                    PUSH   cs ; STACK_PUSH
02D3A5  E8 B7 1B              CALL   0x2ef5f ; CALL_NEAR
02D3A8  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
02D3AB  08 06 98 A8           OR     byte ptr [0xa898], al ; LOGIC
02D3AF  E9 64 FF              JMP    0x2d316 ; JUMP
02D3B2  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
02D3B5  83 7E F6 05           CMP    word ptr [bp - 0xa], 5 ; CMP
02D3B9  7D 09                 JGE    0x2d3c4 ; CJUMP
02D3BB  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
02D3C0  E9 56 FF              JMP    0x2d319 ; JUMP
02D3C3  90                    NOP ; NOP
02D3C4  C9                    LEAVE ; EPILOGUE
02D3C5  CB                    RETF ; RETURN
