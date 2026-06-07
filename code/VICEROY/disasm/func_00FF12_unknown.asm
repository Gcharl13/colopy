; ============================================================================
; func_00FF12_unknown
; Region   : load_image
; Bytes    : file 0x00FF12..0x00FF69  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FF12  55                    PUSH   bp ; STACK_PUSH
00FF13  8B EC                 MOV    bp, sp ; MOV
00FF15  57                    PUSH   di ; STACK_PUSH
00FF16  56                    PUSH   si ; STACK_PUSH
00FF17  8B 36 D3 27           MOV    si, word ptr [0x27d3] ; GLOBAL_LOAD
00FF1B  0B F6                 OR     si, si ; LOGIC
00FF1D  74 4A                 JE     0xff69 ; CJUMP
00FF1F  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
00FF23  74 44                 JE     0xff69 ; CJUMP
00FF25  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00FF28  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
00FF2D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00FF30  8B F8                 MOV    di, ax ; MOV
00FF32  EB 30                 JMP    0xff64 ; JUMP
00FF34  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
00FF36  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
00FF3B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00FF3E  3B C7                 CMP    ax, di ; CMP
00FF40  7E 20                 JLE    0xff62 ; CJUMP
00FF42  8B 1C                 MOV    bx, word ptr [si] ; MOV
00FF44  80 39 3D              CMP    byte ptr [bx + di], 0x3d ; CMP
00FF47  75 19                 JNE    0xff62 ; CJUMP
00FF49  57                    PUSH   di ; STACK_PUSH
00FF4A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00FF4D  53                    PUSH   bx ; STACK_PUSH
00FF4E  9A BC 08 1D 0D        LCALL  0xd1d, 0x8bc ; LCALL
00FF53  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00FF56  0B C0                 OR     ax, ax ; LOGIC
00FF58  75 08                 JNE    0xff62 ; CJUMP
00FF5A  8B 04                 MOV    ax, word ptr [si] ; MOV
00FF5C  03 C7                 ADD    ax, di ; ARITH
00FF5E  40                    INC    ax ; ARITH
00FF5F  EB 0A                 JMP    0xff6b ; JUMP
00FF61  90                    NOP ; NOP
00FF62  46                    INC    si ; ARITH
00FF63  46                    INC    si ; ARITH
00FF64  83 3C 00              CMP    word ptr [si], 0 ; CMP
00FF67  75 CB                 JNE    0xff34 ; CJUMP
