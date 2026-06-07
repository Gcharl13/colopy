; ============================================================================
; func_078068_unknown
; Region   : overlay
; Bytes    : file 0x078068..0x078141  (217 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078068  C8 56 00 00           ENTER  0x56, 0 ; PROLOGUE
07806C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
07806F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
078072  9A FA 06 1F 18        LCALL  0x181f, 0x6fa ; THUNK -> 0x037F:0x00C0 (thunk @file 0x01ACEA type B) overlay @file 0x02EBFC
078077  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07807A  0B C0                 OR     ax, ax ; LOGIC
07807C  75 03                 JNE    0x78081 ; CJUMP
07807E  E9 BE 00              JMP    0x7813f ; JUMP
078081  A1 2A 83              MOV    ax, word ptr [0x832a] ; GLOBAL_LOAD
078084  2B 06 28 83           SUB    ax, word ptr [0x8328] ; ARITH
078088  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
07808B  F7 2E D4 5A           IMUL   word ptr [0x5ad4] ; ARITH
07808F  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
078092  A1 2C 83              MOV    ax, word ptr [0x832c] ; GLOBAL_LOAD
078095  2B 06 2E 83           SUB    ax, word ptr [0x832e] ; ARITH
078099  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
07809C  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
0780A0  05 08 00              ADD    ax, 8 ; ARITH
0780A3  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
0780A6  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
0780AA  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0780AD  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0780B0  16                    PUSH   ss ; STACK_PUSH
0780B1  50                    PUSH   ax ; STACK_PUSH
0780B2  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
0780B7  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0780BA  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
0780BE  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
0780C2  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0780C5  16                    PUSH   ss ; STACK_PUSH
0780C6  50                    PUSH   ax ; STACK_PUSH
0780C7  2B C0                 SUB    ax, ax ; ARITH
0780C9  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
0780CE  40                    INC    ax ; ARITH
0780CF  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
0780D2  8A 0E 84 01           MOV    cl, byte ptr [0x184] ; GLOBAL_LOAD
0780D6  B8 07 00              MOV    ax, 7 ; MOV
0780D9  D3 F8                 SAR    ax, cl ; LOGIC
0780DB  01 46 AE              ADD    word ptr [bp - 0x52], ax ; ARITH
0780DE  B8 06 00              MOV    ax, 6 ; MOV
0780E1  D3 F8                 SAR    ax, cl ; LOGIC
0780E3  01 46 AC              ADD    word ptr [bp - 0x54], ax ; ARITH
0780E6  83 3E 84 01 00        CMP    word ptr [0x184], 0 ; CMP
0780EB  75 24                 JNE    0x78111 ; CJUMP
0780ED  FF 36 B2 25           PUSH   word ptr [0x25b2] ; PUSH_GLOBAL
0780F1  FF 36 B0 25           PUSH   word ptr [0x25b0] ; PUSH_GLOBAL
0780F5  FF 36 AE 25           PUSH   word ptr [0x25ae] ; PUSH_GLOBAL
0780F9  FF 36 AC 25           PUSH   word ptr [0x25ac] ; PUSH_GLOBAL
0780FD  6A 07                 PUSH   7 ; STACK_PUSH
0780FF  6A 00                 PUSH   0 ; STACK_PUSH
078101  8B 46 AE              MOV    ax, word ptr [bp - 0x52] ; LOCAL_LOAD
078104  48                    DEC    ax ; ARITH
078105  8B 56 AC              MOV    dx, word ptr [bp - 0x54] ; LOCAL_LOAD
078108  4A                    DEC    dx ; ARITH
078109  8B 5E AA              MOV    bx, word ptr [bp - 0x56] ; LOCAL_LOAD
07810C  9A BA 00 1F 18        LCALL  0x181f, 0xba ; THUNK -> 0x0B9E:0x000A (thunk @file 0x01A6AA type B)
078111  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
078114  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
078117  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
07811A  8B DA                 MOV    bx, dx ; MOV
07811C  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
078121  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
078125  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
078129  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
07812C  16                    PUSH   ss ; STACK_PUSH
07812D  50                    PUSH   ax ; STACK_PUSH
07812E  6A 00                 PUSH   0 ; STACK_PUSH
078130  8D 1E AC 25           LEA    bx, [0x25ac] ; ADDR
078134  8B 46 AE              MOV    ax, word ptr [bp - 0x52] ; LOCAL_LOAD
078137  8B 56 AC              MOV    dx, word ptr [bp - 0x54] ; LOCAL_LOAD
07813A  9A FA 01 1F 18        LCALL  0x181f, 0x1fa ; THUNK -> 0x0C11:0x000C (thunk @file 0x01A7EA type B)
07813F  C9                    LEAVE ; EPILOGUE
078140  CB                    RETF ; RETURN
