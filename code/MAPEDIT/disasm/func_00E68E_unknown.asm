; ============================================================================
; func_00E68E_unknown
; Region   : load_image
; Bytes    : file 0x00E68E..0x00E6A3  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E68E  55                    PUSH   bp ; STACK_PUSH
00E68F  8B EC                 MOV    bp, sp ; MOV
00E691  57                    PUSH   di ; STACK_PUSH
00E692  56                    PUSH   si ; STACK_PUSH
00E693  B4 52                 MOV    ah, 0x52 ; CONST_LOAD
00E695  CD 21                 INT    0x21 ; SYS
00E697  26 8B 5F FE           MOV    bx, word ptr es:[bx - 2] ; MOV
00E69B  33 FF                 XOR    di, di ; LOGIC
00E69D  33 F6                 XOR    si, si ; LOGIC
00E69F  33 C0                 XOR    ax, ax ; LOGIC
00E6A1  8E C3                 MOV    es, bx ; MOV
