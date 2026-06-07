; ============================================================================
; func_010118_unknown
; Region   : load_image
; Bytes    : file 0x010118..0x010172  (90 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010118  55                    PUSH   bp ; STACK_PUSH
010119  8B EC                 MOV    bp, sp ; MOV
01011B  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
01011E  57                    PUSH   di ; STACK_PUSH
01011F  56                    PUSH   si ; STACK_PUSH
010120  C6 06 36 2D 42        MOV    byte ptr [0x2d36], 0x42 ; GLOBAL_LOAD
010125  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
010128  A3 34 2D              MOV    word ptr [0x2d34], ax ; GLOBAL_LOAD
01012B  BE 30 2D              MOV    si, 0x2d30 ; CONST_LOAD
01012E  89 04                 MOV    word ptr [si], ax ; MOV
010130  C7 06 32 2D FF 7F     MOV    word ptr [0x2d32], 0x7fff ; GLOBAL_LOAD
010136  8D 46 0A              LEA    ax, [bp + 0xa] ; ADDR
010139  50                    PUSH   ax ; STACK_PUSH
01013A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
01013D  8B C6                 MOV    ax, si ; MOV
01013F  50                    PUSH   ax ; STACK_PUSH
010140  9A 6E 19 1D 0D        LCALL  0xd1d, 0x196e ; LCALL
010145  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
010148  8B F8                 MOV    di, ax ; MOV
01014A  FF 0E 32 2D           DEC    word ptr [0x2d32] ; ARITH
01014E  78 0E                 JS     0x1015e ; CJUMP
010150  8B 1E 30 2D           MOV    bx, word ptr [0x2d30] ; GLOBAL_LOAD
010154  FF 06 30 2D           INC    word ptr [0x2d30] ; ARITH
010158  C6 07 00              MOV    byte ptr [bx], 0 ; MOV
01015B  EB 0D                 JMP    0x1016a ; JUMP
01015D  90                    NOP ; NOP
01015E  56                    PUSH   si ; STACK_PUSH
01015F  2B C0                 SUB    ax, ax ; ARITH
010161  50                    PUSH   ax ; STACK_PUSH
010162  9A EC 15 1D 0D        LCALL  0xd1d, 0x15ec ; LCALL
010167  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
01016A  8B C7                 MOV    ax, di ; MOV
01016C  5E                    POP    si ; STACK_POP
01016D  5F                    POP    di ; STACK_POP
01016E  8B E5                 MOV    sp, bp ; MOV
010170  5D                    POP    bp ; STACK_POP
010171  CB                    RETF ; RETURN
