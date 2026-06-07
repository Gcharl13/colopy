; ============================================================================
; func_008FB4_unknown
; Region   : load_image
; Bytes    : file 0x008FB4..0x00903E  (138 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008FB4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
008FB8  56                    PUSH   si ; STACK_PUSH
008FB9  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
008FBC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
008FBF  EB 2A                 JMP    0x8feb ; JUMP
008FC1  90                    NOP ; NOP
008FC2  03 5E FC              ADD    bx, word ptr [bp - 4] ; ARITH
008FC5  8A 47 21              MOV    al, byte ptr [bx + 0x21] ; MOV
008FC8  88 47 20              MOV    byte ptr [bx + 0x20], al ; MOV
008FCB  8A 47 41              MOV    al, byte ptr [bx + 0x41] ; MOV
008FCE  88 47 40              MOV    byte ptr [bx + 0x40], al ; MOV
008FD1  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
008FD4  40                    INC    ax ; ARITH
008FD5  50                    PUSH   ax ; STACK_PUSH
008FD6  0E                    PUSH   cs ; STACK_PUSH
008FD7  E8 50 FF              CALL   0x8f2a ; CALL_NEAR
008FDA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
008FDD  50                    PUSH   ax ; STACK_PUSH
008FDE  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
008FE1  0E                    PUSH   cs ; STACK_PUSH
008FE2  E8 87 FF              CALL   0x8f6c ; CALL_NEAR
008FE5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
008FE8  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
008FEB  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
008FEF  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
008FF2  98                    CWDE ; ARITH
008FF3  48                    DEC    ax ; ARITH
008FF4  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
008FF7  7F C9                 JG     0x8fc2 ; CJUMP
008FF9  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
008FFE  EB 0E                 JMP    0x900e ; JUMP
009000  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
009003  38 40 70              CMP    byte ptr [bx + si + 0x70], al ; CMP
009006  7E 03                 JLE    0x900b ; CJUMP
009008  FE 48 70              DEC    byte ptr [bx + si + 0x70] ; ARITH
00900B  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
00900E  83 7E FE 14           CMP    word ptr [bp - 2], 0x14 ; CMP
009012  7D 16                 JGE    0x902a ; CJUMP
009014  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
009017  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00901B  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
00901E  38 40 70              CMP    byte ptr [bx + si + 0x70], al ; CMP
009021  75 DD                 JNE    0x9000 ; CJUMP
009023  C6 40 70 FF           MOV    byte ptr [bx + si + 0x70], 0xff ; CONST_LOAD
009027  EB E2                 JMP    0x900b ; JUMP
009029  90                    NOP ; NOP
00902A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00902E  FE 4F 1F              DEC    byte ptr [bx + 0x1f] ; ARITH
009031  83 AF C6 00 64        SUB    word ptr [bx + 0xc6], 0x64 ; ARITH
009036  83 9F C8 00 00        SBB    word ptr [bx + 0xc8], 0 ; ARITH
00903B  5E                    POP    si ; STACK_POP
00903C  C9                    LEAVE ; EPILOGUE
00903D  CB                    RETF ; RETURN
