; ============================================================================
; func_01639C_unknown
; Region   : load_image
; Bytes    : file 0x01639C..0x01640F  (115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01639C  55                    PUSH   bp ; STACK_PUSH
01639D  8B EC                 MOV    bp, sp ; MOV
01639F  56                    PUSH   si ; STACK_PUSH
0163A0  57                    PUSH   di ; STACK_PUSH
0163A1  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
0163A4  BB 08 48              MOV    bx, 0x4808 ; CONST_LOAD
0163A7  81 FE CE 46           CMP    si, 0x46ce ; CMP
0163AB  74 12                 JE     0x163bf ; CJUMP
0163AD  BB 0A 48              MOV    bx, 0x480a ; CONST_LOAD
0163B0  81 FE D6 46           CMP    si, 0x46d6 ; CMP
0163B4  74 09                 JE     0x163bf ; CJUMP
0163B6  BB 0C 48              MOV    bx, 0x480c ; CONST_LOAD
0163B9  81 FE E6 46           CMP    si, 0x46e6 ; CMP
0163BD  75 4A                 JNE    0x16409 ; CJUMP
0163BF  8B FE                 MOV    di, si ; MOV
0163C1  81 EF C6 46           SUB    di, 0x46c6 ; ARITH
0163C5  81 C7 66 47           ADD    di, 0x4766 ; ARITH
0163C9  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
0163CD  75 3A                 JNE    0x16409 ; CJUMP
0163CF  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
0163D2  75 35                 JNE    0x16409 ; CJUMP
0163D4  8B 07                 MOV    ax, word ptr [bx] ; MOV
0163D6  0B C0                 OR     ax, ax ; LOGIC
0163D8  74 1B                 JE     0x163f5 ; CJUMP
0163DA  89 44 04              MOV    word ptr [si + 4], ax ; MOV
0163DD  89 04                 MOV    word ptr [si], ax ; MOV
0163DF  C7 44 02 00 02        MOV    word ptr [si + 2], 0x200 ; CONST_LOAD
0163E4  C7 45 02 00 02        MOV    word ptr [di + 2], 0x200 ; CONST_LOAD
0163E9  80 4C 06 02           OR     byte ptr [si + 6], 2 ; LOGIC
0163ED  C6 05 11              MOV    byte ptr [di], 0x11 ; CONST_LOAD
0163F0  B8 01 00              MOV    ax, 1 ; MOV
0163F3  EB 16                 JMP    0x1640b ; JUMP
0163F5  53                    PUSH   bx ; STACK_PUSH
0163F6  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
0163F9  50                    PUSH   ax ; STACK_PUSH
0163FA  9A F2 23 88 13        LCALL  0x1388, 0x23f2 ; LCALL
0163FF  5B                    POP    bx ; STACK_POP
016400  5B                    POP    bx ; STACK_POP
016401  0B C0                 OR     ax, ax ; LOGIC
016403  74 04                 JE     0x16409 ; CJUMP
016405  89 07                 MOV    word ptr [bx], ax ; MOV
016407  EB D1                 JMP    0x163da ; JUMP
016409  33 C0                 XOR    ax, ax ; LOGIC
01640B  5F                    POP    di ; STACK_POP
01640C  5E                    POP    si ; STACK_POP
01640D  5D                    POP    bp ; STACK_POP
01640E  C3                    RET ; RETURN
