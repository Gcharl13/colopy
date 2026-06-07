; ============================================================================
; func_00E6E8_unknown
; Region   : load_image
; Bytes    : file 0x00E6E8..0x00E6FD  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E6E8  55                    PUSH   bp ; STACK_PUSH
00E6E9  8B EC                 MOV    bp, sp ; MOV
00E6EB  E8 A0 FF              CALL   0xe68e ; CALL_NEAR
00E6EE  8B D8                 MOV    bx, ax ; MOV
00E6F0  32 F6                 XOR    dh, dh ; LOGIC
00E6F2  8A D7                 MOV    dl, bh ; MOV
00E6F4  C1 E2 04              SHL    dx, 4 ; LOGIC
00E6F7  8A D6                 MOV    dl, dh ; MOV
00E6F9  32 F6                 XOR    dh, dh ; LOGIC
00E6FB  8B C3                 MOV    ax, bx ; MOV
