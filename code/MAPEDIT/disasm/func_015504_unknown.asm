; ============================================================================
; func_015504_unknown
; Region   : load_image
; Bytes    : file 0x015504..0x01551F  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015504  55                    PUSH   bp ; STACK_PUSH
015505  8B EC                 MOV    bp, sp ; MOV
015507  8B D7                 MOV    dx, di ; MOV
015509  8C D8                 MOV    ax, ds ; MOV
01550B  8E C0                 MOV    es, ax ; MOV
01550D  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
015510  33 C0                 XOR    ax, ax ; LOGIC
015512  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015515  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015517  F7 D1                 NOT    cx ; LOGIC
015519  49                    DEC    cx ; ARITH
01551A  91                    XCHG   cx, ax ; MOV
01551B  8B FA                 MOV    di, dx ; MOV
01551D  5D                    POP    bp ; STACK_POP
01551E  CB                    RETF ; RETURN
