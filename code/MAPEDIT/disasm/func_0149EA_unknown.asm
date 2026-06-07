; ============================================================================
; func_0149EA_unknown
; Region   : load_image
; Bytes    : file 0x0149EA..0x014A33  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0149EA  55                    PUSH   bp ; STACK_PUSH
0149EB  8B EC                 MOV    bp, sp ; MOV
0149ED  57                    PUSH   di ; STACK_PUSH
0149EE  56                    PUSH   si ; STACK_PUSH
0149EF  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
0149F2  33 C0                 XOR    ax, ax ; LOGIC
0149F4  26 8A 0D              MOV    cl, byte ptr es:[di] ; MOV
0149F7  32 ED                 XOR    ch, ch ; LOGIC
0149F9  8B F1                 MOV    si, cx ; MOV
0149FB  C1 E1 05              SHL    cx, 5 ; LOGIC
0149FE  D1 E6                 SHL    si, 1 ; LOGIC
014A00  03 CE                 ADD    cx, si ; ARITH
014A02  D1 E6                 SHL    si, 1 ; LOGIC
014A04  03 CE                 ADD    cx, si ; ARITH
014A06  03 C1                 ADD    ax, cx ; ARITH
014A08  26 8A 4D 01           MOV    cl, byte ptr es:[di + 1] ; MOV
014A0C  32 ED                 XOR    ch, ch ; LOGIC
014A0E  8B F1                 MOV    si, cx ; MOV
014A10  C1 E1 06              SHL    cx, 6 ; LOGIC
014A13  C1 E6 02              SHL    si, 2 ; LOGIC
014A16  03 CE                 ADD    cx, si ; ARITH
014A18  D1 E6                 SHL    si, 1 ; LOGIC
014A1A  03 CE                 ADD    cx, si ; ARITH
014A1C  03 C1                 ADD    ax, cx ; ARITH
014A1E  26 8A 4D 02           MOV    cl, byte ptr es:[di + 2] ; MOV
014A22  32 ED                 XOR    ch, ch ; LOGIC
014A24  8B F1                 MOV    si, cx ; MOV
014A26  C1 E1 04              SHL    cx, 4 ; LOGIC
014A29  D1 E6                 SHL    si, 1 ; LOGIC
014A2B  2B CE                 SUB    cx, si ; ARITH
014A2D  03 C1                 ADD    ax, cx ; ARITH
014A2F  5E                    POP    si ; STACK_POP
014A30  5F                    POP    di ; STACK_POP
014A31  C9                    LEAVE ; EPILOGUE
014A32  CB                    RETF ; RETURN
