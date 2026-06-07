; ============================================================================
; func_034318_unknown
; Region   : overlay
; Bytes    : file 0x034318..0x034439  (289 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034318  C8 CE 00 00           ENTER  0xce, 0 ; PROLOGUE
03431C  57                    PUSH   di ; STACK_PUSH
03431D  56                    PUSH   si ; STACK_PUSH
03431E  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
034322  7D 21                 JGE    0x34345 ; CJUMP
034324  7E 06                 JLE    0x3432c ; CJUMP
034326  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
034329  EB 08                 JMP    0x34333 ; JUMP
03432B  90                    NOP ; NOP
03432C  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
03432F  F6 D0                 NOT    al ; LOGIC
034331  FE C0                 INC    al ; ARITH
034333  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
034337  3A 47 01              CMP    al, byte ptr [bx + 1] ; CMP
03433A  7E 09                 JLE    0x34345 ; CJUMP
03433C  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
03433F  98                    CWDE ; ARITH
034340  F7 D8                 NEG    ax ; ARITH
034342  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
034345  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
034348  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03434C  00 47 01              ADD    byte ptr [bx + 1], al ; ARITH
03434F  80 7F 01 4B           CMP    byte ptr [bx + 1], 0x4b ; CMP
034353  7E 19                 JLE    0x3436e ; CJUMP
034355  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
034358  8B C8                 MOV    cx, ax ; MOV
03435A  98                    CWDE ; ARITH
03435B  2D 4B 00              SUB    ax, 0x4b ; ARITH
03435E  89 86 58 FF           MOV    word ptr [bp - 0xa8], ax ; LOCAL_STORE
034362  2A C8                 SUB    cl, al ; ARITH
034364  88 4F 01              MOV    byte ptr [bx + 1], cl ; MOV
034367  8B 86 58 FF           MOV    ax, word ptr [bp - 0xa8] ; LOCAL_LOAD
03436B  29 46 08              SUB    word ptr [bp + 8], ax ; ARITH
03436E  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
034372  75 03                 JNE    0x34377 ; CJUMP
034374  E9 A3 03              JMP    0x3471a ; JUMP
034377  83 3E 12 9E 04        CMP    word ptr [0x9e12], 4 ; CMP
03437C  7C 03                 JL     0x34381 ; CJUMP
03437E  E9 99 03              JMP    0x3471a ; JUMP
034381  6B 1E 12 9E 34        IMUL   bx, word ptr [0x9e12], 0x34 ; ARITH
034386  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
03438B  74 03                 JE     0x34390 ; CJUMP
03438D  E9 8A 03              JMP    0x3471a ; JUMP
034390  2B C0                 SUB    ax, ax ; ARITH
034392  89 46 84              MOV    word ptr [bp - 0x7c], ax ; LOCAL_STORE
034395  89 46 82              MOV    word ptr [bp - 0x7e], ax ; LOCAL_STORE
034398  89 86 56 FF           MOV    word ptr [bp - 0xaa], ax ; LOCAL_STORE
03439C  8B B6 56 FF           MOV    si, word ptr [bp - 0xaa] ; LOCAL_LOAD
0343A0  D1 E6                 SHL    si, 1 ; LOGIC
0343A2  C7 82 5E FF FF FF     MOV    word ptr [bp + si - 0xa2], 0xffff ; LOCAL_STORE
0343A8  C7 82 36 FF 00 00     MOV    word ptr [bp + si - 0xca], 0 ; LOCAL_STORE
0343AE  6A 00                 PUSH   0 ; STACK_PUSH
0343B0  6A 64                 PUSH   0x64 ; PUSH_CONST
0343B2  8B BE 56 FF           MOV    di, word ptr [bp - 0xaa] ; LOCAL_LOAD
0343B6  C1 E7 02              SHL    di, 2 ; LOGIC
0343B9  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0343BD  FF B1 BE 00           PUSH   word ptr [bx + di + 0xbe] ; PUSH_GLOBAL
0343C1  FF B1 BC 00           PUSH   word ptr [bx + di + 0xbc] ; PUSH_GLOBAL
0343C5  9A DC 0D 1D 0D        LCALL  0xd1d, 0xddc ; LCALL
0343CA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0343CD  52                    PUSH   dx ; STACK_PUSH
0343CE  50                    PUSH   ax ; STACK_PUSH
0343CF  9A C6 0E 1D 0D        LCALL  0xd1d, 0xec6 ; LCALL
0343D4  89 42 88              MOV    word ptr [bp + si - 0x78], ax ; LOCAL_STORE
0343D7  FF 86 56 FF           INC    word ptr [bp - 0xaa] ; ARITH
0343DB  83 BE 56 FF 10        CMP    word ptr [bp - 0xaa], 0x10 ; CMP
0343E0  7C BA                 JL     0x3439c ; CJUMP
0343E2  C1 7E A6 02           SAR    word ptr [bp - 0x5a], 2 ; LOGIC
0343E6  C1 7E 98 02           SAR    word ptr [bp - 0x68], 2 ; LOGIC
0343EA  D1 7E A4              SAR    word ptr [bp - 0x5c], 1 ; LOGIC
0343ED  D1 7E 88              SAR    word ptr [bp - 0x78], 1 ; LOGIC
0343F0  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0343F4  8B 47 20              MOV    ax, word ptr [bx + 0x20] ; MOV
0343F7  89 86 5C FF           MOV    word ptr [bp - 0xa4], ax ; LOCAL_STORE
0343FB  C7 86 34 FF 00 00     MOV    word ptr [bp - 0xcc], 0 ; LOCAL_STORE
034401  EB 4D                 JMP    0x34450 ; JUMP
034403  90                    NOP ; NOP
034404  FF 86 56 FF           INC    word ptr [bp - 0xaa] ; ARITH
034408  83 BE 56 FF 10        CMP    word ptr [bp - 0xaa], 0x10 ; CMP
03440D  7D 3D                 JGE    0x3444c ; CJUMP
03440F  8A 8E 56 FF           MOV    cl, byte ptr [bp - 0xaa] ; LOCAL_LOAD
034413  B8 01 00              MOV    ax, 1 ; MOV
034416  D3 E0                 SHL    ax, cl ; LOGIC
034418  85 86 5C FF           TEST   word ptr [bp - 0xa4], ax ; LOGIC
03441C  75 E6                 JNE    0x34404 ; CJUMP
03441E  8B B6 56 FF           MOV    si, word ptr [bp - 0xaa] ; LOCAL_LOAD
034422  D1 E6                 SHL    si, 1 ; LOGIC
034424  8B 82 36 FF           MOV    ax, word ptr [bp + si - 0xca] ; LOCAL_LOAD
034428  6B 9E 34 FF 65        IMUL   bx, word ptr [bp - 0xcc], 0x65 ; ARITH
03442D  03 9E 56 FF           ADD    bx, word ptr [bp - 0xaa] ; ARITH
034431  D1 E3                 SHL    bx, 1 ; LOGIC
034433  39 87 E0 5D           CMP    word ptr [bx + 0x5de0], ax ; CMP
034437  7E CB                 JLE    0x34404 ; CJUMP
