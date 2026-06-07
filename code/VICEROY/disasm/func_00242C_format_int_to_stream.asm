; ============================================================================
; func_00242C_unknown
; Region   : load_image
; Bytes    : file 0x00242C..0x002461  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00242C  55                    PUSH   bp ; STACK_PUSH
00242D  8B EC                 MOV    bp, sp ; MOV
00242F  56                    PUSH   si ; STACK_PUSH
002430  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
002433  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002436  50                    PUSH   ax ; STACK_PUSH
002437  56                    PUSH   si ; STACK_PUSH
002438  1E                    PUSH   ds ; STACK_PUSH
002439  68 40 2D              PUSH   0x2d40 ; PUSH_CONST
00243C  50                    PUSH   ax ; STACK_PUSH
00243D  56                    PUSH   si ; STACK_PUSH
00243E  9A 3C 11 1D 0D        LCALL  0xd1d, 0x113c ; LCALL
002443  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
002446  40                    INC    ax ; ARITH
002447  99                    CDQ ; ARITH
002448  9A 2C 00 1F 18        LCALL  0x181f, 0x2c ; THUNK -> 0x0000:0x0118 (thunk @file 0x01A61C type A) overlay @file 0x025A18
00244D  52                    PUSH   dx ; STACK_PUSH
00244E  50                    PUSH   ax ; STACK_PUSH
00244F  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
002454  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002457  A1 52 2D              MOV    ax, word ptr [0x2d52] ; GLOBAL_LOAD
00245A  FF 06 52 2D           INC    word ptr [0x2d52] ; ARITH
00245E  5E                    POP    si ; STACK_POP
00245F  C9                    LEAVE ; EPILOGUE
002460  CB                    RETF ; RETURN
