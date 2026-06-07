; ============================================================================
; func_0268CE_unknown
; Region   : overlay
; Bytes    : file 0x0268CE..0x026965  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0268CE  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
0268D2  56                    PUSH   si ; STACK_PUSH
0268D3  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0268D7  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4 ; CMP
0268DB  73 11                 JAE    0x268ee ; CJUMP
0268DD  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
0268E0  2A E4                 SUB    ah, ah ; ARITH
0268E2  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
0268E5  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah ; CMP
0268E9  75 03                 JNE    0x268ee ; CJUMP
0268EB  E9 0A 01              JMP    0x269f8 ; JUMP
0268EE  83 3E 98 0B 00        CMP    word ptr [0xb98], 0 ; CMP
0268F3  74 03                 JE     0x268f8 ; CJUMP
0268F5  E9 00 01              JMP    0x269f8 ; JUMP
0268F8  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
0268FD  74 03                 JE     0x26902 ; CJUMP
0268FF  E9 F6 00              JMP    0x269f8 ; JUMP
026902  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
026906  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02690A  8A 47 1B              MOV    al, byte ptr [bx + 0x1b] ; MOV
02690D  2A E4                 SUB    ah, ah ; ARITH
02690F  50                    PUSH   ax ; STACK_PUSH
026910  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026913  16                    PUSH   ss ; STACK_PUSH
026914  50                    PUSH   ax ; STACK_PUSH
026915  9A A0 01 1F 18        LCALL  0x181f, 0x1a0 ; THUNK -> 0x004B:0x0156 (thunk @file 0x01A790 type B) overlay @file 0x0604FE
02691A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02691D  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026920  50                    PUSH   ax ; STACK_PUSH
026921  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
026926  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026929  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0 ; LOCAL_STORE
02692E  EB 29                 JMP    0x26959 ; JUMP
026930  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
026934  8B 76 AC              MOV    si, word ptr [bp - 0x54] ; LOCAL_LOAD
026937  8A 80 8C 00           MOV    al, byte ptr [bx + si + 0x8c] ; MOV
02693B  98                    CWDE ; ARITH
02693C  50                    PUSH   ax ; STACK_PUSH
02693D  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026940  16                    PUSH   ss ; STACK_PUSH
026941  50                    PUSH   ax ; STACK_PUSH
026942  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
026947  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02694A  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
02694D  50                    PUSH   ax ; STACK_PUSH
02694E  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
026953  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026956  FF 46 AC              INC    word ptr [bp - 0x54] ; ARITH
026959  83 7E AC 04           CMP    word ptr [bp - 0x54], 4 ; CMP
02695D  7D 25                 JGE    0x26984 ; CJUMP
02695F  83 7E AC 01           CMP    word ptr [bp - 0x54], 1 ; CMP
026963  75 CB                 JNE    0x26930 ; CJUMP
