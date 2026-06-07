; ============================================================================
; func_00FAF8_unknown
; Region   : load_image
; Bytes    : file 0x00FAF8..0x00FB7F  (135 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FAF8  55                    PUSH   bp ; STACK_PUSH
00FAF9  8B EC                 MOV    bp, sp ; MOV
00FAFB  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
00FAFE  56                    PUSH   si ; STACK_PUSH
00FAFF  57                    PUSH   di ; STACK_PUSH
00FB00  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00FB03  F7 66 0A              MUL    word ptr [bp + 0xa] ; ARITH
00FB06  8B C8                 MOV    cx, ax ; MOV
00FB08  E3 5D                 JCXZ   0xfb67 ; CJUMP
00FB0A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00FB0D  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00FB10  8B 76 0C              MOV    si, word ptr [bp + 0xc] ; LOCAL_LOAD
00FB13  BF AE 29              MOV    di, 0x29ae ; CONST_LOAD
00FB16  8B C6                 MOV    ax, si ; MOV
00FB18  2D 0E 29              SUB    ax, 0x290e ; ARITH
00FB1B  03 F8                 ADD    di, ax ; ARITH
00FB1D  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
00FB21  75 05                 JNE    0xfb28 ; CJUMP
00FB23  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
00FB26  74 05                 JE     0xfb2d ; CJUMP
00FB28  8B 45 02              MOV    ax, word ptr [di + 2] ; MOV
00FB2B  EB 03                 JMP    0xfb30 ; JUMP
00FB2D  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
00FB30  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00FB33  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
00FB37  75 05                 JNE    0xfb3e ; CJUMP
00FB39  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
00FB3C  74 2F                 JE     0xfb6d ; CJUMP
00FB3E  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
00FB41  0B C0                 OR     ax, ax ; LOGIC
00FB43  74 28                 JE     0xfb6d ; CJUMP
00FB45  3B C1                 CMP    ax, cx ; CMP
00FB47  76 02                 JBE    0xfb4b ; CJUMP
00FB49  8B C1                 MOV    ax, cx ; MOV
00FB4B  50                    PUSH   ax ; STACK_PUSH
00FB4C  53                    PUSH   bx ; STACK_PUSH
00FB4D  51                    PUSH   cx ; STACK_PUSH
00FB4E  50                    PUSH   ax ; STACK_PUSH
00FB4F  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
00FB51  53                    PUSH   bx ; STACK_PUSH
00FB52  0E                    PUSH   cs ; STACK_PUSH
00FB53  E8 FC 07              CALL   0x10352 ; CALL_NEAR
00FB56  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00FB59  59                    POP    cx ; STACK_POP
00FB5A  5B                    POP    bx ; STACK_POP
00FB5B  58                    POP    ax ; STACK_POP
00FB5C  2B C8                 SUB    cx, ax ; ARITH
00FB5E  29 44 02              SUB    word ptr [si + 2], ax ; ARITH
00FB61  03 D8                 ADD    bx, ax ; ARITH
00FB63  01 04                 ADD    word ptr [si], ax ; ARITH
00FB65  EB 02                 JMP    0xfb69 ; JUMP
00FB67  EB 6C                 JMP    0xfbd5 ; JUMP
00FB69  E3 59                 JCXZ   0xfbc4 ; CJUMP
00FB6B  EB C6                 JMP    0xfb33 ; JUMP
00FB6D  3B 4E FC              CMP    cx, word ptr [bp - 4] ; CMP
00FB70  72 2D                 JB     0xfb9f ; CJUMP
00FB72  33 D2                 XOR    dx, dx ; LOGIC
00FB74  8B C1                 MOV    ax, cx ; MOV
00FB76  F7 76 FC              DIV    word ptr [bp - 4] ; ARITH
00FB79  8B C1                 MOV    ax, cx ; MOV
00FB7B  2B C2                 SUB    ax, dx ; ARITH
00FB7D  53                    PUSH   bx ; STACK_PUSH
00FB7E  51                    PUSH   cx ; STACK_PUSH
