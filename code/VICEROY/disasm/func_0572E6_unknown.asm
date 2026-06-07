; ============================================================================
; func_0572E6_unknown
; Region   : overlay
; Bytes    : file 0x0572E6..0x05738A  (164 bytes)
; Purpose  : Native conversion  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "INDIANSCONVERT"  (auto-named via string xrefs)
; ============================================================================

0572E6  C8 25 0F 00           ENTER  0xf25, 0 ; PROLOGUE
0572EA  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
0572ED  74 03                 JE     0x572f2 ; CJUMP
0572EF  E9 8A 00              JMP    0x5737c ; JUMP
0572F2  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
0572F6  8A 47 02              MOV    al, byte ptr [bx + 2] ; MOV
0572F9  2A E4                 SUB    ah, ah ; ARITH
0572FB  40                    INC    ax ; ARITH
0572FC  40                    INC    ax ; ARITH
0572FD  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
057300  F6 C1 10              TEST   cl, 0x10 ; LOGIC
057303  74 05                 JE     0x5730a ; CJUMP
057305  D1 E0                 SHL    ax, 1 ; LOGIC
057307  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
05730A  6A 0F                 PUSH   0xf ; PUSH_CONST
05730C  6A 00                 PUSH   0 ; STACK_PUSH
05730E  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
057313  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057316  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
057319  7D 61                 JGE    0x5737c ; CJUMP
05731B  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
05731F  7D 2B                 JGE    0x5734c ; CJUMP
057321  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
057325  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
05732A  75 20                 JNE    0x5734c ; CJUMP
05732C  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
05732F  40                    INC    ax ; ARITH
057330  40                    INC    ax ; ARITH
057331  1E                    PUSH   ds ; STACK_PUSH
057332  50                    PUSH   ax ; STACK_PUSH
057333  6A 00                 PUSH   0 ; STACK_PUSH
057335  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
05733A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05733D  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
057341  68 2A 18              PUSH   0x182a                       ; STRING: "INDIANSCONVERT"
057344  9A 9C 01 1F 19        LCALL  0x191f, 0x19c ; THUNK -> 0x0000:0x3760 (thunk @file 0x01B78C type A) overlay @file 0x029060
057349  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05734C  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
057350  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
057353  2A E4                 SUB    ah, ah ; ARITH
057355  50                    PUSH   ax ; STACK_PUSH
057356  8A 07                 MOV    al, byte ptr [bx] ; MOV
057358  50                    PUSH   ax ; STACK_PUSH
057359  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
05735C  50                    PUSH   ax ; STACK_PUSH
05735D  6A 00                 PUSH   0 ; STACK_PUSH
05735F  9A 5C 09 1F 18        LCALL  0x181f, 0x95c ; THUNK -> 0x0427:0x06B4 (thunk @file 0x01AF4C type B) overlay @file 0x0313C8
057364  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
057367  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
05736A  0B C0                 OR     ax, ax ; LOGIC
05736C  7D 03                 JGE    0x57371 ; CJUMP
05736E  E9 A4 06              JMP    0x57a15 ; JUMP
057371  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
057374  C6 87 5B 31 1B        MOV    byte ptr [bx + 0x315b], 0x1b ; CONST_LOAD
057379  E9 94 06              JMP    0x57a10 ; JUMP
05737C  A1 58 9E              MOV    ax, word ptr [0x9e58] ; GLOBAL_LOAD
05737F  39 06 78 9E           CMP    word ptr [0x9e78], ax ; CMP
057383  7E 6D                 JLE    0x573f2 ; CJUMP
057385  83 7E CA 00           CMP    word ptr [bp - 0x36], 0 ; CMP
057389  75                    DB     0x75 ; DATA_BYTE
