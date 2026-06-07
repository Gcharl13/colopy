; ============================================================================
; func_00198C_unknown
; Region   : load_image
; Bytes    : file 0x00198C..0x0019A6  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00198C  55                    PUSH   bp ; STACK_PUSH
00198D  8B EC                 MOV    bp, sp ; MOV
00198F  68 00 03              PUSH   0x300 ; PUSH_CONST
001992  6A 00                 PUSH   0 ; STACK_PUSH
001994  68 E8 4A              PUSH   0x4ae8 ; PUSH_CONST
001997  9A 94 0A 52 04        LCALL  0x452, 0xa94 ; LCALL
00199C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00199F  6A 04                 PUSH   4 ; STACK_PUSH
0019A1  1E                    PUSH   ds ; STACK_PUSH
0019A2  68 C2 47              PUSH   0x47c2 ; PUSH_CONST
0019A5  68                    DB     0x68 ; DATA_BYTE
