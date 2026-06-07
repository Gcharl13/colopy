; ============================================================================
; func_002DE0_unknown
; Region   : load_image
; Bytes    : file 0x002DE0..0x002E21  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002DE0  55                    PUSH   bp ; STACK_PUSH
002DE1  8B EC                 MOV    bp, sp ; MOV
002DE3  56                    PUSH   si ; STACK_PUSH
002DE4  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
002DE7  8B C1                 MOV    ax, cx ; MOV
002DE9  2D 13 00              SUB    ax, 0x13 ; ARITH
002DEC  3D 57 00              CMP    ax, 0x57 ; CMP
002DEF  76 03                 JBE    0x2df4 ; CJUMP
002DF1  E9 8C 03              JMP    0x3180 ; JUMP
002DF4  D1 E0                 SHL    ax, 1 ; LOGIC
002DF6  93                    XCHG   bx, ax ; MOV
002DF7  2E FF A7 FC 17        JMP    word ptr cs:[bx + 0x17fc] ; JUMP
002DFC  AC                    LODSB  al, byte ptr [si] ; STR
002DFD  18 24                 SBB    byte ptr [si], ah ; ARITH
002DFF  19 80 1B 80           SBB    word ptr [bx + si - 0x7fe5], ax ; ARITH
002E03  1B 80 1B 80           SBB    ax, word ptr [bx + si - 0x7fe5] ; ARITH
002E07  1B 80 1B 8E           SBB    ax, word ptr [bx + si - 0x71e5] ; ARITH
002E0B  19 D4                 SBB    sp, dx ; ARITH
002E0D  19 80 1B 80           SBB    word ptr [bx + si - 0x7fe5], ax ; ARITH
002E11  1B 80 1B 5E           SBB    ax, word ptr [bx + si + 0x5e1b] ; ARITH
002E15  1A 80 1B BA           SBB    al, byte ptr [bx + si - 0x45e5] ; ARITH
002E19  1A 80 1B 80           SBB    al, byte ptr [bx + si - 0x7fe5] ; ARITH
002E1D  1B C2                 SBB    ax, dx ; ARITH
002E1F  1A D2                 SBB    dl, dl ; ARITH
