; ============================================================================
; func_002594_unknown
; Region   : load_image
; Bytes    : file 0x002594..0x0025DD  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002594  55                    PUSH   bp ; STACK_PUSH
002595  8B EC                 MOV    bp, sp ; MOV
002597  57                    PUSH   di ; STACK_PUSH
002598  56                    PUSH   si ; STACK_PUSH
002599  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00259C  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
00259F  26 80 3C 2A           CMP    byte ptr es:[si], 0x2a ; CMP
0025A3  75 03                 JNE    0x25a8 ; CJUMP
0025A5  46                    INC    si ; ARITH
0025A6  8C C0                 MOV    ax, es ; MOV
0025A8  83 3E F2 03 00        CMP    word ptr [0x3f2], 0 ; CMP
0025AD  75 13                 JNE    0x25c2 ; CJUMP
0025AF  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0025B2  06                    PUSH   es ; STACK_PUSH
0025B3  56                    PUSH   si ; STACK_PUSH
0025B4  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0025B7  57                    PUSH   di ; STACK_PUSH
0025B8  9A E8 0D 52 04        LCALL  0x452, 0xde8 ; LCALL
0025BD  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0025C0  EB 12                 JMP    0x25d4 ; JUMP
0025C2  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0025C5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0025C8  57                    PUSH   di ; STACK_PUSH
0025C9  1E                    PUSH   ds ; STACK_PUSH
0025CA  68 D0 5C              PUSH   0x5cd0 ; PUSH_CONST
0025CD  06                    PUSH   es ; STACK_PUSH
0025CE  56                    PUSH   si ; STACK_PUSH
0025CF  9A 00 00 7E 02        LCALL  0x27e, 0 ; LCALL
0025D4  8B C7                 MOV    ax, di ; MOV
0025D6  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0025D9  5E                    POP    si ; STACK_POP
0025DA  5F                    POP    di ; STACK_POP
0025DB  C9                    LEAVE ; EPILOGUE
0025DC  CB                    RETF ; RETURN
