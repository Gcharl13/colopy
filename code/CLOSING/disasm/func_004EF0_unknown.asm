; ============================================================================
; func_004EF0_unknown
; Region   : load_image
; Bytes    : file 0x004EF0..0x004F07  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004EF0  55                    PUSH   bp ; STACK_PUSH
004EF1  8B EC                 MOV    bp, sp ; MOV
004EF3  8B D7                 MOV    dx, di ; MOV
004EF5  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004EF8  33 C0                 XOR    ax, ax ; LOGIC
004EFA  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004EFD  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004EFF  F7 D1                 NOT    cx ; LOGIC
004F01  49                    DEC    cx ; ARITH
004F02  91                    XCHG   cx, ax ; MOV
004F03  8B FA                 MOV    di, dx ; MOV
004F05  5D                    POP    bp ; STACK_POP
004F06  CB                    RETF ; RETURN
