; ============================================================================
; func_00FF72_unknown
; Region   : load_image
; Bytes    : file 0x00FF72..0x00FF99  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FF72  55                    PUSH   bp ; STACK_PUSH
00FF73  8B EC                 MOV    bp, sp ; MOV
00FF75  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00FF78  9A 90 22 1D 0D        LCALL  0xd1d, 0x2290 ; LCALL
00FF7D  8B E5                 MOV    sp, bp ; MOV
00FF7F  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00FF82  89 07                 MOV    word ptr [bx], ax ; MOV
00FF84  89 57 02              MOV    word ptr [bx + 2], dx ; MOV
00FF87  3D FF FF              CMP    ax, 0xffff ; CMP
00FF8A  75 04                 JNE    0xff90 ; CJUMP
00FF8C  3B D0                 CMP    dx, ax ; CMP
00FF8E  74 04                 JE     0xff94 ; CJUMP
00FF90  2B C0                 SUB    ax, ax ; ARITH
00FF92  EB 03                 JMP    0xff97 ; JUMP
00FF94  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00FF97  5D                    POP    bp ; STACK_POP
00FF98  CB                    RETF ; RETURN
