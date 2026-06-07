; ============================================================================
; func_06BE50_unknown
; Region   : overlay
; Bytes    : file 0x06BE50..0x06BE91  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06BE50  55                    PUSH   bp ; STACK_PUSH
06BE51  8B EC                 MOV    bp, sp ; MOV
06BE53  56                    PUSH   si ; STACK_PUSH
06BE54  8B 46 04              MOV    ax, word ptr [bp + 4] ; LOCAL_LOAD
06BE57  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
06BE5A  05 84 00              ADD    ax, 0x84 ; ARITH
06BE5D  52                    PUSH   dx ; STACK_PUSH
06BE5E  50                    PUSH   ax ; STACK_PUSH
06BE5F  53                    PUSH   bx ; STACK_PUSH
06BE60  8B F3                 MOV    si, bx ; MOV
06BE62  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
06BE67  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06BE6A  40                    INC    ax ; ARITH
06BE6B  2B D2                 SUB    dx, dx ; ARITH
06BE6D  9A 2C 00 1F 18        LCALL  0x181f, 0x2c ; THUNK -> 0x0000:0x0118 (thunk @file 0x01A61C type A) overlay @file 0x025A18
06BE72  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06BE75  26 89 47 6C           MOV    word ptr es:[bx + 0x6c], ax ; MOV
06BE79  26 89 57 6E           MOV    word ptr es:[bx + 0x6e], dx ; MOV
06BE7D  1E                    PUSH   ds ; STACK_PUSH
06BE7E  56                    PUSH   si ; STACK_PUSH
06BE7F  52                    PUSH   dx ; STACK_PUSH
06BE80  26 FF 77 6C           PUSH   word ptr es:[bx + 0x6c] ; PUSH_GLOBAL
06BE84  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
06BE89  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
06BE8C  5E                    POP    si ; STACK_POP
06BE8D  C9                    LEAVE ; EPILOGUE
06BE8E  C2 04 00              RET    4 ; RETURN
