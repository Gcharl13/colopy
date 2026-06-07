; ============================================================================
; func_011F6E_load_game_state
; Region   : load_image
; Bytes    : file 0x011F6E..0x012101  (403 bytes)
; Purpose  : Large savegame / state-loader function. Allocates a 0xAE-byte working buffer (LCALL 0xD1D:0x3D0), reads a path/handle from [bp+6], iterates over a list, calls a parser at 0xD1D:0x2C8E (~14 bytes of args) to fetch records, calls coreleft_total at 0x124D6 to verify free memory, and calls _close at 0x1144A on completion. The 0xAE-byte buffer suggests a single-record stride matching the 174-byte ColonyRecord or a similar major struct. Sets DGROUP:0x27AC = 8 on out-of-memory failure (errno-like signal).
; Args     : [bp+6] = file handle / path; [bp+8], [bp+0xA], [bp+0xC] = additional parser args (count, mode, etc.)
; Returns  : AX = 0 on success; -1 (0xFFFF) on parse failure or out-of-memory.
; Callers  : TBD
; Callees  : _close at 0x1144A, coreleft_total at 0x124D6, 0xD1D:0x3D0 (alloc), 0xD1D:0x942 (table lookup), 0xD1D:0x2C8E (record parser), … (~12 LCALL targets total)
; Verified : Boundary verified: 0x011F6E to 0x012101 (403 bytes) with a clean PUSH BP / MOV BP, SP prologue. Per-line annotation pending.
; Source   : manually identified — discovered as a caller of _close AND coreleft_total via callgraph.json
; ============================================================================

