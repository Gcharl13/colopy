; ============================================================================
; func_0106BA_strrchr_far
; Region   : load_image
; Bytes    : file 0x0106BA..0x0106E4  (42 bytes)
; Purpose  : C `strrchr(s, c)` for far-pointer s — finds the LAST occurrence of byte c in string s. After finding string length with REPNE SCASB, sets STD (direction-decrement), DEC DI, scans BACKWARDS with REPNE SCASB to find the last match, then CLD restores forward-direction. Returns DX:AX = far-pointer to last match, or 0:0 if not found.
; Args     : [bp+6..9] = string far-pointer, [bp+0xA] = byte to find
; Returns  : DX:AX = far-pointer to last occurrence, or 0:0 if not found
; Callers  : TBD (6 distinct call sites)
; Callees  : (none — leaf, REPNE SCASB twice with STD)
; Verified : Boundary verified: PUSH BP / PUSH DI / RETF, 42 bytes. The STD/CLD pair around the second SCASB is the strrchr signature.
; Source   : Pattern matches MS C runtime _fstrrchr.
; ============================================================================

0106BA  55                    PUSH   bp ; STACK_PUSH
0106BB  8B EC                 MOV    bp, sp ; MOV
0106BD  57                    PUSH   di ; STACK_PUSH
0106BE  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
0106C1  33 C0                 XOR    ax, ax ; LOGIC
0106C3  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0106C6  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0106C8  41                    INC    cx ; ARITH
0106C9  F7 D9                 NEG    cx ; ARITH
0106CB  4F                    DEC    di ; ARITH
0106CC  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
0106CF  FD                    STD ; FLAG
0106D0  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0106D2  47                    INC    di ; ARITH
0106D3  26 38 05              CMP    byte ptr es:[di], al ; CMP
0106D6  74 06                 JE     0x106de ; CJUMP
0106D8  33 C0                 XOR    ax, ax ; LOGIC
0106DA  8B D0                 MOV    dx, ax ; MOV
0106DC  EB 04                 JMP    0x106e2 ; JUMP
0106DE  8B C7                 MOV    ax, di ; MOV
0106E0  8C C2                 MOV    dx, es ; MOV
0106E2  FC                    CLD ; FLAG
0106E3  5F                    POP    di ; STACK_POP
