; ============================================================================
; func_054505_unknown
; Region   : overlay
; Bytes    : file 0x054505..0x0545B6  (177 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

054505  C8 98 03 06           ENTER  0x398, 6 ; PROLOGUE
054509  72 8D                 JB     0x54498 ; CJUMP
05450B  3B 86 56 FF           CMP    ax, word ptr [bp - 0xaa] ; CMP
05450F  7F 03                 JG     0x54514 ; CJUMP
054511  E9 A2 00              JMP    0x545b6 ; JUMP
054514  80 F9 20              CMP    cl, 0x20 ; CMP
054517  7C 03                 JL     0x5451c ; CJUMP
054519  E9 9A 00              JMP    0x545b6 ; JUMP
05451C  FF B6 56 FF           PUSH   word ptr [bp - 0xaa] ; PUSH_GLOBAL
054520  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
054525  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
054528  89 86 14 FF           MOV    word ptr [bp - 0xec], ax ; LOCAL_STORE
05452C  FF B6 56 FF           PUSH   word ptr [bp - 0xaa] ; PUSH_GLOBAL
054530  9A 54 0C 1F 18        LCALL  0x181f, 0xc54 ; THUNK -> 0x05EB:0x0E52 (thunk @file 0x01B244 type B) overlay @file 0x027E42
054535  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
054538  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
05453B  83 BE 14 FF 15        CMP    word ptr [bp - 0xec], 0x15 ; CMP
054540  74 0A                 JE     0x5454c ; CJUMP
054542  83 BE 14 FF 17        CMP    word ptr [bp - 0xec], 0x17 ; CMP
054547  74 03                 JE     0x5454c ; CJUMP
054549  E9 2B FF              JMP    0x54477 ; JUMP
05454C  83 7E 8C 00           CMP    word ptr [bp - 0x74], 0 ; CMP
054550  7D 0A                 JGE    0x5455c ; CJUMP
054552  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
054556  F6 47 1B 08           TEST   byte ptr [bx + 0x1b], 8 ; LOGIC
05455A  74 2C                 JE     0x54588 ; CJUMP
05455C  50                    PUSH   ax ; STACK_PUSH
05455D  9A 9A 0C 1F 18        LCALL  0x181f, 0xc9a ; THUNK -> 0x05EB:0x0002 (thunk @file 0x01B28A type B) overlay @file 0x026FF2
054562  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
054565  0B C0                 OR     ax, ax ; LOGIC
054567  74 12                 JE     0x5457b ; CJUMP
054569  83 7E EA 15           CMP    word ptr [bp - 0x16], 0x15 ; CMP
05456D  74 0C                 JE     0x5457b ; CJUMP
05456F  83 7E C0 00           CMP    word ptr [bp - 0x40], 0 ; CMP
054573  75 13                 JNE    0x54588 ; CJUMP
054575  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0 ; CMP
054579  75 0D                 JNE    0x54588 ; CJUMP
05457B  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
05457F  F6 47 1B 04           TEST   byte ptr [bx + 0x1b], 4 ; LOGIC
054583  75 03                 JNE    0x54588 ; CJUMP
054585  E9 EF FE              JMP    0x54477 ; JUMP
054588  6A 12                 PUSH   0x12 ; PUSH_CONST
05458A  FF B6 56 FF           PUSH   word ptr [bp - 0xaa] ; PUSH_GLOBAL
05458E  9A 36 0C 1F 18        LCALL  0x181f, 0xc36 ; THUNK -> 0x05EB:0x1068 (thunk @file 0x01B226 type B) overlay @file 0x028058
054593  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
054596  FF 46 8C              INC    word ptr [bp - 0x74] ; ARITH
054599  C7 46 D0 01 00        MOV    word ptr [bp - 0x30], 1 ; LOCAL_STORE
05459E  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0545A2  80 67 1B FB           AND    byte ptr [bx + 0x1b], 0xfb ; LOGIC
0545A6  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0 ; CMP
0545AA  75 03                 JNE    0x545af ; CJUMP
0545AC  E9 BF FE              JMP    0x5446e ; JUMP
0545AF  FF 4E C4              DEC    word ptr [bp - 0x3c] ; ARITH
0545B2  E9 C2 FE              JMP    0x54477 ; JUMP
0545B5  90                    NOP ; NOP
