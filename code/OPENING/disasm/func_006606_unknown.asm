; ============================================================================
; func_006606_unknown
; Region   : load_image
; Bytes    : file 0x006606..0x00667A  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006606  55                    PUSH   bp ; STACK_PUSH
006607  8B EC                 MOV    bp, sp ; MOV
006609  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
00660C  57                    PUSH   di ; STACK_PUSH
00660D  56                    PUSH   si ; STACK_PUSH
00660E  2B FF                 SUB    di, di ; ARITH
006610  39 7E 06              CMP    word ptr [bp + 6], di ; CMP
006613  75 09                 JNE    0x661e ; CJUMP
006615  2B C0                 SUB    ax, ax ; ARITH
006617  50                    PUSH   ax ; STACK_PUSH
006618  E8 67 00              CALL   0x6682 ; CALL_NEAR
00661B  EB 57                 JMP    0x6674 ; JUMP
00661D  90                    NOP ; NOP
00661E  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006621  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
006624  8B C8                 MOV    cx, ax ; MOV
006626  24 03                 AND    al, 3 ; LOGIC
006628  3C 02                 CMP    al, 2 ; CMP
00662A  75 3C                 JNE    0x6668 ; CJUMP
00662C  F6 C1 08              TEST   cl, 8 ; LOGIC
00662F  75 0D                 JNE    0x663e ; CJUMP
006631  8B DE                 MOV    bx, si ; MOV
006633  81 EB FE 43           SUB    bx, 0x43fe ; ARITH
006637  F6 87 9E 44 01        TEST   byte ptr [bx + 0x449e], 1 ; LOGIC
00663C  74 2A                 JE     0x6668 ; CJUMP
00663E  8B 04                 MOV    ax, word ptr [si] ; MOV
006640  2B 44 04              SUB    ax, word ptr [si + 4] ; ARITH
006643  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
006646  0B C0                 OR     ax, ax ; LOGIC
006648  7E 1E                 JLE    0x6668 ; CJUMP
00664A  50                    PUSH   ax ; STACK_PUSH
00664B  FF 74 04              PUSH   word ptr [si + 4] ; STACK_PUSH
00664E  8A 4C 07              MOV    cl, byte ptr [si + 7] ; MOV
006651  2A ED                 SUB    ch, ch ; ARITH
006653  51                    PUSH   cx ; STACK_PUSH
006654  9A F0 23 52 04        LCALL  0x452, 0x23f0 ; LCALL
006659  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00665C  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
00665F  74 07                 JE     0x6668 ; CJUMP
006661  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
006665  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
006668  8B 44 04              MOV    ax, word ptr [si + 4] ; MOV
00666B  89 04                 MOV    word ptr [si], ax ; MOV
00666D  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
006672  8B C7                 MOV    ax, di ; MOV
006674  5E                    POP    si ; STACK_POP
006675  5F                    POP    di ; STACK_POP
006676  8B E5                 MOV    sp, bp ; MOV
006678  5D                    POP    bp ; STACK_POP
006679  CB                    RETF ; RETURN
