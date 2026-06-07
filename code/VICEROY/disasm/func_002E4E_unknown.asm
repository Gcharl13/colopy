; ============================================================================
; func_002E4E_unknown
; Region   : load_image
; Bytes    : file 0x002E4E..0x002EE3  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002E4E  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
002E52  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
002E56  7F 03                 JG     0x2e5b ; CJUMP
002E58  E9 86 00              JMP    0x2ee1 ; JUMP
002E5B  83 46 0A 02           ADD    word ptr [bp + 0xa], 2 ; ARITH
002E5F  6A 0A                 PUSH   0xa ; PUSH_CONST
002E61  8D 46 EA              LEA    ax, [bp - 0x16] ; ADDR
002E64  50                    PUSH   ax ; STACK_PUSH
002E65  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002E68  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
002E6D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
002E70  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
002E74  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
002E78  8D 46 EA              LEA    ax, [bp - 0x16] ; ADDR
002E7B  16                    PUSH   ss ; STACK_PUSH
002E7C  50                    PUSH   ax ; STACK_PUSH
002E7D  2B C0                 SUB    ax, ax ; ARITH
002E7F  9A 06 00 2A 0C        LCALL  0xc2a, 6 ; LCALL
002E84  48                    DEC    ax ; ARITH
002E85  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
002E88  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0 ; CMP
002E8C  74 23                 JE     0x2eb1 ; CJUMP
002E8E  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
002E92  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
002E96  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
002E9A  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
002E9E  6A 07                 PUSH   7 ; STACK_PUSH
002EA0  6A 00                 PUSH   0 ; STACK_PUSH
002EA2  8B D8                 MOV    bx, ax ; MOV
002EA4  43                    INC    bx ; ARITH
002EA5  43                    INC    bx ; ARITH
002EA6  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002EA9  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
002EAC  9A 0A 00 9E 0B        LCALL  0xb9e, 0xa ; LCALL
002EB1  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
002EB4  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
002EB7  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
002EBA  8B DA                 MOV    bx, dx ; MOV
002EBC  9A 0A 00 28 0C        LCALL  0xc28, 0xa ; LCALL
002EC1  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
002EC5  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
002EC9  8D 46 EA              LEA    ax, [bp - 0x16] ; ADDR
002ECC  16                    PUSH   ss ; STACK_PUSH
002ECD  50                    PUSH   ax ; STACK_PUSH
002ECE  6A 00                 PUSH   0 ; STACK_PUSH
002ED0  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002ED3  40                    INC    ax ; ARITH
002ED4  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
002ED7  42                    INC    dx ; ARITH
002ED8  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002EDC  9A 0C 00 11 0C        LCALL  0xc11, 0xc ; LCALL
002EE1  C9                    LEAVE ; EPILOGUE
002EE2  CB                    RETF ; RETURN
