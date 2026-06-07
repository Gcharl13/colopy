; ============================================================================
; func_00AEEC_unknown
; Region   : load_image
; Bytes    : file 0x00AEEC..0x00AF35  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AEEC  55                    PUSH   bp ; STACK_PUSH
00AEED  8B EC                 MOV    bp, sp ; MOV
00AEEF  57                    PUSH   di ; STACK_PUSH
00AEF0  56                    PUSH   si ; STACK_PUSH
00AEF1  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00AEF4  33 C0                 XOR    ax, ax ; LOGIC
00AEF6  26 8A 0D              MOV    cl, byte ptr es:[di] ; MOV
00AEF9  32 ED                 XOR    ch, ch ; LOGIC
00AEFB  8B F1                 MOV    si, cx ; MOV
00AEFD  C1 E1 05              SHL    cx, 5 ; LOGIC
00AF00  D1 E6                 SHL    si, 1 ; LOGIC
00AF02  03 CE                 ADD    cx, si ; ARITH
00AF04  D1 E6                 SHL    si, 1 ; LOGIC
00AF06  03 CE                 ADD    cx, si ; ARITH
00AF08  03 C1                 ADD    ax, cx ; ARITH
00AF0A  26 8A 4D 01           MOV    cl, byte ptr es:[di + 1] ; MOV
00AF0E  32 ED                 XOR    ch, ch ; LOGIC
00AF10  8B F1                 MOV    si, cx ; MOV
00AF12  C1 E1 06              SHL    cx, 6 ; LOGIC
00AF15  C1 E6 02              SHL    si, 2 ; LOGIC
00AF18  03 CE                 ADD    cx, si ; ARITH
00AF1A  D1 E6                 SHL    si, 1 ; LOGIC
00AF1C  03 CE                 ADD    cx, si ; ARITH
00AF1E  03 C1                 ADD    ax, cx ; ARITH
00AF20  26 8A 4D 02           MOV    cl, byte ptr es:[di + 2] ; MOV
00AF24  32 ED                 XOR    ch, ch ; LOGIC
00AF26  8B F1                 MOV    si, cx ; MOV
00AF28  C1 E1 04              SHL    cx, 4 ; LOGIC
00AF2B  D1 E6                 SHL    si, 1 ; LOGIC
00AF2D  2B CE                 SUB    cx, si ; ARITH
00AF2F  03 C1                 ADD    ax, cx ; ARITH
00AF31  5E                    POP    si ; STACK_POP
00AF32  5F                    POP    di ; STACK_POP
00AF33  C9                    LEAVE ; EPILOGUE
00AF34  CB                    RETF ; RETURN
