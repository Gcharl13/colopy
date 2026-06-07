; ============================================================================
; func_004976_unknown
; Region   : load_image
; Bytes    : file 0x004976..0x0049AB  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004976  55                    PUSH   bp ; STACK_PUSH
004977  8B EC                 MOV    bp, sp ; MOV
004979  56                    PUSH   si ; STACK_PUSH
00497A  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00497D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
004980  50                    PUSH   ax ; STACK_PUSH
004981  56                    PUSH   si ; STACK_PUSH
004982  1E                    PUSH   ds ; STACK_PUSH
004983  68 02 4A              PUSH   0x4a02 ; PUSH_CONST
004986  50                    PUSH   ax ; STACK_PUSH
004987  56                    PUSH   si ; STACK_PUSH
004988  9A D4 0D 88 13        LCALL  0x1388, 0xdd4 ; LCALL
00498D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004990  40                    INC    ax ; ARITH
004991  99                    CDQ ; ARITH
004992  9A 0A 01 45 0F        LCALL  0xf45, 0x10a ; LCALL
004997  52                    PUSH   dx ; STACK_PUSH
004998  50                    PUSH   ax ; STACK_PUSH
004999  9A EC 0D 88 13        LCALL  0x1388, 0xdec ; LCALL
00499E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0049A1  A1 40 60              MOV    ax, word ptr [0x6040] ; GLOBAL_LOAD
0049A4  FF 06 40 60           INC    word ptr [0x6040] ; ARITH
0049A8  5E                    POP    si ; STACK_POP
0049A9  C9                    LEAVE ; EPILOGUE
0049AA  CB                    RETF ; RETURN
