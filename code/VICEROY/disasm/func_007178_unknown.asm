; ============================================================================
; func_007178_unknown
; Region   : load_image
; Bytes    : file 0x007178..0x007238  (192 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007178  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00717C  57                    PUSH   di ; STACK_PUSH
00717D  56                    PUSH   si ; STACK_PUSH
00717E  C7 06 FA 8C FF FF     MOV    word ptr [0x8cfa], 0xffff ; GLOBAL_LOAD
007184  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007187  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00718A  9A 74 00 E4 03        LCALL  0x3e4, 0x74 ; LCALL
00718F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007192  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
007195  2B F6                 SUB    si, si ; ARITH
007197  39 36 FA 8C           CMP    word ptr [0x8cfa], si ; CMP
00719B  7C 03                 JL     0x71a0 ; CJUMP
00719D  E9 8A 00              JMP    0x722a ; JUMP
0071A0  83 FE 08              CMP    si, 8 ; CMP
0071A3  7C 03                 JL     0x71a8 ; CJUMP
0071A5  E9 82 00              JMP    0x722a ; JUMP
0071A8  8A 84 BE 00           MOV    al, byte ptr [si + 0xbe] ; MOV
0071AC  98                    CWDE ; ARITH
0071AD  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
0071B0  8B F8                 MOV    di, ax ; MOV
0071B2  50                    PUSH   ax ; STACK_PUSH
0071B3  8A 84 B4 00           MOV    al, byte ptr [si + 0xb4] ; MOV
0071B7  98                    CWDE ; ARITH
0071B8  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
0071BB  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0071BE  50                    PUSH   ax ; STACK_PUSH
0071BF  9A 14 03 7F 03        LCALL  0x37f, 0x314 ; LCALL
0071C4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0071C7  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0071CA  0B C0                 OR     ax, ax ; LOGIC
0071CC  7C 1F                 JL     0x71ed ; CJUMP
0071CE  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0071D1  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
0071D4  74 17                 JE     0x71ed ; CJUMP
0071D6  57                    PUSH   di ; STACK_PUSH
0071D7  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0071DA  9A 74 00 E4 03        LCALL  0x3e4, 0x74 ; LCALL
0071DF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0071E2  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
0071E5  75 06                 JNE    0x71ed ; CJUMP
0071E7  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0071EA  A3 FA 8C              MOV    word ptr [0x8cfa], ax ; GLOBAL_LOAD
0071ED  57                    PUSH   di ; STACK_PUSH
0071EE  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0071F1  9A E4 03 7F 03        LCALL  0x37f, 0x3e4 ; LCALL
0071F6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0071F9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0071FC  0B C0                 OR     ax, ax ; LOGIC
0071FE  7C 1F                 JL     0x721f ; CJUMP
007200  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
007203  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
007206  74 17                 JE     0x721f ; CJUMP
007208  57                    PUSH   di ; STACK_PUSH
007209  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00720C  9A 74 00 E4 03        LCALL  0x3e4, 0x74 ; LCALL
007211  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007214  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
007217  75 06                 JNE    0x721f ; CJUMP
007219  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00721C  A3 FA 8C              MOV    word ptr [0x8cfa], ax ; GLOBAL_LOAD
00721F  46                    INC    si ; ARITH
007220  83 3E FA 8C 00        CMP    word ptr [0x8cfa], 0 ; CMP
007225  7D 03                 JGE    0x722a ; CJUMP
007227  E9 76 FF              JMP    0x71a0 ; JUMP
00722A  83 3E FA 8C 00        CMP    word ptr [0x8cfa], 0 ; CMP
00722F  7C 07                 JL     0x7238 ; CJUMP
007231  B8 01 00              MOV    ax, 1 ; MOV
007234  5E                    POP    si ; STACK_POP
007235  5F                    POP    di ; STACK_POP
007236  C9                    LEAVE ; EPILOGUE
007237  CB                    RETF ; RETURN
