; ============================================================================
; func_004B72_unknown
; Region   : load_image
; Bytes    : file 0x004B72..0x004D1D  (427 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "MYLEADER", "LEVN00", "BUILD"  (auto-named via string xrefs)
; ============================================================================

004B72  C8 50 03 00           ENTER  0x350, 0 ; PROLOGUE
004B76  57                    PUSH   di ; STACK_PUSH
004B77  56                    PUSH   si ; STACK_PUSH
004B78  68 72 00              PUSH   0x72                         ; STRING: "LEVN00"
004B7B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
004B7E  50                    PUSH   ax ; STACK_PUSH
004B7F  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
004B84  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004B87  83 7E 06 0A           CMP    word ptr [bp + 6], 0xa ; CMP
004B8B  7D 0F                 JGE    0x4b9c ; CJUMP
004B8D  68 79 00              PUSH   0x79 ; PUSH_CONST
004B90  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
004B93  50                    PUSH   ax ; STACK_PUSH
004B94  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
004B99  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004B9C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004B9F  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
004BA2  16                    PUSH   ss ; STACK_PUSH
004BA3  50                    PUSH   ax ; STACK_PUSH
004BA4  9A 2E 01 4B 00        LCALL  0x4b, 0x12e ; LCALL
004BA9  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
004BAC  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
004BB0  75 04                 JNE    0x4bb6 ; CJUMP
004BB2  0E                    PUSH   cs ; STACK_PUSH
004BB3  E8 7C FE              CALL   0x4a32 ; CALL_NEAR
004BB6  8D 86 B0 FC           LEA    ax, [bp - 0x350] ; ADDR
004BBA  16                    PUSH   ss ; STACK_PUSH
004BBB  50                    PUSH   ax ; STACK_PUSH
004BBC  6A 00                 PUSH   0 ; STACK_PUSH
004BBE  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
004BC2  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
004BC6  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
004BCA  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
004BCE  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
004BD1  50                    PUSH   ax ; STACK_PUSH
004BD2  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
004BD7  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
004BDA  0B C0                 OR     ax, ax ; LOGIC
004BDC  74 03                 JE     0x4be1 ; CJUMP
004BDE  E9 2C 01              JMP    0x4d0d ; JUMP
004BE1  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
004BE5  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
004BE9  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
004BED  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
004BF1  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
004BF5  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
004BF9  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
004BFD  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
004C01  68 C8 00              PUSH   0xc8 ; PUSH_CONST
004C04  99                    CDQ ; ARITH
004C05  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
004C08  9A 06 00 8F 0B        LCALL  0xb8f, 6 ; LCALL
004C0D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004C10  48                    DEC    ax ; ARITH
004C11  48                    DEC    ax ; ARITH
004C12  74 08                 JE     0x4c1c ; CJUMP
004C14  48                    DEC    ax ; ARITH
004C15  74 27                 JE     0x4c3e ; CJUMP
004C17  48                    DEC    ax ; ARITH
004C18  74 3A                 JE     0x4c54 ; CJUMP
004C1A  EB 7D                 JMP    0x4c99 ; JUMP
004C1C  8A 1E A6 53           MOV    bl, byte ptr [0x53a6] ; GLOBAL_LOAD
004C20  2A FF                 SUB    bh, bh ; ARITH
004C22  D1 E3                 SHL    bx, 1 ; LOGIC
004C24  FF B7 94 83           PUSH   word ptr [bx - 0x7c6c] ; PUSH_GLOBAL
004C28  6A 00                 PUSH   0 ; STACK_PUSH
004C2A  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
004C2F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004C32  6B 06 98 53 34        IMUL   ax, word ptr [0x5398], 0x34 ; ARITH
004C37  05 0E 54              ADD    ax, 0x540e ; ARITH
004C3A  1E                    PUSH   ds ; STACK_PUSH
004C3B  50                    PUSH   ax ; STACK_PUSH
004C3C  EB 51                 JMP    0x4c8f ; JUMP
004C3E  8B 1E 98 53           MOV    bx, word ptr [0x5398] ; GLOBAL_LOAD
004C42  D1 E3                 SHL    bx, 1 ; LOGIC
004C44  FF B7 8C 83           PUSH   word ptr [bx - 0x7c74] ; PUSH_GLOBAL
004C48  6A 00                 PUSH   0 ; STACK_PUSH
004C4A  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
004C4F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004C52  EB 45                 JMP    0x4c99 ; JUMP
004C54  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
004C58  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
004C5B  50                    PUSH   ax ; STACK_PUSH
004C5C  6A 00                 PUSH   0 ; STACK_PUSH
004C5E  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
004C62  9A 44 01 B3 05        LCALL  0x5b3, 0x144 ; LCALL
004C67  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
004C6A  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
004C6D  16                    PUSH   ss ; STACK_PUSH
004C6E  50                    PUSH   ax ; STACK_PUSH
004C6F  6A 00                 PUSH   0 ; STACK_PUSH
004C71  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
004C76  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
004C79  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
004C7D  68 7B 00              PUSH   0x7b                         ; STRING: "MYLEADER"
004C80  68 7C 08              PUSH   0x87c ; PUSH_CONST
004C83  9A 22 04 1F 18        LCALL  0x181f, 0x422 ; THUNK -> 0x0000:0x0208 (thunk @file 0x01AA12 type A) overlay @file 0x025B08
004C88  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
004C8B  1E                    PUSH   ds ; STACK_PUSH
004C8C  68 3C 83              PUSH   0x833c ; PUSH_CONST
004C8F  6A 01                 PUSH   1 ; STACK_PUSH
004C91  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
004C96  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
004C99  9A 0A 04 1F 18        LCALL  0x181f, 0x40a ; THUNK -> 0x0000:0x37F6 (thunk @file 0x01A9FA type A) overlay @file 0x0290F6
004C9E  80 0E 56 1F 20        OR     byte ptr [0x1f56], 0x20 ; LOGIC
004CA3  C7 06 6A 1F 01 00     MOV    word ptr [0x1f6a], 1 ; GLOBAL_LOAD
004CA9  C7 06 64 1F 00 00     MOV    word ptr [0x1f64], 0 ; GLOBAL_LOAD
004CAF  68 84 00              PUSH   0x84                         ; STRING: "BUILD"
004CB2  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
004CB5  50                    PUSH   ax ; STACK_PUSH
004CB6  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
004CBB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004CBE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004CC1  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
004CC4  16                    PUSH   ss ; STACK_PUSH
004CC5  50                    PUSH   ax ; STACK_PUSH
004CC6  9A 2E 01 4B 00        LCALL  0x4b, 0x12e ; LCALL
004CCB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
004CCE  8B 36 4A 1F           MOV    si, word ptr [0x1f4a] ; GLOBAL_LOAD
004CD2  8B 3E 50 1F           MOV    di, word ptr [0x1f50] ; GLOBAL_LOAD
004CD6  C7 06 4A 1F 0E 00     MOV    word ptr [0x1f4a], 0xe ; GLOBAL_LOAD
004CDC  C7 06 50 1F 36 00     MOV    word ptr [0x1f50], 0x36 ; GLOBAL_LOAD
004CE2  8D 5E B0              LEA    bx, [bp - 0x50] ; ADDR
004CE5  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
004CEA  89 36 4A 1F           MOV    word ptr [0x1f4a], si ; GLOBAL_LOAD
004CEE  89 3E 50 1F           MOV    word ptr [0x1f50], di ; GLOBAL_LOAD
004CF2  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
004CF6  75 0B                 JNE    0x4d03 ; CJUMP
004CF8  8D 86 B0 FC           LEA    ax, [bp - 0x350] ; ADDR
004CFC  16                    PUSH   ss ; STACK_PUSH
004CFD  50                    PUSH   ax ; STACK_PUSH
004CFE  9A 04 00 DE 0A        LCALL  0xade, 4 ; LCALL
004D03  6A 08                 PUSH   8 ; STACK_PUSH
004D05  9A 00 00 D6 02        LCALL  0x2d6, 0 ; LCALL
004D0A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004D0D  C7 06 6A 1F 00 00     MOV    word ptr [0x1f6a], 0 ; GLOBAL_LOAD
004D13  C7 06 64 1F 01 00     MOV    word ptr [0x1f64], 1 ; GLOBAL_LOAD
004D19  5E                    POP    si ; STACK_POP
004D1A  5F                    POP    di ; STACK_POP
004D1B  C9                    LEAVE ; EPILOGUE
004D1C  CB                    RETF ; RETURN
