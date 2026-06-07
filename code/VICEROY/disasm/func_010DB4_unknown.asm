; ============================================================================
; func_010DB4_unknown
; Region   : load_image
; Bytes    : file 0x010DB4..0x010E27  (115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010DB4  55                    PUSH   bp ; STACK_PUSH
010DB5  8B EC                 MOV    bp, sp ; MOV
010DB7  56                    PUSH   si ; STACK_PUSH
010DB8  57                    PUSH   di ; STACK_PUSH
010DB9  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
010DBC  BB 50 2A              MOV    bx, 0x2a50 ; CONST_LOAD
010DBF  81 FE 16 29           CMP    si, 0x2916 ; CMP
010DC3  74 12                 JE     0x10dd7 ; CJUMP
010DC5  BB 52 2A              MOV    bx, 0x2a52 ; CONST_LOAD
010DC8  81 FE 1E 29           CMP    si, 0x291e ; CMP
010DCC  74 09                 JE     0x10dd7 ; CJUMP
010DCE  BB 54 2A              MOV    bx, 0x2a54 ; CONST_LOAD
010DD1  81 FE 2E 29           CMP    si, 0x292e ; CMP
010DD5  75 4A                 JNE    0x10e21 ; CJUMP
010DD7  8B FE                 MOV    di, si ; MOV
010DD9  81 EF 0E 29           SUB    di, 0x290e ; ARITH
010DDD  81 C7 AE 29           ADD    di, 0x29ae ; ARITH
010DE1  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
010DE5  75 3A                 JNE    0x10e21 ; CJUMP
010DE7  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
010DEA  75 35                 JNE    0x10e21 ; CJUMP
010DEC  8B 07                 MOV    ax, word ptr [bx] ; MOV
010DEE  0B C0                 OR     ax, ax ; LOGIC
010DF0  74 1B                 JE     0x10e0d ; CJUMP
010DF2  89 44 04              MOV    word ptr [si + 4], ax ; MOV
010DF5  89 04                 MOV    word ptr [si], ax ; MOV
010DF7  C7 44 02 00 02        MOV    word ptr [si + 2], 0x200 ; CONST_LOAD
010DFC  C7 45 02 00 02        MOV    word ptr [di + 2], 0x200 ; CONST_LOAD
010E01  80 4C 06 02           OR     byte ptr [si + 6], 2 ; LOGIC
010E05  C6 05 11              MOV    byte ptr [di], 0x11 ; CONST_LOAD
010E08  B8 01 00              MOV    ax, 1 ; MOV
010E0B  EB 16                 JMP    0x10e23 ; JUMP
010E0D  53                    PUSH   bx ; STACK_PUSH
010E0E  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
010E11  50                    PUSH   ax ; STACK_PUSH
010E12  9A 16 29 1D 0D        LCALL  0xd1d, 0x2916 ; LCALL
010E17  5B                    POP    bx ; STACK_POP
010E18  5B                    POP    bx ; STACK_POP
010E19  0B C0                 OR     ax, ax ; LOGIC
010E1B  74 04                 JE     0x10e21 ; CJUMP
010E1D  89 07                 MOV    word ptr [bx], ax ; MOV
010E1F  EB D1                 JMP    0x10df2 ; JUMP
010E21  33 C0                 XOR    ax, ax ; LOGIC
010E23  5F                    POP    di ; STACK_POP
010E24  5E                    POP    si ; STACK_POP
010E25  5D                    POP    bp ; STACK_POP
010E26  C3                    RET ; RETURN
