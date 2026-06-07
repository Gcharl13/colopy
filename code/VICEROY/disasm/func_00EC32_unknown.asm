; ============================================================================
; func_00EC32_unknown
; Region   : load_image
; Bytes    : file 0x00EC32..0x00EC96  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EC32  55                    PUSH   bp ; STACK_PUSH
00EC33  8B EC                 MOV    bp, sp ; MOV
00EC35  53                    PUSH   bx ; STACK_PUSH
00EC36  52                    PUSH   dx ; STACK_PUSH
00EC37  57                    PUSH   di ; STACK_PUSH
00EC38  56                    PUSH   si ; STACK_PUSH
00EC39  C5 7E 0C              LDS    di, ptr [bp + 0xc] ; MOV_FAR
00EC3C  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
00EC3F  8B F0                 MOV    si, ax ; MOV
00EC41  D1 E6                 SHL    si, 1 ; LOGIC
00EC43  03 F0                 ADD    si, ax ; ARITH
00EC45  C1 E6 02              SHL    si, 2 ; LOGIC
00EC48  03 F7                 ADD    si, di ; ARITH
00EC4A  83 C6 36              ADD    si, 0x36 ; ARITH
00EC4D  8B 44 08              MOV    ax, word ptr [si + 8] ; MOV
00EC50  F7 66 0A              MUL    word ptr [bp + 0xa] ; ARITH
00EC53  05 32 00              ADD    ax, 0x32 ; ARITH
00EC56  B9 64 00              MOV    cx, 0x64 ; CONST_LOAD
00EC59  2B D2                 SUB    dx, dx ; ARITH
00EC5B  F7 F1                 DIV    cx ; ARITH
00EC5D  26 89 47 08           MOV    word ptr es:[bx + 8], ax ; MOV
00EC61  8B D0                 MOV    dx, ax ; MOV
00EC63  8B 44 0A              MOV    ax, word ptr [si + 0xa] ; MOV
00EC66  8B F2                 MOV    si, dx ; MOV
00EC68  F7 66 0A              MUL    word ptr [bp + 0xa] ; ARITH
00EC6B  05 32 00              ADD    ax, 0x32 ; ARITH
00EC6E  2B D2                 SUB    dx, dx ; ARITH
00EC70  F7 F1                 DIV    cx ; ARITH
00EC72  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
00EC76  D1 EE                 SHR    si, 1 ; LOGIC
00EC78  2B 76 FC              SUB    si, word ptr [bp - 4] ; ARITH
00EC7B  F7 DE                 NEG    si ; ARITH
00EC7D  26 89 77 04           MOV    word ptr es:[bx + 4], si ; MOV
00EC81  2B 46 FE              SUB    ax, word ptr [bp - 2] ; ARITH
00EC84  F7 D8                 NEG    ax ; ARITH
00EC86  40                    INC    ax ; ARITH
00EC87  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
00EC8B  B9 5A 1B              MOV    cx, 0x1b5a ; CONST_LOAD
00EC8E  8E D9                 MOV    ds, cx ; MOV
00EC90  5E                    POP    si ; STACK_POP
00EC91  5F                    POP    di ; STACK_POP
00EC92  C9                    LEAVE ; EPILOGUE
00EC93  CA 0A 00              RETF   0xa ; RETURN
