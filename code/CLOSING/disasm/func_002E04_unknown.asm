; ============================================================================
; func_002E04_unknown
; Region   : load_image
; Bytes    : file 0x002E04..0x002E19  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002E04  55                    PUSH   bp ; STACK_PUSH
002E05  8B EC                 MOV    bp, sp ; MOV
002E07  E8 A0 FF              CALL   0x2daa ; CALL_NEAR
002E0A  8B D8                 MOV    bx, ax ; MOV
002E0C  32 F6                 XOR    dh, dh ; LOGIC
002E0E  8A D7                 MOV    dl, bh ; MOV
002E10  C1 E2 04              SHL    dx, 4 ; LOGIC
002E13  8A D6                 MOV    dl, dh ; MOV
002E15  32 F6                 XOR    dh, dh ; LOGIC
002E17  8B C3                 MOV    ax, bx ; MOV
