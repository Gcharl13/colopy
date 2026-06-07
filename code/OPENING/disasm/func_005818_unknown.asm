; ============================================================================
; func_005818_unknown
; Region   : load_image
; Bytes    : file 0x005818..0x005843  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005818  55                    PUSH   bp ; STACK_PUSH
005819  8B EC                 MOV    bp, sp ; MOV
00581B  8B D7                 MOV    dx, di ; MOV
00581D  8B DE                 MOV    bx, si ; MOV
00581F  8C D8                 MOV    ax, ds ; MOV
005821  8E C0                 MOV    es, ax ; MOV
005823  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
005826  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
005829  33 C0                 XOR    ax, ax ; LOGIC
00582B  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
00582E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005830  F7 D1                 NOT    cx ; LOGIC
005832  2B F9                 SUB    di, cx ; ARITH
005834  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; STR
005836  74 05                 JE     0x583d ; CJUMP
005838  1B C0                 SBB    ax, ax ; ARITH
00583A  1D FF FF              SBB    ax, 0xffff ; ARITH
00583D  8B F3                 MOV    si, bx ; MOV
00583F  8B FA                 MOV    di, dx ; MOV
005841  5D                    POP    bp ; STACK_POP
005842  CB                    RETF ; RETURN
