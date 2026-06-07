; ============================================================================
; func_00F52C_unknown
; Region   : load_image
; Bytes    : file 0x00F52C..0x00F54F  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F52C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00F530  1E                    PUSH   ds ; STACK_PUSH
00F531  06                    PUSH   es ; STACK_PUSH
00F532  56                    PUSH   si ; STACK_PUSH
00F533  57                    PUSH   di ; STACK_PUSH
00F534  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00F537  26 8B 5D 02           MOV    bx, word ptr es:[di + 2] ; MOV
00F53B  26 8B 75 04           MOV    si, word ptr es:[di + 4] ; MOV
00F53F  26 8B 4D 06           MOV    cx, word ptr es:[di + 6] ; MOV
00F543  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00F546  F7 E3                 MUL    bx ; ARITH
00F548  C1 E2 0C              SHL    dx, 0xc ; LOGIC
00F54B  03 CA                 ADD    cx, dx ; ARITH
00F54D  8B D0                 MOV    dx, ax ; MOV
