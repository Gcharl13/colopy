; ============================================================================
; func_002EE4_unknown
; Region   : load_image
; Bytes    : file 0x002EE4..0x00304A  (358 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002EE4  C8 1A 00 00           ENTER  0x1a, 0 ; PROLOGUE
002EE8  53                    PUSH   bx ; STACK_PUSH
002EE9  52                    PUSH   dx ; STACK_PUSH
002EEA  50                    PUSH   ax ; STACK_PUSH
002EEB  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
002EF0  8D 4E 10              LEA    cx, [bp + 0x10] ; ADDR
002EF3  51                    PUSH   cx ; STACK_PUSH
002EF4  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
002EF7  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
002EFA  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
002EFD  8D 4E FC              LEA    cx, [bp - 4] ; ADDR
002F00  51                    PUSH   cx ; STACK_PUSH
002F01  8D 4E EC              LEA    cx, [bp - 0x14] ; ADDR
002F04  51                    PUSH   cx ; STACK_PUSH
002F05  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002F08  0E                    PUSH   cs ; STACK_PUSH
002F09  E8 68 FE              CALL   0x2d74 ; CALL_NEAR
002F0C  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
002F0F  0B C0                 OR     ax, ax ; LOGIC
002F11  75 03                 JNE    0x2f16 ; CJUMP
002F13  E9 30 01              JMP    0x3046 ; JUMP
002F16  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
002F1B  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002F1E  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
002F21  2B 46 E4              SUB    ax, word ptr [bp - 0x1c] ; ARITH
002F24  F7 D8                 NEG    ax ; ARITH
002F26  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
002F29  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
002F2C  8A 4E EC              MOV    cl, byte ptr [bp - 0x14] ; LOCAL_LOAD
002F2F  D3 7E 08              SAR    word ptr [bp + 8], cl ; LOGIC
002F32  D3 7E E8              SAR    word ptr [bp - 0x18], cl ; LOGIC
002F35  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
002F38  D3 F8                 SAR    ax, cl ; LOGIC
002F3A  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
002F3D  8B 46 E4              MOV    ax, word ptr [bp - 0x1c] ; LOCAL_LOAD
002F40  D3 F8                 SAR    ax, cl ; LOGIC
002F42  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
002F45  83 7E EC 00           CMP    word ptr [bp - 0x14], 0 ; CMP
002F49  74 0D                 JE     0x2f58 ; CJUMP
002F4B  8A 46 F6              MOV    al, byte ptr [bp - 0xa] ; LOCAL_LOAD
002F4E  22 46 FA              AND    al, byte ptr [bp - 6] ; LOGIC
002F51  A8 01                 TEST   al, 1 ; LOGIC
002F53  74 03                 JE     0x2f58 ; CJUMP
002F55  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
002F58  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
002F5B  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
002F5E  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
002F63  EB 74                 JMP    0x2fd9 ; JUMP
002F65  90                    NOP ; NOP
002F66  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
002F6A  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
002F6E  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
002F71  40                    INC    ax ; ARITH
002F72  50                    PUSH   ax ; STACK_PUSH
002F73  8B 46 E0              MOV    ax, word ptr [bp - 0x20] ; LOCAL_LOAD
002F76  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002F7A  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
002F7D  9A 0A 00 36 0C        LCALL  0xc36, 0xa ; LCALL
002F82  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
002F85  39 46 E8              CMP    word ptr [bp - 0x18], ax ; CMP
002F88  75 06                 JNE    0x2f90 ; CJUMP
002F8A  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
002F8D  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
002F90  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
002F93  39 46 E8              CMP    word ptr [bp - 0x18], ax ; CMP
002F96  7F 1C                 JG     0x2fb4 ; CJUMP
002F98  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
002F9C  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
002FA0  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
002FA3  40                    INC    ax ; ARITH
002FA4  50                    PUSH   ax ; STACK_PUSH
002FA5  B8 38 00              MOV    ax, 0x38 ; CONST_LOAD
002FA8  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002FAC  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
002FAF  9A 0A 00 36 0C        LCALL  0xc36, 0xa ; LCALL
002FB4  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
002FB7  01 46 10              ADD    word ptr [bp + 0x10], ax ; ARITH
002FBA  F6 46 06 01           TEST   byte ptr [bp + 6], 1 ; LOGIC
002FBE  74 16                 JE     0x2fd6 ; CJUMP
002FC0  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
002FC3  01 46 F8              ADD    word ptr [bp - 8], ax ; ARITH
002FC6  EB 06                 JMP    0x2fce ; JUMP
002FC8  29 46 F8              SUB    word ptr [bp - 8], ax ; ARITH
002FCB  FF 46 10              INC    word ptr [bp + 0x10] ; ARITH
002FCE  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
002FD1  39 46 F8              CMP    word ptr [bp - 8], ax ; CMP
002FD4  7D F2                 JGE    0x2fc8 ; CJUMP
002FD6  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
002FD9  8B 46 E6              MOV    ax, word ptr [bp - 0x1a] ; LOCAL_LOAD
002FDC  39 46 F0              CMP    word ptr [bp - 0x10], ax ; CMP
002FDF  7D 1D                 JGE    0x2ffe ; CJUMP
002FE1  F6 46 06 02           TEST   byte ptr [bp + 6], 2 ; LOGIC
002FE5  75 03                 JNE    0x2fea ; CJUMP
002FE7  E9 7C FF              JMP    0x2f66 ; JUMP
002FEA  6A 03                 PUSH   3 ; STACK_PUSH
002FEC  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
002FEF  43                    INC    bx ; ARITH
002FF0  8B 46 E0              MOV    ax, word ptr [bp - 0x20] ; LOCAL_LOAD
002FF3  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
002FF6  9A 5C 01 2B 01        LCALL  0x12b, 0x15c ; LCALL
002FFB  EB 85                 JMP    0x2f82 ; JUMP
002FFD  90                    NOP ; NOP
002FFE  A1 70 00              MOV    ax, word ptr [0x70] ; GLOBAL_LOAD
003001  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
003004  83 7E EA 01           CMP    word ptr [bp - 0x16], 1 ; CMP
003008  75 0B                 JNE    0x3015 ; CJUMP
00300A  83 7E E4 01           CMP    word ptr [bp - 0x1c], 1 ; CMP
00300E  7E 05                 JLE    0x3015 ; CJUMP
003010  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
003015  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
003019  74 2B                 JE     0x3046 ; CJUMP
00301B  6A 01                 PUSH   1 ; STACK_PUSH
00301D  6A 0F                 PUSH   0xf ; PUSH_CONST
00301F  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
003022  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
003025  40                    INC    ax ; ARITH
003026  40                    INC    ax ; ARITH
003027  50                    PUSH   ax ; STACK_PUSH
003028  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00302B  0E                    PUSH   cs ; STACK_PUSH
00302C  E8 1F FE              CALL   0x2e4e ; CALL_NEAR
00302F  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
003032  6A 01                 PUSH   1 ; STACK_PUSH
003034  6A 0C                 PUSH   0xc ; PUSH_CONST
003036  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
003039  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
00303C  40                    INC    ax ; ARITH
00303D  40                    INC    ax ; ARITH
00303E  50                    PUSH   ax ; STACK_PUSH
00303F  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
003042  0E                    PUSH   cs ; STACK_PUSH
003043  E8 08 FE              CALL   0x2e4e ; CALL_NEAR
003046  C9                    LEAVE ; EPILOGUE
003047  CA 0C 00              RETF   0xc ; RETURN
