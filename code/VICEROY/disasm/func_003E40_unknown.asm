; ============================================================================
; func_003E40_unknown
; Region   : load_image
; Bytes    : file 0x003E40..0x003EEE  (174 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003E40  C8 60 00 00           ENTER  0x60, 0 ; PROLOGUE
003E44  53                    PUSH   bx ; STACK_PUSH
003E45  52                    PUSH   dx ; STACK_PUSH
003E46  50                    PUSH   ax ; STACK_PUSH
003E47  57                    PUSH   di ; STACK_PUSH
003E48  56                    PUSH   si ; STACK_PUSH
003E49  6B D8 12              IMUL   bx, ax, 0x12 ; ARITH
003E4C  89 5E A0              MOV    word ptr [bp - 0x60], bx ; LOCAL_STORE
003E4F  8A 87 EE 54           MOV    al, byte ptr [bx + 0x54ee] ; MOV
003E53  2A E4                 SUB    ah, ah ; ARITH
003E55  2D 04 00              SUB    ax, 4 ; ARITH
003E58  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
003E5B  6B D8 4E              IMUL   bx, ax, 0x4e ; ARITH
003E5E  8A 87 D8 5A           MOV    al, byte ptr [bx + 0x5ad8] ; MOV
003E62  2A E4                 SUB    ah, ah ; ARITH
003E64  8B F0                 MOV    si, ax ; MOV
003E66  83 7E 06 64           CMP    word ptr [bp + 6], 0x64 ; CMP
003E6A  7D 14                 JGE    0x3e80 ; CJUMP
003E6C  8A 0E 84 01           MOV    cl, byte ptr [0x184] ; GLOBAL_LOAD
003E70  B8 02 00              MOV    ax, 2 ; MOV
003E73  D3 F8                 SAR    ax, cl ; LOGIC
003E75  29 46 9C              SUB    word ptr [bp - 0x64], ax ; ARITH
003E78  A1 D4 5A              MOV    ax, word ptr [0x5ad4] ; GLOBAL_LOAD
003E7B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
003E7E  EB 05                 JMP    0x3e85 ; JUMP
003E80  C7 46 F6 10 00        MOV    word ptr [bp - 0xa], 0x10 ; LOCAL_STORE
003E85  8B 46 9E              MOV    ax, word ptr [bp - 0x62] ; LOCAL_LOAD
003E88  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
003E8B  48                    DEC    ax ; ARITH
003E8C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
003E8F  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
003E93  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
003E97  50                    PUSH   ax ; STACK_PUSH
003E98  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
003E9B  8B C6                 MOV    ax, si ; MOV
003E9D  3D 03 00              CMP    ax, 3 ; CMP
003EA0  7E 03                 JLE    0x3ea5 ; CJUMP
003EA2  B8 03 00              MOV    ax, 3 ; MOV
003EA5  05 0B 00              ADD    ax, 0xb ; ARITH
003EA8  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
003EAB  D1 FA                 SAR    dx, 1 ; LOGIC
003EAD  03 56 9C              ADD    dx, word ptr [bp - 0x64] ; ARITH
003EB0  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
003EB3  8D 5E 08              LEA    bx, [bp + 8] ; ADDR
003EB6  9A 04 00 56 0C        LCALL  0xc56, 4 ; LCALL
003EBB  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
003EBE  8A 87 4C 08           MOV    al, byte ptr [bx + 0x84c] ; MOV
003EC2  88 46 F8              MOV    byte ptr [bp - 8], al ; LOCAL_STORE
003EC5  83 7E 06 64           CMP    word ptr [bp + 6], 0x64 ; CMP
003EC9  74 03                 JE     0x3ece ; CJUMP
003ECB  E9 BC 00              JMP    0x3f8a ; JUMP
003ECE  0B F6                 OR     si, si ; LOGIC
003ED0  75 68                 JNE    0x3f3a ; CJUMP
003ED2  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
003ED5  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
003ED8  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
003EDB  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
003EDE  6A 01                 PUSH   1 ; STACK_PUSH
003EE0  50                    PUSH   ax ; STACK_PUSH
003EE1  8B 46 9C              MOV    ax, word ptr [bp - 0x64] ; LOCAL_LOAD
003EE4  05 03 00              ADD    ax, 3 ; ARITH
003EE7  8B 56 9E              MOV    dx, word ptr [bp - 0x62] ; LOCAL_LOAD
003EEA  83 C2 04              ADD    dx, 4 ; ARITH
003EED  BB                    DB     0xBB ; DATA_BYTE
