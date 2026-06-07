; ============================================================================
; func_005EF0_unknown
; Region   : load_image
; Bytes    : file 0x005EF0..0x005F07  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005EF0  55                    PUSH   bp ; STACK_PUSH
005EF1  8B EC                 MOV    bp, sp ; MOV
005EF3  8B D7                 MOV    dx, di ; MOV
005EF5  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005EF8  33 C0                 XOR    ax, ax ; LOGIC
005EFA  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005EFD  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005EFF  F7 D1                 NOT    cx ; LOGIC
005F01  49                    DEC    cx ; ARITH
005F02  91                    XCHG   cx, ax ; MOV
005F03  8B FA                 MOV    di, dx ; MOV
005F05  5D                    POP    bp ; STACK_POP
005F06  CB                    RETF ; RETURN
