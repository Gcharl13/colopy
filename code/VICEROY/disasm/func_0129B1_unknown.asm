; ============================================================================
; func_0129B1_unknown
; Region   : load_image
; Bytes    : file 0x0129B1..0x0129C1  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0129B1  55                    PUSH   bp ; STACK_PUSH
0129B2  8B EC                 MOV    bp, sp ; MOV
0129B4  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0129B7  89 87 B4 26           MOV    word ptr [bx + 0x26b4], ax ; MOV
0129BB  FE 06 C4 26           INC    byte ptr [0x26c4] ; ARITH
0129BF  5D                    POP    bp ; STACK_POP
0129C0  CB                    RETF ; RETURN
