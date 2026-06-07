; ============================================================================
; func_005768_unknown
; Region   : load_image
; Bytes    : file 0x005768..0x0057A6  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005768  55                    PUSH   bp ; STACK_PUSH
005769  8B EC                 MOV    bp, sp ; MOV
00576B  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
00576E  57                    PUSH   di ; STACK_PUSH
00576F  56                    PUSH   si ; STACK_PUSH
005770  BE 06 44              MOV    si, 0x4406 ; CONST_LOAD
005773  56                    PUSH   si ; STACK_PUSH
005774  E8 DD 0D              CALL   0x6554 ; CALL_NEAR
005777  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00577A  8B F8                 MOV    di, ax ; MOV
00577C  8D 46 08              LEA    ax, [bp + 8] ; ADDR
00577F  50                    PUSH   ax ; STACK_PUSH
005780  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005783  B8 06 44              MOV    ax, 0x4406 ; CONST_LOAD
005786  50                    PUSH   ax ; STACK_PUSH
005787  9A BE 15 52 04        LCALL  0x452, 0x15be ; LCALL
00578C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00578F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
005792  B8 06 44              MOV    ax, 0x4406 ; CONST_LOAD
005795  50                    PUSH   ax ; STACK_PUSH
005796  57                    PUSH   di ; STACK_PUSH
005797  E8 2D 0E              CALL   0x65c7 ; CALL_NEAR
00579A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00579D  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0057A0  5E                    POP    si ; STACK_POP
0057A1  5F                    POP    di ; STACK_POP
0057A2  8B E5                 MOV    sp, bp ; MOV
0057A4  5D                    POP    bp ; STACK_POP
0057A5  CB                    RETF ; RETURN
