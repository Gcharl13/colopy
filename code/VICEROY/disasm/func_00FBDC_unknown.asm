; ============================================================================
; func_00FBDC_unknown
; Region   : load_image
; Bytes    : file 0x00FBDC..0x00FC7F  (163 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FBDC  55                    PUSH   bp ; STACK_PUSH
00FBDD  8B EC                 MOV    bp, sp ; MOV
00FBDF  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
00FBE2  56                    PUSH   si ; STACK_PUSH
00FBE3  57                    PUSH   di ; STACK_PUSH
00FBE4  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00FBE7  F7 66 0A              MUL    word ptr [bp + 0xa] ; ARITH
00FBEA  8B C8                 MOV    cx, ax ; MOV
00FBEC  E3 5D                 JCXZ   0xfc4b ; CJUMP
00FBEE  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00FBF1  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00FBF4  8B 76 0C              MOV    si, word ptr [bp + 0xc] ; LOCAL_LOAD
00FBF7  BF AE 29              MOV    di, 0x29ae ; CONST_LOAD
00FBFA  8B C6                 MOV    ax, si ; MOV
00FBFC  2D 0E 29              SUB    ax, 0x290e ; ARITH
00FBFF  03 F8                 ADD    di, ax ; ARITH
00FC01  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
00FC05  75 05                 JNE    0xfc0c ; CJUMP
00FC07  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
00FC0A  74 05                 JE     0xfc11 ; CJUMP
00FC0C  8B 45 02              MOV    ax, word ptr [di + 2] ; MOV
00FC0F  EB 03                 JMP    0xfc14 ; JUMP
00FC11  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
00FC14  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00FC17  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
00FC1B  75 05                 JNE    0xfc22 ; CJUMP
00FC1D  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
00FC20  74 32                 JE     0xfc54 ; CJUMP
00FC22  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
00FC25  0B C0                 OR     ax, ax ; LOGIC
00FC27  74 2B                 JE     0xfc54 ; CJUMP
00FC29  3B C1                 CMP    ax, cx ; CMP
00FC2B  76 02                 JBE    0xfc2f ; CJUMP
00FC2D  8B C1                 MOV    ax, cx ; MOV
00FC2F  50                    PUSH   ax ; STACK_PUSH
00FC30  53                    PUSH   bx ; STACK_PUSH
00FC31  51                    PUSH   cx ; STACK_PUSH
00FC32  50                    PUSH   ax ; STACK_PUSH
00FC33  53                    PUSH   bx ; STACK_PUSH
00FC34  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
00FC36  0E                    PUSH   cs ; STACK_PUSH
00FC37  E8 18 07              CALL   0x10352 ; CALL_NEAR
00FC3A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00FC3D  59                    POP    cx ; STACK_POP
00FC3E  5B                    POP    bx ; STACK_POP
00FC3F  58                    POP    ax ; STACK_POP
00FC40  2B C8                 SUB    cx, ax ; ARITH
00FC42  29 44 02              SUB    word ptr [si + 2], ax ; ARITH
00FC45  03 D8                 ADD    bx, ax ; ARITH
00FC47  01 04                 ADD    word ptr [si], ax ; ARITH
00FC49  EB 03                 JMP    0xfc4e ; JUMP
00FC4B  E9 8D 00              JMP    0xfcdb ; JUMP
00FC4E  0B C9                 OR     cx, cx ; LOGIC
00FC50  75 C5                 JNE    0xfc17 ; CJUMP
00FC52  EB 76                 JMP    0xfcca ; JUMP
00FC54  3B 4E FC              CMP    cx, word ptr [bp - 4] ; CMP
00FC57  72 48                 JB     0xfca1 ; CJUMP
00FC59  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
00FC5D  75 05                 JNE    0xfc64 ; CJUMP
00FC5F  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
00FC62  74 0E                 JE     0xfc72 ; CJUMP
00FC64  53                    PUSH   bx ; STACK_PUSH
00FC65  51                    PUSH   cx ; STACK_PUSH
00FC66  56                    PUSH   si ; STACK_PUSH
00FC67  0E                    PUSH   cs ; STACK_PUSH
00FC68  E8 FB 11              CALL   0x10e66 ; CALL_NEAR
00FC6B  5A                    POP    dx ; STACK_POP
00FC6C  59                    POP    cx ; STACK_POP
00FC6D  5B                    POP    bx ; STACK_POP
00FC6E  0B C0                 OR     ax, ax ; LOGIC
00FC70  75 58                 JNE    0xfcca ; CJUMP
00FC72  33 D2                 XOR    dx, dx ; LOGIC
00FC74  8B C1                 MOV    ax, cx ; MOV
00FC76  F7 76 FC              DIV    word ptr [bp - 4] ; ARITH
00FC79  8B C1                 MOV    ax, cx ; MOV
00FC7B  2B C2                 SUB    ax, dx ; ARITH
00FC7D  50                    PUSH   ax ; STACK_PUSH
00FC7E  53                    PUSH   bx ; STACK_PUSH
