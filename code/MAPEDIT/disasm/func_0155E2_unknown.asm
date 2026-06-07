; ============================================================================
; func_0155E2_unknown
; Region   : load_image
; Bytes    : file 0x0155E2..0x015609  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0155E2  55                    PUSH   bp ; STACK_PUSH
0155E3  8B EC                 MOV    bp, sp ; MOV
0155E5  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0155E8  9A F6 1E 88 13        LCALL  0x1388, 0x1ef6 ; LCALL
0155ED  8B E5                 MOV    sp, bp ; MOV
0155EF  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0155F2  89 07                 MOV    word ptr [bx], ax ; MOV
0155F4  89 57 02              MOV    word ptr [bx + 2], dx ; MOV
0155F7  3D FF FF              CMP    ax, 0xffff ; CMP
0155FA  75 04                 JNE    0x15600 ; CJUMP
0155FC  3B D0                 CMP    dx, ax ; CMP
0155FE  74 04                 JE     0x15604 ; CJUMP
015600  2B C0                 SUB    ax, ax ; ARITH
015602  EB 03                 JMP    0x15607 ; JUMP
015604  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
015607  5D                    POP    bp ; STACK_POP
015608  CB                    RETF ; RETURN
