; ============================================================================
; func_00726E_unknown
; Region   : load_image
; Bytes    : file 0x00726E..0x0072E2  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00726E  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
007272  57                    PUSH   di ; STACK_PUSH
007273  56                    PUSH   si ; STACK_PUSH
007274  2B FF                 SUB    di, di ; ARITH
007276  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007279  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00727C  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
007281  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007284  0B C0                 OR     ax, ax ; LOGIC
007286  74 54                 JE     0x72dc ; CJUMP
007288  2B F6                 SUB    si, si ; ARITH
00728A  83 FE 08              CMP    si, 8 ; CMP
00728D  7D 4D                 JGE    0x72dc ; CJUMP
00728F  8A 84 BE 00           MOV    al, byte ptr [si + 0xbe] ; MOV
007293  98                    CWDE ; ARITH
007294  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
007297  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00729A  50                    PUSH   ax ; STACK_PUSH
00729B  8A 84 B4 00           MOV    al, byte ptr [si + 0xb4] ; MOV
00729F  98                    CWDE ; ARITH
0072A0  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
0072A3  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0072A6  50                    PUSH   ax ; STACK_PUSH
0072A7  9A 14 03 7F 03        LCALL  0x37f, 0x314 ; LCALL
0072AC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0072AF  3B 46 0A              CMP    ax, word ptr [bp + 0xa] ; CMP
0072B2  75 06                 JNE    0x72ba ; CJUMP
0072B4  BF 01 00              MOV    di, 1 ; MOV
0072B7  EB 03                 JMP    0x72bc ; JUMP
0072B9  90                    NOP ; NOP
0072BA  2B FF                 SUB    di, di ; ARITH
0072BC  46                    INC    si ; ARITH
0072BD  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0072C0  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0072C3  9A 58 03 7F 03        LCALL  0x37f, 0x358 ; LCALL
0072C8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0072CB  3B 46 0A              CMP    ax, word ptr [bp + 0xa] ; CMP
0072CE  75 06                 JNE    0x72d6 ; CJUMP
0072D0  B8 01 00              MOV    ax, 1 ; MOV
0072D3  EB 03                 JMP    0x72d8 ; JUMP
0072D5  90                    NOP ; NOP
0072D6  2B C0                 SUB    ax, ax ; ARITH
0072D8  0B F8                 OR     di, ax ; LOGIC
0072DA  74 AE                 JE     0x728a ; CJUMP
0072DC  8B C7                 MOV    ax, di ; MOV
0072DE  5E                    POP    si ; STACK_POP
0072DF  5F                    POP    di ; STACK_POP
0072E0  C9                    LEAVE ; EPILOGUE
0072E1  CB                    RETF ; RETURN
