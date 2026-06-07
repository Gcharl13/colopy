; ============================================================================
; func_061E96_unknown
; Region   : overlay
; Bytes    : file 0x061E96..0x061F01  (107 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

061E96  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
061E9A  52                    PUSH   dx ; STACK_PUSH
061E9B  50                    PUSH   ax ; STACK_PUSH
061E9C  C7 46 FC 08 00        MOV    word ptr [bp - 4], 8 ; LOCAL_STORE
061EA1  0B C0                 OR     ax, ax ; LOGIC
061EA3  7E 05                 JLE    0x61eaa ; CJUMP
061EA5  B8 01 00              MOV    ax, 1 ; MOV
061EA8  EB 0B                 JMP    0x61eb5 ; JUMP
061EAA  0B C0                 OR     ax, ax ; LOGIC
061EAC  7C 04                 JL     0x61eb2 ; CJUMP
061EAE  2B C0                 SUB    ax, ax ; ARITH
061EB0  EB 03                 JMP    0x61eb5 ; JUMP
061EB2  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
061EB5  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
061EB8  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
061EBC  7E 06                 JLE    0x61ec4 ; CJUMP
061EBE  B8 01 00              MOV    ax, 1 ; MOV
061EC1  EB 0E                 JMP    0x61ed1 ; JUMP
061EC3  90                    NOP ; NOP
061EC4  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
061EC8  7C 04                 JL     0x61ece ; CJUMP
061ECA  2B C0                 SUB    ax, ax ; ARITH
061ECC  EB 03                 JMP    0x61ed1 ; JUMP
061ECE  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
061ED1  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
061ED4  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
061ED9  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
061EDC  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
061EE0  98                    CWDE ; ARITH
061EE1  3B 46 F8              CMP    ax, word ptr [bp - 8] ; CMP
061EE4  75 0D                 JNE    0x61ef3 ; CJUMP
061EE6  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
061EEA  98                    CWDE ; ARITH
061EEB  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
061EEE  75 03                 JNE    0x61ef3 ; CJUMP
061EF0  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
061EF3  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
061EF6  83 7E FE 08           CMP    word ptr [bp - 2], 8 ; CMP
061EFA  7C DD                 JL     0x61ed9 ; CJUMP
061EFC  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
061EFF  C9                    LEAVE ; EPILOGUE
061F00  CB                    RETF ; RETURN
