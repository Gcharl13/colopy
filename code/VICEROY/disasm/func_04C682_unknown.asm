; ============================================================================
; func_04C682_unknown
; Region   : overlay
; Bytes    : file 0x04C682..0x04C71B  (153 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C682  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
04C686  56                    PUSH   si ; STACK_PUSH
04C687  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
04C68C  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
04C690  7D 03                 JGE    0x4c695 ; CJUMP
04C692  E9 80 00              JMP    0x4c715 ; JUMP
04C695  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
04C698  D1 E3                 SHL    bx, 1 ; LOGIC
04C69A  8B 87 C8 85           MOV    ax, word ptr [bx - 0x7a38] ; MOV
04C69E  B9 0C 00              MOV    cx, 0xc ; CONST_LOAD
04C6A1  99                    CDQ ; ARITH
04C6A2  F7 F9                 IDIV   cx ; ARITH
04C6A4  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
04C6A7  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
04C6AA  8A 87 7E 94           MOV    al, byte ptr [bx - 0x6b82] ; MOV
04C6AE  2A E4                 SUB    ah, ah ; ARITH
04C6B0  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
04C6B3  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
04C6B8  8B 76 FC              MOV    si, word ptr [bp - 4] ; LOCAL_LOAD
04C6BB  C1 E6 04              SHL    si, 4 ; LOGIC
04C6BE  8A 80 E6 94           MOV    al, byte ptr [bx + si - 0x6b1a] ; MOV
04C6C2  2A E4                 SUB    ah, ah ; ARITH
04C6C4  01 46 FA              ADD    word ptr [bp - 6], ax ; ARITH
04C6C7  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
04C6CA  83 7E FC 04           CMP    word ptr [bp - 4], 4 ; CMP
04C6CE  7C E8                 JL     0x4c6b8 ; CJUMP
04C6D0  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
04C6D3  2B 46 FA              SUB    ax, word ptr [bp - 6] ; ARITH
04C6D6  0B C0                 OR     ax, ax ; LOGIC
04C6D8  7E 06                 JLE    0x4c6e0 ; CJUMP
04C6DA  B8 01 00              MOV    ax, 1 ; MOV
04C6DD  EB 10                 JMP    0x4c6ef ; JUMP
04C6DF  90                    NOP ; NOP
04C6E0  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
04C6E3  2B 46 FA              SUB    ax, word ptr [bp - 6] ; ARITH
04C6E6  78 04                 JS     0x4c6ec ; CJUMP
04C6E8  2B C0                 SUB    ax, ax ; ARITH
04C6EA  EB 03                 JMP    0x4c6ef ; JUMP
04C6EC  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
04C6EF  01 46 F6              ADD    word ptr [bp - 0xa], ax ; ARITH
04C6F2  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
04C6F5  8A 87 7E 94           MOV    al, byte ptr [bx - 0x6b82] ; MOV
04C6F9  2A E4                 SUB    ah, ah ; ARITH
04C6FB  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
04C6FE  75 04                 JNE    0x4c704 ; CJUMP
04C700  83 46 F6 02           ADD    word ptr [bp - 0xa], 2 ; ARITH
04C704  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
04C707  C1 E6 04              SHL    si, 4 ; LOGIC
04C70A  80 B8 E6 94 01        CMP    byte ptr [bx + si - 0x6b1a], 1 ; CMP
04C70F  73 04                 JAE    0x4c715 ; CJUMP
04C711  83 46 F6 04           ADD    word ptr [bp - 0xa], 4 ; ARITH
04C715  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
04C718  5E                    POP    si ; STACK_POP
04C719  C9                    LEAVE ; EPILOGUE
04C71A  CB                    RETF ; RETURN
