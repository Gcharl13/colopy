; ============================================================================
; func_010172_unknown
; Region   : load_image
; Bytes    : file 0x010172..0x0101F8  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010172  55                    PUSH   bp ; STACK_PUSH
010173  8B EC                 MOV    bp, sp ; MOV
010175  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
010178  56                    PUSH   si ; STACK_PUSH
010179  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
01017C  0B F6                 OR     si, si ; LOGIC
01017E  7C 06                 JL     0x10186 ; CJUMP
010180  39 36 B9 27           CMP    word ptr [0x27b9], si ; CMP
010184  7F 0C                 JG     0x10192 ; CJUMP
010186  C7 06 AC 27 09 00     MOV    word ptr [0x27ac], 9 ; GLOBAL_LOAD
01018C  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
01018F  99                    CDQ ; ARITH
010190  EB 61                 JMP    0x101f3 ; JUMP
010192  B8 01 00              MOV    ax, 1 ; MOV
010195  50                    PUSH   ax ; STACK_PUSH
010196  2B C0                 SUB    ax, ax ; ARITH
010198  50                    PUSH   ax ; STACK_PUSH
010199  50                    PUSH   ax ; STACK_PUSH
01019A  56                    PUSH   si ; STACK_PUSH
01019B  9A 9A 1E 1D 0D        LCALL  0xd1d, 0x1e9a ; LCALL
0101A0  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0101A3  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0101A6  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
0101A9  3D FF FF              CMP    ax, 0xffff ; CMP
0101AC  75 0C                 JNE    0x101ba ; CJUMP
0101AE  3B D0                 CMP    dx, ax ; CMP
0101B0  75 08                 JNE    0x101ba ; CJUMP
0101B2  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0101B5  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0101B8  EB 33                 JMP    0x101ed ; JUMP
0101BA  B8 02 00              MOV    ax, 2 ; MOV
0101BD  50                    PUSH   ax ; STACK_PUSH
0101BE  2B C0                 SUB    ax, ax ; ARITH
0101C0  50                    PUSH   ax ; STACK_PUSH
0101C1  50                    PUSH   ax ; STACK_PUSH
0101C2  56                    PUSH   si ; STACK_PUSH
0101C3  9A 9A 1E 1D 0D        LCALL  0xd1d, 0x1e9a ; LCALL
0101C8  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0101CB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0101CE  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
0101D1  3B 46 F8              CMP    ax, word ptr [bp - 8] ; CMP
0101D4  75 05                 JNE    0x101db ; CJUMP
0101D6  3B 56 FA              CMP    dx, word ptr [bp - 6] ; CMP
0101D9  74 12                 JE     0x101ed ; CJUMP
0101DB  2B C0                 SUB    ax, ax ; ARITH
0101DD  50                    PUSH   ax ; STACK_PUSH
0101DE  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
0101E1  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
0101E4  56                    PUSH   si ; STACK_PUSH
0101E5  9A 9A 1E 1D 0D        LCALL  0xd1d, 0x1e9a ; LCALL
0101EA  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0101ED  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0101F0  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
0101F3  5E                    POP    si ; STACK_POP
0101F4  8B E5                 MOV    sp, bp ; MOV
0101F6  5D                    POP    bp ; STACK_POP
0101F7  CB                    RETF ; RETURN
