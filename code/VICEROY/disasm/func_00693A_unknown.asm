; ============================================================================
; func_00693A_unknown
; Region   : load_image
; Bytes    : file 0x00693A..0x006948  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00693A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00693E  52                    PUSH   dx ; STACK_PUSH
00693F  50                    PUSH   ax ; STACK_PUSH
006940  57                    PUSH   di ; STACK_PUSH
006941  56                    PUSH   si ; STACK_PUSH
006942  8B FB                 MOV    di, bx ; MOV
006944  8B C2                 MOV    ax, dx ; MOV
006946  8B D7                 MOV    dx, di ; MOV
