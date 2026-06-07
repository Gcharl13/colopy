; ============================================================================
; func_005546_unknown
; Region   : load_image
; Bytes    : file 0x005546..0x005563  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005546  55                    PUSH   bp ; STACK_PUSH
005547  8B EC                 MOV    bp, sp ; MOV
005549  50                    PUSH   ax ; STACK_PUSH
00554A  53                    PUSH   bx ; STACK_PUSH
00554B  51                    PUSH   cx ; STACK_PUSH
00554C  52                    PUSH   dx ; STACK_PUSH
00554D  56                    PUSH   si ; STACK_PUSH
00554E  57                    PUSH   di ; STACK_PUSH
00554F  06                    PUSH   es ; STACK_PUSH
005550  53                    PUSH   bx ; STACK_PUSH
005551  BB FF FF              MOV    bx, 0xffff ; CONST_LOAD
005554  E8 C9 FF              CALL   0x5520 ; CALL_NEAR
005557  5B                    POP    bx ; STACK_POP
005558  07                    POP    es ; STACK_POP
005559  5F                    POP    di ; STACK_POP
00555A  5E                    POP    si ; STACK_POP
00555B  5A                    POP    dx ; STACK_POP
00555C  59                    POP    cx ; STACK_POP
00555D  5B                    POP    bx ; STACK_POP
00555E  58                    POP    ax ; STACK_POP
00555F  8B E5                 MOV    sp, bp ; MOV
005561  5D                    POP    bp ; STACK_POP
005562  CB                    RETF ; RETURN
