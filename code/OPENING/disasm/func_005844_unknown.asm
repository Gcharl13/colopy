; ============================================================================
; func_005844_unknown
; Region   : load_image
; Bytes    : file 0x005844..0x00585F  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005844  55                    PUSH   bp ; STACK_PUSH
005845  8B EC                 MOV    bp, sp ; MOV
005847  8B D7                 MOV    dx, di ; MOV
005849  8C D8                 MOV    ax, ds ; MOV
00584B  8E C0                 MOV    es, ax ; MOV
00584D  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
005850  33 C0                 XOR    ax, ax ; LOGIC
005852  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005855  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005857  F7 D1                 NOT    cx ; LOGIC
005859  49                    DEC    cx ; ARITH
00585A  91                    XCHG   cx, ax ; MOV
00585B  8B FA                 MOV    di, dx ; MOV
00585D  5D                    POP    bp ; STACK_POP
00585E  CB                    RETF ; RETURN
