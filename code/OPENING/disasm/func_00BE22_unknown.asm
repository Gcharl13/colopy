; ============================================================================
; func_00BE22_unknown
; Region   : load_image
; Bytes    : file 0x00BE22..0x00BE6B  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BE22  55                    PUSH   bp ; STACK_PUSH
00BE23  8B EC                 MOV    bp, sp ; MOV
00BE25  57                    PUSH   di ; STACK_PUSH
00BE26  56                    PUSH   si ; STACK_PUSH
00BE27  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00BE2A  33 C0                 XOR    ax, ax ; LOGIC
00BE2C  26 8A 0D              MOV    cl, byte ptr es:[di] ; MOV
00BE2F  32 ED                 XOR    ch, ch ; LOGIC
00BE31  8B F1                 MOV    si, cx ; MOV
00BE33  C1 E1 05              SHL    cx, 5 ; LOGIC
00BE36  D1 E6                 SHL    si, 1 ; LOGIC
00BE38  03 CE                 ADD    cx, si ; ARITH
00BE3A  D1 E6                 SHL    si, 1 ; LOGIC
00BE3C  03 CE                 ADD    cx, si ; ARITH
00BE3E  03 C1                 ADD    ax, cx ; ARITH
00BE40  26 8A 4D 01           MOV    cl, byte ptr es:[di + 1] ; MOV
00BE44  32 ED                 XOR    ch, ch ; LOGIC
00BE46  8B F1                 MOV    si, cx ; MOV
00BE48  C1 E1 06              SHL    cx, 6 ; LOGIC
00BE4B  C1 E6 02              SHL    si, 2 ; LOGIC
00BE4E  03 CE                 ADD    cx, si ; ARITH
00BE50  D1 E6                 SHL    si, 1 ; LOGIC
00BE52  03 CE                 ADD    cx, si ; ARITH
00BE54  03 C1                 ADD    ax, cx ; ARITH
00BE56  26 8A 4D 02           MOV    cl, byte ptr es:[di + 2] ; MOV
00BE5A  32 ED                 XOR    ch, ch ; LOGIC
00BE5C  8B F1                 MOV    si, cx ; MOV
00BE5E  C1 E1 04              SHL    cx, 4 ; LOGIC
00BE61  D1 E6                 SHL    si, 1 ; LOGIC
00BE63  2B CE                 SUB    cx, si ; ARITH
00BE65  03 C1                 ADD    ax, cx ; ARITH
00BE67  5E                    POP    si ; STACK_POP
00BE68  5F                    POP    di ; STACK_POP
00BE69  C9                    LEAVE ; EPILOGUE
00BE6A  CB                    RETF ; RETURN
