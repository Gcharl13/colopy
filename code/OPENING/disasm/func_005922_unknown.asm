; ============================================================================
; func_005922_unknown
; Region   : load_image
; Bytes    : file 0x005922..0x005949  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005922  55                    PUSH   bp ; STACK_PUSH
005923  8B EC                 MOV    bp, sp ; MOV
005925  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005928  9A CE 1C 52 04        LCALL  0x452, 0x1cce ; LCALL
00592D  8B E5                 MOV    sp, bp ; MOV
00592F  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
005932  89 07                 MOV    word ptr [bx], ax ; MOV
005934  89 57 02              MOV    word ptr [bx + 2], dx ; MOV
005937  3D FF FF              CMP    ax, 0xffff ; CMP
00593A  75 04                 JNE    0x5940 ; CJUMP
00593C  3B D0                 CMP    dx, ax ; CMP
00593E  74 04                 JE     0x5944 ; CJUMP
005940  2B C0                 SUB    ax, ax ; ARITH
005942  EB 03                 JMP    0x5947 ; JUMP
005944  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
005947  5D                    POP    bp ; STACK_POP
005948  CB                    RETF ; RETURN
