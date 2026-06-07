; ============================================================================
; func_034DD4_unknown
; Region   : overlay
; Bytes    : file 0x034DD4..0x034EB7  (227 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034DD4  C8 62 00 00           ENTER  0x62, 0 ; PROLOGUE
034DD8  57                    PUSH   di ; STACK_PUSH
034DD9  56                    PUSH   si ; STACK_PUSH
034DDA  2B C0                 SUB    ax, ax ; ARITH
034DDC  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
034DDF  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
034DE2  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
034DE6  8A 47 06              MOV    al, byte ptr [bx + 6] ; MOV
034DE9  2A E4                 SUB    ah, ah ; ARITH
034DEB  8A 0E A6 53           MOV    cl, byte ptr [0x53a6] ; GLOBAL_LOAD
034DEF  2A ED                 SUB    ch, ch ; ARITH
034DF1  03 C1                 ADD    ax, cx ; ARITH
034DF3  05 07 00              ADD    ax, 7 ; ARITH
034DF6  6B C0 14              IMUL   ax, ax, 0x14 ; ARITH
034DF9  B9 05 00              MOV    cx, 5 ; MOV
034DFC  8B F0                 MOV    si, ax ; MOV
034DFE  99                    CDQ ; ARITH
034DFF  F7 F9                 IDIV   cx ; ARITH
034E01  3D 64 00              CMP    ax, 0x64 ; CMP
034E04  7D 03                 JGE    0x34e09 ; CJUMP
034E06  B8 64 00              MOV    ax, 0x64 ; CONST_LOAD
034E09  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
034E0C  8B 47 30              MOV    ax, word ptr [bx + 0x30] ; MOV
034E0F  99                    CDQ ; ARITH
034E10  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
034E13  8B F9                 MOV    di, cx ; MOV
034E15  2B C8                 SUB    cx, ax ; ARITH
034E17  1B FA                 SBB    di, dx ; ARITH
034E19  57                    PUSH   di ; STACK_PUSH
034E1A  51                    PUSH   cx ; STACK_PUSH
034E1B  8B C6                 MOV    ax, si ; MOV
034E1D  2B 46 FE              SUB    ax, word ptr [bp - 2] ; ARITH
034E20  F7 6F 2E              IMUL   word ptr [bx + 0x2e] ; ARITH
034E23  52                    PUSH   dx ; STACK_PUSH
034E24  50                    PUSH   ax ; STACK_PUSH
034E25  9A C6 0E 1D 0D        LCALL  0xd1d, 0xec6 ; LCALL
034E2A  03 F0                 ADD    si, ax ; ARITH
034E2C  89 76 A4              MOV    word ptr [bp - 0x5c], si ; LOCAL_STORE
034E2F  8B C6                 MOV    ax, si ; MOV
034E31  3D 0A 00              CMP    ax, 0xa ; CMP
034E34  7D 03                 JGE    0x34e39 ; CJUMP
034E36  B8 0A 00              MOV    ax, 0xa ; CONST_LOAD
034E39  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
034E3C  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
034E40  75 06                 JNE    0x34e48 ; CJUMP
034E42  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
034E46  74 05                 JE     0x34e4d ; CJUMP
034E48  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0 ; LOCAL_STORE
034E4D  8B 46 A4              MOV    ax, word ptr [bp - 0x5c] ; LOCAL_LOAD
034E50  99                    CDQ ; ARITH
034E51  A3 B0 9C              MOV    word ptr [0x9cb0], ax ; GLOBAL_LOAD
034E54  89 16 B2 9C           MOV    word ptr [0x9cb2], dx ; GLOBAL_LOAD
034E58  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
034E5C  74 10                 JE     0x34e6e ; CJUMP
034E5E  C7 06 5E 1F 03 00     MOV    word ptr [0x1f5e], 3 ; GLOBAL_LOAD
034E64  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
034E68  8D 06 F1 10           LEA    ax, [0x10f1] ; ADDR
034E6C  EB 38                 JMP    0x34ea6 ; JUMP
034E6E  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
034E72  74 24                 JE     0x34e98 ; CJUMP
034E74  C7 06 5E 1F 04 00     MOV    word ptr [0x1f5e], 4 ; GLOBAL_LOAD
034E7A  8B 1E 12 9E           MOV    bx, word ptr [0x9e12] ; GLOBAL_LOAD
034E7E  D1 E3                 SHL    bx, 1 ; LOGIC
034E80  FF B7 8C 83           PUSH   word ptr [bx - 0x7c74] ; PUSH_GLOBAL
034E84  6A 00                 PUSH   0 ; STACK_PUSH
034E86  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
034E8B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
034E8E  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
034E92  8D 06 FB 10           LEA    ax, [0x10fb] ; ADDR
034E96  EB 0E                 JMP    0x34ea6 ; JUMP
034E98  C7 06 5E 1F 02 00     MOV    word ptr [0x1f5e], 2 ; GLOBAL_LOAD
034E9E  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
034EA2  8D 06 09 11           LEA    ax, [0x1109] ; ADDR
034EA6  2B D2                 SUB    dx, dx ; ARITH
034EA8  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
034EAD  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
034EB0  89 56 A8              MOV    word ptr [bp - 0x58], dx ; LOCAL_STORE
034EB3  8B C2                 MOV    ax, dx ; MOV
034EB5  0B                    DB     0x0B ; DATA_BYTE
034EB6  46                    DB     0x46 ; DATA_BYTE
