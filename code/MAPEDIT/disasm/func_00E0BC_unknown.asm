; ============================================================================
; func_00E0BC_unknown
; Region   : load_image
; Bytes    : file 0x00E0BC..0x00E124  (104 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E0BC  55                    PUSH   bp ; STACK_PUSH
00E0BD  8B EC                 MOV    bp, sp ; MOV
00E0BF  53                    PUSH   bx ; STACK_PUSH
00E0C0  57                    PUSH   di ; STACK_PUSH
00E0C1  56                    PUSH   si ; STACK_PUSH
00E0C2  8B FA                 MOV    di, dx ; MOV
00E0C4  8B F0                 MOV    si, ax ; MOV
00E0C6  8D 46 08              LEA    ax, [bp + 8] ; ADDR
00E0C9  50                    PUSH   ax ; STACK_PUSH
00E0CA  8D 46 06              LEA    ax, [bp + 6] ; ADDR
00E0CD  50                    PUSH   ax ; STACK_PUSH
00E0CE  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00E0D1  8D 46 0C              LEA    ax, [bp + 0xc] ; ADDR
00E0D4  8D 56 0A              LEA    dx, [bp + 0xa] ; ADDR
00E0D7  9A 44 00 91 0C        LCALL  0xc91, 0x44 ; LCALL
00E0DC  0B C0                 OR     ax, ax ; LOGIC
00E0DE  74 03                 JE     0xe0e3 ; CJUMP
00E0E0  E9 A7 00              JMP    0xe18a ; JUMP
00E0E3  8B C6                 MOV    ax, si ; MOV
00E0E5  2D ED FF              SUB    ax, 0xffed ; ARITH
00E0E8  7C 11                 JL     0xe0fb ; CJUMP
00E0EA  2D 09 00              SUB    ax, 9 ; ARITH
00E0ED  7E 35                 JLE    0xe124 ; CJUMP
00E0EF  2D 07 00              SUB    ax, 7 ; ARITH
00E0F2  75 03                 JNE    0xe0f7 ; CJUMP
00E0F4  E9 93 00              JMP    0xe18a ; JUMP
00E0F7  48                    DEC    ax ; ARITH
00E0F8  48                    DEC    ax ; ARITH
00E0F9  74 4D                 JE     0xe148 ; CJUMP
00E0FB  83 3E 46 07 00        CMP    word ptr [0x746], 0 ; CMP
00E100  74 04                 JE     0xe106 ; CJUMP
00E102  81 E6 FF BF           AND    si, 0xbfff ; LOGIC
00E106  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00E109  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00E10C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00E10F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00E112  8B D7                 MOV    dx, di ; MOV
00E114  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00E117  8B C6                 MOV    ax, si ; MOV
00E119  9A 9E 00 3D 10        LCALL  0x103d, 0x9e ; LCALL
00E11E  5E                    POP    si ; STACK_POP
00E11F  5F                    POP    di ; STACK_POP
00E120  C9                    LEAVE ; EPILOGUE
00E121  CA 08 00              RETF   8 ; RETURN
