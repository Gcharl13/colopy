; ============================================================================
; func_015788_unknown
; Region   : load_image
; Bytes    : file 0x015788..0x0157E2  (90 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015788  55                    PUSH   bp ; STACK_PUSH
015789  8B EC                 MOV    bp, sp ; MOV
01578B  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
01578E  57                    PUSH   di ; STACK_PUSH
01578F  56                    PUSH   si ; STACK_PUSH
015790  C6 06 B0 49 42        MOV    byte ptr [0x49b0], 0x42 ; GLOBAL_LOAD
015795  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
015798  A3 AE 49              MOV    word ptr [0x49ae], ax ; GLOBAL_LOAD
01579B  BE AA 49              MOV    si, 0x49aa ; CONST_LOAD
01579E  89 04                 MOV    word ptr [si], ax ; MOV
0157A0  C7 06 AC 49 FF 7F     MOV    word ptr [0x49ac], 0x7fff ; GLOBAL_LOAD
0157A6  8D 46 0A              LEA    ax, [bp + 0xa] ; ADDR
0157A9  50                    PUSH   ax ; STACK_PUSH
0157AA  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0157AD  8B C6                 MOV    ax, si ; MOV
0157AF  50                    PUSH   ax ; STACK_PUSH
0157B0  9A A6 16 88 13        LCALL  0x1388, 0x16a6 ; LCALL
0157B5  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0157B8  8B F8                 MOV    di, ax ; MOV
0157BA  FF 0E AC 49           DEC    word ptr [0x49ac] ; ARITH
0157BE  78 0E                 JS     0x157ce ; CJUMP
0157C0  8B 1E AA 49           MOV    bx, word ptr [0x49aa] ; GLOBAL_LOAD
0157C4  FF 06 AA 49           INC    word ptr [0x49aa] ; ARITH
0157C8  C6 07 00              MOV    byte ptr [bx], 0 ; MOV
0157CB  EB 0D                 JMP    0x157da ; JUMP
0157CD  90                    NOP ; NOP
0157CE  56                    PUSH   si ; STACK_PUSH
0157CF  2B C0                 SUB    ax, ax ; ARITH
0157D1  50                    PUSH   ax ; STACK_PUSH
0157D2  9A 24 13 88 13        LCALL  0x1388, 0x1324 ; LCALL
0157D7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0157DA  8B C7                 MOV    ax, di ; MOV
0157DC  5E                    POP    si ; STACK_POP
0157DD  5F                    POP    di ; STACK_POP
0157DE  8B E5                 MOV    sp, bp ; MOV
0157E0  5D                    POP    bp ; STACK_POP
0157E1  CB                    RETF ; RETURN
