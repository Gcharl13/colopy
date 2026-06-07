; ============================================================================
; func_00FAC0_unknown
; Region   : load_image
; Bytes    : file 0x00FAC0..0x00FAF8  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FAC0  55                    PUSH   bp ; STACK_PUSH
00FAC1  8B EC                 MOV    bp, sp ; MOV
00FAC3  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
00FAC6  57                    PUSH   di ; STACK_PUSH
00FAC7  56                    PUSH   si ; STACK_PUSH
00FAC8  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00FACB  56                    PUSH   si ; STACK_PUSH
00FACC  E8 E5 12              CALL   0x10db4 ; CALL_NEAR
00FACF  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00FAD2  8B F8                 MOV    di, ax ; MOV
00FAD4  8D 46 0A              LEA    ax, [bp + 0xa] ; ADDR
00FAD7  50                    PUSH   ax ; STACK_PUSH
00FAD8  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00FADB  56                    PUSH   si ; STACK_PUSH
00FADC  9A 6E 19 1D 0D        LCALL  0xd1d, 0x196e ; LCALL
00FAE1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00FAE4  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00FAE7  56                    PUSH   si ; STACK_PUSH
00FAE8  57                    PUSH   di ; STACK_PUSH
00FAE9  E8 3B 13              CALL   0x10e27 ; CALL_NEAR
00FAEC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00FAEF  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00FAF2  5E                    POP    si ; STACK_POP
00FAF3  5F                    POP    di ; STACK_POP
00FAF4  8B E5                 MOV    sp, bp ; MOV
00FAF6  5D                    POP    bp ; STACK_POP
00FAF7  CB                    RETF ; RETURN