011F6E  55                    PUSH   bp ; STACK_PUSH
011F6F  8B EC                 MOV    bp, sp ; MOV
011F71  B8 AE 00              MOV    ax, 0xae ; CONST_LOAD
011F74  9A D0 03 1D 0D        LCALL  0xd1d, 0x3d0 ; LCALL
011F79  56                    PUSH   si ; STACK_PUSH
011F7A  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
011F7D  C7 46 D8 01 00        MOV    word ptr [bp - 0x28], 1 ; LOCAL_STORE
011F82  C7 46 D2 00 00        MOV    word ptr [bp - 0x2e], 0 ; LOCAL_STORE
011F87  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
011F8B  75 46                 JNE    0x11fd3 ; CJUMP
011F8D  89 76 DC              MOV    word ptr [bp - 0x24], si ; LOCAL_STORE
011F90  B8 E2 2A              MOV    ax, 0x2ae2 ; CONST_LOAD
011F93  50                    PUSH   ax ; STACK_PUSH
011F94  9A 42 09 1D 0D        LCALL  0xd1d, 0x942 ; LCALL
011F99  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011F9C  8B F0                 MOV    si, ax ; MOV
011F9E  0B F6                 OR     si, si ; LOGIC
011FA0  75 0C                 JNE    0x11fae ; CJUMP
011FA2  C7 06 AC 27 08 00     MOV    word ptr [0x27ac], 8 ; GLOBAL_LOAD
011FA8  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
011FAB  E9 4E 01              JMP    0x120fc ; JUMP
011FAE  FF 76 DC              PUSH   word ptr [bp - 0x24] ; PUSH_GLOBAL
011FB1  56                    PUSH   si ; STACK_PUSH
011FB2  8D 86 52 FF           LEA    ax, [bp - 0xae] ; ADDR
011FB6  50                    PUSH   ax ; STACK_PUSH
011FB7  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
011FBA  50                    PUSH   ax ; STACK_PUSH
011FBB  8D 46 D2              LEA    ax, [bp - 0x2e] ; ADDR
011FBE  50                    PUSH   ax ; STACK_PUSH
011FBF  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
011FC2  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
011FC5  9A 8E 2C 1D 0D        LCALL  0xd1d, 0x2c8e ; LCALL
011FCA  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
011FCD  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
011FD0  40                    INC    ax ; ARITH
011FD1  74 D5                 JE     0x11fa8 ; CJUMP
011FD3  B8 20 00              MOV    ax, 0x20 ; CONST_LOAD
011FD6  50                    PUSH   ax ; STACK_PUSH
011FD7  B8 00 80              MOV    ax, 0x8000 ; CONST_LOAD
011FDA  50                    PUSH   ax ; STACK_PUSH
011FDB  56                    PUSH   si ; STACK_PUSH
011FDC  9A 46 27 1D 0D        LCALL  0xd1d, 0x2746 ; LCALL
011FE1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
011FE4  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
011FE7  40                    INC    ax ; ARITH
011FE8  75 14                 JNE    0x11ffe ; CJUMP
011FEA  83 7E D2 00           CMP    word ptr [bp - 0x2e], 0 ; CMP
011FEE  74 B8                 JE     0x11fa8 ; CJUMP
011FF0  FF 76 D2              PUSH   word ptr [bp - 0x2e] ; PUSH_GLOBAL
011FF3  9A 1C 29 1D 0D        LCALL  0xd1d, 0x291c ; LCALL
011FF8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011FFB  EB AB                 JMP    0x11fa8 ; JUMP
011FFD  90                    NOP ; NOP
011FFE  B8 18 00              MOV    ax, 0x18 ; CONST_LOAD
012001  50                    PUSH   ax ; STACK_PUSH
012002  8D 46 E2              LEA    ax, [bp - 0x1e] ; ADDR
012005  50                    PUSH   ax ; STACK_PUSH
012006  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
012009  9A 14 1F 1D 0D        LCALL  0xd1d, 0x1f14 ; LCALL
01200E  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
012011  40                    INC    ax ; ARITH
012012  75 2C                 JNE    0x12040 ; CJUMP
012014  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
012017  9A 7A 1E 1D 0D        LCALL  0xd1d, 0x1e7a ; LCALL
01201C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
01201F  83 7E D2 00           CMP    word ptr [bp - 0x2e], 0 ; CMP
012023  74 0B                 JE     0x12030 ; CJUMP
012025  FF 76 D2              PUSH   word ptr [bp - 0x2e] ; PUSH_GLOBAL
012028  9A 1C 29 1D 0D        LCALL  0xd1d, 0x291c ; LCALL
01202D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
012030  C7 06 AC 27 08 00     MOV    word ptr [0x27ac], 8 ; GLOBAL_LOAD
012036  C7 06 B7 27 0B 00     MOV    word ptr [0x27b7], 0xb ; GLOBAL_LOAD
01203C  E9 69 FF              JMP    0x11fa8 ; JUMP
01203F  90                    NOP ; NOP
012040  B8 02 00              MOV    ax, 2 ; MOV
012043  50                    PUSH   ax ; STACK_PUSH
012044  2B C0                 SUB    ax, ax ; ARITH
012046  50                    PUSH   ax ; STACK_PUSH
012047  50                    PUSH   ax ; STACK_PUSH
012048  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
01204B  9A 9A 1E 1D 0D        LCALL  0xd1d, 0x1e9a ; LCALL
012050  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
012053  05 0F 00              ADD    ax, 0xf ; ARITH
012056  83 D2 00              ADC    dx, 0 ; ARITH
012059  D1 FA                 SAR    dx, 1 ; LOGIC
01205B  D1 D8                 RCR    ax, 1 ; LOGIC
01205D  D1 FA                 SAR    dx, 1 ; LOGIC
01205F  D1 D8                 RCR    ax, 1 ; LOGIC
012061  D1 FA                 SAR    dx, 1 ; LOGIC
012063  D1 D8                 RCR    ax, 1 ; LOGIC
012065  D1 FA                 SAR    dx, 1 ; LOGIC
012067  D1 D8                 RCR    ax, 1 ; LOGIC
012069  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
01206C  89 56 D6              MOV    word ptr [bp - 0x2a], dx ; LOCAL_STORE
01206F  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
012072  9A 7A 1E 1D 0D        LCALL  0xd1d, 0x1e7a ; LCALL
012077  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
01207A  81 7E E2 5A 4D        CMP    word ptr [bp - 0x1e], 0x4d5a ; CMP
01207F  74 07                 JE     0x12088 ; CJUMP
012081  81 7E E2 4D 5A        CMP    word ptr [bp - 0x1e], 0x5a4d ; CMP
012086  75 03                 JNE    0x1208b ; CJUMP
012088  FF 4E D8              DEC    word ptr [bp - 0x28] ; ARITH
01208B  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
01208F  74 28                 JE     0x120b9 ; CJUMP
012091  2B C0                 SUB    ax, ax ; ARITH
012093  50                    PUSH   ax ; STACK_PUSH
012094  56                    PUSH   si ; STACK_PUSH
012095  8D 86 52 FF           LEA    ax, [bp - 0xae] ; ADDR
012099  50                    PUSH   ax ; STACK_PUSH
01209A  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
01209D  50                    PUSH   ax ; STACK_PUSH
01209E  8D 46 D2              LEA    ax, [bp - 0x2e] ; ADDR
0120A1  50                    PUSH   ax ; STACK_PUSH
0120A2  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0120A5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0120A8  9A 8E 2C 1D 0D        LCALL  0xd1d, 0x2c8e ; LCALL
0120AD  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
0120B0  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
0120B3  40                    INC    ax ; ARITH
0120B4  75 03                 JNE    0x120b9 ; CJUMP
0120B6  E9 EF FE              JMP    0x11fa8 ; JUMP
0120B9  FF 76 D4              PUSH   word ptr [bp - 0x2c] ; PUSH_GLOBAL
0120BC  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
0120BF  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
0120C2  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
0120C5  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
0120C8  8B 46 E6              MOV    ax, word ptr [bp - 0x1a] ; LOCAL_LOAD
0120CB  B1 05                 MOV    cl, 5 ; MOV
0120CD  D3 E0                 SHL    ax, cl ; LOGIC
0120CF  2B 46 EA              SUB    ax, word ptr [bp - 0x16] ; ARITH
0120D2  03 46 EC              ADD    ax, word ptr [bp - 0x14] ; ARITH
0120D5  50                    PUSH   ax ; STACK_PUSH
0120D6  FF 76 DE              PUSH   word ptr [bp - 0x22] ; PUSH_GLOBAL
0120D9  FF 76 E0              PUSH   word ptr [bp - 0x20] ; PUSH_GLOBAL
0120DC  8D 86 52 FF           LEA    ax, [bp - 0xae] ; ADDR
0120E0  50                    PUSH   ax ; STACK_PUSH
0120E1  56                    PUSH   si ; STACK_PUSH
0120E2  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
0120E7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0120EA  40                    INC    ax ; ARITH
0120EB  50                    PUSH   ax ; STACK_PUSH
0120EC  56                    PUSH   si ; STACK_PUSH
0120ED  FF 76 D8              PUSH   word ptr [bp - 0x28] ; PUSH_GLOBAL
0120F0  9A 06 2F 1D 0D        LCALL  0xd1d, 0x2f06 ; LCALL
0120F5  83 C4 18              ADD    sp, 0x18 ; STACK_CLEANUP
0120F8  E9 F5 FE              JMP    0x11ff0 ; JUMP
0120FB  90                    NOP ; NOP
0120FC  5E                    POP    si ; STACK_POP
0120FD  8B E5                 MOV    sp, bp ; MOV
0120FF  5D                    POP    bp ; STACK_POP
012100  CB                    RETF ; RETURN
