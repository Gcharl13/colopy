; ============================================================================
; func_00765C_unknown
; Region   : load_image
; Bytes    : file 0x00765C..0x0076B3  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00765C  55                    PUSH   bp ; STACK_PUSH
00765D  8B EC                 MOV    bp, sp ; MOV
00765F  57                    PUSH   di ; STACK_PUSH
007660  56                    PUSH   si ; STACK_PUSH
007661  8B 36 C7 42           MOV    si, word ptr [0x42c7] ; GLOBAL_LOAD
007665  0B F6                 OR     si, si ; LOGIC
007667  74 4A                 JE     0x76b3 ; CJUMP
007669  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
00766D  74 44                 JE     0x76b3 ; CJUMP
00766F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
007672  9A 24 07 52 04        LCALL  0x452, 0x724 ; LCALL
007677  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00767A  8B F8                 MOV    di, ax ; MOV
00767C  EB 30                 JMP    0x76ae ; JUMP
00767E  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
007680  9A 24 07 52 04        LCALL  0x452, 0x724 ; LCALL
007685  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007688  3B C7                 CMP    ax, di ; CMP
00768A  7E 20                 JLE    0x76ac ; CJUMP
00768C  8B 1C                 MOV    bx, word ptr [si] ; MOV
00768E  80 39 3D              CMP    byte ptr [bx + di], 0x3d ; CMP
007691  75 19                 JNE    0x76ac ; CJUMP
007693  57                    PUSH   di ; STACK_PUSH
007694  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
007697  53                    PUSH   bx ; STACK_PUSH
007698  9A 9E 07 52 04        LCALL  0x452, 0x79e ; LCALL
00769D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0076A0  0B C0                 OR     ax, ax ; LOGIC
0076A2  75 08                 JNE    0x76ac ; CJUMP
0076A4  8B 04                 MOV    ax, word ptr [si] ; MOV
0076A6  03 C7                 ADD    ax, di ; ARITH
0076A8  40                    INC    ax ; ARITH
0076A9  EB 0A                 JMP    0x76b5 ; JUMP
0076AB  90                    NOP ; NOP
0076AC  46                    INC    si ; ARITH
0076AD  46                    INC    si ; ARITH
0076AE  83 3C 00              CMP    word ptr [si], 0 ; CMP
0076B1  75 CB                 JNE    0x767e ; CJUMP
