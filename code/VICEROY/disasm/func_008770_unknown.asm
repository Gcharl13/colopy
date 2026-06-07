; ============================================================================
; func_008770_unknown
; Region   : load_image
; Bytes    : file 0x008770..0x0087F4  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008770  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
008774  56                    PUSH   si ; STACK_PUSH
008775  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00877A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00877D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008780  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
008785  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
008788  0B C0                 OR     ax, ax ; LOGIC
00878A  74 62                 JE     0x87ee ; CJUMP
00878C  0E                    PUSH   cs ; STACK_PUSH
00878D  E8 90 FF              CALL   0x8720 ; CALL_NEAR
008790  8B D8                 MOV    bx, ax ; MOV
008792  8A 87 29 03           MOV    al, byte ptr [bx + 0x329] ; MOV
008796  2A E4                 SUB    ah, ah ; ARITH
008798  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00879B  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
00879E  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0087A2  38 07                 CMP    byte ptr [bx], al ; CMP
0087A4  75 0D                 JNE    0x87b3 ; CJUMP
0087A6  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
0087A9  38 47 01              CMP    byte ptr [bx + 1], al ; CMP
0087AC  75 05                 JNE    0x87b3 ; CJUMP
0087AE  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0087B3  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
0087B8  EB 2E                 JMP    0x87e8 ; JUMP
0087BA  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0087BD  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
0087C0  7D 2C                 JGE    0x87ee ; CJUMP
0087C2  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
0087C5  8A 87 C8 00           MOV    al, byte ptr [bx + 0xc8] ; MOV
0087C9  8B 36 42 85           MOV    si, word ptr [0x8542] ; GLOBAL_LOAD
0087CD  02 04                 ADD    al, byte ptr [si] ; ARITH
0087CF  3A 46 06              CMP    al, byte ptr [bp + 6] ; CMP
0087D2  75 11                 JNE    0x87e5 ; CJUMP
0087D4  8A 87 DE 00           MOV    al, byte ptr [bx + 0xde] ; MOV
0087D8  02 44 01              ADD    al, byte ptr [si + 1] ; ARITH
0087DB  3A 46 08              CMP    al, byte ptr [bp + 8] ; CMP
0087DE  75 05                 JNE    0x87e5 ; CJUMP
0087E0  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0087E5  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
0087E8  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0087EC  74 CC                 JE     0x87ba ; CJUMP
0087EE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0087F1  5E                    POP    si ; STACK_POP
0087F2  C9                    LEAVE ; EPILOGUE
0087F3  CB                    RETF ; RETURN
