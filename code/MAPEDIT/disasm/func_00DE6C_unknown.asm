; ============================================================================
; func_00DE6C_unknown
; Region   : load_image
; Bytes    : file 0x00DE6C..0x00DE7A  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DE6C  55                    PUSH   bp ; STACK_PUSH
00DE6D  8B EC                 MOV    bp, sp ; MOV
00DE6F  53                    PUSH   bx ; STACK_PUSH
00DE70  52                    PUSH   dx ; STACK_PUSH
00DE71  50                    PUSH   ax ; STACK_PUSH
00DE72  3B D8                 CMP    bx, ax ; CMP
00DE74  7D 0A                 JGE    0xde80 ; CJUMP
00DE76  8B D0                 MOV    dx, ax ; MOV
00DE78  8B C3                 MOV    ax, bx ; MOV
