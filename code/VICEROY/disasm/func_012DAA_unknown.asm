; ============================================================================
; func_012DAA_unknown
; Region   : load_image
; Bytes    : file 0x012DAA..0x012E0D  (99 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012DAA  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
012DAE  53                    PUSH   bx ; STACK_PUSH
012DAF  57                    PUSH   di ; STACK_PUSH
012DB0  56                    PUSH   si ; STACK_PUSH
012DB1  2B FF                 SUB    di, di ; ARITH
012DB3  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
012DB6  74 4F                 JE     0x12e07 ; CJUMP
012DB8  8A 07                 MOV    al, byte ptr [bx] ; MOV
012DBA  98                    CWDE ; ARITH
012DBB  8B F0                 MOV    si, ax ; MOV
012DBD  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
012DC0  F6 84 ED 27 02        TEST   byte ptr [si + 0x27ed], 2 ; LOGIC
012DC5  74 03                 JE     0x12dca ; CJUMP
012DC7  83 EE 20              SUB    si, 0x20 ; ARITH
012DCA  F6 84 ED 27 04        TEST   byte ptr [si + 0x27ed], 4 ; LOGIC
012DCF  74 0B                 JE     0x12ddc ; CJUMP
012DD1  C1 E7 04              SHL    di, 4 ; LOGIC
012DD4  8D 44 D0              LEA    ax, [si - 0x30] ; ADDR
012DD7  03 F8                 ADD    di, ax ; ARITH
012DD9  EB 24                 JMP    0x12dff ; JUMP
012DDB  90                    NOP ; NOP
012DDC  83 FE 41              CMP    si, 0x41 ; CMP
012DDF  7C 0D                 JL     0x12dee ; CJUMP
012DE1  83 FE 46              CMP    si, 0x46 ; CMP
012DE4  7F 08                 JG     0x12dee ; CJUMP
012DE6  C1 E7 04              SHL    di, 4 ; LOGIC
012DE9  8D 44 C9              LEA    ax, [si - 0x37] ; ADDR
012DEC  EB E9                 JMP    0x12dd7 ; JUMP
012DEE  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
012DF1  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
012DF4  74 09                 JE     0x12dff ; CJUMP
012DF6  43                    INC    bx ; ARITH
012DF7  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
012DFA  75 FA                 JNE    0x12df6 ; CJUMP
012DFC  89 5E FA              MOV    word ptr [bp - 6], bx ; LOCAL_STORE
012DFF  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
012E02  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
012E05  75 B1                 JNE    0x12db8 ; CJUMP
012E07  8B C7                 MOV    ax, di ; MOV
012E09  5E                    POP    si ; STACK_POP
012E0A  5F                    POP    di ; STACK_POP
012E0B  C9                    LEAVE ; EPILOGUE
012E0C  CB                    RETF ; RETURN
