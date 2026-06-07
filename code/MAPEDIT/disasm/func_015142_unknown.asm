; ============================================================================
; func_015142_unknown
; Region   : load_image
; Bytes    : file 0x015142..0x0151FC  (186 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015142  55                    PUSH   bp ; STACK_PUSH
015143  8B EC                 MOV    bp, sp ; MOV
015145  83 EC 0E              SUB    sp, 0xe ; STACK_ALLOC
015148  57                    PUSH   di ; STACK_PUSH
015149  56                    PUSH   si ; STACK_PUSH
01514A  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
01514D  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
015150  F6 44 06 40           TEST   byte ptr [si + 6], 0x40 ; LOGIC
015154  74 03                 JE     0x15159 ; CJUMP
015156  E9 97 00              JMP    0x151f0 ; JUMP
015159  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
01515D  75 03                 JNE    0x15162 ; CJUMP
01515F  E9 8E 00              JMP    0x151f0 ; JUMP
015162  56                    PUSH   si ; STACK_PUSH
015163  9A CE 15 88 13        LCALL  0x1388, 0x15ce ; LCALL
015168  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
01516B  8B F8                 MOV    di, ax ; MOV
01516D  8B DE                 MOV    bx, si ; MOV
01516F  81 EB C6 46           SUB    bx, 0x46c6 ; ARITH
015173  8B 87 6A 47           MOV    ax, word ptr [bx + 0x476a] ; MOV
015177  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
01517A  56                    PUSH   si ; STACK_PUSH
01517B  E8 0A 11              CALL   0x16288 ; CALL_NEAR
01517E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
015181  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
015184  2A E4                 SUB    ah, ah ; ARITH
015186  50                    PUSH   ax ; STACK_PUSH
015187  9A B2 1B 88 13        LCALL  0x1388, 0x1bb2 ; LCALL
01518C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
01518F  0B C0                 OR     ax, ax ; LOGIC
015191  7C 5A                 JL     0x151ed ; CJUMP
015193  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
015197  74 57                 JE     0x151f0 ; CJUMP
015199  B8 A4 45              MOV    ax, 0x45a4 ; CONST_LOAD
01519C  50                    PUSH   ax ; STACK_PUSH
01519D  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
0151A0  50                    PUSH   ax ; STACK_PUSH
0151A1  9A 26 06 88 13        LCALL  0x1388, 0x626 ; LCALL
0151A6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0151A9  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
0151AC  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0151AF  80 7E F2 5C           CMP    byte ptr [bp - 0xe], 0x5c ; CMP
0151B3  74 13                 JE     0x151c8 ; CJUMP
0151B5  B8 A6 45              MOV    ax, 0x45a6 ; CONST_LOAD
0151B8  50                    PUSH   ax ; STACK_PUSH
0151B9  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
0151BC  50                    PUSH   ax ; STACK_PUSH
0151BD  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
0151C2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0151C5  EB 04                 JMP    0x151cb ; JUMP
0151C7  90                    NOP ; NOP
0151C8  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
0151CB  B8 0A 00              MOV    ax, 0xa ; CONST_LOAD
0151CE  50                    PUSH   ax ; STACK_PUSH
0151CF  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0151D2  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0151D5  9A 3C 07 88 13        LCALL  0x1388, 0x73c ; LCALL
0151DA  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0151DD  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
0151E0  50                    PUSH   ax ; STACK_PUSH
0151E1  9A A6 0A 88 13        LCALL  0x1388, 0xaa6 ; LCALL
0151E6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0151E9  0B C0                 OR     ax, ax ; LOGIC
0151EB  74 03                 JE     0x151f0 ; CJUMP
0151ED  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
0151F0  C6 44 06 00           MOV    byte ptr [si + 6], 0 ; MOV
0151F4  8B C7                 MOV    ax, di ; MOV
0151F6  5E                    POP    si ; STACK_POP
0151F7  5F                    POP    di ; STACK_POP
0151F8  8B E5                 MOV    sp, bp ; MOV
0151FA  5D                    POP    bp ; STACK_POP
0151FB  CB                    RETF ; RETURN
