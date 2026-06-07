; ============================================================================
; func_078640_unknown
; Region   : overlay
; Bytes    : file 0x078640..0x0786FD  (189 bytes)
; Purpose  : Game-state preservation (auto-save)  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "$preserv"  (auto-named via string xrefs)
; ============================================================================

078640  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
078644  53                    PUSH   bx ; STACK_PUSH
078645  57                    PUSH   di ; STACK_PUSH
078646  56                    PUSH   si ; STACK_PUSH
078647  8B F0                 MOV    si, ax ; MOV
078649  BF FD FF              MOV    di, 0xfffd ; CONST_LOAD
07864C  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
07864F  8D 46 08              LEA    ax, [bp + 8] ; ADDR
078652  50                    PUSH   ax ; STACK_PUSH
078653  8D 46 06              LEA    ax, [bp + 6] ; ADDR
078656  50                    PUSH   ax ; STACK_PUSH
078657  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
07865A  8D 46 0C              LEA    ax, [bp + 0xc] ; ADDR
07865D  8D 56 0A              LEA    dx, [bp + 0xa] ; ADDR
078660  9A CC 0E 1F 18        LCALL  0x181f, 0xecc ; THUNK -> 0x0A4E:0x001C (thunk @file 0x01B4BC type B) overlay @file 0x0287C6
078665  0B C0                 OR     ax, ax ; LOGIC
078667  74 03                 JE     0x7866c ; CJUMP
078669  E9 81 00              JMP    0x786ed ; JUMP
07866C  83 FE F8              CMP    si, -8 ; CMP
07866F  75 55                 JNE    0x786c6 ; CJUMP
078671  68 18 26              PUSH   0x2618                       ; STRING: "$preserv"
078674  8D 1E 28 2D           LEA    bx, [0x2d28] ; ADDR
078678  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
07867B  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
07867E  9A A0 0F 1F 1A        LCALL  0x1a1f, 0xfa0 ; THUNK -> 0x0000:0x003C (thunk @file 0x01D590 type A) overlay @file 0x02593C
078683  A1 2E 2D              MOV    ax, word ptr [0x2d2e] ; GLOBAL_LOAD
078686  0B 06 2C 2D           OR     ax, word ptr [0x2d2c] ; LOGIC
07868A  74 3A                 JE     0x786c6 ; CJUMP
07868C  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
07868F  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
078692  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
078695  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
078698  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
07869A  FF 36 2E 2D           PUSH   word ptr [0x2d2e] ; PUSH_GLOBAL
07869E  FF 36 2C 2D           PUSH   word ptr [0x2d2c] ; PUSH_GLOBAL
0786A2  FF 36 2A 2D           PUSH   word ptr [0x2d2a] ; PUSH_GLOBAL
0786A6  FF 36 28 2D           PUSH   word ptr [0x2d28] ; PUSH_GLOBAL
0786AA  6A 00                 PUSH   0 ; STACK_PUSH
0786AC  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0786AF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0786B2  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
0786B5  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
0786B8  2B DB                 SUB    bx, bx ; ARITH
0786BA  9A 3A 03 1F 18        LCALL  0x181f, 0x33a ; THUNK -> 0x0BAA:0x0006 (thunk @file 0x01A92A type B)
0786BF  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
0786C4  EB 27                 JMP    0x786ed ; JUMP
0786C6  83 FE FE              CMP    si, -2 ; CMP
0786C9  74 27                 JE     0x786f2 ; CJUMP
0786CB  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0786CE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0786D1  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
0786D4  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
0786D7  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
0786DA  9A 96 0F 1F 1A        LCALL  0x1a1f, 0xf96 ; THUNK -> 0x0BDD:0x0002 (thunk @file 0x01D586 type B) overlay @file 0x026FF2
0786DF  8B F0                 MOV    si, ax ; MOV
0786E1  0B F6                 OR     si, si ; LOGIC
0786E3  7C 0D                 JL     0x786f2 ; CJUMP
0786E5  BF F6 FF              MOV    di, 0xfff6 ; CONST_LOAD
0786E8  2B FE                 SUB    di, si ; ARITH
0786EA  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
0786ED  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
0786F0  EB 03                 JMP    0x786f5 ; JUMP
0786F2  BE FD FF              MOV    si, 0xfffd ; CONST_LOAD
0786F5  8B C6                 MOV    ax, si ; MOV
0786F7  5E                    POP    si ; STACK_POP
0786F8  5F                    POP    di ; STACK_POP
0786F9  C9                    LEAVE ; EPILOGUE
0786FA  CA 08 00              RETF   8 ; RETURN
