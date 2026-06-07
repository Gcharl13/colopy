; ============================================================================
; func_06E2DE_unknown
; Region   : overlay
; Bytes    : file 0x06E2DE..0x06E3AD  (207 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06E2DE  C8 5E 00 00           ENTER  0x5e, 0 ; PROLOGUE
06E2E2  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1 ; LOCAL_STORE
06E2E7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E2EA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E2ED  E8 26 F0              CALL   0x6d316 ; CALL_NEAR
06E2F0  0B C0                 OR     ax, ax ; LOGIC
06E2F2  74 03                 JE     0x6e2f7 ; CJUMP
06E2F4  E9 B1 00              JMP    0x6e3a8 ; JUMP
06E2F7  A3 62 1F              MOV    word ptr [0x1f62], ax ; GLOBAL_LOAD
06E2FA  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E2FD  26 8B 47 10           MOV    ax, word ptr es:[bx + 0x10] ; MOV
06E301  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
06E304  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12] ; MOV
06E308  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
06E30B  26 8B 47 14           MOV    ax, word ptr es:[bx + 0x14] ; MOV
06E30F  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
06E312  26 8B 47 16           MOV    ax, word ptr es:[bx + 0x16] ; MOV
06E316  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
06E319  83 3E 5C 1F 00        CMP    word ptr [0x1f5c], 0 ; CMP
06E31E  7C 09                 JL     0x6e329 ; CJUMP
06E320  06                    PUSH   es ; STACK_PUSH
06E321  53                    PUSH   bx ; STACK_PUSH
06E322  0E                    PUSH   cs ; STACK_PUSH
06E323  E8 05 15              CALL   0x6f82b ; CALL_NEAR
06E326  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06E329  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
06E32C  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
06E32F  FF 76 A6              PUSH   word ptr [bp - 0x5a] ; PUSH_GLOBAL
06E332  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
06E335  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E338  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E33B  0E                    PUSH   cs ; STACK_PUSH
06E33C  E8 DD 14              CALL   0x6f81c ; CALL_NEAR
06E33F  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06E342  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E345  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E348  B8 01 00              MOV    ax, 1 ; MOV
06E34B  99                    CDQ ; ARITH
06E34C  8B D8                 MOV    bx, ax ; MOV
06E34E  E8 1D FB              CALL   0x6de6e ; CALL_NEAR
06E351  C7 06 62 1F 00 00     MOV    word ptr [0x1f62], 0 ; GLOBAL_LOAD
06E357  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E35A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E35D  B8 01 00              MOV    ax, 1 ; MOV
06E360  E8 85 EC              CALL   0x6cfe8 ; CALL_NEAR
06E363  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E366  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E369  2B C0                 SUB    ax, ax ; ARITH
06E36B  E8 5E F6              CALL   0x6d9cc ; CALL_NEAR
06E36E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E371  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E374  2B C0                 SUB    ax, ax ; ARITH
06E376  E8 EB F8              CALL   0x6dc64 ; CALL_NEAR
06E379  83 3E 5C 1F 00        CMP    word ptr [0x1f5c], 0 ; CMP
06E37E  7D 0D                 JGE    0x6e38d ; CJUMP
06E380  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E383  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E386  0E                    PUSH   cs ; STACK_PUSH
06E387  E8 A1 14              CALL   0x6f82b ; CALL_NEAR
06E38A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06E38D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E390  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E393  0E                    PUSH   cs ; STACK_PUSH
06E394  E8 B2 14              CALL   0x6f849 ; CALL_NEAR
06E397  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06E39A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06E39D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06E3A0  E8 E9 F4              CALL   0x6d88c ; CALL_NEAR
06E3A3  C7 46 AA 00 00        MOV    word ptr [bp - 0x56], 0 ; LOCAL_STORE
06E3A8  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
06E3AB  C9                    LEAVE ; EPILOGUE
06E3AC  CB                    RETF ; RETURN
