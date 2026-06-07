; ============================================================================
; func_076B9E_unknown
; Region   : overlay
; Bytes    : file 0x076B9E..0x076C70  (210 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

076B9E  C8 26 01 00           ENTER  0x126, 0 ; PROLOGUE
076BA2  57                    PUSH   di ; STACK_PUSH
076BA3  56                    PUSH   si ; STACK_PUSH
076BA4  BE 01 00              MOV    si, 1 ; MOV
076BA7  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
076BAA  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
076BAD  50                    PUSH   ax ; STACK_PUSH
076BAE  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
076BB3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
076BB6  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
076BB9  16                    PUSH   ss ; STACK_PUSH
076BBA  50                    PUSH   ax ; STACK_PUSH
076BBB  1E                    PUSH   ds ; STACK_PUSH
076BBC  68 02 24              PUSH   0x2402 ; PUSH_CONST
076BBF  9A 94 0A 1F 1A        LCALL  0x1a1f, 0xa94 ; THUNK -> 0x0B32:0x000E (thunk @file 0x01D084 type B) overlay @file 0x040608
076BC4  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076BC8  16                    PUSH   ss ; STACK_PUSH
076BC9  50                    PUSH   ax ; STACK_PUSH
076BCA  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
076BCD  16                    PUSH   ss ; STACK_PUSH
076BCE  50                    PUSH   ax ; STACK_PUSH
076BCF  8D 1E 06 24           LEA    bx, [0x2406] ; ADDR
076BD3  2B C0                 SUB    ax, ax ; ARITH
076BD5  9A 9E 0E 1F 1A        LCALL  0x1a1f, 0xe9e ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D48E type A) overlay @file 0x025900
076BDA  0B C0                 OR     ax, ax ; LOGIC
076BDC  74 03                 JE     0x76be1 ; CJUMP
076BDE  E9 89 00              JMP    0x76c6a ; JUMP
076BE1  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
076BE4  16                    PUSH   ss ; STACK_PUSH
076BE5  50                    PUSH   ax ; STACK_PUSH
076BE6  6A 00                 PUSH   0 ; STACK_PUSH
076BE8  6A 01                 PUSH   1 ; STACK_PUSH
076BEA  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076BEE  16                    PUSH   ss ; STACK_PUSH
076BEF  50                    PUSH   ax ; STACK_PUSH
076BF0  B8 08 00              MOV    ax, 8 ; MOV
076BF3  99                    CDQ ; ARITH
076BF4  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
076BF9  0B D0                 OR     dx, ax ; LOGIC
076BFB  74 6D                 JE     0x76c6a ; CJUMP
076BFD  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
076C00  8B 56 0E              MOV    dx, word ptr [bp + 0xe] ; LOCAL_LOAD
076C03  8B F8                 MOV    di, ax ; MOV
076C05  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
076C08  83 7E 10 00           CMP    word ptr [bp + 0x10], 0 ; CMP
076C0C  74 15                 JE     0x76c23 ; CJUMP
076C0E  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
076C11  2B 56 F4              SUB    dx, word ptr [bp - 0xc] ; ARITH
076C14  8D 5E 08              LEA    bx, [bp + 8] ; ADDR
076C17  2B C0                 SUB    ax, ax ; ARITH
076C19  9A 90 02 1F 18        LCALL  0x181f, 0x290 ; THUNK -> 0x0A4E:0x0008 (thunk @file 0x01A880 type B) overlay @file 0x0287B2
076C1E  8B F8                 MOV    di, ax ; MOV
076C20  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
076C23  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
076C26  57                    PUSH   di ; STACK_PUSH
076C27  6A 00                 PUSH   0 ; STACK_PUSH
076C29  6A 01                 PUSH   1 ; STACK_PUSH
076C2B  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076C2F  16                    PUSH   ss ; STACK_PUSH
076C30  50                    PUSH   ax ; STACK_PUSH
076C31  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
076C34  F7 6E F4              IMUL   word ptr [bp - 0xc] ; ARITH
076C37  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
076C3C  0B D0                 OR     dx, ax ; LOGIC
076C3E  74 2A                 JE     0x76c6a ; CJUMP
076C40  FF 76 14              PUSH   word ptr [bp + 0x14] ; PUSH_GLOBAL
076C43  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
076C46  6A 00                 PUSH   0 ; STACK_PUSH
076C48  6A 01                 PUSH   1 ; STACK_PUSH
076C4A  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076C4E  16                    PUSH   ss ; STACK_PUSH
076C4F  50                    PUSH   ax ; STACK_PUSH
076C50  B8 00 03              MOV    ax, 0x300 ; CONST_LOAD
076C53  99                    CDQ ; ARITH
076C54  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
076C59  0B D0                 OR     dx, ax ; LOGIC
076C5B  74 0D                 JE     0x76c6a ; CJUMP
076C5D  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076C61  16                    PUSH   ss ; STACK_PUSH
076C62  50                    PUSH   ax ; STACK_PUSH
076C63  9A AC 0E 1F 1A        LCALL  0x1a1f, 0xeac ; THUNK -> 0x0000:0x021C (thunk @file 0x01D49C type A) overlay @file 0x025B1C
076C68  2B F6                 SUB    si, si ; ARITH
076C6A  8B C6                 MOV    ax, si ; MOV
076C6C  5E                    POP    si ; STACK_POP
076C6D  5F                    POP    di ; STACK_POP
076C6E  C9                    LEAVE ; EPILOGUE
076C6F  CB                    RETF ; RETURN
