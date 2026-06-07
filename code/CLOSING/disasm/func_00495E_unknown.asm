; ============================================================================
; func_00495E_unknown
; Region   : load_image
; Bytes    : file 0x00495E..0x004985  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00495E  55                    PUSH   bp ; STACK_PUSH
00495F  8B EC                 MOV    bp, sp ; MOV
004961  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004964  9A 1E 1C 7D 03        LCALL  0x37d, 0x1c1e ; LCALL
004969  8B E5                 MOV    sp, bp ; MOV
00496B  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00496E  89 07                 MOV    word ptr [bx], ax ; MOV
004970  89 57 02              MOV    word ptr [bx + 2], dx ; MOV
004973  3D FF FF              CMP    ax, 0xffff ; CMP
004976  75 04                 JNE    0x497c ; CJUMP
004978  3B D0                 CMP    dx, ax ; CMP
00497A  74 04                 JE     0x4980 ; CJUMP
00497C  2B C0                 SUB    ax, ax ; ARITH
00497E  EB 03                 JMP    0x4983 ; JUMP
004980  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
004983  5D                    POP    bp ; STACK_POP
004984  CB                    RETF ; RETURN
