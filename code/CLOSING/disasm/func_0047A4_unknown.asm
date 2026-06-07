; ============================================================================
; func_0047A4_unknown
; Region   : load_image
; Bytes    : file 0x0047A4..0x0047E2  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0047A4  55                    PUSH   bp ; STACK_PUSH
0047A5  8B EC                 MOV    bp, sp ; MOV
0047A7  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
0047AA  57                    PUSH   di ; STACK_PUSH
0047AB  56                    PUSH   si ; STACK_PUSH
0047AC  BE B0 41              MOV    si, 0x41b0 ; CONST_LOAD
0047AF  56                    PUSH   si ; STACK_PUSH
0047B0  E8 A1 0D              CALL   0x5554 ; CALL_NEAR
0047B3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0047B6  8B F8                 MOV    di, ax ; MOV
0047B8  8D 46 08              LEA    ax, [bp + 8] ; ADDR
0047BB  50                    PUSH   ax ; STACK_PUSH
0047BC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0047BF  B8 B0 41              MOV    ax, 0x41b0 ; CONST_LOAD
0047C2  50                    PUSH   ax ; STACK_PUSH
0047C3  9A 0E 15 7D 03        LCALL  0x37d, 0x150e ; LCALL
0047C8  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0047CB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0047CE  B8 B0 41              MOV    ax, 0x41b0 ; CONST_LOAD
0047D1  50                    PUSH   ax ; STACK_PUSH
0047D2  57                    PUSH   di ; STACK_PUSH
0047D3  E8 F1 0D              CALL   0x55c7 ; CALL_NEAR
0047D6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0047D9  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0047DC  5E                    POP    si ; STACK_POP
0047DD  5F                    POP    di ; STACK_POP
0047DE  8B E5                 MOV    sp, bp ; MOV
0047E0  5D                    POP    bp ; STACK_POP
0047E1  CB                    RETF ; RETURN
