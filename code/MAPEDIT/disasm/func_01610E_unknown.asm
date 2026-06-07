; ============================================================================
; func_01610E_unknown
; Region   : load_image
; Bytes    : file 0x01610E..0x0161A3  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01610E  55                    PUSH   bp ; STACK_PUSH
01610F  8B EC                 MOV    bp, sp ; MOV
016111  56                    PUSH   si ; STACK_PUSH
016112  57                    PUSH   di ; STACK_PUSH
016113  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
016116  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
016119  A8 83                 TEST   al, 0x83 ; LOGIC
01611B  74 59                 JE     0x16176 ; CJUMP
01611D  A8 40                 TEST   al, 0x40 ; LOGIC
01611F  75 55                 JNE    0x16176 ; CJUMP
016121  A8 02                 TEST   al, 2 ; LOGIC
016123  75 42                 JNE    0x16167 ; CJUMP
016125  0C 01                 OR     al, 1 ; LOGIC
016127  88 44 06              MOV    byte ptr [si + 6], al ; MOV
01612A  8B FE                 MOV    di, si ; MOV
01612C  81 EF C6 46           SUB    di, 0x46c6 ; ARITH
016130  81 C7 66 47           ADD    di, 0x4766 ; ARITH
016134  A8 0C                 TEST   al, 0xc ; LOGIC
016136  75 0A                 JNE    0x16142 ; CJUMP
016138  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
01613B  75 05                 JNE    0x16142 ; CJUMP
01613D  56                    PUSH   si ; STACK_PUSH
01613E  E8 1D 0F              CALL   0x1705e ; CALL_NEAR
016141  58                    POP    ax ; STACK_POP
016142  8B 44 04              MOV    ax, word ptr [si + 4] ; MOV
016145  89 04                 MOV    word ptr [si], ax ; MOV
016147  FF 75 02              PUSH   word ptr [di + 2] ; STACK_PUSH
01614A  50                    PUSH   ax ; STACK_PUSH
01614B  33 DB                 XOR    bx, bx ; LOGIC
01614D  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
016150  53                    PUSH   bx ; STACK_PUSH
016151  0E                    PUSH   cs ; STACK_PUSH
016152  E8 77 09              CALL   0x16acc ; CALL_NEAR
016155  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
016158  0B C0                 OR     ax, ax ; LOGIC
01615A  74 11                 JE     0x1616d ; CJUMP
01615C  3D FF FF              CMP    ax, 0xffff ; CMP
01615F  75 1A                 JNE    0x1617b ; CJUMP
016161  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
016165  EB 0A                 JMP    0x16171 ; JUMP
016167  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
01616B  EB 09                 JMP    0x16176 ; JUMP
01616D  80 4C 06 10           OR     byte ptr [si + 6], 0x10 ; LOGIC
016171  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
016176  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
016179  EB 24                 JMP    0x1619f ; JUMP
01617B  8A BF 77 45           MOV    bh, byte ptr [bx + 0x4577] ; MOV
01617F  80 E7 82              AND    bh, 0x82 ; LOGIC
016182  80 FF 82              CMP    bh, 0x82 ; CMP
016185  75 0B                 JNE    0x16192 ; CJUMP
016187  8A 7C 06              MOV    bh, byte ptr [si + 6] ; MOV
01618A  F6 C7 82              TEST   bh, 0x82 ; LOGIC
01618D  75 03                 JNE    0x16192 ; CJUMP
01618F  80 0D 20              OR     byte ptr [di], 0x20 ; LOGIC
016192  48                    DEC    ax ; ARITH
016193  89 44 02              MOV    word ptr [si + 2], ax ; MOV
016196  8B 1C                 MOV    bx, word ptr [si] ; MOV
016198  33 C0                 XOR    ax, ax ; LOGIC
01619A  8A 07                 MOV    al, byte ptr [bx] ; MOV
01619C  43                    INC    bx ; ARITH
01619D  89 1C                 MOV    word ptr [si], bx ; MOV
01619F  5F                    POP    di ; STACK_POP
0161A0  5E                    POP    si ; STACK_POP
0161A1  5D                    POP    bp ; STACK_POP
0161A2  CB                    RETF ; RETURN
