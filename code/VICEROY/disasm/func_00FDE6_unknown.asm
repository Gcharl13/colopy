; ============================================================================
; func_00FDE6_unknown
; Region   : load_image
; Bytes    : file 0x00FDE6..0x00FE11  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FDE6  55                    PUSH   bp ; STACK_PUSH
00FDE7  8B EC                 MOV    bp, sp ; MOV
00FDE9  8B D7                 MOV    dx, di ; MOV
00FDEB  8B DE                 MOV    bx, si ; MOV
00FDED  8C D8                 MOV    ax, ds ; MOV
00FDEF  8E C0                 MOV    es, ax ; MOV
00FDF1  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00FDF4  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
00FDF7  33 C0                 XOR    ax, ax ; LOGIC
00FDF9  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
00FDFC  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
00FDFE  F7 D1                 NOT    cx ; LOGIC
00FE00  2B F9                 SUB    di, cx ; ARITH
00FE02  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; STR
00FE04  74 05                 JE     0xfe0b ; CJUMP
00FE06  1B C0                 SBB    ax, ax ; ARITH
00FE08  1D FF FF              SBB    ax, 0xffff ; ARITH
00FE0B  8B F3                 MOV    si, bx ; MOV
00FE0D  8B FA                 MOV    di, dx ; MOV
00FE0F  5D                    POP    bp ; STACK_POP
00FE10  CB                    RETF ; RETURN
