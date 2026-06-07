; ============================================================================
; func_003104_unknown
; Region   : load_image
; Bytes    : file 0x003104..0x003193  (143 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003104  C8 24 00 00           ENTER  0x24, 0 ; PROLOGUE
003108  53                    PUSH   bx ; STACK_PUSH
003109  52                    PUSH   dx ; STACK_PUSH
00310A  50                    PUSH   ax ; STACK_PUSH
00310B  56                    PUSH   si ; STACK_PUSH
00310C  2B C0                 SUB    ax, ax ; ARITH
00310E  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
003111  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
003114  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
003117  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
00311A  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
00311D  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
003120  EB 1A                 JMP    0x313c ; JUMP
003122  8B D8                 MOV    bx, ax ; MOV
003124  D1 E3                 SHL    bx, 1 ; LOGIC
003126  8B 87 CE 2C           MOV    ax, word ptr [bx + 0x2cce] ; MOV
00312A  01 46 DC              ADD    word ptr [bp - 0x24], ax ; ARITH
00312D  3D 01 00              CMP    ax, 1 ; CMP
003130  7E 07                 JLE    0x3139 ; CJUMP
003132  FF 46 E0              INC    word ptr [bp - 0x20] ; ARITH
003135  48                    DEC    ax ; ARITH
003136  01 46 F6              ADD    word ptr [bp - 0xa], ax ; ARITH
003139  FF 46 EA              INC    word ptr [bp - 0x16] ; ARITH
00313C  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
00313F  39 06 E0 2C           CMP    word ptr [0x2ce0], ax ; CMP
003143  7F DD                 JG     0x3122 ; CJUMP
003145  2B C0                 SUB    ax, ax ; ARITH
003147  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00314A  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
00314D  EB 24                 JMP    0x3173 ; JUMP
00314F  90                    NOP ; NOP
003150  8B D8                 MOV    bx, ax ; MOV
003152  D1 E3                 SHL    bx, 1 ; LOGIC
003154  8B B7 F4 2C           MOV    si, word ptr [bx + 0x2cf4] ; MOV
003158  81 E6 FF 0F           AND    si, 0xfff ; LOGIC
00315C  8B C6                 MOV    ax, si ; MOV
00315E  D1 E6                 SHL    si, 1 ; LOGIC
003160  03 F0                 ADD    si, ax ; ARITH
003162  C1 E6 02              SHL    si, 2 ; LOGIC
003165  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
003169  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; MOV
00316D  01 46 F4              ADD    word ptr [bp - 0xc], ax ; ARITH
003170  FF 46 EA              INC    word ptr [bp - 0x16] ; ARITH
003173  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
003176  39 06 E0 2C           CMP    word ptr [0x2ce0], ax ; CMP
00317A  7F D4                 JG     0x3150 ; CJUMP
00317C  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
003181  A1 E0 2C              MOV    ax, word ptr [0x2ce0] ; GLOBAL_LOAD
003184  F7 6E F2              IMUL   word ptr [bp - 0xe] ; ARITH
003187  2B 46 F4              SUB    ax, word ptr [bp - 0xc] ; ARITH
00318A  F7 D8                 NEG    ax ; ARITH
00318C  0B C0                 OR     ax, ax ; LOGIC
00318E  7D 02                 JGE    0x3192 ; CJUMP
003190  2B C0                 SUB    ax, ax ; ARITH
003192  8B                    DB     0x8B ; DATA_BYTE
