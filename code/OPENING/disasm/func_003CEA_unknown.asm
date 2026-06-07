; ============================================================================
; func_003CEA_unknown
; Region   : load_image
; Bytes    : file 0x003CEA..0x003CFF  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003CEA  55                    PUSH   bp ; STACK_PUSH
003CEB  8B EC                 MOV    bp, sp ; MOV
003CED  E8 A0 FF              CALL   0x3c90 ; CALL_NEAR
003CF0  8B D8                 MOV    bx, ax ; MOV
003CF2  32 F6                 XOR    dh, dh ; LOGIC
003CF4  8A D7                 MOV    dl, bh ; MOV
003CF6  C1 E2 04              SHL    dx, 4 ; LOGIC
003CF9  8A D6                 MOV    dl, dh ; MOV
003CFB  32 F6                 XOR    dh, dh ; LOGIC
003CFD  8B C3                 MOV    ax, bx ; MOV
