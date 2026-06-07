; ============================================================================
; func_0096DA_unknown
; Region   : load_image
; Bytes    : file 0x0096DA..0x009725  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0096DA  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0096DE  56                    PUSH   si ; STACK_PUSH
0096DF  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0096E2  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0096E5  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0096E8  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0096ED  EB 2A                 JMP    0x9719 ; JUMP
0096EF  90                    NOP ; NOP
0096F0  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0096F4  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
0096F7  98                    CWDE ; ARITH
0096F8  3B 46 FE              CMP    ax, word ptr [bp - 2] ; CMP
0096FB  7E 22                 JLE    0x971f ; CJUMP
0096FD  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
009700  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
009703  38 40 20              CMP    byte ptr [bx + si + 0x20], al ; CMP
009706  75 0E                 JNE    0x9716 ; CJUMP
009708  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00970B  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
00970E  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
009711  75 03                 JNE    0x9716 ; CJUMP
009713  89 76 FA              MOV    word ptr [bp - 6], si ; LOCAL_STORE
009716  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
009719  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
00971D  7C D1                 JL     0x96f0 ; CJUMP
00971F  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
009722  5E                    POP    si ; STACK_POP
009723  C9                    LEAVE ; EPILOGUE
009724  CB                    RETF ; RETURN
