; ============================================================================
; func_015C54_unknown
; Region   : load_image
; Bytes    : file 0x015C54..0x015C6B  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015C54  55                    PUSH   bp ; STACK_PUSH
015C55  8B EC                 MOV    bp, sp ; MOV
015C57  8B D7                 MOV    dx, di ; MOV
015C59  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015C5C  33 C0                 XOR    ax, ax ; LOGIC
015C5E  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015C61  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015C63  F7 D1                 NOT    cx ; LOGIC
015C65  49                    DEC    cx ; ARITH
015C66  91                    XCHG   cx, ax ; MOV
015C67  8B FA                 MOV    di, dx ; MOV
015C69  5D                    POP    bp ; STACK_POP
015C6A  CB                    RETF ; RETURN
