; ============================================================================
; func_0069A5_unknown
; Region   : load_image
; Bytes    : file 0x0069A5..0x0069CD  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0069A5  55                    PUSH   bp ; STACK_PUSH
0069A6  8B EC                 MOV    bp, sp ; MOV
0069A8  56                    PUSH   si ; STACK_PUSH
0069A9  57                    PUSH   di ; STACK_PUSH
0069AA  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
0069AD  83 F9 E8              CMP    cx, -0x18 ; CMP
0069B0  77 12                 JA     0x69c4 ; CJUMP
0069B2  BB 16 40              MOV    bx, 0x4016 ; CONST_LOAD
0069B5  E8 9E 07              CALL   0x7156 ; CALL_NEAR
0069B8  73 0F                 JAE    0x69c9 ; CJUMP
0069BA  E8 11 00              CALL   0x69ce ; CALL_NEAR
0069BD  72 05                 JB     0x69c4 ; CJUMP
0069BF  E8 94 07              CALL   0x7156 ; CALL_NEAR
0069C2  73 05                 JAE    0x69c9 ; CJUMP
0069C4  33 C0                 XOR    ax, ax ; LOGIC
0069C6  99                    CDQ ; ARITH
0069C7  EB 00                 JMP    0x69c9 ; JUMP
0069C9  5F                    POP    di ; STACK_POP
0069CA  5E                    POP    si ; STACK_POP
0069CB  5D                    POP    bp ; STACK_POP
0069CC  CB                    RETF ; RETURN
