; ============================================================================
; func_0319BC_unknown
; Region   : overlay
; Bytes    : file 0x0319BC..0x031A1D  (97 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0319BC  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0319C0  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0319C3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0319C6  2B C9                 SUB    cx, cx ; ARITH
0319C8  89 4E F8              MOV    word ptr [bp - 8], cx ; LOCAL_STORE
0319CB  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
0319CE  89 0F                 MOV    word ptr [bx], cx ; MOV
0319D0  3D 03 00              CMP    ax, 3 ; CMP
0319D3  7D 05                 JGE    0x319da ; CJUMP
0319D5  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0319D8  EB 19                 JMP    0x319f3 ; JUMP
0319DA  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
0319DD  FF 07                 INC    word ptr [bx] ; ARITH
0319DF  83 6E FE 03           SUB    word ptr [bp - 2], 3 ; ARITH
0319E3  83 7E FE 05           CMP    word ptr [bp - 2], 5 ; CMP
0319E7  7D 05                 JGE    0x319ee ; CJUMP
0319E9  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0319EC  EB E7                 JMP    0x319d5 ; JUMP
0319EE  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
0319F1  FF 07                 INC    word ptr [bx] ; ARITH
0319F3  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
0319F6  8B 5E 12              MOV    bx, word ptr [bp + 0x12] ; LOCAL_LOAD
0319F9  89 07                 MOV    word ptr [bx], ax ; MOV
0319FB  8B 5E 10              MOV    bx, word ptr [bp + 0x10] ; LOCAL_LOAD
0319FE  89 07                 MOV    word ptr [bx], ax ; MOV
031A00  6B 46 F8 11           IMUL   ax, word ptr [bp - 8], 0x11 ; ARITH
031A04  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
031A07  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
031A0A  89 07                 MOV    word ptr [bx], ax ; MOV
031A0C  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
031A0F  8B 07                 MOV    ax, word ptr [bx] ; MOV
031A11  EB 15                 JMP    0x31a28 ; JUMP
031A13  90                    NOP ; NOP
031A14  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
031A17  C7 07 8A 00           MOV    word ptr [bx], 0x8a ; CONST_LOAD
031A1B  C9                    LEAVE ; EPILOGUE
031A1C  CB                    RETF ; RETURN
