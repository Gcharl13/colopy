; ============================================================================
; func_020F50_unknown
; Region   : overlay
; Bytes    : file 0x020F50..0x020FD6  (134 bytes)
; Purpose  : Tutorial dispatcher  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

020F50  C8 2A 00 00           ENTER  0x2a, 0 ; PROLOGUE
020F54  56                    PUSH   si ; STACK_PUSH
020F55  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
020F58  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
020F5B  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
020F5E  80 BF 4C 31 00        CMP    byte ptr [bx + 0x314c], 0 ; CMP
020F63  74 03                 JE     0x20f68 ; CJUMP
020F65  E9 97 06              JMP    0x215ff ; JUMP
020F68  0B C0                 OR     ax, ax ; LOGIC
020F6A  7D 03                 JGE    0x20f6f ; CJUMP
020F6C  E9 90 06              JMP    0x215ff ; JUMP
020F6F  39 06 9C 53           CMP    word ptr [0x539c], ax ; CMP
020F73  7F 03                 JG     0x20f78 ; CJUMP
020F75  E9 87 06              JMP    0x215ff ; JUMP
020F78  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
020F7B  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
020F7F  25 0F 00              AND    ax, 0xf ; LOGIC
020F82  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
020F85  3B 06 98 53           CMP    ax, word ptr [0x5398] ; CMP
020F89  74 03                 JE     0x20f8e ; CJUMP
020F8B  E9 71 06              JMP    0x215ff ; JUMP
020F8E  6B 5E DA 1C           IMUL   bx, word ptr [bp - 0x26], 0x1c ; ARITH
020F92  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
020F96  2A E4                 SUB    ah, ah ; ARITH
020F98  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
020F9B  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
020F9F  2A ED                 SUB    ch, ch ; ARITH
020FA1  89 4E E4              MOV    word ptr [bp - 0x1c], cx ; LOCAL_STORE
020FA4  51                    PUSH   cx ; STACK_PUSH
020FA5  50                    PUSH   ax ; STACK_PUSH
020FA6  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
020FAB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
020FAE  0B C0                 OR     ax, ax ; LOGIC
020FB0  75 03                 JNE    0x20fb5 ; CJUMP
020FB2  E9 4A 06              JMP    0x215ff ; JUMP
020FB5  83 3E 8E 53 00        CMP    word ptr [0x538e], 0 ; CMP
020FBA  75 48                 JNE    0x21004 ; CJUMP
020FBC  80 3E A6 53 00        CMP    byte ptr [0x53a6], 0 ; CMP
020FC1  75 41                 JNE    0x21004 ; CJUMP
020FC3  F6 06 86 53 10        TEST   byte ptr [0x5386], 0x10 ; LOGIC
020FC8  75 3A                 JNE    0x21004 ; CJUMP
020FCA  6B 5E DA 1C           IMUL   bx, word ptr [bp - 0x26], 0x1c ; ARITH
020FCE  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
020FD2  2A FF                 SUB    bh, bh ; ARITH
020FD4  8B C3                 MOV    ax, bx ; MOV
