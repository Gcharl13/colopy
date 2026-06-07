; ============================================================================
; func_00666A_unknown
; Region   : load_image
; Bytes    : file 0x00666A..0x0066C1  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00666A  55                    PUSH   bp ; STACK_PUSH
00666B  8B EC                 MOV    bp, sp ; MOV
00666D  57                    PUSH   di ; STACK_PUSH
00666E  56                    PUSH   si ; STACK_PUSH
00666F  8B 36 71 40           MOV    si, word ptr [0x4071] ; GLOBAL_LOAD
006673  0B F6                 OR     si, si ; LOGIC
006675  74 4A                 JE     0x66c1 ; CJUMP
006677  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
00667B  74 44                 JE     0x66c1 ; CJUMP
00667D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
006680  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
006685  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006688  8B F8                 MOV    di, ax ; MOV
00668A  EB 30                 JMP    0x66bc ; JUMP
00668C  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
00668E  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
006693  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006696  3B C7                 CMP    ax, di ; CMP
006698  7E 20                 JLE    0x66ba ; CJUMP
00669A  8B 1C                 MOV    bx, word ptr [si] ; MOV
00669C  80 39 3D              CMP    byte ptr [bx + di], 0x3d ; CMP
00669F  75 19                 JNE    0x66ba ; CJUMP
0066A1  57                    PUSH   di ; STACK_PUSH
0066A2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0066A5  53                    PUSH   bx ; STACK_PUSH
0066A6  9A 2A 07 7D 03        LCALL  0x37d, 0x72a ; LCALL
0066AB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0066AE  0B C0                 OR     ax, ax ; LOGIC
0066B0  75 08                 JNE    0x66ba ; CJUMP
0066B2  8B 04                 MOV    ax, word ptr [si] ; MOV
0066B4  03 C7                 ADD    ax, di ; ARITH
0066B6  40                    INC    ax ; ARITH
0066B7  EB 0A                 JMP    0x66c3 ; JUMP
0066B9  90                    NOP ; NOP
0066BA  46                    INC    si ; ARITH
0066BB  46                    INC    si ; ARITH
0066BC  83 3C 00              CMP    word ptr [si], 0 ; CMP
0066BF  75 CB                 JNE    0x668c ; CJUMP
