; ============================================================================
; func_005606_unknown
; Region   : load_image
; Bytes    : file 0x005606..0x00567A  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005606  55                    PUSH   bp ; STACK_PUSH
005607  8B EC                 MOV    bp, sp ; MOV
005609  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
00560C  57                    PUSH   di ; STACK_PUSH
00560D  56                    PUSH   si ; STACK_PUSH
00560E  2B FF                 SUB    di, di ; ARITH
005610  39 7E 06              CMP    word ptr [bp + 6], di ; CMP
005613  75 09                 JNE    0x561e ; CJUMP
005615  2B C0                 SUB    ax, ax ; ARITH
005617  50                    PUSH   ax ; STACK_PUSH
005618  E8 67 00              CALL   0x5682 ; CALL_NEAR
00561B  EB 57                 JMP    0x5674 ; JUMP
00561D  90                    NOP ; NOP
00561E  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
005621  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
005624  8B C8                 MOV    cx, ax ; MOV
005626  24 03                 AND    al, 3 ; LOGIC
005628  3C 02                 CMP    al, 2 ; CMP
00562A  75 3C                 JNE    0x5668 ; CJUMP
00562C  F6 C1 08              TEST   cl, 8 ; LOGIC
00562F  75 0D                 JNE    0x563e ; CJUMP
005631  8B DE                 MOV    bx, si ; MOV
005633  81 EB A8 41           SUB    bx, 0x41a8 ; ARITH
005637  F6 87 48 42 01        TEST   byte ptr [bx + 0x4248], 1 ; LOGIC
00563C  74 2A                 JE     0x5668 ; CJUMP
00563E  8B 04                 MOV    ax, word ptr [si] ; MOV
005640  2B 44 04              SUB    ax, word ptr [si + 4] ; ARITH
005643  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
005646  0B C0                 OR     ax, ax ; LOGIC
005648  7E 1E                 JLE    0x5668 ; CJUMP
00564A  50                    PUSH   ax ; STACK_PUSH
00564B  FF 74 04              PUSH   word ptr [si + 4] ; STACK_PUSH
00564E  8A 4C 07              MOV    cl, byte ptr [si + 7] ; MOV
005651  2A ED                 SUB    ch, ch ; ARITH
005653  51                    PUSH   cx ; STACK_PUSH
005654  9A 4E 23 7D 03        LCALL  0x37d, 0x234e ; LCALL
005659  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00565C  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
00565F  74 07                 JE     0x5668 ; CJUMP
005661  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
005665  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
005668  8B 44 04              MOV    ax, word ptr [si + 4] ; MOV
00566B  89 04                 MOV    word ptr [si], ax ; MOV
00566D  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
005672  8B C7                 MOV    ax, di ; MOV
005674  5E                    POP    si ; STACK_POP
005675  5F                    POP    di ; STACK_POP
005676  8B E5                 MOV    sp, bp ; MOV
005678  5D                    POP    bp ; STACK_POP
005679  CB                    RETF ; RETURN
