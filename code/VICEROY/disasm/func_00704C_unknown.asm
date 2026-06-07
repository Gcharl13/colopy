; ============================================================================
; func_00704C_unknown
; Region   : load_image
; Bytes    : file 0x00704C..0x007119  (205 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00704C  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
007050  57                    PUSH   di ; STACK_PUSH
007051  56                    PUSH   si ; STACK_PUSH
007052  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
007055  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
007058  57                    PUSH   di ; STACK_PUSH
007059  56                    PUSH   si ; STACK_PUSH
00705A  9A 74 00 E4 03        LCALL  0x3e4, 0x74 ; LCALL
00705F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007062  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
007065  57                    PUSH   di ; STACK_PUSH
007066  56                    PUSH   si ; STACK_PUSH
007067  9A E4 03 7F 03        LCALL  0x37f, 0x3e4 ; LCALL
00706C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00706F  0B C0                 OR     ax, ax ; LOGIC
007071  7C 05                 JL     0x7078 ; CJUMP
007073  B8 01 00              MOV    ax, 1 ; MOV
007076  EB 02                 JMP    0x707a ; JUMP
007078  2B C0                 SUB    ax, ax ; ARITH
00707A  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00707D  C7 06 FA 8C FF FF     MOV    word ptr [0x8cfa], 0xffff ; GLOBAL_LOAD
007083  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
007088  83 7E FC 08           CMP    word ptr [bp - 4], 8 ; CMP
00708C  7D 7D                 JGE    0x710b ; CJUMP
00708E  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
007091  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
007095  98                    CWDE ; ARITH
007096  8B F0                 MOV    si, ax ; MOV
007098  03 76 06              ADD    si, word ptr [bp + 6] ; ARITH
00709B  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
00709F  98                    CWDE ; ARITH
0070A0  8B F8                 MOV    di, ax ; MOV
0070A2  03 7E 08              ADD    di, word ptr [bp + 8] ; ARITH
0070A5  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
0070A9  74 07                 JE     0x70b2 ; CJUMP
0070AB  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0070AE  EB 0C                 JMP    0x70bc ; JUMP
0070B0  90                    NOP ; NOP
0070B1  90                    NOP ; NOP
0070B2  57                    PUSH   di ; STACK_PUSH
0070B3  56                    PUSH   si ; STACK_PUSH
0070B4  9A 74 00 E4 03        LCALL  0x3e4, 0x74 ; LCALL
0070B9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0070BC  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0070BF  57                    PUSH   di ; STACK_PUSH
0070C0  56                    PUSH   si ; STACK_PUSH
0070C1  9A E4 03 7F 03        LCALL  0x37f, 0x3e4 ; LCALL
0070C6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0070C9  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
0070CC  0B C0                 OR     ax, ax ; LOGIC
0070CE  7D 10                 JGE    0x70e0 ; CJUMP
0070D0  57                    PUSH   di ; STACK_PUSH
0070D1  56                    PUSH   si ; STACK_PUSH
0070D2  9A 14 03 7F 03        LCALL  0x37f, 0x314 ; LCALL
0070D7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0070DA  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
0070DD  EB 07                 JMP    0x70e6 ; JUMP
0070DF  90                    NOP ; NOP
0070E0  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0070E3  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0070E6  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
0070E9  0B D2                 OR     dx, dx ; LOGIC
0070EB  7C 11                 JL     0x70fe ; CJUMP
0070ED  39 56 0A              CMP    word ptr [bp + 0xa], dx ; CMP
0070F0  74 0C                 JE     0x70fe ; CJUMP
0070F2  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0070F5  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
0070F8  75 04                 JNE    0x70fe ; CJUMP
0070FA  89 16 FA 8C           MOV    word ptr [0x8cfa], dx ; GLOBAL_LOAD
0070FE  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
007101  83 3E FA 8C 00        CMP    word ptr [0x8cfa], 0 ; CMP
007106  7D 03                 JGE    0x710b ; CJUMP
007108  E9 7D FF              JMP    0x7088 ; JUMP
00710B  83 3E FA 8C 00        CMP    word ptr [0x8cfa], 0 ; CMP
007110  7C 08                 JL     0x711a ; CJUMP
007112  B8 01 00              MOV    ax, 1 ; MOV
007115  5E                    POP    si ; STACK_POP
007116  5F                    POP    di ; STACK_POP
007117  C9                    LEAVE ; EPILOGUE
007118  CB                    RETF ; RETURN
