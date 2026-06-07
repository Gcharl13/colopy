; ============================================================================
; func_022F08_unknown
; Region   : overlay
; Bytes    : file 0x022F08..0x022F83  (123 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022F08  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
022F0C  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
022F11  6A 17                 PUSH   0x17 ; PUSH_CONST
022F13  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
022F17  8D 06 51 0A           LEA    ax, [0xa51] ; ADDR
022F1B  8D 16 50 0A           LEA    dx, [0xa50] ; ADDR
022F1F  9A 20 01 1F 19        LCALL  0x191f, 0x120 ; THUNK -> 0x0000:0x37FC (thunk @file 0x01B710 type A) overlay @file 0x0290FC
022F24  0B C0                 OR     ax, ax ; LOGIC
022F26  74 03                 JE     0x22f2b ; CJUMP
022F28  E9 A8 00              JMP    0x22fd3 ; JUMP
022F2B  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
022F2E  EB 63                 JMP    0x22f93 ; JUMP
022F30  A1 9E 53              MOV    ax, word ptr [0x539e] ; GLOBAL_LOAD
022F33  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
022F36  7D 61                 JGE    0x22f99 ; CJUMP
022F38  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
022F3B  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
022F40  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
022F43  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
022F46  40                    INC    ax ; ARITH
022F47  40                    INC    ax ; ARITH
022F48  50                    PUSH   ax ; STACK_PUSH
022F49  68 20 98              PUSH   0x9820 ; PUSH_CONST
022F4C  9A 80 0C 1D 0D        LCALL  0xd1d, 0xc80 ; LCALL
022F51  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022F54  0B C0                 OR     ax, ax ; LOGIC
022F56  75 38                 JNE    0x22f90 ; CJUMP
022F58  83 3E 96 53 04        CMP    word ptr [0x5396], 4 ; CMP
022F5D  7D 2B                 JGE    0x22f8a ; CJUMP
022F5F  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
022F63  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
022F66  2A E4                 SUB    ah, ah ; ARITH
022F68  50                    PUSH   ax ; STACK_PUSH
022F69  8A 07                 MOV    al, byte ptr [bx] ; MOV
022F6B  50                    PUSH   ax ; STACK_PUSH
022F6C  9A 4A 07 1F 18        LCALL  0x181f, 0x74a ; THUNK -> 0x037F:0x02F8 (thunk @file 0x01AD3A type B) overlay @file 0x02EE34
022F71  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022F74  2A E4                 SUB    ah, ah ; ARITH
022F76  8A 0E 96 53           MOV    cl, byte ptr [0x5396] ; GLOBAL_LOAD
022F7A  BA 10 00              MOV    dx, 0x10 ; CONST_LOAD
022F7D  D3 E2                 SHL    dx, cl ; LOGIC
022F7F  85 C2                 TEST   dx, ax ; LOGIC
022F81  75 07                 JNE    0x22f8a ; CJUMP
