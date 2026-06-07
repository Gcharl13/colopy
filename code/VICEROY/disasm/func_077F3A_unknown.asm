; ============================================================================
; func_077F3A_unknown
; Region   : overlay
; Bytes    : file 0x077F3A..0x078062  (296 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077F3A  C8 0A 03 00           ENTER  0x30a, 0 ; PROLOGUE
077F3E  57                    PUSH   di ; STACK_PUSH
077F3F  C7 06 0A 08 00 00     MOV    word ptr [0x80a], 0 ; GLOBAL_LOAD
077F45  33 FF                 XOR    di, di ; LOGIC
077F47  B9 20 00              MOV    cx, 0x20 ; CONST_LOAD
077F4A  FA                    CLI ; FLAG
077F4B  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
077F4E  B4 08                 MOV    ah, 8 ; MOV
077F50  EC                    IN     al, dx ; IO
077F51  22 C4                 AND    al, ah ; LOGIC
077F53  75 FB                 JNE    0x77f50 ; CJUMP
077F55  EC                    IN     al, dx ; IO
077F56  22 C4                 AND    al, ah ; LOGIC
077F58  74 FB                 JE     0x77f55 ; CJUMP
077F5A  32 C0                 XOR    al, al ; LOGIC
077F5C  E6 43                 OUT    0x43, al ; IO
077F5E  EB 00                 JMP    0x77f60 ; JUMP
077F60  E4 40                 IN     al, 0x40 ; IO
077F62  8A D8                 MOV    bl, al ; MOV
077F64  EB 00                 JMP    0x77f66 ; JUMP
077F66  E4 40                 IN     al, 0x40 ; IO
077F68  8A F8                 MOV    bh, al ; MOV
077F6A  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
077F6D  B4 08                 MOV    ah, 8 ; MOV
077F6F  EC                    IN     al, dx ; IO
077F70  22 C4                 AND    al, ah ; LOGIC
077F72  75 FB                 JNE    0x77f6f ; CJUMP
077F74  32 C0                 XOR    al, al ; LOGIC
077F76  E6 43                 OUT    0x43, al ; IO
077F78  EB 00                 JMP    0x77f7a ; JUMP
077F7A  E4 40                 IN     al, 0x40 ; IO
077F7C  8A D0                 MOV    dl, al ; MOV
077F7E  EB 00                 JMP    0x77f80 ; JUMP
077F80  E4 40                 IN     al, 0x40 ; IO
077F82  8A F0                 MOV    dh, al ; MOV
077F84  FB                    STI ; FLAG
077F85  2B DA                 SUB    bx, dx ; ARITH
077F87  03 FB                 ADD    di, bx ; ARITH
077F89  E2 BF                 LOOP   0x77f4a ; CJUMP
077F8B  C1 EF 05              SHR    di, 5 ; LOGIC
077F8E  89 3E 02 08           MOV    word ptr [0x802], di ; GLOBAL_LOAD
077F92  8D 86 00 FD           LEA    ax, [bp - 0x300] ; ADDR
077F96  16                    PUSH   ss ; STACK_PUSH
077F97  50                    PUSH   ax ; STACK_PUSH
077F98  9A 78 0A 1F 1A        LCALL  0x1a1f, 0xa78 ; THUNK -> 0x0000:0x0008 (thunk @file 0x01D068 type A) overlay @file 0x025908
077F9D  C7 86 F6 FC 40 00     MOV    word ptr [bp - 0x30a], 0x40 ; LOCAL_STORE
077FA3  C7 86 FE FC 80 00     MOV    word ptr [bp - 0x302], 0x80 ; LOCAL_STORE
077FA9  2B C0                 SUB    ax, ax ; ARITH
077FAB  89 86 FA FC           MOV    word ptr [bp - 0x306], ax ; LOCAL_STORE
077FAF  89 86 FC FC           MOV    word ptr [bp - 0x304], ax ; LOCAL_STORE
077FB3  83 BE F6 FC 02        CMP    word ptr [bp - 0x30a], 2 ; CMP
077FB8  7F 07                 JG     0x77fc1 ; CJUMP
077FBA  83 BE FA FC 00        CMP    word ptr [bp - 0x306], 0 ; CMP
077FBF  75 69                 JNE    0x7802a ; CJUMP
077FC1  83 BE FC FC 40        CMP    word ptr [bp - 0x304], 0x40 ; CMP
077FC6  7D 62                 JGE    0x7802a ; CJUMP
077FC8  8D 86 00 FD           LEA    ax, [bp - 0x300] ; ADDR
077FCC  16                    PUSH   ss ; STACK_PUSH
077FCD  50                    PUSH   ax ; STACK_PUSH
077FCE  2B C0                 SUB    ax, ax ; ARITH
077FD0  8B 96 FE FC           MOV    dx, word ptr [bp - 0x302] ; LOCAL_LOAD
077FD4  0E                    PUSH   cs ; STACK_PUSH
077FD5  E8 8A 00              CALL   0x78062 ; CALL_NEAR
077FD8  89 86 F8 FC           MOV    word ptr [bp - 0x308], ax ; LOCAL_STORE
077FDC  39 06 02 08           CMP    word ptr [0x802], ax ; CMP
077FE0  72 1C                 JB     0x77ffe ; CJUMP
077FE2  8B 86 FE FC           MOV    ax, word ptr [bp - 0x302] ; LOCAL_LOAD
077FE6  03 86 F6 FC           ADD    ax, word ptr [bp - 0x30a] ; ARITH
077FEA  3D 00 01              CMP    ax, 0x100 ; CMP
077FED  7E 03                 JLE    0x77ff2 ; CJUMP
077FEF  B8 00 01              MOV    ax, 0x100 ; CONST_LOAD
077FF2  89 86 FE FC           MOV    word ptr [bp - 0x302], ax ; LOCAL_STORE
077FF6  C7 86 FA FC 01 00     MOV    word ptr [bp - 0x306], 1 ; LOCAL_STORE
077FFC  EB 1A                 JMP    0x78018 ; JUMP
077FFE  8B 86 FE FC           MOV    ax, word ptr [bp - 0x302] ; LOCAL_LOAD
078002  2B 86 F6 FC           SUB    ax, word ptr [bp - 0x30a] ; ARITH
078006  3D 01 00              CMP    ax, 1 ; CMP
078009  7D 03                 JGE    0x7800e ; CJUMP
07800B  B8 01 00              MOV    ax, 1 ; MOV
07800E  89 86 FE FC           MOV    word ptr [bp - 0x302], ax ; LOCAL_STORE
078012  C7 86 FA FC 00 00     MOV    word ptr [bp - 0x306], 0 ; LOCAL_STORE
078018  83 BE F6 FC 02        CMP    word ptr [bp - 0x30a], 2 ; CMP
07801D  7E 04                 JLE    0x78023 ; CJUMP
07801F  D1 BE F6 FC           SAR    word ptr [bp - 0x30a], 1 ; LOGIC
078023  FF 86 FC FC           INC    word ptr [bp - 0x304] ; ARITH
078027  EB 8A                 JMP    0x77fb3 ; JUMP
078029  90                    NOP ; NOP
07802A  83 BE FA FC 00        CMP    word ptr [bp - 0x306], 0 ; CMP
07802F  75 09                 JNE    0x7803a ; CJUMP
078031  C7 06 04 08 20 00     MOV    word ptr [0x804], 0x20 ; GLOBAL_LOAD
078037  EB 14                 JMP    0x7804d ; JUMP
078039  90                    NOP ; NOP
07803A  8B 86 FE FC           MOV    ax, word ptr [bp - 0x302] ; LOCAL_LOAD
07803E  8B C8                 MOV    cx, ax ; MOV
078040  D1 E0                 SHL    ax, 1 ; LOGIC
078042  03 C1                 ADD    ax, cx ; ARITH
078044  D1 E0                 SHL    ax, 1 ; LOGIC
078046  03 C1                 ADD    ax, cx ; ARITH
078048  D1 E0                 SHL    ax, 1 ; LOGIC
07804A  A3 04 08              MOV    word ptr [0x804], ax ; GLOBAL_LOAD
07804D  A1 04 08              MOV    ax, word ptr [0x804] ; GLOBAL_LOAD
078050  8B C8                 MOV    cx, ax ; MOV
078052  D1 E0                 SHL    ax, 1 ; LOGIC
078054  03 C1                 ADD    ax, cx ; ARITH
078056  A3 06 08              MOV    word ptr [0x806], ax ; GLOBAL_LOAD
078059  C7 06 00 08 01 00     MOV    word ptr [0x800], 1 ; GLOBAL_LOAD
07805F  5F                    POP    di ; STACK_POP
078060  C9                    LEAVE ; EPILOGUE
078061  CB                    RETF ; RETURN
