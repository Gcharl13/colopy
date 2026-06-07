; ============================================================================
; func_0045C4_unknown
; Region   : load_image
; Bytes    : file 0x0045C4..0x00467E  (186 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0045C4  55                    PUSH   bp ; STACK_PUSH
0045C5  8B EC                 MOV    bp, sp ; MOV
0045C7  83 EC 0E              SUB    sp, 0xe ; STACK_ALLOC
0045CA  57                    PUSH   di ; STACK_PUSH
0045CB  56                    PUSH   si ; STACK_PUSH
0045CC  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
0045CF  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0045D2  F6 44 06 40           TEST   byte ptr [si + 6], 0x40 ; LOGIC
0045D6  74 03                 JE     0x45db ; CJUMP
0045D8  E9 97 00              JMP    0x4672 ; JUMP
0045DB  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
0045DF  75 03                 JNE    0x45e4 ; CJUMP
0045E1  E9 8E 00              JMP    0x4672 ; JUMP
0045E4  56                    PUSH   si ; STACK_PUSH
0045E5  9A 36 14 7D 03        LCALL  0x37d, 0x1436 ; LCALL
0045EA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0045ED  8B F8                 MOV    di, ax ; MOV
0045EF  8B DE                 MOV    bx, si ; MOV
0045F1  81 EB A8 41           SUB    bx, 0x41a8 ; ARITH
0045F5  8B 87 4C 42           MOV    ax, word ptr [bx + 0x424c] ; MOV
0045F9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0045FC  56                    PUSH   si ; STACK_PUSH
0045FD  E8 40 0E              CALL   0x5440 ; CALL_NEAR
004600  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004603  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
004606  2A E4                 SUB    ah, ah ; ARITH
004608  50                    PUSH   ax ; STACK_PUSH
004609  9A 1A 1A 7D 03        LCALL  0x37d, 0x1a1a ; LCALL
00460E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004611  0B C0                 OR     ax, ax ; LOGIC
004613  7C 5A                 JL     0x466f ; CJUMP
004615  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
004619  74 57                 JE     0x4672 ; CJUMP
00461B  B8 86 40              MOV    ax, 0x4086 ; CONST_LOAD
00461E  50                    PUSH   ax ; STACK_PUSH
00461F  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
004622  50                    PUSH   ax ; STACK_PUSH
004623  9A 52 06 7D 03        LCALL  0x37d, 0x652 ; LCALL
004628  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00462B  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
00462E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
004631  80 7E F2 5C           CMP    byte ptr [bp - 0xe], 0x5c ; CMP
004635  74 13                 JE     0x464a ; CJUMP
004637  B8 88 40              MOV    ax, 0x4088 ; CONST_LOAD
00463A  50                    PUSH   ax ; STACK_PUSH
00463B  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
00463E  50                    PUSH   ax ; STACK_PUSH
00463F  9A 12 06 7D 03        LCALL  0x37d, 0x612 ; LCALL
004644  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004647  EB 04                 JMP    0x464d ; JUMP
004649  90                    NOP ; NOP
00464A  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
00464D  B8 0A 00              MOV    ax, 0xa ; CONST_LOAD
004650  50                    PUSH   ax ; STACK_PUSH
004651  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
004654  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
004657  9A 68 07 7D 03        LCALL  0x37d, 0x768 ; LCALL
00465C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00465F  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
004662  50                    PUSH   ax ; STACK_PUSH
004663  9A 36 20 7D 03        LCALL  0x37d, 0x2036 ; LCALL
004668  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00466B  0B C0                 OR     ax, ax ; LOGIC
00466D  74 03                 JE     0x4672 ; CJUMP
00466F  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
004672  C6 44 06 00           MOV    byte ptr [si + 6], 0 ; MOV
004676  8B C7                 MOV    ax, di ; MOV
004678  5E                    POP    si ; STACK_POP
004679  5F                    POP    di ; STACK_POP
00467A  8B E5                 MOV    sp, bp ; MOV
00467C  5D                    POP    bp ; STACK_POP
00467D  CB                    RETF ; RETURN
