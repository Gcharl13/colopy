; ============================================================================
; func_004854_unknown
; Region   : load_image
; Bytes    : file 0x004854..0x00487F  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004854  55                    PUSH   bp ; STACK_PUSH
004855  8B EC                 MOV    bp, sp ; MOV
004857  8B D7                 MOV    dx, di ; MOV
004859  8B DE                 MOV    bx, si ; MOV
00485B  8C D8                 MOV    ax, ds ; MOV
00485D  8E C0                 MOV    es, ax ; MOV
00485F  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
004862  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
004865  33 C0                 XOR    ax, ax ; LOGIC
004867  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
00486A  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
00486C  F7 D1                 NOT    cx ; LOGIC
00486E  2B F9                 SUB    di, cx ; ARITH
004870  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; STR
004872  74 05                 JE     0x4879 ; CJUMP
004874  1B C0                 SBB    ax, ax ; ARITH
004876  1D FF FF              SBB    ax, 0xffff ; ARITH
004879  8B F3                 MOV    si, bx ; MOV
00487B  8B FA                 MOV    di, dx ; MOV
00487D  5D                    POP    bp ; STACK_POP
00487E  CB                    RETF ; RETURN
