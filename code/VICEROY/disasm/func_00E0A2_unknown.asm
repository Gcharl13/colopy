; ============================================================================
; func_00E0A2_unknown
; Region   : load_image
; Bytes    : file 0x00E0A2..0x00E0B0  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E0A2  55                    PUSH   bp ; STACK_PUSH
00E0A3  8B EC                 MOV    bp, sp ; MOV
00E0A5  53                    PUSH   bx ; STACK_PUSH
00E0A6  52                    PUSH   dx ; STACK_PUSH
00E0A7  50                    PUSH   ax ; STACK_PUSH
00E0A8  3B D8                 CMP    bx, ax ; CMP
00E0AA  7D 0A                 JGE    0xe0b6 ; CJUMP
00E0AC  8B D0                 MOV    dx, ax ; MOV
00E0AE  8B C3                 MOV    ax, bx ; MOV
