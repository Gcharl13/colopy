; ============================================================================
; func_06E0C8_unknown
; Region   : overlay
; Bytes    : file 0x06E0C8..0x06E2DE  (534 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06E0C8  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
06E0CC  57                    PUSH   di ; STACK_PUSH
06E0CD  56                    PUSH   si ; STACK_PUSH
06E0CE  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
06E0D3  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
06E0D6  0B 46 06              OR     ax, word ptr [bp + 6] ; LOGIC
06E0D9  74 05                 JE     0x6e0e0 ; CJUMP
06E0DB  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1 ; LOCAL_STORE
06E0E0  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
06E0E4  74 18                 JE     0x6e0fe ; CJUMP
06E0E6  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E0E9  26 8B 47 10           MOV    ax, word ptr es:[bx + 0x10] ; MOV
06E0ED  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06E0F0  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12] ; MOV
06E0F4  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
06E0F7  26 8B 47 14           MOV    ax, word ptr es:[bx + 0x14] ; MOV
06E0FB  EB 10                 JMP    0x6e10d ; JUMP
06E0FD  90                    NOP ; NOP
06E0FE  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06E101  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06E104  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
06E107  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
06E10A  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
06E10D  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
06E110  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
06E113  0B 46 06              OR     ax, word ptr [bp + 6] ; LOGIC
06E116  74 0D                 JE     0x6e125 ; CJUMP
06E118  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E11B  26 F6 47 0A 10        TEST   byte ptr es:[bx + 0xa], 0x10 ; LOGIC
06E120  74 03                 JE     0x6e125 ; CJUMP
06E122  E9 EF 00              JMP    0x6e214 ; JUMP
06E125  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06E129  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06E12D  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06E131  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06E135  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
06E138  03 46 0C              ADD    ax, word ptr [bp + 0xc] ; ARITH
06E13B  8B C8                 MOV    cx, ax ; MOV
06E13D  48                    DEC    ax ; ARITH
06E13E  50                    PUSH   ax ; STACK_PUSH
06E13F  6A 00                 PUSH   0 ; STACK_PUSH
06E141  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06E144  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
06E147  03 D8                 ADD    bx, ax ; ARITH
06E149  8B D3                 MOV    dx, bx ; MOV
06E14B  8D 5F FF              LEA    bx, [bx - 1] ; ADDR
06E14E  8B F2                 MOV    si, dx ; MOV
06E150  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
06E153  8B F9                 MOV    di, cx ; MOV
06E155  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
06E15A  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06E15E  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06E162  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06E166  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06E16A  8D 45 FE              LEA    ax, [di - 2] ; ADDR
06E16D  50                    PUSH   ax ; STACK_PUSH
06E16E  A0 44 1F              MOV    al, byte ptr [0x1f44] ; GLOBAL_LOAD
06E171  50                    PUSH   ax ; STACK_PUSH
06E172  8D 5C FE              LEA    bx, [si - 2] ; ADDR
06E175  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06E178  40                    INC    ax ; ARITH
06E179  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
06E17C  42                    INC    dx ; ARITH
06E17D  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
06E182  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06E186  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06E18A  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06E18E  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06E192  A0 48 1F              MOV    al, byte ptr [0x1f48] ; GLOBAL_LOAD
06E195  50                    PUSH   ax ; STACK_PUSH
06E196  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06E199  40                    INC    ax ; ARITH
06E19A  40                    INC    ax ; ARITH
06E19B  8D 5D FD              LEA    bx, [di - 3] ; ADDR
06E19E  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
06E1A1  42                    INC    dx ; ARITH
06E1A2  42                    INC    dx ; ARITH
06E1A3  8B F8                 MOV    di, ax ; MOV
06E1A5  89 56 EE              MOV    word ptr [bp - 0x12], dx ; LOCAL_STORE
06E1A8  89 5E EC              MOV    word ptr [bp - 0x14], bx ; LOCAL_STORE
06E1AB  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
06E1B0  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06E1B4  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06E1B8  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06E1BC  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06E1C0  A0 46 1F              MOV    al, byte ptr [0x1f46] ; GLOBAL_LOAD
06E1C3  50                    PUSH   ax ; STACK_PUSH
06E1C4  8D 44 FD              LEA    ax, [si - 3] ; ADDR
06E1C7  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
06E1CA  8B 5E EC              MOV    bx, word ptr [bp - 0x14] ; LOCAL_LOAD
06E1CD  8B F0                 MOV    si, ax ; MOV
06E1CF  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
06E1D4  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06E1D8  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06E1DC  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06E1E0  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06E1E4  A0 46 1F              MOV    al, byte ptr [0x1f46] ; GLOBAL_LOAD
06E1E7  50                    PUSH   ax ; STACK_PUSH
06E1E8  8B D6                 MOV    dx, si ; MOV
06E1EA  8B C7                 MOV    ax, di ; MOV
06E1EC  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
06E1EF  9A BC 08 1F 19        LCALL  0x191f, 0x8bc ; THUNK -> 0x0BBC:0x000C (thunk @file 0x01BEAC type B)
06E1F4  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06E1F8  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06E1FC  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06E200  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06E204  A0 48 1F              MOV    al, byte ptr [0x1f48] ; GLOBAL_LOAD
06E207  50                    PUSH   ax ; STACK_PUSH
06E208  8B C7                 MOV    ax, di ; MOV
06E20A  8B D6                 MOV    dx, si ; MOV
06E20C  8B 5E EC              MOV    bx, word ptr [bp - 0x14] ; LOCAL_LOAD
06E20F  9A BC 08 1F 19        LCALL  0x191f, 0x8bc ; THUNK -> 0x0BBC:0x000C (thunk @file 0x01BEAC type B)
06E214  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
06E218  74 14                 JE     0x6e22e ; CJUMP
06E21A  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E21D  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa] ; MOV
06E221  25 10 00              AND    ax, 0x10 ; LOGIC
06E224  3D 01 00              CMP    ax, 1 ; CMP
06E227  1B C0                 SBB    ax, ax ; ARITH
06E229  25 03 00              AND    ax, 3 ; LOGIC
06E22C  EB 03                 JMP    0x6e231 ; JUMP
06E22E  B8 03 00              MOV    ax, 3 ; MOV
06E231  03 46 0A              ADD    ax, word ptr [bp + 0xa] ; ARITH
06E234  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06E237  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
06E23B  74 15                 JE     0x6e252 ; CJUMP
06E23D  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E240  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa] ; MOV
06E244  25 10 00              AND    ax, 0x10 ; LOGIC
06E247  3D 01 00              CMP    ax, 1 ; CMP
06E24A  1B C0                 SBB    ax, ax ; ARITH
06E24C  25 03 00              AND    ax, 3 ; LOGIC
06E24F  EB 04                 JMP    0x6e255 ; JUMP
06E251  90                    NOP ; NOP
06E252  B8 03 00              MOV    ax, 3 ; MOV
06E255  03 46 0C              ADD    ax, word ptr [bp + 0xc] ; ARITH
06E258  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06E25B  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
06E25F  74 15                 JE     0x6e276 ; CJUMP
06E261  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E264  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa] ; MOV
06E268  25 10 00              AND    ax, 0x10 ; LOGIC
06E26B  3D 01 00              CMP    ax, 1 ; CMP
06E26E  1B C0                 SBB    ax, ax ; ARITH
06E270  25 03 00              AND    ax, 3 ; LOGIC
06E273  EB 04                 JMP    0x6e279 ; JUMP
06E275  90                    NOP ; NOP
06E276  B8 03 00              MOV    ax, 3 ; MOV
06E279  D1 E0                 SHL    ax, 1 ; LOGIC
06E27B  2B 46 0E              SUB    ax, word ptr [bp + 0xe] ; ARITH
06E27E  F7 D8                 NEG    ax ; ARITH
06E280  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06E283  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
06E287  74 15                 JE     0x6e29e ; CJUMP
06E289  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E28C  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa] ; MOV
06E290  25 10 00              AND    ax, 0x10 ; LOGIC
06E293  3D 01 00              CMP    ax, 1 ; CMP
06E296  1B C0                 SBB    ax, ax ; ARITH
06E298  25 03 00              AND    ax, 3 ; LOGIC
06E29B  EB 04                 JMP    0x6e2a1 ; JUMP
06E29D  90                    NOP ; NOP
06E29E  B8 03 00              MOV    ax, 3 ; MOV
06E2A1  D1 E0                 SHL    ax, 1 ; LOGIC
06E2A3  2B 46 10              SUB    ax, word ptr [bp + 0x10] ; ARITH
06E2A6  F7 D8                 NEG    ax ; ARITH
06E2A8  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06E2AC  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06E2B0  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06E2B4  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06E2B8  50                    PUSH   ax ; STACK_PUSH
06E2B9  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
06E2BC  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
06E2BF  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
06E2C2  A0 3C 1F              MOV    al, byte ptr [0x1f3c] ; GLOBAL_LOAD
06E2C5  50                    PUSH   ax ; STACK_PUSH
06E2C6  A0 3E 1F              MOV    al, byte ptr [0x1f3e] ; GLOBAL_LOAD
06E2C9  50                    PUSH   ax ; STACK_PUSH
06E2CA  6A 00                 PUSH   0 ; STACK_PUSH
06E2CC  6A 00                 PUSH   0 ; STACK_PUSH
06E2CE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
06E2D1  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06E2D4  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
06E2D7  E8 B2 DE              CALL   0x6c18c ; CALL_NEAR
06E2DA  5E                    POP    si ; STACK_POP
06E2DB  5F                    POP    di ; STACK_POP
06E2DC  C9                    LEAVE ; EPILOGUE
06E2DD  CB                    RETF ; RETURN
