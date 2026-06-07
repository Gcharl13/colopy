; ============================================================================
; func_0098F6_unknown
; Region   : load_image
; Bytes    : file 0x0098F6..0x00994B  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0098F6  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0098FA  2B C0                 SUB    ax, ax ; ARITH
0098FC  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0098FF  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
009902  EB 35                 JMP    0x9939 ; JUMP
009904  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
009907  83 7E FE 05           CMP    word ptr [bp - 2], 5 ; CMP
00990B  7D 29                 JGE    0x9936 ; CJUMP
00990D  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
009910  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
009913  0E                    PUSH   cs ; STACK_PUSH
009914  E8 3F F0              CALL   0x8956 ; CALL_NEAR
009917  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00991A  3A 46 06              CMP    al, byte ptr [bp + 6] ; CMP
00991D  75 E5                 JNE    0x9904 ; CJUMP
00991F  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
009922  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
009925  89 07                 MOV    word ptr [bx], ax ; MOV
009927  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00992A  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
00992D  89 07                 MOV    word ptr [bx], ax ; MOV
00992F  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
009934  EB CE                 JMP    0x9904 ; JUMP
009936  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
009939  83 7E FC 05           CMP    word ptr [bp - 4], 5 ; CMP
00993D  7D 07                 JGE    0x9946 ; CJUMP
00993F  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
009944  EB C1                 JMP    0x9907 ; JUMP
009946  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
009949  C9                    LEAVE ; EPILOGUE
00994A  CB                    RETF ; RETURN
