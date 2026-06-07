; ============================================================================
; func_01644E_unknown
; Region   : load_image
; Bytes    : file 0x01644E..0x0164C2  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01644E  55                    PUSH   bp ; STACK_PUSH
01644F  8B EC                 MOV    bp, sp ; MOV
016451  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
016454  57                    PUSH   di ; STACK_PUSH
016455  56                    PUSH   si ; STACK_PUSH
016456  2B FF                 SUB    di, di ; ARITH
016458  39 7E 06              CMP    word ptr [bp + 6], di ; CMP
01645B  75 09                 JNE    0x16466 ; CJUMP
01645D  2B C0                 SUB    ax, ax ; ARITH
01645F  50                    PUSH   ax ; STACK_PUSH
016460  E8 67 00              CALL   0x164ca ; CALL_NEAR
016463  EB 57                 JMP    0x164bc ; JUMP
016465  90                    NOP ; NOP
016466  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
016469  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
01646C  8B C8                 MOV    cx, ax ; MOV
01646E  24 03                 AND    al, 3 ; LOGIC
016470  3C 02                 CMP    al, 2 ; CMP
016472  75 3C                 JNE    0x164b0 ; CJUMP
016474  F6 C1 08              TEST   cl, 8 ; LOGIC
016477  75 0D                 JNE    0x16486 ; CJUMP
016479  8B DE                 MOV    bx, si ; MOV
01647B  81 EB C6 46           SUB    bx, 0x46c6 ; ARITH
01647F  F6 87 66 47 01        TEST   byte ptr [bx + 0x4766], 1 ; LOGIC
016484  74 2A                 JE     0x164b0 ; CJUMP
016486  8B 04                 MOV    ax, word ptr [si] ; MOV
016488  2B 44 04              SUB    ax, word ptr [si + 4] ; ARITH
01648B  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
01648E  0B C0                 OR     ax, ax ; LOGIC
016490  7E 1E                 JLE    0x164b0 ; CJUMP
016492  50                    PUSH   ax ; STACK_PUSH
016493  FF 74 04              PUSH   word ptr [si + 4] ; STACK_PUSH
016496  8A 4C 07              MOV    cl, byte ptr [si + 7] ; MOV
016499  2A ED                 SUB    ch, ch ; ARITH
01649B  51                    PUSH   cx ; STACK_PUSH
01649C  9A 36 1D 88 13        LCALL  0x1388, 0x1d36 ; LCALL
0164A1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0164A4  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
0164A7  74 07                 JE     0x164b0 ; CJUMP
0164A9  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
0164AD  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
0164B0  8B 44 04              MOV    ax, word ptr [si + 4] ; MOV
0164B3  89 04                 MOV    word ptr [si], ax ; MOV
0164B5  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
0164BA  8B C7                 MOV    ax, di ; MOV
0164BC  5E                    POP    si ; STACK_POP
0164BD  5F                    POP    di ; STACK_POP
0164BE  8B E5                 MOV    sp, bp ; MOV
0164C0  5D                    POP    bp ; STACK_POP
0164C1  CB                    RETF ; RETURN
