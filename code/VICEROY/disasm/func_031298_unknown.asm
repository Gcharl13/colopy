; ============================================================================
; func_031298_unknown
; Region   : overlay
; Bytes    : file 0x031298..0x03132F  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031298  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
03129C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
03129F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0312A2  2B C9                 SUB    cx, cx ; ARITH
0312A4  89 4E F8              MOV    word ptr [bp - 8], cx ; LOCAL_STORE
0312A7  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
0312AA  89 0F                 MOV    word ptr [bx], cx ; MOV
0312AC  3D 04 00              CMP    ax, 4 ; CMP
0312AF  7D 05                 JGE    0x312b6 ; CJUMP
0312B1  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0312B4  EB 2A                 JMP    0x312e0 ; JUMP
0312B6  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
0312B9  FF 07                 INC    word ptr [bx] ; ARITH
0312BB  83 6E FE 04           SUB    word ptr [bp - 2], 4 ; ARITH
0312BF  83 7E FE 08           CMP    word ptr [bp - 2], 8 ; CMP
0312C3  7D 05                 JGE    0x312ca ; CJUMP
0312C5  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0312C8  EB E7                 JMP    0x312b1 ; JUMP
0312CA  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
0312CD  FF 07                 INC    word ptr [bx] ; ARITH
0312CF  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0312D2  83 6E FE 08           SUB    word ptr [bp - 2], 8 ; ARITH
0312D6  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
0312D9  7C EA                 JL     0x312c5 ; CJUMP
0312DB  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
0312DE  FF 07                 INC    word ptr [bx] ; ARITH
0312E0  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
0312E3  8A 0F                 MOV    cl, byte ptr [bx] ; MOV
0312E5  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
0312E8  D3 F8                 SAR    ax, cl ; LOGIC
0312EA  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0312ED  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0312F0  83 3F 00              CMP    word ptr [bx], 0 ; CMP
0312F3  75 06                 JNE    0x312fb ; CJUMP
0312F5  03 46 0C              ADD    ax, word ptr [bp + 0xc] ; ARITH
0312F8  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0312FB  83 3F 02              CMP    word ptr [bx], 2 ; CMP
0312FE  75 03                 JNE    0x31303 ; CJUMP
031300  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
031303  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
031306  8B 5E 16              MOV    bx, word ptr [bp + 0x16] ; LOCAL_LOAD
031309  89 07                 MOV    word ptr [bx], ax ; MOV
03130B  8B 5E 14              MOV    bx, word ptr [bp + 0x14] ; LOCAL_LOAD
03130E  89 07                 MOV    word ptr [bx], ax ; MOV
031310  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
031313  F7 6E FC              IMUL   word ptr [bp - 4] ; ARITH
031316  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
031319  8B 5E 10              MOV    bx, word ptr [bp + 0x10] ; LOCAL_LOAD
03131C  89 07                 MOV    word ptr [bx], ax ; MOV
03131E  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
031321  8B 07                 MOV    ax, word ptr [bx] ; MOV
031323  EB 35                 JMP    0x3135a ; JUMP
031325  90                    NOP ; NOP
031326  8B 5E 12              MOV    bx, word ptr [bp + 0x12] ; LOCAL_LOAD
031329  C7 07 92 00           MOV    word ptr [bx], 0x92 ; CONST_LOAD
03132D  C9                    LEAVE ; EPILOGUE
03132E  CB                    RETF ; RETURN
