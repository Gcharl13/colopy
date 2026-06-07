; ============================================================================
; func_073BB0_unknown
; Region   : overlay
; Bytes    : file 0x073BB0..0x073D1E  (366 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "COLONIZE"  (auto-named via string xrefs)
; ============================================================================

073BB0  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
073BB4  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1 ; LOCAL_STORE
073BB9  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0 ; LOCAL_STORE
073BBE  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0 ; LOCAL_STORE
073BC3  83 3E 5A 01 00        CMP    word ptr [0x15a], 0 ; CMP
073BC8  74 05                 JE     0x73bcf ; CJUMP
073BCA  C7 46 AA 05 00        MOV    word ptr [bp - 0x56], 5 ; LOCAL_STORE
073BCF  68 86 21              PUSH   0x2186 ; PUSH_CONST
073BD2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
073BD5  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
073BDA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
073BDD  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
073BE0  0B C0                 OR     ax, ax ; LOGIC
073BE2  75 03                 JNE    0x73be7 ; CJUMP
073BE4  E9 E5 06              JMP    0x742cc ; JUMP
073BE7  8D 5E B0              LEA    bx, [bp - 0x50] ; ADDR
073BEA  8B 46 9C              MOV    ax, word ptr [bp - 0x64] ; LOCAL_LOAD
073BED  9A EE 0D 1F 1A        LCALL  0x1a1f, 0xdee ; THUNK -> 0x0B2C:0x0004 (thunk @file 0x01D3DE type B) overlay @file 0x0287EA
073BF2  0B C0                 OR     ax, ax ; LOGIC
073BF4  75 03                 JNE    0x73bf9 ; CJUMP
073BF6  E9 D3 06              JMP    0x742cc ; JUMP
073BF9  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
073BFC  50                    PUSH   ax ; STACK_PUSH
073BFD  68 7A 21              PUSH   0x217a                       ; STRING: "COLONIZE"
073C00  9A 16 08 1D 0D        LCALL  0xd1d, 0x816 ; LCALL
073C05  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
073C08  0B C0                 OR     ax, ax ; LOGIC
073C0A  74 08                 JE     0x73c14 ; CJUMP
073C0C  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2 ; LOCAL_STORE
073C11  E9 B8 06              JMP    0x742cc ; JUMP
073C14  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
073C17  6A 01                 PUSH   1 ; STACK_PUSH
073C19  6A 02                 PUSH   2 ; STACK_PUSH
073C1B  8D 46 A2              LEA    ax, [bp - 0x5e] ; ADDR
073C1E  50                    PUSH   ax ; STACK_PUSH
073C1F  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
073C24  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
073C27  0B C0                 OR     ax, ax ; LOGIC
073C29  75 03                 JNE    0x73c2e ; CJUMP
073C2B  E9 9E 06              JMP    0x742cc ; JUMP
073C2E  A1 1A 08              MOV    ax, word ptr [0x81a] ; GLOBAL_LOAD
073C31  39 46 A2              CMP    word ptr [bp - 0x5e], ax ; CMP
073C34  7F D6                 JG     0x73c0c ; CJUMP
073C36  7D 08                 JGE    0x73c40 ; CJUMP
073C38  C7 46 AA 03 00        MOV    word ptr [bp - 0x56], 3 ; LOCAL_STORE
073C3D  E9 8C 06              JMP    0x742cc ; JUMP
073C40  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
073C43  6A 01                 PUSH   1 ; STACK_PUSH
073C45  6A 04                 PUSH   4 ; STACK_PUSH
073C47  8D 46 A6              LEA    ax, [bp - 0x5a] ; ADDR
073C4A  50                    PUSH   ax ; STACK_PUSH
073C4B  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
073C50  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
073C53  0B C0                 OR     ax, ax ; LOGIC
073C55  75 03                 JNE    0x73c5a ; CJUMP
073C57  E9 72 06              JMP    0x742cc ; JUMP
073C5A  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
073C5D  F7 6E A6              IMUL   word ptr [bp - 0x5a] ; ARITH
073C60  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
073C63  89 56 AE              MOV    word ptr [bp - 0x52], dx ; LOCAL_STORE
073C66  8B 0E 82 01           MOV    cx, word ptr [0x182] ; GLOBAL_LOAD
073C6A  0B 0E 80 01           OR     cx, word ptr [0x180] ; LOGIC
073C6E  74 14                 JE     0x73c84 ; CJUMP
073C70  3B 06 80 01           CMP    ax, word ptr [0x180] ; CMP
073C74  75 06                 JNE    0x73c7c ; CJUMP
073C76  3B 16 82 01           CMP    dx, word ptr [0x182] ; CMP
073C7A  74 31                 JE     0x73cad ; CJUMP
073C7C  C7 46 AA 04 00        MOV    word ptr [bp - 0x56], 4 ; LOCAL_STORE
073C81  E9 48 06              JMP    0x742cc ; JUMP
073C84  6A 04                 PUSH   4 ; STACK_PUSH
073C86  8D 46 A6              LEA    ax, [bp - 0x5a] ; ADDR
073C89  50                    PUSH   ax ; STACK_PUSH
073C8A  68 3A 85              PUSH   0x853a ; PUSH_CONST
073C8D  9A 82 0D 1D 0D        LCALL  0xd1d, 0xd82 ; LCALL
073C92  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
073C95  2B C0                 SUB    ax, ax ; ARITH
073C97  9A 72 0C 1F 1A        LCALL  0x1a1f, 0xc72 ; THUNK -> 0x0000:0x0058 (thunk @file 0x01D262 type A) overlay @file 0x025958
073C9C  0B C0                 OR     ax, ax ; LOGIC
073C9E  74 08                 JE     0x73ca8 ; CJUMP
073CA0  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1 ; LOCAL_STORE
073CA5  E9 24 06              JMP    0x742cc ; JUMP
073CA8  C7 46 A4 01 00        MOV    word ptr [bp - 0x5c], 1 ; LOCAL_STORE
073CAD  6A 04                 PUSH   4 ; STACK_PUSH
073CAF  8D 46 A6              LEA    ax, [bp - 0x5a] ; ADDR
073CB2  50                    PUSH   ax ; STACK_PUSH
073CB3  68 3A 85              PUSH   0x853a ; PUSH_CONST
073CB6  9A 82 0D 1D 0D        LCALL  0xd1d, 0xd82 ; LCALL
073CBB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
073CBE  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
073CC1  6A 01                 PUSH   1 ; STACK_PUSH
073CC3  68 8E 00              PUSH   0x8e ; PUSH_CONST
073CC6  68 80 53              PUSH   0x5380 ; PUSH_CONST
073CC9  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
073CCE  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
073CD1  0B C0                 OR     ax, ax ; LOGIC
073CD3  75 03                 JNE    0x73cd8 ; CJUMP
073CD5  E9 F4 05              JMP    0x742cc ; JUMP
073CD8  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
073CDB  6A 01                 PUSH   1 ; STACK_PUSH
073CDD  68 D0 00              PUSH   0xd0 ; PUSH_CONST
073CE0  68 0E 54              PUSH   0x540e ; PUSH_CONST
073CE3  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
073CE8  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
073CEB  0B C0                 OR     ax, ax ; LOGIC
073CED  75 03                 JNE    0x73cf2 ; CJUMP
073CEF  E9 DA 05              JMP    0x742cc ; JUMP
073CF2  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
073CF5  6A 01                 PUSH   1 ; STACK_PUSH
073CF7  6A 18                 PUSH   0x18 ; PUSH_CONST
073CF9  68 8E 94              PUSH   0x948e ; PUSH_CONST
073CFC  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
073D01  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
073D04  0B C0                 OR     ax, ax ; LOGIC
073D06  75 03                 JNE    0x73d0b ; CJUMP
073D08  E9 C1 05              JMP    0x742cc ; JUMP
073D0B  83 3E 9E 53 00        CMP    word ptr [0x539e], 0 ; CMP
073D10  74 1E                 JE     0x73d30 ; CJUMP
073D12  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
073D15  6A 01                 PUSH   1 ; STACK_PUSH
073D17  69 06 9E 53 CA 00     IMUL   ax, word ptr [0x539e], 0xca ; ARITH
073D1D  50                    PUSH   ax ; STACK_PUSH
